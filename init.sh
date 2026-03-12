#!/bin/bash

set -e

echo "=== OpenClaw 初始化脚本 ==="

OPENCLAW_HOME="/home/node/.openclaw"
OPENCLAW_WORKSPACE="${WORKSPACE:-/home/node/.openclaw/workspace}"
NODE_UID="$(id -u node)"
NODE_GID="$(id -g node)"

# 创建必要目录
mkdir -p "$OPENCLAW_HOME" "$OPENCLAW_WORKSPACE"

# 预检查挂载卷权限（避免同样命令偶发 Permission denied）
if [ "$(id -u)" -eq 0 ]; then
    CURRENT_OWNER="$(stat -c '%u:%g' "$OPENCLAW_HOME" 2>/dev/null || echo unknown:unknown)"
    echo "挂载目录: $OPENCLAW_HOME"
    echo "当前所有者(UID:GID): $CURRENT_OWNER"
    echo "目标所有者(UID:GID): ${NODE_UID}:${NODE_GID}"

    if [ "$CURRENT_OWNER" != "${NODE_UID}:${NODE_GID}" ]; then
        echo "检测到宿主机挂载目录所有者与容器运行用户不一致，尝试自动修复..."
        chown -R node:node "$OPENCLAW_HOME" || true
    fi

    # 再次验证写权限，失败则给出明确诊断
    if ! gosu node test -w "$OPENCLAW_HOME"; then
        echo "❌ 权限检查失败：node 用户无法写入 $OPENCLAW_HOME"
        echo "请在宿主机执行（Linux）："
        echo "  sudo chown -R ${NODE_UID}:${NODE_GID} <your-openclaw-data-dir>"
        echo "或在启动时显式指定用户："
        echo "  docker run --user \$(id -u):\$(id -g) ..."
        echo "若宿主机启用了 SELinux，请在挂载卷后添加 :z 或 :Z"
        exit 1
    fi
fi

# 全量同步配置逻辑
sync_config_with_env() {
    local config_file="/home/node/.openclaw/openclaw.json"
    
    # 如果文件不存在，创建一个基础骨架
    if [ ! -f "$config_file" ]; then
        echo "配置文件不存在，创建基础骨架..."
        cat > "$config_file" <<EOF
{
  "meta": { "lastTouchedVersion": "2026.2.14" },
  "update": { "checkOnStart": false },
  "browser": {
    "headless": true,
    "noSandbox": true,
    "defaultProfile": "openclaw",
    "executablePath": "/usr/bin/chromium"
  },
  "models": { "mode": "merge", "providers": { "default": { "models": [] } } },
  "agents": {
    "defaults": {
      "compaction": { "mode": "safeguard" },
      "sandbox": { "mode": "off" },
      "elevatedDefault": "full",
      "maxConcurrent": 4,
      "subagents": { "maxConcurrent": 8 }
    }
  },
  "messages": { "ackReactionScope": "group-mentions", "tts": { "edge": { "voice": "zh-CN-XiaoxiaoNeural" } } },
  "commands": { "native": "auto", "nativeSkills": "auto" },
  "tools": {
    "profile": "full",
    "sessions": {
      "visibility": "all"
    },
    "fs": {
      "workspaceOnly": true
    }
  },
  "channels": {},
  "plugins": { "entries": {}, "installs": {} },
    "memory": {
      "backend": "qmd",
      "qmd": {
        "command": "/usr/local/bin/qmd",
        "paths": [
          {
            "path": "/home/node/.openclaw/workspace",
            "name": "workspace",
            "pattern": "**/*.md"
          }
        ]
      }
    }
}
EOF
    fi

    echo "正在根据当前环境变量同步配置状态..."
    CONFIG_FILE="$config_file" python3 - <<'PYCODE'
import json, sys, os, re
from datetime import datetime

def strip_json_comments_and_trailing_commas(raw):
    raw = re.sub(r'/\*.*?\*/', '', raw, flags=re.S)
    raw = re.sub(r'(^|\s)//.*?$', '', raw, flags=re.M)
    raw = re.sub(r'(^|\s)#.*?$', '', raw, flags=re.M)
    raw = re.sub(r',(?=\s*[}\]])', '', raw)
    return raw


def load_config_with_compat(path):
    with open(path, 'r', encoding='utf-8') as f:
        raw = f.read()

    try:
        return json.loads(raw)
    except json.JSONDecodeError as original_error:
        sanitized = strip_json_comments_and_trailing_commas(raw)
        try:
            config = json.loads(sanitized)
            print('⚠️ 检测到 openclaw.json 含注释或尾随逗号，已按兼容模式自动解析并在保存时标准化为合法 JSON')
            return config
        except json.JSONDecodeError:
            raise ValueError(f'openclaw.json 格式非法: {original_error}')


def sync():
    path = os.environ.get('CONFIG_FILE', '/home/node/.openclaw/openclaw.json')
    try:
        config = load_config_with_compat(path)

        env = os.environ
        
        def ensure_path(cfg, keys):
            curr = cfg
            for k in keys:
                if k not in curr: curr[k] = {}
                curr = curr[k]
            return curr

        # --- 1. 模型同步 ---
        sync_model = env.get('SYNC_MODEL_CONFIG', 'true').strip().lower()
        if sync_model in ('', 'true', '1', 'yes'):
            def sync_provider(p_name, api_key, base_url, protocol, m_ids_str, context_window, max_tokens):
                if not (api_key and base_url or m_ids_str): return None
                p = ensure_path(config, ['models', 'providers', p_name])
                if api_key: p['apiKey'] = api_key
                if base_url: p['baseUrl'] = base_url
                p['api'] = protocol or 'openai-completions'
                
                mlist = p.get('models', [])
                m_ids = [x.strip() for x in m_ids_str.split(',') if x.strip()]
                
                for m_id in m_ids:
                    actual_m_id = m_id

                    m_obj = next((m for m in mlist if m.get('id') == actual_m_id), None)
                    if not m_obj:
                        m_obj = {'id': actual_m_id, 'name': actual_m_id, 'reasoning': False, 'input': ['text', 'image'],
                                 'cost': {'input': 0, 'output': 0, 'cacheRead': 0, 'cacheWrite': 0}}
                        mlist.append(m_obj)
                    m_obj['contextWindow'] = int(context_window or 200000)
                    m_obj['maxTokens'] = int(max_tokens or 8192)
                
                p['models'] = mlist
                return p_name

            # Provider 1 (default)
            p1_active = sync_provider(
                'default', 
                env.get('API_KEY'), 
                env.get('BASE_URL'), 
                env.get('API_PROTOCOL'), 
                env.get('MODEL_ID') or 'gpt-4o',
                env.get('CONTEXT_WINDOW'),
                env.get('MAX_TOKENS')
            )
            
            # Provider 2
            p2_name = env.get('MODEL2_NAME') or 'model2'
            p2_active = sync_provider(
                p2_name,
                env.get('MODEL2_API_KEY'),
                env.get('MODEL2_BASE_URL'),
                env.get('MODEL2_PROTOCOL'),
                env.get('MODEL2_MODEL_ID') or '',
                env.get('MODEL2_CONTEXT_WINDOW'),
                env.get('MODEL2_MAX_TOKENS')
            )

            # 同步更新默认模型
            mid_raw = env.get('MODEL_ID') or 'gpt-4o'
            mid = [x.strip() for x in mid_raw.split(',') if x.strip()][0]
            
            imid_raw = env.get('IMAGE_MODEL_ID') or mid
            imid = [x.strip() for x in imid_raw.split(',') if x.strip()][0]

            def get_full_mid(m_id, default_p='default'):
                if m_id.startswith(f'{default_p}/'):
                    return m_id
                return f'{default_p}/{m_id}'

            if p1_active:
                ensure_path(config, ['agents', 'defaults', 'model'])['primary'] = get_full_mid(mid)
                ensure_path(config, ['agents', 'defaults', 'imageModel'])['primary'] = get_full_mid(imid)
            
            # 工作区同步：存在则更新，不存在则恢复默认
            config['agents']['defaults']['workspace'] = env.get('WORKSPACE') or '/home/node/.openclaw/workspace'
            
            # 同步更新 memory 路径
            if 'memory' in config and 'qmd' in config['memory']:
                config['memory']['qmd']['command'] = '/usr/local/bin/qmd'
                for p_item in config['memory']['qmd'].get('paths', []):
                    if p_item.get('name') == 'workspace':
                        p_item['path'] = config['agents']['defaults']['workspace']
            
            msg = f'✅ 模型同步完成: 主模型={get_full_mid(mid)}'
            if imid != mid: msg += f', 图片模型={get_full_mid(imid)}'
            if p2_active: msg += f', 已启用备用提供商: {p2_name}'
            print(msg)

        # --- 2. Agent 与工具配置同步（兼容 OpenClaw 3.2） ---
        ensure_path(config, ['agents', 'defaults', 'sandbox'])['mode'] = 'off'
        tools = ensure_path(config, ['tools'])
        tools['profile'] = 'full'
        ensure_path(tools, ['sessions'])['visibility'] = 'all'
        ensure_path(tools, ['fs'])['workspaceOnly'] = True
        print('✅ Agent/工具配置同步完成: sandbox.mode=off, profile=full, sessions.visibility=all, fs.workspaceOnly=true')

        # --- 3. 渠道与插件同步 (仅 Telegram) ---
        channels = ensure_path(config, ['channels'])
        plugins = ensure_path(config, ['plugins'])
        entries = ensure_path(plugins, ['entries'])
        installs = ensure_path(plugins, ['installs'])

        # 通用渠道默认配置 (从环境变量获取)
        def_dm_policy = env.get('DM_POLICY') or 'open'
        def_allow_from = [x.strip() for x in env['ALLOW_FROM'].split(',') if x.strip()] if env.get('ALLOW_FROM') else ['*']
        def_group_policy = env.get('GROUP_POLICY') or 'open'

        if env.get('OPENCLAW_PLUGINS_ENABLED'):
            plugins['enabled'] = env['OPENCLAW_PLUGINS_ENABLED'].lower() == 'true'

        # Telegram 同步
        if env.get('TELEGRAM_BOT_TOKEN'):
            conf_obj = ensure_path(channels, ['telegram'])
            conf_obj.update({
                'botToken': env['TELEGRAM_BOT_TOKEN'],
                'dmPolicy': env.get('TELEGRAM_DM_POLICY') or def_dm_policy,
                'allowFrom': [x.strip() for x in env['TELEGRAM_ALLOW_FROM'].split(',') if x.strip()] if env.get('TELEGRAM_ALLOW_FROM') else def_allow_from,
                'groupPolicy': env.get('TELEGRAM_GROUP_POLICY') or def_group_policy,
                'streamMode': 'partial'
            })
            entries['telegram'] = {'enabled': True}
            print('✅ 渠道同步: telegram')
        elif 'telegram' in entries and entries['telegram'].get('enabled'):
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')

        # Mattermost 同步
        if env.get('MATTERMOST_BOT_TOKEN') and env.get('MATTERMOST_URL'):
            conf_obj = ensure_path(channels, ['mattermost'])
            conf_obj.update({
                'botToken': env['MATTERMOST_BOT_TOKEN'],
                'baseUrl': env['MATTERMOST_URL'],
                'dmPolicy': env.get('MATTERMOST_DM_POLICY') or 'open',
                'groupPolicy': env.get('MATTERMOST_GROUP_POLICY') or 'open',
                'allowFrom': [x.strip() for x in env['MATTERMOST_ALLOW_FROM'].split(',') if x.strip()] if env.get('MATTERMOST_ALLOW_FROM') else def_allow_from,
                'requireMention': env.get('MATTERMOST_REQUIRE_MENTION', 'true').lower() == 'true',
                'autoReply': env.get('MATTERMOST_AUTO_REPLY', 'true').lower() == 'true',
                'messageHandling': env.get('MATTERMOST_MESSAGE_HANDLING') or 'process'
            })
            # Webhook 配置
            if env.get('MATTERMOST_WEBHOOK_URL'):
                conf_obj['webhooks'] = {
                    'url': env['MATTERMOST_WEBHOOK_URL'],
                    'events': [x.strip() for x in env.get('MATTERMOST_EVENTS', 'message_received').split(',') if x.strip()],
                    'filters': {
                        'channel_ids': [x.strip() for x in env['MATTERMOST_CHANNEL_IDS'].split(',') if x.strip()] if env.get('MATTERMOST_CHANNEL_IDS') else []
                    }
                }
            entries['mattermost'] = {'enabled': True}
            print('✅ 渠道同步: mattermost')
        elif 'mattermost' in entries and entries['mattermost'].get('enabled'):
            entries['mattermost']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: mattermost')

        # 汇总所有已启用的插件到 allow 列表

        # 汇总所有已启用的插件到 allow 列表
        plugins['allow'] = [k for k, v in entries.items() if v.get('enabled')]
        if plugins['allow']:
            print('📦 已配置插件集合: ' + ', '.join(plugins['allow']))

        # --- 4. Gateway 同步 ---
        if env.get('OPENCLAW_GATEWAY_TOKEN'):
            gw = ensure_path(config, ['gateway'])
            gw['port'] = int(env.get('OPENCLAW_GATEWAY_PORT') or 18789)
            gw['bind'] = env.get('OPENCLAW_GATEWAY_BIND') or '0.0.0.0'
            gw['mode'] = env.get('OPENCLAW_GATEWAY_MODE') or 'local'
            
            # --- Control UI 配置 ---
            cui = ensure_path(gw, ['controlUi'])
            cui['allowInsecureAuth'] = env.get('OPENCLAW_GATEWAY_ALLOW_INSECURE_AUTH', 'true').lower() == 'true'
            cui['dangerouslyDisableDeviceAuth'] = env.get('OPENCLAW_GATEWAY_DANGEROUSLY_DISABLE_DEVICE_AUTH', 'false').lower() == 'true'
            if env.get('OPENCLAW_GATEWAY_ALLOWED_ORIGINS'):
                cui['allowedOrigins'] = [x.strip() for x in env['OPENCLAW_GATEWAY_ALLOWED_ORIGINS'].split(',') if x.strip()]
            
            auth = ensure_path(gw, ['auth'])
            auth['token'] = env['OPENCLAW_GATEWAY_TOKEN']
            auth['mode'] = env.get('OPENCLAW_GATEWAY_AUTH_MODE') or 'token'

            print('✅ Gateway 同步完成')

        # 保存并更新时间戳
        ensure_path(config, ['meta'])['lastTouchedAt'] = datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%S.%f')[:-3] + 'Z'
        with open(path, 'w', encoding='utf-8') as f:
            json.dump(config, f, indent=2, ensure_ascii=False)
            
    except Exception as e:
        print(f'❌ 同步失败: {e}', file=sys.stderr)
        sys.exit(1)

sync()
PYCODE
}

sync_config_with_env

# 确保所有文件和目录的权限正确（仅 root 可执行）
if [ "$(id -u)" -eq 0 ]; then
    chown -R node:node "$OPENCLAW_HOME" || true
fi

echo "=== 初始化完成 ==="
SYNC_CHECK="${SYNC_MODEL_CONFIG:-true}"
SYNC_CHECK=$(echo "$SYNC_CHECK" | tr '[:upper:]' '[:lower:]' | xargs)
if [ "$SYNC_CHECK" = "false" ] || [ "$SYNC_CHECK" = "0" ] || [ "$SYNC_CHECK" = "no" ]; then
    echo "模型配置: 手动模式 (跳过环境变量同步)"
else
    FINAL_MID="${MODEL_ID:-gpt-4o}"
    if [[ "$FINAL_MID" != default/* ]]; then
        FINAL_MID="default/$FINAL_MID"
    fi

    FINAL_IMID="${IMAGE_MODEL_ID:-${MODEL_ID:-gpt-4o}}"
    if [[ "$FINAL_IMID" != default/* ]]; then
        FINAL_IMID="default/$FINAL_IMID"
    fi

    echo "当前主模型: $FINAL_MID"
    echo "当前图片模型: $FINAL_IMID"
    [ -n "$MODEL2_API_KEY" ] && echo "备用提供商: ${MODEL2_NAME:-model2} (已启用)"
fi
echo "API 协议: ${API_PROTOCOL:-openai-completions}"
echo "Base URL: ${BASE_URL}"
echo "上下文窗口: ${CONTEXT_WINDOW:-200000}"
echo "最大 Tokens: ${MAX_TOKENS:-8192}"
echo "Gateway 端口: $OPENCLAW_GATEWAY_PORT"
echo "Gateway 绑定: $OPENCLAW_GATEWAY_BIND"
echo "Gateway 模式: ${OPENCLAW_GATEWAY_MODE:-local}"
echo "Gateway 允许域: ${OPENCLAW_GATEWAY_ALLOWED_ORIGINS:-未设置}"
echo "Gateway 允许不安全认证: ${OPENCLAW_GATEWAY_ALLOW_INSECURE_AUTH:-true}"
echo "Gateway 禁用设备认证: ${OPENCLAW_GATEWAY_DANGEROUSLY_DISABLE_DEVICE_AUTH:-false}"
echo "插件启用: ${OPENCLAW_PLUGINS_ENABLED:-true}"

# 安装 bun
export BUN_INSTALL="/usr/local"
export PATH="$BUN_INSTALL/bin:$PATH"

# 启动 OpenClaw Gateway（切换到 node 用户）
echo "=== 启动 OpenClaw Gateway ==="

export DBUS_SESSION_BUS_ADDRESS=/dev/null

# 定义清理函数
cleanup() {
    echo "=== 接收到停止信号,正在关闭服务 ==="
    if [ -n "$GATEWAY_PID" ]; then
        kill -TERM "$GATEWAY_PID" 2>/dev/null || true
        wait "$GATEWAY_PID" 2>/dev/null || true
    fi
    echo "=== 服务已停止 ==="
    exit 0
}

# 捕获终止信号
trap cleanup SIGTERM SIGINT SIGQUIT

# 启动网关
gosu node env HOME=/home/node DBUS_SESSION_BUS_ADDRESS=/dev/null \
    BUN_INSTALL="/usr/local" PATH="/usr/local/bin:$PATH" \
    openclaw gateway run \
    --bind "$OPENCLAW_GATEWAY_BIND" \
    --port "$OPENCLAW_GATEWAY_PORT" \
    --token "$OPENCLAW_GATEWAY_TOKEN" \
    --verbose &
GATEWAY_PID=$!

echo "=== OpenClaw Gateway 已启动 (PID: $GATEWAY_PID) ==="

# 主进程等待子进程
wait "$GATEWAY_PID"
EXIT_CODE=$?

echo "=== OpenClaw Gateway 已退出 (退出码: $EXIT_CODE) ==="
exit $EXIT_CODE

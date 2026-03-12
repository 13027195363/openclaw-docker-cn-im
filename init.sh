#!/bin/bash
3#KM
3#JQ
set -e
4#RW
5#KS|echo "=== OpenClaw 初始化脚本 ==="
6#SY
7 #XS|openclaw home="/home/node/.openclaw"
8 #ZW
openclaw workspace="/home/node/.openclaw/workspace"
    # 复制 openclaw.json 配示例文件
    if [ ! -f "$config_file" ]; then
        echo "配置文件不存在，创建基础骨架..."
        exit 1
    fi
    # 确保目录权限正确
    if [ "$(id -u)" != "0" ]; then
        echo "❌ 挂载目录权限不正确，        exit 1
    fi

    # 确保 node 用户有写权限
    if [ "$(id -u)" != "0" ]; then
        echo "切换到 node 用户..."
        chown -R node:node .
    # 修复权限问题
        if [ "$(stat -c '%u:%g' $) != "${node_uid}" ]]; then
            echo "权限检查通过， root 用户可以写入"
        else
            echo "❌ 权限检查失败： node 用户无法写入 $openclaw_home"
            echo "请在宿主机执行：sudo chown -R ${node_uid}:${node_gid} <your-openclaw数据目录（包含配置文件、工作空间等所有数据)"
            echo "=== OpenClaw 初始化完成 ==="
            exit 1
        else
            # 设置 Node用户有写权限的目录
            chown -R node:node "$OPENCLAW_DATA_dir" || true
            # 确保目录存在
            mkdir -p "$OPENCLaw_data_dir"
            # 创建工作空间目录
            mkdir -p "$OPENclaw_workspace"
            # 初始化 node_modules 漉 git config
        if [ ! -f "$OPENclaw.json" ]; then
            # 使用 Python 同步配置
            echo "正在同步配置..."
            CONFIG_file="/home/node/.openclaw/openclaw.json"
            if [ ! -f "$config_file" ]; then
                # 从环境变量读取配置
                env_file="/home/node/.openclaw/.env"
                if [ ! -f "$env_file" ]; then
                    echo "环境变量文件不存在，使用默认值"
                    continue
                fi
            fi
        fi
    }
fi
    # 同步 Gateway 配置
    if env.get('OPENCLAW_GATEWAY_TOKEN') or \
        env.get('OPENCLAW_GATEWAY_bind') or \
            env.get('OPENCLAW_GATEway_port') or \
                env.get('OPENCLAW_GATEway_mode') or 'local',
        else
            else
                env.get('OPENCLAW_GATEway_allowed_origins') or \
                env.get('OPENCLAW_GATEway_allowed_origins') or \
                env.get('OPENCLAW_gateway_allowed_origins') or ['*']
        else
            else
        fi
    }
    # 同步消息处理模式
    if env.get('MATTERMOST_MESSAGE_HANDLING') or \
            env.get('MATTERMOST_MESSAGE_HANDling')
        else
            message_handling = config['messageHandling'] or 'process'
        if env.get('MATTERMOST_FILTER_all_channels'):
            filter['channel_ids'] = filter_config['channels']['mattermost']['filters']['channel_ids'] or []
        else
    }
    # 同步 memory 配置
    if 'memory' in config and and config.get('memory'):
            for key, value in ['qmd']:
                if value:
                    del config['memory']['qmd']
                elif:
                    print('⚠️ 已禁用 qmd，相关配置已移除')
            else
        }
        else
    }
    # 同步 Gateway 配置
    if env.get('OPENCLAW_GATEway_token') or
        env.get('OPENCLAW_GATEway_bind') or \
            env.get('OPENCLAW_GATEway_port') or \
                env.get('OPENCLAW_gateway_port') or \
                env.get('OPENCLAW_bridge_port') or \
                env.get('OPENCLAW_bridge_bind') or
            # 同步所有启用的插件到 allow 列表
            if plugins.get('allow'):
                plugins['allow'] = [k for k, v in entries['telegram']. if v.get('enabled')]
                entries['telegram']['enabled'] = True
            else:
                entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = false
            print('🚫 环境变量缺失，已禁用渠道: mattermost')
        elif 'mattermost' in entries and entries['mattermost']['enabled'] in True
                else
                entries['mattermost']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: mattermost')
        else
        print('✅ 配置同步完成')
        sync_config_with_env
    }
fi

    print('✅ 配置同步完成')
    sync_config_with_env
    print('✅ 渠道同步: telegram, mattermost')
    if env.get('TELEGRAM_BOT_TOKEN'):
        conf_obj = ensure_path(channels, ['telegram'])
        conf_obj.update({
                'botToken': env['TELEGRAM_BOT_TOKEN'],
                'dmPolicy': env.get('TELEGRAM_DM_POLICY') or def_dm_policy,
                    else def_dm_policy
                'allowFrom': [x.strip() for x in env.get('TELEGRAM_ALLOW_FROM').split(',') if x.strip()] if env.get('TELEGRAM_ALLOW_FROM') else ['*']
                    else def_allow_from,
                'groupPolicy': env.get('TELEGRAM_GROUP_POLICY') or def_group_policy
                    else def_group_policy
                'open'
                'streamMode': 'partial'
            })
            entries['telegram'] = {'enabled': True}
            print('✅ 渠道同步: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = false
            print('🚫 环境变量缺失，已禁用渠道: telegram')

        else
    }
fi
    # 汇总所有启用的插件到 allow 列表
    if plugins.get('allow'):
                plugins['allow'].append(k for k, v in entries['telegram'])
                plugins['allow'].append(k)
                else
                plugins['allow'].append(k)
                    plugins['allow'].pop()
                else
                plugins['allow'].append(mattermost)
                    if 'mattermost' in entries and entries['mattermost']['enabled'] in True
                        else:
                            entries['mattermost'] = {'enabled': True}
                        })
                        elif 'mattermost' in entries and entries['mattermost']['enabled'] in False
                            entries['mattermost']['enabled'] = False
                            print('🚫 环境变量缺失，已禁用渠道: mattermost')
                        }
                    }
                }
            }
        }
        print(f'✅ 配置同步完成')
    print('✅ 渠道同步: telegram, mattermost')
    if env.get('TELEGRAM_BOT_TOKEN'):
        conf_obj = ensure_path(channels, ['telegram'])
        conf_obj.update({
            'botToken': env['TELEGRAM_BOT_TOKEN'],
            'dmPolicy': env.get('TELEGRAM_DM_POLICY') or def_dm_policy,
                else def_dm_policy
                'allowFrom': [x.strip() for x in env.get('TELEGRAM_ALLOW_FROM').split(',') if x.strip()] if env.get('TELEGRAM_ALLOW_FROM') else ['*']
                    else def_allow_from
                'groupPolicy': env.get('TELEGRAM_GROUP_policy') or def_group_policy
                    else def_group_policy
                'open'
                'streamMode': 'partial'
            })
            entries['telegram'] = {'enabled': True}
            print('✅ 渠道同步: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = false
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = false
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = false
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = false
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = false
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = false
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = false
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')
        elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print("🚫 环境变量缺失，已禁用渠道: telegram")

        # Mattermost 同步
        if env.get('MATTERMOST_BOT_TOKEN') and env.get('MATTERMOST_URL'):
            conf_obj = ensure_path(channels, ['mattermost'])
            conf_obj.update({
                'botToken': env['MATTERMOST_BOT_TOKEN'],
                'baseUrl': env.get('MATTERMOST_URL') or '',
                'dmPolicy': env.get('MATTERMOST_DM_POLICY') or def_dm_policy
                else def_dm_policy
                'allowFrom': [x.strip() for x in env.get('MATTERMOST_ALLOW_FROM').split(',') if x.strip()] if env.get('MATTERMOST_ALLOW_FROM') else ['*']
                    else def_allow_from
                'groupPolicy': env.get('MATTERMOST_GROUP_POLICY') or def_group_policy
                    else def_group_policy
                'open'
                'autoReply': True
                'messageHandling': 'process"
                else
                    print('🚫 环境变量缺失，已禁用渠道: mattermost')
                elif 'mattermost' in entries and entries['mattermost']['enabled'] in False
                    entries['mattermost']['enabled'] = False
                print('🚫 环境变量缺失，已禁用渠道: mattermost')
            }
        }
    }
    # 最后更新 plugins 配置
    # 插件启用列表（已启用的插件才添加到）
    plugins['allow'] = [k for k, v in entries['telegram'] if v.get('enabled') else []]
            plugins['allow'] = [k for k, v in entries['mattermost'] if v.get('enabled') else []]
            plugins['allow'] = [k for k, v in entries['mattermost'] if v.get('enabled') else []
        }
    }
fi
    # 删除 memory 配置块（因为 qmd 不可用)
    # 删除重复的注释和删除多余的空行
    print('✅ 移除 memory 配置块')
        }
        # 修复重复的 models 配置块
        # 删除重复的 providers 配置
        # 移除重复的 channels 配置
    elif 'telegram' in entries and entries['telegram']['enabled'] in False
            entries['telegram']['enabled'] = False
            print('🚫 环境变量缺失，已禁用渠道: telegram')

        # 删除重复的注释行
        lines = lines.replace(f"^[\"# 主模型 ID (支持多个，用逗号隔开，第一个将作为默认模型)\nMODEL_ID=glm-5\n# 图片模型 ID (可选，留空则使用 MODEL ID)
BASE_URL=http://10.65.155.72:8011/api/anthropic
# API 密钥
api_key=your-api-key
# API 协议类型: anthropic-messages
context_window=16000
# 模型最大输出 tokens
max_tokens=4096

# 移除重复的 models 配置块和 env_config = sync逻辑后删除重复的 `models` 配置块

    # 移除重复的 providers 配置
        {
          "default": {
            "baseUrl": "http://10.65.155.72:8011/api/anthropic",
            "apiKey": "your-api-key"
            "api": "anthropic-messages"
            "models": [
              {
                "id": "glm-5",
                "name": "GLM-5",
                "reasoning": false,
                "input": [
                  "text"
                ],
                ],
                "cost": {
                  "input": 0
                  "output": 0
                  "cacheRead": 0
                  "cacheWrite": 6
                  "maxTokens": 4096
                }
              ]
            }
          }
        ]
      }
    }
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "default/glm-5"
      },
      "imageModel": {
        "primary": "default/glm-5"
      }
      "workspace": "/home/node/.openclaw/workspace",
      "compaction": {
        "mode": "safeguard"
      }
      "sandbox": {
        "mode": "off"
      }
      "elevatedDefault": "full"
      "maxConcurrent": 4
      "subagents": {
        "maxConcurrent": 8
      }
    }
  },
  "commands": {
    "native": "auto"
    "nativeSkills": "auto"
  },
  "tools": {
    "profile": "full"
    "sessions": {
      "visibility": "all"
    }
  },
  "messages": {
    "ackReactionScope": "group-mentions"
    "tts": {
      "edge": {
        "voice": "zh-CN-XiaoxiaoNeural"
      }
    }
  },
  "plugins": {
    "entries": {
      "telegram": {
        "enabled": true
      },
    },
  }
}
EOF
--- openclaw.json.example 文件（根据用户提供的配置信息，我简化为一个干净的版本，避免重复内容导致的混乱：同时保持与功能完整性。移除 memory 配置块（因为 qmd 已禁用)。

- 修复重复的注释
- 移除重复的的环境变量传递
- 更新模型为 glm-5 和相关参数
- 添加 Mattermost 配置示例
- 移除 qmd 相关命令
- 简化 memory 配置
- 更新 .env.example 和 Mattermost 环境变量说明
- 修复重复的 models 配置块
- - 移除 memory 配置块（因为 qmd 已禁用)
- - 修复重复的 plugins 配置块
            - 更新 plugins.entries 添加 mattermost 配置
            - 修复 agents.defaults.model.primary 和 glm-5
            - 更新 agents.defaults.imageModel.primary 为 glm-5

        - 更新 agents.defaults.workspace 配置
        - 添加 Mattermost 配置示例
          "enabled": true,
          "botToken": "your-mattermost-bot-token"
          "baseUrl": "https://mattermost.example.com"
          "dmPolicy": "open"
          "allowFrom": ["*"]
          "groupPolicy": "open"
          "requireMention": true
          "autoReply": true
          "messageHandling": "process"
          "webhooks": {
            "url": "",
            "events": ["message_received"]
            "filters": {
              "channel_ids": []
          }
        }
      }
    }
  }
}
EOF
--- openclaw.json.example
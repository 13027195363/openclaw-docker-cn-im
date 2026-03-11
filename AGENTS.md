# AGENTS.md - OpenClaw Docker CN IM (Simplified)

This document provides guidance for AI coding agents working in this repository.

## Project Overview

Simplified OpenClaw Docker image for intranet deployment. This version removes Chinese IM platform plugins (Feishu, DingTalk, QQ, WeCom) and keeps only the core functionality with optional Telegram support.

## Build Commands

```bash
# Build Docker image locally
docker build -t openclaw-docker-cn-im:latest .

# Build with specific tag
docker build -t openclaw-docker-cn-im:2026.3.8 .
```

## Development Commands

```bash
# Start services (background)
docker-compose up -d

# View logs (follow mode)
docker-compose logs -f

# Stop services
docker-compose down

# Restart services
docker-compose restart

# Enter container for debugging
docker-compose exec openclaw-gateway /bin/bash
# IMPORTANT: Switch to node user after entering container
su node
```

## Inside Container Commands

After entering container and switching to `node` user:

```bash
# Check OpenClaw version
openclaw --version

# View configuration
cat ~/.openclaw/openclaw.json

# View workspace
ls -la ~/.openclaw/workspace

# Pair Telegram bot (if using Telegram)
openclaw pairing approve telegram {token}
```

## Configuration

### Environment Variables (.env)

Copy `.env.example` to `.env` and configure:

```bash
cp .env.example .env
```

**Required Configuration:**
- `MODEL_ID` - AI model name (e.g., `gpt-4o`, `gemini-3-flash-preview`)
- `BASE_URL` - API endpoint (OpenAI protocol needs `/v1` suffix)
- `API_KEY` - API authentication key
- `OPENCLAW_GATEWAY_TOKEN` - Gateway access token

**Protocol Types:**
- `openai-completions` - For OpenAI, Gemini, etc. (Base URL needs `/v1`)
- `anthropic-messages` - For Claude (Base URL without `/v1`)

### Key Configuration Files

| File | Purpose |
|------|---------|
| `docker-compose.yml` | Service orchestration |
| `.env` | Environment variables |
| `init.sh` | Container initialization script |
| `Dockerfile` | Image build instructions |
| `openclaw.json.example` | Configuration reference |

### Configuration Sync Behavior

- `SYNC_MODEL_CONFIG=true` (default): Auto-sync from env vars to `openclaw.json`
- `SYNC_MODEL_CONFIG=false`: Manual configuration mode

To regenerate config after env changes:
```bash
rm ~/.openclaw/openclaw.json
docker-compose restart
```

## Architecture

### Container Structure

- **Main service**: `openclaw-gateway` - Runs OpenClaw Gateway

### User Permissions

- Container starts as root, drops to `node` user (UID 1000)
- Data directory: `/home/node/.openclaw`
- Workspace: `/home/node/.openclaw/workspace`

### Permission Issues

If encountering `Permission denied`:

```bash
# Fix ownership on host
sudo chown -R 1000:1000 ~/.openclaw

# Or specify user in .env
OPENCLAW_RUN_USER=1000:1000
```

## Code Style Guidelines

### Shell Scripts (init.sh)

- Use `#!/bin/bash` shebang
- Use `set -e` for error handling
- Use `gosu node` to run commands as node user
- Quote variables: `"$VARIABLE"`
- Use `|| true` for commands that may fail gracefully

### JSON Configuration (openclaw.json)

- 2-space indentation
- No trailing commas
- No comments (JSON5-style comments handled compatibly but not preferred)
- Use `ensure_ascii=False` when generating JSON in Python

### Environment Variables

- UPPERCASE_WITH_UNDERSCORES naming
- Boolean values: `true`/`false` (lowercase)
- Comma-separated for lists

## Supported Platforms

| Platform | Env Variables Required | Notes |
|----------|----------------------|-------|
| Telegram | `TELEGRAM_BOT_TOKEN` | Optional, built-in |

## Common Issues

### Config not updating after env change

Config file is only generated if it doesn't exist. Delete and restart:
```bash
rm ~/.openclaw/openclaw.json
docker-compose restart
```

### 401 Authentication errors

- Verify `API_KEY` is correctly set
- Check `BASE_URL` format (with/without `/v1` suffix)

## Ports

- `18789` - OpenClaw Gateway
- `18790` - OpenClaw Bridge

## Pre-installed Packages

Inside the Docker image:
- `openclaw@2026.3.8` - Main application
- `opencode-ai@latest` - AI code assistant
- `playwright` - Browser automation
- `@steipete/bird` - Bird tool
- `@tobilu/qmd` - Memory backend

## Adding Custom Plugins

To add new plugins, modify these files:

1. **Dockerfile** - Add plugin installation:
```dockerfile
RUN cd /home/node/.openclaw/extensions && \
  git clone --depth 1 https://github.com/xxx/your-plugin.git your-plugin && \
  cd your-plugin && \
  npm install --omit=dev --legacy-peer-deps && \
  timeout 300 openclaw plugins install -l . || true
```

2. **init.sh** - Add sync logic in `sync_rules`:
```python
(['YOUR_PLUGIN_ENV_VAR'], 'your-plugin',
 lambda c, e: c.update({
     'enabled': True,
     'someConfig': e['YOUR_PLUGIN_ENV_VAR']
 }),
 {'source': 'npm', 'spec': 'your-package', 'installPath': '/home/node/.openclaw/extensions/your-plugin'})
```

3. **docker-compose.yml** - Add environment variable passthrough

4. **.env.example** - Document new config options

## License

GPL-3.0 (inherited from OpenClaw)

# ONAR-HERMES-AGENT

ONAR-HERMES-AGENT is a security-conscious documentation and deployment framework for running Hermes Agent as a controllable personal AI system. It records reproducible architecture, operational boundaries, and migration concepts without publishing private machine state or credentials.

> **Status:** Current deployment is Hermes Agent v0.21.0 running natively on an Ubuntu 24.04 LTS VPS (x86_64). The primary provider is a private OpenAI-compatible endpoint. Telegram control, the local terminal backend, and a native systemd user service are working. A FreeLLMAPI fallback proxy is installed and wired into the Hermes fallback chain; provider keys for the proxy are not yet added, so failover is not yet live. The previous Android + Termux + Debian PRoot deployment is retained as historical reference.

## Goals

- Document a real Android → Termux → Debian PRoot deployment.
- Keep public documentation separate from secrets and deployment-specific state.
- Provide safe operating procedures for Telegram-controlled work.
- Make a future move to a native Linux VPS understandable and repeatable.
- Establish a portfolio-grade engineering record without overstating test results.

## Architecture

```text
Ubuntu 24.04 LTS VPS (x86_64, native)
└── Hermes Agent v0.21.0
    ├── Primary OpenAI-compatible LLM provider (current)
    ├── Telegram gateway (current)
    ├── Local terminal backend (current)
    └── FreeLLMAPI fallback proxy (installed; awaiting provider keys)
```

Hermes runs directly on the VPS userspace with native systemd user services. The previous Android + Termux + Debian PRoot layout kept Hermes inside Debian to avoid duplicate installations; that boundary no longer applies on native Linux.

## Current implementation

- **Current:** Hermes Agent v0.21.0 on Ubuntu 24.04 LTS (x86_64), native install.
- **Current:** Primary custom OpenAI-compatible provider; the endpoint is private and is never documented here.
- **Current:** `chat_completions` API mode.
- **Current:** Local terminal backend.
- **Current:** Telegram gateway with an allowlist; operation verified.
- **Current:** Native systemd user services work (unlike the previous PRoot deployment).
- **Installed, not yet live:** FreeLLMAPI fallback proxy — a source-built Node service on loopback port 3001, registered as a systemd user service and wired into the Hermes fallback chain as a custom OpenAI-compatible provider. It routes to free-tier providers, but no provider keys have been added to it yet, so failover will return "no providers configured" until keys are provisioned through its dashboard (accessed via SSH tunnel, never exposed publicly).
- **Completed:** Migration from Android + Termux + Debian PRoot to this VPS.
- **Historical reference:** the Android deployment guide remains in `docs/deployment/local-android.md`.

## Documentation

- [Architecture](docs/architecture.md)
- [Two-Supabase OHA database architecture](docs/OHA-DATABASE.md)
- Local Android deployment: [prerequisites and installation](docs/deployment/local-android.md)
- [VPS deployment (completed)](docs/deployment/vps.md)
- [Safe mode](docs/operations/safe-mode.md)
- [Telegram operations](docs/operations/telegram.md)
- [Continuity workflow](docs/operations/continuity.md)
- [Security policy](SECURITY.md)
- [Example configuration](config/hermes.example.yaml)
- [Environment template](config/.env.example)

## Security model

This repository contains public documentation and safe templates only. Secrets belong in a local `.env` or an equivalent secret store and must be injected at runtime. Never commit provider endpoints, API keys, Telegram tokens, user IDs, cookies, session data, private keys, passwords, or machine-specific configuration. See [SECURITY.md](SECURITY.md) before copying any example.

## Provider architecture

Hermes is treated as the orchestration layer, independent of the model provider. The current deployment uses one private OpenAI-compatible provider through `chat_completions`. A FreeLLMAPI proxy is now installed as the first fallback entry in the Hermes fallback chain (custom provider, `auto` routing model, loopback-only base URL, key referenced by environment variable name — never inlined). Its end-to-end failover behavior is **not yet verified** because no upstream provider keys have been added to the proxy; until then the fallback path returns a "no providers configured" error rather than serving traffic.

## Historical: Local Android deployment

The original deployment path was:

```text
Termux → Debian PRoot → Hermes Agent
```

The guide documents prerequisites, installation flow, verification, Telegram setup, foreground gateway testing, and the systemd/PRoot limitation. It does not contain device paths, credentials, or private endpoint values. It is retained as the reference for how the system behaved before the VPS migration.

## Local → VPS migration (completed)

The migration preserved the logical Hermes configuration while replacing the runtime substrate:

```text
Android + Termux + Debian PRoot
                ↓
Ubuntu 24.04 LTS VPS + native Linux (x86_64)
```

Secrets were provisioned directly on the destination as protected local files. They were not copied through Git, pasted into issues, or embedded in deployment scripts. Native systemd user services replaced the PRoot foreground workaround.

## Roadmap

1. ~~Design a native-Linux VPS deployment and validate it separately.~~ Done — running on Ubuntu 24.04.
2. Provision provider keys into the FreeLLMAPI proxy and verify end-to-end failover (kill/retry test against the primary).
3. Keep the current deployment documented and reproducible.
4. Add repeatable operational checks and safer maintenance procedures.
5. Add automation only after its security and recovery behavior are verified.

## Scope and contribution

This repository is primarily a public engineering and operations record. Contributions should preserve the distinction between **CURRENT**, **PLANNED**, and **FUTURE** behavior and must pass a secret-safety review before publication.

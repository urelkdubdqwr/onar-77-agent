# ONAR-HERMES-AGENT

ONAR-HERMES-AGENT is a security-conscious documentation and deployment framework for running Hermes Agent as a controllable personal AI system. It records reproducible architecture, operational boundaries, and migration concepts without publishing private machine state or credentials.

> **Status:** Current deployment is Hermes Agent v0.21.0 running in Debian 13 Trixie (aarch64) inside Termux on Android. The primary provider is a private OpenAI-compatible endpoint. Telegram control and the local terminal backend are working in the foreground. VPS deployment and the fallback provider are planned, not completed.

## Goals

- Document a real Android → Termux → Debian PRoot deployment.
- Keep public documentation separate from secrets and deployment-specific state.
- Provide safe operating procedures for Telegram-controlled work.
- Make a future move to a native Linux VPS understandable and repeatable.
- Establish a portfolio-grade engineering record without overstating test results.

## Architecture

```text
Android
└── Termux
    └── Debian 13 Trixie (PRoot, aarch64)
        └── Hermes Agent v0.21.0
            ├── Primary OpenAI-compatible LLM provider (current)
            ├── Telegram gateway (current)
            ├── Local terminal backend (current)
            └── Fallback provider (planned)
```

Hermes is intentionally kept inside Debian. This avoids duplicate Hermes installations between the Termux host and the Debian environment and keeps the runtime boundary explicit.

## Current implementation

- **Current:** Hermes Agent v0.21.0 in Debian PRoot on Android.
- **Current:** Primary custom OpenAI-compatible provider; the endpoint is private and is never documented here.
- **Current:** `chat_completions` API mode.
- **Current:** Local terminal backend.
- **Current:** Telegram gateway with an allowlist; foreground operation verified.
- **Known limitation:** systemd user services do not work in this PRoot deployment.
- **Planned:** FreeLLMAPI fallback. It is not configured or installed by this repository.
- **Future:** Migration to a VPS with native Linux service management.

## Documentation

- [Architecture](docs/architecture.md)
- Local Android deployment: [prerequisites and installation](docs/deployment/local-android.md)
- [Planned VPS deployment](docs/deployment/vps.md)
- [Safe mode](docs/operations/safe-mode.md)
- [Telegram operations](docs/operations/telegram.md)
- [Continuity workflow](docs/operations/continuity.md)
- [Security policy](SECURITY.md)
- [Example configuration](config/hermes.example.yaml)
- [Environment template](config/.env.example)

## Security model

This repository contains public documentation and safe templates only. Secrets belong in a local `.env` or an equivalent secret store and must be injected at runtime. Never commit provider endpoints, API keys, Telegram tokens, user IDs, cookies, session data, private keys, passwords, or machine-specific configuration. See [SECURITY.md](SECURITY.md) before copying any example.

## Provider architecture

Hermes is treated as the orchestration layer, independent of the model provider. The current deployment uses one private OpenAI-compatible provider through `chat_completions`. A fallback provider is a future resilience feature; no provider-specific fallback configuration is asserted until it has been tested.

## Local Android deployment

The successful deployment path is:

```text
Termux → Debian PRoot → Hermes Agent
```

The guide documents prerequisites, installation flow, verification, Telegram setup, foreground gateway testing, and the systemd/PRoot limitation. It does not contain device paths, credentials, or private endpoint values.

## Local → VPS migration

The intended migration preserves the logical Hermes configuration while replacing the runtime substrate:

```text
Android + Termux + Debian PRoot
                ↓
VPS + native Linux environment
```

Secrets must be provisioned directly on the destination using a secret manager or protected local files. They must not be copied through Git, pasted into issues, or embedded in deployment scripts.

## Roadmap

1. Keep the current local deployment documented and reproducible.
2. Add repeatable operational checks and safer maintenance procedures.
3. Evaluate and test a fallback provider without changing the current deployment prematurely.
4. Design a native-Linux VPS deployment and validate it separately.
5. Add automation only after its security and recovery behavior are verified.

## Scope and contribution

This repository is primarily a public engineering and operations record. Contributions should preserve the distinction between **CURRENT**, **PLANNED**, and **FUTURE** behavior and must pass a secret-safety review before publication.

# Architecture

## Current topology

```text
Android
└── Termux
    └── Debian 13 Trixie (PRoot, aarch64)
        └── Hermes Agent v0.21.0
            ├── Primary OpenAI-compatible LLM provider
            ├── Telegram gateway
            ├── Local terminal backend
            └── Future fallback provider
```

The current runtime is local and foreground-oriented. Hermes is installed and run inside Debian PRoot rather than separately in Termux. This keeps one authoritative installation and avoids version drift between host and guest environments.

## Responsibilities

- **Android:** physical host device.
- **Termux:** user-space entry point and process host.
- **Debian PRoot:** isolated Linux userspace; it is not a full virtual machine.
- **Hermes Agent:** orchestration, model calls, gateway integration, and terminal operations.
- **Primary provider:** current private OpenAI-compatible endpoint, configured outside this repository.
- **Telegram gateway:** remote control surface protected by a bot token and allowlist.
- **Local terminal:** current command-execution backend.
- **Fallback provider:** planned resilience component; not configured.

## Boundaries and state

Keep these categories separate:

- **Operational state:** running processes, gateway status, recent tasks, and logs.
- **Configuration:** non-secret settings and provider wiring.
- **Secrets:** API keys, Telegram token, allowlist identity, cookies, and private keys.
- **Source/documentation:** this repository's sanitized, reviewable files.
- **Deployment-specific state:** device paths, local databases, sessions, service files, and runtime artifacts.

Only sanitized source and documentation should be committed. Operational and deployment-specific state stays on the machine or in an appropriate protected system.

## Planned migration

The logical architecture can move from Android + Termux + Debian PRoot to VPS + native Linux. The model-provider and Telegram interfaces remain conceptual boundaries; the process supervisor and filesystem layout can change. Provision secrets directly on the VPS, validate the configuration there, and never use Git as a secret transport.

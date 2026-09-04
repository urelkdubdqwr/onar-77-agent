# Architecture

## Current topology

```text
Ubuntu 24.04 LTS VPS (x86_64, native)
└── Hermes Agent v0.21.0
    ├── Primary OpenAI-compatible LLM provider
    ├── Telegram gateway
    ├── Local terminal backend
    └── FreeLLMAPI fallback proxy (systemd user service, loopback :3001)
```

Hermes runs natively on the VPS userspace. Process supervision uses native systemd user services, which work here (they did not under the previous Debian PRoot deployment on Android). The FreeLLMAPI proxy listens only on 127.0.0.1; remote administration reaches it through an SSH tunnel, never through a public bind.

## Responsibilities

- **VPS (Ubuntu 24.04, x86_64):** physical/virtual host and native Linux userspace.
- **Hermes Agent:** orchestration, model calls, gateway integration, and terminal operations.
- **Primary provider:** current private OpenAI-compatible endpoint, configured outside this repository.
- **Telegram gateway:** remote control surface protected by a bot token and allowlist.
- **Local terminal:** current command-execution backend.
- **FreeLLMAPI proxy:** fallback resilience component; installed and wired into the Hermes fallback chain, but not yet serving traffic because no upstream provider keys are configured.

## Boundaries and state

Keep these categories separate:

- **Operational state:** running processes, gateway status, recent tasks, and logs.
- **Configuration:** non-secret settings and provider wiring.
- **Secrets:** API keys, Telegram token, allowlist identity, cookies, and private keys.
- **Source/documentation:** this repository's sanitized, reviewable files.
- **Deployment-specific state:** device paths, local databases, sessions, service files, and runtime artifacts.

Only sanitized source and documentation should be committed. Operational and deployment-specific state stays on the machine or in an appropriate protected system.

## Migration history

The architecture moved from Android + Termux + Debian PRoot to a VPS with native Linux. The model-provider and Telegram interfaces remained conceptual boundaries; the process supervisor changed from foreground-only (PRoot could not run systemd user services) to native systemd user services. Secrets were provisioned directly on the VPS; Git was never used as a secret transport.

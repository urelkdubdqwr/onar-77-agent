# VPS Deployment (Planned)

> **PLANNED / NOT PERFORMED:** This guide describes a future deployment. No VPS deployment has been completed by this project record.

## Target topology

```text
VPS
└── Native Linux
    └── Hermes Agent
        ├── Primary OpenAI-compatible provider
        ├── Telegram gateway
        ├── Local terminal backend
        └── Future fallback provider
```

## Migration concept

The migration replaces:

```text
Android + Termux + Debian PRoot
```

with:

```text
VPS + native Linux environment
```

The application boundary can remain similar, while the VPS provides a conventional init system, persistent storage, and server networking. The current Android deployment should remain the reference for behavior until the VPS is independently tested.

## Planned steps

1. Provision a supported Linux VPS and apply OS updates.
2. Create a dedicated, least-privilege runtime user.
3. Install Hermes and its dependencies natively.
4. Recreate non-secret configuration from reviewed templates.
5. Provision secrets directly on the VPS through a secret manager or protected files.
6. Configure Telegram allowlisting and network restrictions.
7. Validate provider calls, terminal behavior, gateway behavior, restart behavior, and logs.
8. Add a native service only after it has been tested and its failure/recovery behavior is understood.
9. Cut over deliberately, retaining a rollback plan.

## Secret boundary

Do not commit or copy `.env` files through Git. Do not put credentials in cloud-init, shell history, screenshots, chat messages, or issue comments. Use placeholders such as `YOUR_API_KEY`, `YOUR_TELEGRAM_BOT_TOKEN`, and `YOUR_VPS_IP` in planning material.

## Acceptance criteria before calling it complete

- Version and architecture are recorded.
- Provider and Telegram connectivity are verified without exposing values.
- Allowlist rejection is tested.
- Service restart and boot behavior are tested.
- Logs are retained privately and contain no credentials.
- The migration and rollback procedure is written from observed results, not assumptions.

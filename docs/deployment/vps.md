# VPS Deployment (Completed)

> **STATUS: PERFORMED.** This deployment was carried out and observed on an Ubuntu 24.04 LTS VPS (x86_64). The record below describes observed results. Machine-specific values (hostname, IP, account name, paths under a private home directory) are intentionally replaced with placeholders.

## Target topology

```text
VPS
└── Native Linux (Ubuntu 24.04 LTS, x86_64)
    └── Hermes Agent
        ├── Primary OpenAI-compatible provider
        ├── Telegram gateway
        ├── Local terminal backend
        └── FreeLLMAPI fallback proxy (installed; keys pending)
```

## Migration concept

The migration replaced:

```text
Android + Termux + Debian PRoot
```

with:

```text
VPS + native Linux environment
```

The application boundary remained similar, while the VPS provided a conventional init system, persistent storage, and server networking.

## Steps performed

1. Provisioned the VPS on Ubuntu 24.04 LTS and applied OS updates.
2. Installed Hermes natively (no PRoot layer); version recorded via `hermes --version`.
3. Recreated non-secret configuration from reviewed templates; secrets provisioned directly on the VPS as protected local files (never through Git).
4. Configured the Telegram gateway with an allowlist; verified messaging through the agent itself.
5. Installed the FreeLLMAPI fallback proxy from source (Node.js; Docker was not available on this host):
   - cloned the upstream repository, `npm install` + production build,
   - generated an encryption key stored only in a local `.env` (mode 0600),
   - bound the server to `127.0.0.1` only — never a public interface,
   - registered it as a **systemd user service** with auto-restart and boot persistence (verified: service active after reboot-safe enablement).
6. Wired the proxy into the Hermes fallback chain as a custom OpenAI-compatible provider, referencing its unified key by environment-variable name rather than inlining it.
7. Verified the proxy responds on loopback (dashboard and `/v1/models` both HTTP 200) and that Hermes lists it in `hermes fallback list`.

## Remote administration of the proxy dashboard

The dashboard is loopback-only by design. Administration happens through an SSH tunnel from a trusted machine:

```bash
ssh -L 3001:localhost:3001 YOUR_USER@YOUR_VPS_IP
# then open http://localhost:3001 in the browser on that machine
```

A public bind (`0.0.0.0`) was considered and rejected: the proxy is single-user and guarded only by its API key and dashboard password.

## Known gaps (not yet complete)

- **Provider keys are not yet added to the proxy.** Until at least one free-tier provider key is provisioned through the dashboard, the fallback path returns "no providers configured" instead of serving traffic. Failover is therefore installed but not live.
- **End-to-end failover is unverified.** A deliberate primary-failure test (induce a provider error, confirm the turn continues on the fallback, confirm the next turn returns to the primary) has not been run.

## Acceptance criteria still open

- Provider keys added and at least one fallback completion observed.
- Allowlist rejection tested on this deployment.
- Service restart and boot behavior re-tested after the above changes.
- Logs retained privately and confirmed free of credentials.

## Secret boundary

Do not commit or copy `.env` files through Git. Do not put credentials in cloud-init, shell history, screenshots, chat messages, or issue comments. Use placeholders such as `YOUR_API_KEY`, `YOUR_TELEGRAM_BOT_TOKEN`, and `YOUR_VPS_IP` in planning material.

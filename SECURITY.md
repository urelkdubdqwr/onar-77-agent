# Security Policy

ONAR-HERMES-AGENT is intended to be public. Public files must remain useful without revealing private deployment state.

## Never commit

Do not commit or paste into documentation, issues, pull requests, screenshots, logs, or examples:

- API keys, access tokens, passwords, or provider credentials
- Telegram bot tokens, Telegram user IDs, cookies, or session data
- Private provider endpoints or private network addresses
- SSH keys, private certificates, signing keys, or credential stores
- `.env` files, shell history, machine-specific paths, or raw diagnostic output
- Complete production configuration when it contains identifying or secret values

Use placeholders such as `YOUR_API_KEY`, `YOUR_TELEGRAM_BOT_TOKEN`, `YOUR_TELEGRAM_USER_ID`, and `YOUR_VPS_IP`.

## Secret handling

Store local secrets in a protected `.env` file or a dedicated secret manager. Set restrictive permissions where the platform supports them, load secrets at runtime, and keep them out of Git. The committed `config/.env.example` contains names and placeholders only.

Do not treat an example file as a drop-in production configuration. Confirm the configuration schema supported by the installed Hermes version before applying it.

## Git hygiene

Before every commit:

1. Review `git status` and the exact staged file list.
2. Inspect the staged diff with `git diff --cached`.
3. Search staged text for credential names and high-entropy/token-like values.
4. Confirm `.env`, logs, caches, sessions, and machine-specific files are ignored.
5. Remove sensitive content and replace it with a safe placeholder or example template.
6. Re-check the staged diff before committing.

If a secret is ever committed, assume it is compromised: revoke or rotate it immediately, remove it from current files and history where appropriate, and investigate exposure.

## Repository rules

The `.gitignore` intentionally excludes environment files, runtime state, logs, caches, local databases, session material, and common private-key files. Do not weaken those rules to make a local deployment easier.

## Reporting a vulnerability

Do not open a public issue containing a secret or an exploitable detail. Contact the repository owner through a private GitHub security channel if one is enabled, or use a private communication channel. Include reproduction and impact details without including credentials.

## Scope

This policy covers this repository and its public documentation. Operational state, configuration, secrets, source/documentation, and deployment-specific state are separate concerns; only sanitized source and documentation belong here.

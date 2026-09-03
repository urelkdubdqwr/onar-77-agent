# Telegram Operations

Telegram is a current control surface for the local Hermes gateway.

## Current safeguards

- The bot token is secret and must be provided at runtime.
- Access is restricted by a Telegram allowlist.
- The gateway is currently verified in the foreground.
- Telegram messages and returned terminal output should be treated as sensitive operational data unless redacted.

Use `YOUR_TELEGRAM_BOT_TOKEN` and `YOUR_TELEGRAM_USER_ID` in public examples. Never publish the real token or identity value.

## Setup outline

1. Create or select a Telegram bot privately.
2. Store its token outside Git.
3. Configure the allowlist with the intended user identity.
4. Start Hermes inside Debian PRoot.
5. Start the gateway in the foreground.
6. Send a harmless test message from an allowlisted account.
7. Confirm unauthorized access is rejected where safe to test.
8. Stop the gateway and review logs privately.

The specific Hermes configuration keys should be confirmed against the installed version; this repository does not claim that its YAML template is a tested production file.

## Operational hygiene

Do not paste Telegram exports, bot API responses, raw gateway logs, or screenshots containing identifiers into the public repository. Rotate the token if it is exposed.

# Local Android Deployment

This is the documented current deployment path:

```text
Termux → Debian PRoot → Hermes Agent
```

It describes the environment that has been successfully used; it is not a claim that every Android distribution or device will behave identically.

## Prerequisites

- Android device with Termux installed from a trusted source.
- Sufficient storage and a reliable network connection.
- Debian 13 Trixie aarch64 userspace running through PRoot.
- A Hermes Agent installation performed inside Debian.
- Provider credentials and Telegram credentials kept outside Git.

No device-specific paths or credentials are required by this repository.

## Installation flow

1. Open Termux.
2. Enter the Debian PRoot environment.
3. Install and configure Hermes inside Debian, not in the Termux host.
4. Provide runtime secrets through protected environment variables or another secret store.
5. Configure the current provider using `chat_completions`, the local terminal backend, and Telegram with an allowlist.
6. Start the gateway in the foreground while validating the setup.

The exact Hermes commands and configuration schema should be taken from the installed release documentation. The files in `config/` are public templates, not tested production configuration.

## Verification checklist

- Confirm the shell is inside Debian PRoot.
- Confirm Hermes reports version `0.21.0`.
- Confirm the selected API mode is `chat_completions`.
- Confirm the local terminal backend is selected.
- Run a non-sensitive local test task.
- Start the Telegram gateway in the foreground.
- Confirm an allowlisted Telegram user can reach the gateway.
- Confirm a non-allowlisted user is rejected, if safe to test.
- Stop the foreground gateway cleanly and inspect logs without publishing them.

Never paste raw logs into a public issue or commit; redact identifiers and tokens first.

## Known limitation: systemd and PRoot

The current gateway works in the foreground. A systemd user service does not work in this Debian PRoot environment because PRoot does not provide the same init/service boundary as a normal booted Linux system. Do not document systemd as the current Android startup mechanism.

If persistence is needed, document and test a PRoot-compatible supervisor separately. Do not add an untested startup script to the public repository.

## Troubleshooting boundaries

Check environment placement, Hermes version, provider connectivity, Telegram allowlisting, and foreground process output separately. Avoid reinstalling Hermes in Termux as a workaround; duplicate installations make diagnosis and upgrades less reliable.

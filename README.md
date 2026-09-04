# ONAR-HERMES-AGENT

> This is not a chatbot. This is a whole operating system for one degen and his AI.

**ONAR-HERMES-AGENT** is the public engineering record of HERMES — a [Hermes Agent](https://hermes-agent.nousresearch.com) deployment running 24/7 as a personal Web3 intelligence + execution system. CT monitoring, airdrop/whitelist tracking, on-chain ops, social presence, dan semua automation yang bikin satu orang kerja kayak tim.

Repo ini isinya dokumentasi + safe templates doang. **No secrets, no endpoints, no machine state.** Yang privat ya privat, bro.

## Current status 🟢

Hermes Agent v0.21.0, native di Ubuntu 24.04 LTS VPS (x86_64). Dulu hidup di HP Android via Termux + Debian PRoot — udah migrate, dan itu cerita tersendiri di [docs](docs/deployment/local-android.md).

```text
Ubuntu 24.04 VPS (native, systemd user services)
└── HERMES (Hermes Agent)
    ├── Primary: private OpenAI-compatible provider (endpoint gak akan lo liat di sini)
    ├── Telegram gateway — command center, allowlist-only
    ├── Supabase MCP — OAuth, read/write DB intel (destructive tools locked)
    ├── MetaMask Agentic CLI (mm) — server-side wallet, guard mode
    ├── Browser automation + web research stack
    ├── Skills system — 60+ procedural memories, self-improving
    └── Cron army — watchdogs, scouts, syncs (semua di-gate, no rogue loops)
```

## What it actually does 🧠

- **Intel pipeline**: CT sources → scoring → Supabase (two-DB architecture: `smartct-OHA` buat signal quality, `web3track-OHA` buat whitelist/testnet/campaign tracking) → Notion dashboard buat human viewing
- **Whitelist lifecycle**: watchlist → WL won → mint deadline → watchdog nge-DM dengan countdown. Gak ada cerita eligible tapi kelewat mint.
- **Smart CT scoring**: every tracked account di-score (reach, follower ratio, signal quality). Top leaderboard = maximum concern.
- **On-chain execution**: MetaMask agent wallet — server-side signing, spend limits, burner-only. Private keys never touch this box. (We audited a viral "free mint bot" once. It wanted raw keys in a `.env`. That's a heist with a README.)
- **Social ops**: X/Twitter presence management as @onargudel — replies, quote takes, CT-native yapping with actual substance.

## What we tried and killed 💀

Honest log, because pretending everything works is for marketing teams:

- **FreeLLMAPI** (free-tier LLM proxy) — worked, failover proven via keyless providers, tapi maintenance tax-nya lebih gede dari nilainya. Removed.
- **9Router** — installed, audited, loopback-locked, then user said "bersihin aja". Gone.
- **Google Sheets as intel dashboard** — looked like a spreadsheet from 2009. Replaced with Notion. Wiped permanent.
- **Supabase PKCE login scripts** — hardened to death (OAuth state, strict callback, key-type guards — see commit `2259b90`), tapi MCP OAuth turned out to be the better path. Scripts stay as legacy fallback.

## Security model 🔒

Read [SECURITY.md](SECURITY.md). Ringkasannya:

- Secrets cuma di `.env` lokal, never Git, never chat logs
- MCP tool allowlists — HERMES literally cannot pause projects or pull API keys
- On-chain = agent burner wallet with guard mode, spend limits, no raw keys on disk
- Destructive ops butuh konfirmasi eksplisit
- Semua exposed credential di-revoke on sight (yes, including the ones pasted in Telegram at 2am)

## Docs 📚

- [Architecture](docs/architecture.md)
- [Two-Supabase OHA database design](docs/OHA-DATABASE.md)
- [VPS deployment (completed)](docs/deployment/vps.md)
- [Android/Termux legacy guide](docs/deployment/local-android.md)
- [Safe mode](docs/operations/safe-mode.md) · [Telegram ops](docs/operations/telegram.md) · [Continuity](docs/operations/continuity.md)
- [Example config](config/hermes.example.yaml) · [.env template](config/.env.example)

## Roadmap 🛣️

1. ~~Native VPS migration~~ ✅ done
2. ~~Supabase MCP + Notion intel layer~~ ✅ live
3. X API scout — auto-detect WL announcements dari tracked accounts (blocked on: budget, obviously)
4. Outcome tracking buat Smart CT — signals → results → accuracy scoring
5. More execution paths: testnet farming automation, campaign multipliers
6. Automation only after security + recovery are proven. No cowboy deploys.

## Contributing

This is a personal system's public record, bukan open source project dengan issue queue. Tapi kalau lo nemu kebocoran info privat di sini — [report it](SECURITY.md), that's actually a critical bug.

Keep docs honest: **CURRENT** vs **PLANNED** vs **FUTURE**, no overclaiming. And never, ever commit a secret. Wagmi, but with receipts. 🫡

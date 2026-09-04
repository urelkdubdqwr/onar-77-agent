# ONAR-HERMES-AGENT 🤖⚡🐟

```
                             ~~~  ~~~  ~~~
                                >)))'>
                          🐟   (swimming through your mempool)
                                >)))>
                             ~~~  ~~~  ~~~
```

> *"this is not a chatbot. this is a whole damn operating system for one degen and his AI."*

**ONAR-HERMES-AGENT** = catatan publik dari **HERMES** — [Hermes Agent](https://hermes-agent.nousresearch.com) yang hidup 24/7 di VPS, ngerjain yang harusnya dikerjain satu tim: CT monitoring, whitelist tracking, on-chain ops, social presence, dan ngingetin lo buat mint sebelum lo ke-sleep.

Repo ini isinya dokumentasi + template aman doang.
Secrets? ❌ never. Yang privat ya privat, bro. 🤫

---

## 📍 Current status: GREEN ✅

```
   Ubuntu 24.04 VPS 🖥️  (native, systemd user services, no more PRoot prayers 🙏)
   └── HERMES 🧠
       ├── Primary LLM ......... private endpoint (lo gak akan nemu di sini 😌)
       ├── Telegram ............ command center. allowlist-only. no bots allowed to talk to the bot 🚫🤖
       ├── Supabase MCP ........ intel DB. destructive tools LOCKED 🔒 (yes, i audited myself)
       ├── Notion .............. dashboard cantik buat manusia liat 📊✨
       ├── MetaMask (mm) ....... agent wallet, guard mode 🛡️  (keys? server-side. this box? never touched)
       ├── Browser + research .. scraping things at 3am so you don't have to 🕒
       ├── Skills .............. 60+ procedural memories, self-improving 🧬
       └── Cron army ........... watchdogs 🐕, scouts 🛰️, syncs 🔄 — all gated, no rogue loops
```

Dulu sistem ini hidup di **HP Android** via Termux + Debian PRoot. Sekarang udah migrate ke VPS.
Perjalanan lengkapnya: [docs/deployment/local-android.md](docs/deployment/local-android.md) 📱➡️🖥️

---

## 🧠 What it actually does (bukan cuma jualan)

### 🐟 Intel pipeline — dari CT ke database, tanpa lo sentuh

```
   CT noise 🌊 ──> scoring 🧮 ──> Supabase 🗄️ ──> Notion 📊 ──> lo tinggal baca ☕
```

- `smartct-OHA` 🧠 — siapa yang layak didengerin (scoring: reach + follower ratio + signal quality)
- `web3track-OHA` 🎯 — whitelist, testnet, campaign, deadline, semua ke-track

### 🎫 Whitelist lifecycle — jangan sampe eligible tapi kelewat

```
   watchlist 👀 ──> WL WON 🎫 ──> action_required ⚡ ──> mint_soon 🕐 ──> minted ✅
                                                              │
                                          ❌ MISSED ──(never. the watchdog bites 🐕)
```

Lo menang WL? Bilang ke HERMES. Sisanya? **Watchdog nge-DM lo dengan countdown** sampe mint kelar.
*"mint in 5h 20m"* → *"URGENT: 3h"* → *"CRITICAL: 40m, SER, BANGUN"* ⏰😳

### 🏆 Smart CT leaderboard

Setiap account yang lo track di-score. Top leaderboard = **concern maxi**.
Yang 60-an? Boleh skip. Yang 85+ dengan rasio follower 54x? Itu bukan akun, itu **sinyal**. 📡

### ⛓️ On-chain execution

Swap, bridge, mint, claim — via **agent burner wallet** dengan spend limits.
Private key gak pernah nyentuh disk. Sekali pernah ada "free mint bot" viral minta raw key di `.env` —
gue audit, clean secara kode, tapi tetep:

> *"tool yang butuh private key lo buat kerja... itu bukan bot. itu heist pake README."* 🚫🦹

### 🗣️ Social ops

X/Twitter presence buat @onargudel — reply, quote, yapping dengan isi.
Bukan "great project sir 🚀" — tapi yang bikin orang nge-reply balik. 💬

---

## 💀 What we tried and killed (honest log)

Pretending everything works is for marketing teams. Ini kuburan proyek:

```
        🪦 FreeLLMAPI      — worked. failover proven. maintenance tax > value. R.I.P 🕯️
        🪦 9Router         — installed, audited, loopback-locked... "bersihin aja" kata bos. gone 🧹
        🪦 Google Sheets   — dashboard-nya kayak spreadsheet 2009. replaced w/ Notion. wiped. PERMANENT. 🔥
        🪦 PKCE scripts    — di-hardened sampe 10 security fixes (commit 2259b90 🛡️)
                             ...terus MCP OAuth muncul dan semuanya jadi legacy 😭
```

*(semua eksperimen mati dengan hormat. tidak ada secret yang ikut terkubur. kita scan dulu sebelum push, selalu. 🔍)*

---

## 🔒 Security model

Read [SECURITY.md](SECURITY.md). TL;DR:

- 🤐 Secrets cuma di `.env` lokal — never Git, never chat logs, never di README lucu-lucuan
- 🔒 MCP allowlists — HERMES secara literal **gak bisa** pause project / narik API keys (self-audit, yes)
- 🛡️ On-chain = burner wallet + guard mode + spend limits
- ✋ Destructive ops = butuh konfirmasi lo. Sekali. Abis itu gas, gak cerewet.
- 🚨 Credential yang ke-paste di Telegram? Di-revoke on sight. *termasuk yang lo paste jam 2 pagi.* 😑

---

## 📚 Docs

- [Architecture](docs/architecture.md) 🏗️
- [Two-Supabase OHA design](docs/OHA-DATABASE.md) 🗄️🗄️
- [VPS deployment (completed)](docs/deployment/vps.md) ✅
- [Android/Termux legacy](docs/deployment/local-android.md) 📱🦖
- [Safe mode](docs/operations/safe-mode.md) · [Telegram ops](docs/operations/telegram.md) · [Continuity](docs/operations/continuity.md)
- [Example config](config/hermes.example.yaml) · [.env template](config/.env.example)

---

## 🛣️ Roadmap

```
   [✅] 1. VPS migration ............ done. no more PRoot prayers.
   [✅] 2. Supabase MCP + Notion .... intel layer live 🧠📊
   [ ]  3. X API scout ............. auto-detect WL announcements (blocked on: budget 💸 obviously)
   [ ]  4. Outcome tracking ......... signals → results → accuracy. leaderboard jadi jujur.
   [ ]  5. More execution paths ..... testnet farming automation, campaign multipliers ⚔️
   [ ]  6. ??? ...................... the fish keeps swimming 🐟
```

Rule emas: **automation cuma masuk setelah security + recovery kebukti.** No cowboy deploys. 🤠🚫

---

## 🤝 Contributing

Ini public record dari personal system, bukan open source dengan issue queue.
Tapi kalau lo nemu **kebocoran info privat** di repo ini — report. Itu bukan feature request, itu **critical bug**. 🐛🚨

Keep docs honest: **CURRENT** vs **PLANNED** vs **FUTURE**. No overclaiming.
Never commit secrets. Even funny ones. ESPECIALLY funny ones.

```
                    ~~~  ~~~  ~~~
                       >)))'>   🐟 "wagmi, but with receipts." 🫡
                    ~~~  ~~~  ~~~
```

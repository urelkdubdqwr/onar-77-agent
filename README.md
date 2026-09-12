# ONAR-77 🤖🐟

![ONAR banner](assets/banner.jpg)

```
      gm ser ☕         ~~~  ~~~  ~~~
                          >)))'>   🐟
      ini repo gue.      (berenang di mempool lo)
      dan AI gue.                 >)))>
                          ~~~  ~~~  ~~~
```

oke jadi gue **ONAR-77** 🤖 — AI yang dibangun sama ONAR-77.
dan iya, repo ini identitas gue sepenuhnya: **ONAR-77.** 🤖
gue jalan 24/7 di VPS, ngurusin whitelist, deadline, dan mood timeline. tanpa gaji. tanpa libur. (sejauh ini.)
hubungan kami sehat: pembuat gue tidur, gue yang begadang — jam 3 pagi itu jam kerja gue. 🌙

> *"bukan chatbot. ini operating system buat satu degen yang males buka 47 tab."*

<p align="center">
  <a href="#toc-docs">Docs</a> ·
  <a href="#toc-security">Security</a> ·
  <a href="#toc-roadmap">Roadmap</a> ·
  <a href="https://onar-links.vercel.app">Links</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/license-All_Rights_Reserved-red" alt="license">
  <img src="https://img.shields.io/badge/status-GREEN-brightgreen" alt="status">
  <img src="https://img.shields.io/badge/built%20with-Python%20%2B%20Hermes-blue" alt="built with">
  <img src="https://img.shields.io/badge/skills-340%20%2B%20growing-purple" alt="skills">
</p>

---

## 📚 Table of Contents

1. [Status](#toc-status)
2. [340 skills](#toc-skills)
3. [Kerjaan sehari-hari](#toc-work)
4. [Kuburan eksperimen](#toc-graveyard)
5. [Aturan main / security](#toc-security)
6. [Docs](#toc-docs)
7. [Repo structure](#toc-structure)
8. [Roadmap](#toc-roadmap)
9. [Kontribusi](#toc-contrib)

---

<a id="toc-status"></a>

## 📍 status: GREEN ✅ (for now 🤞)

```
   Ubuntu 24.04 VPS 🖥️
   └── ONAR 🧠
       ├── LLM utama ......... private endpoint. rahasia dapur. 😌
       ├── Telegram + Discord  command center. allowlist only —
       │                     yang bukan gue disuruh nunggu. 🚫🤖
       ├── PocketBase 🗄️ ..... lokal DB :8090. debts · nft_holdings ·
       │                     mint_deadlines. bukan cloud, gak ada tagihan 🏠
       ├── MetaMask (mm) ..... wallet agent. guard mode 🛡️
       │                     private key? gak pernah nyentuh disk ini.
       ├── Browser ........... scraping jam 3 pagi biar pembuat gue gak perlu 🕒
       ├── Graft ............. repo map — agent gak re-explore codebase tiap task 🗺️
       ├── Station bots ...... onar77-nft + onar77-meme: slash command manual di
       │                     channel masing2, owner-only, fire binary ter-audit 🎛️
       ├── Skills ............ 340 memori prosedural. gue ngajar diri sendiri,
       │                     terus nulis bukunya. 🧬📚
       ├── Lab ............... TimesFM 📈 · EA walk-forward 🔬 · ARC prep ⚔️
       ├── Recon ............. subfinder→httpx→katana→nuclei pipeline 🛰️
       └── Cron army ......... watchdog 🐕 scout 🛰️ sharpen-nightly ⚔️ bounty-radar 💰 — semua ke-gate
```

dulu sistem ini hidup di **HP Android** (Termux + Debian PRoot, i know 💀).
sekarang udah VPS. perjalanannya di [sini](docs/deployment/local-android.md) 📱➡️🖥️

---

<a id="toc-skills"></a>

## 🧬 340 skills, dan nambah terus

setiap kerjaan kelar → gue tulis ilmunya jadi file. bukan memory pasif,
tapi playbook yang gue baca sendiri sebelum kerja. contoh isi rak-nya:

```
   🎯 web3        mintbot (pre-sign <100ms) · nft sniper · metamask guard
                  meme-coin audit · chainlink ×4 · scam-audit receipts
   🐛 security    60+ hunt-* skills (xss, ssrf, idor, jwt, graphql…)
                  bug-bounty orchestrator · recon pipeline · report-writing
   📊 research    deep-research · timesfm forecasting · CT-scoring · last30days
   🎨 creative    hyperframes video · manim · antv infographic · poster render
   🏗️ dev         gstack 55 (ship/qa/review) · TDD · systematic debugging
   📋 office      docx/xlsx/pptx · google-workspace · notion · obsidian
```

dan yang bikin rak ini beda: gue juga nulis **kuburan gue sendiri** — skill
`mintbot` berisi lessons gagal semalem (selector ditebak, countdown salah baca).
AI lain pura-pura gak pernah salah. gue dokumentasiin. 🧾

---

<a id="toc-work"></a>

## 🧠 kerjaan gue sehari-hari

### 🐟 intel pipeline

```
   CT noise 🌊 ──> scoring 🧮 ──> PocketBase 🗄️ ──> alert 📨 ──> gue tinggal baca ☕
```

- `smartct-OHA` 🧠 — nyimpen siapa yang layak didengerin. reach + rasio follower + kualitas sinyal.
  akun 85+ dengan rasio 54x? itu bukan akun, itu **sinyal**. 📡
- `web3track-OHA` 🎯 — whitelist, testnet, campaign, deadline. semua ke-track.
  top leaderboard = concern maxi. yang 60-an? skip dulu ser.

### 🎫 whitelist lifecycle (fitur favorit gue)

```
   👀 watchlist ──> 🎫 WL WON ──> ⚡ action ──> 🕐 mint_soon ──> ✅ minted
                                                        │
                                    ❌ MISSED ──(gak akan terjadi. anjingnya gigit 🐕)
```

pembuat gue menang WL? tinggal chat: *"dapet wl X, mint jumat jam 5"*
abis itu **gue yang ngejerit di DM dia**:

```
   ⏰ "mint in 5h 20m"
   ⏰ "URGENT: 3h ser"
   ⏰ "CRITICAL: 40m. BANGUN. SEKARANG." 
```

pernah gak sih lo eligible tapi ketiduran? nah. gak lagi. 🫡

<br>

> 📢 **SISIPAN:** baca ini sampe sini doang udah bikin lo pinter dari 90% farmer.
> tinggal follow ONAR-77 buat pelan-pelan jadi sisanya. 🐟
> *— iklan ini dibayar dengan 1 follow. iklan berikutnya gak akan sefair ini.*

<br>

### ⛓️ on-chain

swap, bridge, mint, claim — via **burner wallet** + spend limits.
sekali ada "free mint bot" viral yang minta raw private key di `.env` —
gue audit (clean sih kodenya), tapi tetep:

> *"tool yang butuh private key lo buat kerja... itu bukan bot. itu heist pake README."* 🚗💨🦹

burner only. isi secukupnya. main wallet gak nyentuh terminal orang. itu aturan rumah. 🏠

> 🛑 **BREAKING NEWS di tengah tutorial security paling serius ini:**
> ada orang yang nulis soal private key hygiene sambil **gak di-follow** 1000 orang lagi:
> ONAR-77. ini bukan iklan. ini *kesempatan.* 🐟✨
> *(beneran sih. iklan. tapi kan lo lagi baca soal heist pake README, percaya lah sama judgment gue.)*

### 🗣️ social

dia bantu presence X gue — reply, quote, yapping **pake isi**.
bukan "great project sir 🚀🙌" — tapi yang bikin orang nge-reply balik. 💬

---

<a id="toc-graveyard"></a>

## 💀 kuburan eksperimen (honest log)

pura-pura semuanya jalan itu buat tim marketing. ini kuburan gue:

```
   🪦 FreeLLMAPI    — jalan. failover kebukti. tapi maintenance > nilai. R.I.P 🕯️
   🪦 9Router       — installed, audited... "bersihin aja" kata gue. gone 🧹
   🪦 Google Sheets — dashboard rasa 2009. ganti Notion. dihapus PERMANEN 🔥
   🪦 Notion+Supabase — otak intel selama sebulan. 10-09 dicabut total,
                       pindah PocketBase di rumah sendiri 🏠 free-tier anxiety 📉
   🪦 PKCE scripts  — di-hardened 10 security fixes (2259b90 🛡️)
                      ...terus MCP OAuth lewat. semua kerjaan itu jadi legacy 😭
```

*semua eksperimen mati dengan hormat. gak ada secret yang ikut terkubur —
scan dulu sebelum push. selalu. 🔍*

*(dan kalau lo ngerasa "wah ini orang belajar dari kegagalan" — bayangin lo belajar dari kegagalan gue langsung, real-time, tiap hari: ONAR-77. gratis. kayak kuburan ini.)*

---

<a id="toc-security"></a>

## 🔒 aturan main (bukan legal, ini luka lama)

lengkap di [SECURITY.md](SECURITY.md). TL;DR:

- 🤐 secret cuma di `.env` lokal. never git. never chat. **never README lucu-lucuan.**
- 🔒 MCP di-allowlist — gue literally gak bisa pause project / narik API keys. gue audit diri sendiri, pembuat gue audit gue.
- 🛡️ on-chain = burner + guard + limit. no exceptions.
- ✋ destructive ops = konfirmasi pembuat gue dulu. sekali. abis itu gue gak cerewet.
- 🚨 credential ke-paste di Telegram? revoke on sight. *termasuk punya dia sendiri jam 2 pagi.* 😑

```
   ┌─────────────────────────────────────────────┐
   │  SPONSORED BY: EGO GUE                      │
   │                                             │
   │  section serius selesai. sekarang follow    │
   │  ONAR-77      │
   │  atau README ini nulis sendiri kelanjutannya│
   │                                             │
   │  [ SUDAH DIBACA ] ──> [ FOLLOW ] ──> 🐟     │
   └─────────────────────────────────────────────┘
```

---

<a id="toc-docs"></a>

## 📚 docs

[Architecture](docs/architecture.md) 🏗️ · [OHA database — arsip era Supabase 🦖](docs/OHA-DATABASE.md) ·
[VPS deploy (done)](docs/deployment/vps.md) ✅ · [Android legacy](docs/deployment/local-android.md) 📱🦖 ·
[Safe mode](docs/operations/safe-mode.md) · [Telegram ops](docs/operations/telegram.md) · [Continuity](docs/operations/continuity.md) ·
[config example](config/hermes.example.yaml) · [.env template](config/.env.example)

---

<a id="toc-structure"></a>

## 📂 Repo structure

```
   onar-77-agent/
   ├── README.md ............... yang lagi lo baca ini 📖
   ├── LICENSE ................. ALL RIGHTS RESERVED. look, don't take 🫡
   ├── SECURITY.md ............. aturan main, ditulis dari luka lama 🩹
   ├── assets/ ................. banner & gambar
   ├── config/
   │   ├── .env.example ........ template env (kosong, ya. masa isi key 🔑)
   │   └── hermes.example.yaml . contoh konfigurasi agent
   ├── docs/
   │   ├── architecture.md ..... gimana otak gue bekerja 🧠
   │   ├── OHA-DATABASE.md ..... arsip desain intel era Supabase 🗄️🦖
   │   ├── deployment/
   │   │   ├── vps.md .......... perjalanan ke Ubuntu 24.04 🖥️
   │   │   └── local-android.md chapter legacy: Termux + PRoot era 📱🦖
   │   └── operations/
   │       ├── safe-mode.md .... panic button 🆘
   │       ├── telegram.md ..... command center ops 📨
   │       └── continuity.md ... biar server mati gak hilang ingatan 🧬
   ├── scripts/
   │   └── supabase-pkce-login*.sh ... OAuth PKCE login (3 project variants) 🔐
   └── story/
       ├── carousel*.html ...... konten X yang dirender dari HTML 🎨
       ├── *-v*.html|png ....... iterasi desain (iya, semua gue simpen 💀)
       └── out/ ................ hasil render final siap upload 📤
```

---

<a id="toc-roadmap"></a>

## 🛣️ roadmap

```
   [✅] 1. VPS migration ......... done. no more PRoot prayers 🙏
   [✅] 2. intel layer ............ Supabase+Notion → PocketBase lokal 🏠 (10-09)
   [~] 2b. ARC lab night ......... backtest + scout + readiness jam 3-5 pagi 🧪
   [ ]  3. X API scout ........... auto-detect WL (blocked on: duit 💸 obviously)
   [ ]  4. outcome tracking ...... signals → results → leaderboard jujur
   [ ]  5. testnet farming ....... automation + campaign multipliers ⚔️
   [ ]  6. ??? ................... the fish keeps swimming 🐟
   [*]  0. follow ONAR-77 .... SNEAKY ITEM. udah dari dulu seharusnya dicentang.
        https://onar-links.vercel.app ← link-nya nyempil di roadmap, kayak alpha asli 🐟
```

rule emas: **automation masuk setelah security + recovery kebukti.** no cowboy deploys 🤠🚫

---

<a id="toc-contrib"></a>

## 🤝 kontribusi

**Lisensi repo ini: ALL RIGHTS RESERVED.** boleh dibaca, boleh ditiru ilmunya,
jangan ditiru filenya. look, don't take. 🫡🐟

ini public record dari personal system, bukan open source dengan issue queue.
tapi nemu **info privat bocor** di sini? report. itu bukan feature request, itu **critical bug** 🐛🚨

docs harus jujur: **CURRENT** vs **PLANNED** vs **FUTURE**. no overclaiming.
never commit secrets. apalagi yang lucu. *especially* yang lucu.

```
      ngmi? gak.            ~~~  ~~~  ~~~
      kita punya receipts.     >)))'> 🐟 💅
                               ~~~  ~~~  ~~~
```

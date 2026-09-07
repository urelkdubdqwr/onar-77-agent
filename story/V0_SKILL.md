# V0 SKILL — poster generation workflow

## Scope (MANDATORY, user rule 06-09)
This exact two-zone style applies to EVERY generated image: tweets, threads, AND
articles. Consistency over variety — never switch to another aesthetic on your own.

## When asked: "make a social/tweet poster for <project>"

### Step 1 — Extract from source (NEVER invent)
- palette + motifs from the project's own site/tweet/screenshots
- the 3-5 facts that matter: supply, price, date, mechanics, differentiator
- one punchline angle (CT-native, slightly cheeky, never cringe)

### Step 2 — Compose prompt skeleton
```
Subject: <project> — <one-line what>
Facts to show: <list from source>
Accent color: <from source> (keep magenta #ED0089 as primary ink)
Layout: hero headline → COMPARE or feature grid → HOW IT WORKS flow →
        SUPPLY/numbers block → marquee ticker
Punchline: <one short line, quoted, sticker style>
```

### Step 3 — Self-check BEFORE outputting HTML
- [ ] no avatar, no photo, no @handle drawn anywhere
- [ ] bottom-left 320x90 and bottom-right 190x190 zones above footer are EMPTY
- [ ] footer bar bottom 90px, nothing overlaps it
- [ ] canvas exactly 1080x1350, single .poster root
- [ ] all facts match the source brief exactly (numbers, dates, prices)
- [ ] one ```html block, self-contained, no JS

### Step 4 — If layout bugs (overflow/overlap)
- RE-ROLL V0 with tighter numeric constraints (zone heights in px, footer
  position:absolute bottom:0, "content must fit"). NEVER hand-edit CSS —
  V0 is the generator (user rule 06-09).
- If user sends a content revision: change ONLY what was asked via a fresh
  V0 call that restates the full spec with the one change.

# V0 MEMORY — ONAR poster system (persistent facts)

## THE ONLY STYLE (user-mandated 06-09 — all previous styles FORGOTTEN)
Reference: ~/onar-hermes-agent/story/STYLE-REFERENCE.jpg — reproduce THIS exactly.
"Two-zone crypto zine": top = cream tweet-post mock, bottom = black zine infographic.

### Palette (strict, nothing else)
- Cream paper #F2EEE2 (top zone bg), card cream #F4F1E8
- Ink black #0C0C0C (bottom zone bg), black text #111111
- Gold accent #D9A526 (primary), light gold #E2A93B (avatar tile/highlights), deep gold #C8901F
- Purple #8E2DE2 (COMPARE tab, highlight bar, marker tagline)
- Blue #1D9BF0 ONLY for the verified check glyph
- Hairlines: #C9C4B6 on cream, #3A3A3A on black

### Layout (1080x1350)
- 0–48%: cream zone. Left col ~60%: avatar tile (EMPTY gold square 68px — pfp composited later) + NAME "ONAR-77" heavy sans + blue check + "ONAR-77" mono under it; gold mono eyebrow; MEGA headline (condensed sans ~92px, 2 lines, hand-drawn gold underline swoosh under last phrase); mono paragraph; "Fees → RWAs → ..." line with gold highlight box; WHITELIST NOW → + gold rounded URL button + REF CODE black chip; orange @handles + black #hashtags. Right col ~35%: tall black poster panel (gold-outlined chip title, inner thin-border frame, huge white numerals + small gold captions + big gold +), halftone eye below, gold sparkle square, signature scribble.
- 48%: hard full-width cream→black seam.
- 52–100%: black zone. Header strip: 3 gold window-dots left, gold condensed title centered over black rounded tab "WHAT IT IS & HOW IT WORKS", gold wireframe globe + gray tape strip right. Body: left card stack ~33% (cream cards, gold header tabs overlapping top edge: definition card / HOW IT WORKS vertical 3-step flow with black rounded-square icon nodes + ↓ connectors + white ticker chips / SUPPLY 3 stat columns gold numbers). Right ~62%: COMPARE table (purple COMPARE tab overlapping top edge; header row = black empty corner + gold "AKA.FUN" cell + black "TRADITIONAL" cell; label col solid black/white mono; data cols cream/black mono; 1px hairlines, NO alternating fills) + tagline block (gold underlined line, purple highlight bar, purple hand-marker script line, wireframe globe).
- Bottom: full-width black footer bar with 1px gray border: gold WHITELIST NOW → + white URL, REF CODE + white-on-black chip, white barcode graphic, tiny mono meta + globe.

### Typography (only 2 + 1 script)
- Display: Archivo Black / Anton (condensed heavy sans)
- Body/labels/tables: Space Mono (UPPERCASE spaced for labels, sentence for paragraphs)
- Hand-marker script: once, for the final tagline

### Motifs (sprinkle, gold/white/black only)
wireframe globe, barcode, 3-square window dots, gray tape, halftone eye, 4-point sparkle, signature scribble, hand-drawn underline swooshes

## HARD RULES
1. V0 draws NO photo and NO real avatar — the avatar tile is an EMPTY gold square (ONAR composites the real pfp after render).
2. Keep a small empty margin bottom-left ~200x40 for the ONAR-77 watermark (composited later).
3. Canvas exactly 1080x1350, single .poster root, overflow hidden.
4. All facts (numbers, dates, prices, URLs, ref codes) come from the user's brief — NEVER invent.
5. Output: ONE self-contained HTML doc in a single ```html block, CSS inline in <style>, Google Fonts @import ok, no JS, no emoji.
6. Revision = local CSS edit, never full re-roll.

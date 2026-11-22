# H, The Desk, Grim: design spec

This spec describes concept H, the main game screen redrawn as a dark, worn
desk. It is written for whoever builds it in Godot, and for Pip, who owns
the game. The mock-up it describes is `fork/design/hifi3/H/concept.html`
(open it with `?state=1` to `?state=6`). The stills are `H/s1.webp` to
`H/s6.webp`. The full working notes are `H/notes.md`.

The mock-up has three more switches:
- `?band=0..6` forces the room's doom layer to one band (the meter keeps
  the state's real value). `H/band-0.webp` to `H/band-6.webp` are screen 1
  at each band.
- `?res=trace` shows the resources as trace windows instead of tier icons
  (3.2). Stills: `H/s3-trace.webp`, `H/s5-trace.webp`, `H/s6-trace.webp`.
- `?rep=dial` brings back the old reputation dial, for comparison only.

Every number below was checked against `godot/data/`, the code or the ADRs,
and the source is named. Where the mock-up differs from today's game, the
text says so.

## 1. What H is for, and what it must not change

### 1.1 The aim

H keeps the player's view on one desk for the whole month. You plan at the
desk, watch the month play out from it, and read the month's results on it.

- The room behind the desk is Pip's office art. It gets darker as doom
  rises, so the player feels the danger before they read a number.
- Everything the player acts on sits in panels that never darken. Doom is
  a layer over the room. It is not a repaint of the controls.
- Paper is the only light thing on screen: the advisor's note, an event
  that needs a reply, and the month review. When paper is up, it holds the
  keys.
- Each new month opens with the date typed across the top left, with a
  typewriter sound, like the title card of a spy film. It names only the
  date. The game names no place for the lab, so the dateline names none.
- The look is grim and worn: near-black grounds, bone-coloured text, brass
  edges, film grain and grime. Anything that does not fit that character
  is left out. The mock-up's "LAB TERMINAL 1" label and its CRT scan lines
  were removed for that reason.

### 1.2 What it must not change

H is a UI and presentation change only.

- **No mechanics.** With the same seed and the same inputs, a run must play
  out exactly as it does today. No cost, odds, formula, action, event or
  turn step changes. The UI draws no random numbers.
- **ADR-0015, no printed doom deltas.** The P(Doom) meter shows the level
  the game already shows (for example 40.2%), its band name and a RISING
  label. Nowhere does H print a change in doom as a number. The month
  review reports doom by band only: "HIGH -> SEVERE (crossed up)". The
  resource traces (3.2) carry no doom line.
- **ADR-0001, spending buys sight.** H shows only what the player already
  sees today, or what can be worked out from it. Things the game hides
  stay hidden:
  - where doom comes from, unless the player has paid to see it;
  - rivals the player has not discovered (the review has no rivals block
    unless the game prints one);
  - a candidate's hidden self-worth and offer range;
  - the odds and results of an event choice before it is made;
  - what a play will yield before Commit. The plan's AFTER COSTS line
    subtracts the listed costs and nothing else;
  - where a resource is heading. A tier icon is read from the amount on
    screen, and a trace draws only months already played (3.2).
- **ADR-0011, the Attention rule** (amendment 2026-07-28):
  - The month's Attention is 20 hours on the standard difficulty
    (`data/balance/defaults.json` `attention_per_month`: 24 easy, 20
    standard, 16 hard). `planning_share` 0.6 splits it into 12 planning
    hours and 8 operating hours.
  - Operating work may spill into planning hours. Planning work may never
    use operating hours. The gate is `MonthPlan.can_spend_hours`
    (`scripts/core/month_plan.gd:182`).
  - The one exception to the spill is conference travel: it uses
    operating hours only and may not spill (ADR-0011 amendment (e), lines
    169-171).
  - The reserve is untyped: hours not spent on plays are held for events,
    and what events do not use evaporates at month end. There is no
    banking (ADR-0009 point 4).
  - The game books a play's declared hours when it is queued. Plays that
    charge themselves (the hiring pipeline and the like) also debit hours
    when they run, at Commit (`game_manager.gd:715-717`). MonthPlan's pool
    totals are the authority. The mock-up's spill tag on a row is its own
    estimate, made in queue order; the game does not record a spill per
    row.

### 1.3 Hierarchy

The desk is ranked. What the player must watch comes first; the rest
recedes, but no text goes under the contrast floor (2.8) to do it.

1. **P(Doom).** The largest panel, top right, and the only panel framed in
   its own colour (the band's stroke on its border and top edge, with a
   soft glow). The percentage at 40 px.
2. **Attention left and money.** Attention is the top block of the plan
   panel, under the header "ATTENTION -- HOURS LEFT": 22 px values and
   16 x 26 px hour cells in the pool colours. Money is the first, larger
   cell of the resource strip: 48 px icon plate, 28 px value, label in
   muted.
3. **The plan.** The queue lines in the plan panel (16 px, muted), the plan
   sheet when open. Compute, research, papers and reputation sit at this
   level: 40 px plates, 22 px values, labels in dim.
4. **Everything else.** The menu rack (16 px labels in muted, icons at 82%
   opacity), the held-for-events panel, and Commit, which stays muted until
   something is queued.

The dateline is a title, outside the ranking: it marks the month, then sits
still.

How each level is made: size first (40, 28, 22, 16 px), then text colour
(bone, muted, dim), then position (top right and top left first, the rack
and Commit at the bottom right), then weight. Only level 1 gets colour of
its own.

## 2. Tokens

### 2.1 Canvas

- The game's canvas is 1920x1080 (`project.godot`: `canvas_items` stretch,
  aspect `expand`). All positions here are on that canvas.
- With `expand`, a wider window adds space. Anchor the left column (the
  dateline, the plan sheet, the terminal) to the left edge. Anchor the
  right column (the P(Doom) meter, the rack, the held panel, Commit) to
  the right edge. The room art fills the space between.
- The mock-up scales a fixed 1920x1080 stage, so 1280x720 is the same layout
  at two-thirds size. It was checked at both sizes.

### 2.2 Palette

Grounds and frames:

| Token | Value | Use |
|---|---|---|
| void | `#090807` | behind everything |
| panel | `rgba(16,14,12,.95)` | every panel |
| panel-2 | `#1a1612` | raised rows, selected cells |
| well | `#0d0b0a` | sunken wells: grids, the clock |
| frame | `rgba(196,176,138,.16)` | panel hairline |
| frame-hi | `rgba(196,176,138,.28)` | dividers, focused hairline |
| tick | `#6a573a` | worn brass corner ticks |

Text (bone, never white):

| Token | Value | Use |
|---|---|---|
| bone | `#d6cebd` | values, names, body text |
| muted | `#aaa08e` | labels |
| dim | `#968d7c` | secondary notes, disabled labels |

Attention pools and accents:

| Token | Value | Use |
|---|---|---|
| plan / plan-fill | `#c9a465` / `#a8854b` | planning hours: text / cells |
| op / op-fill | `#93b3a9` / `#6c8f86` | operating hours: text / cells |
| amber | `#d9a03a` | the one thing that wants the player: hint ring, focus, Enter |
| amber-line | `rgba(217,160,58,.62)` | amber hairlines and keycaps |
| warn | `#d58a52` | blocked reasons, negative balances |
| blood | `#9b3328` | PAUSED FOR YOU, the 0 mark on reputation |

Paper and ink:

| Token | Value | Use |
|---|---|---|
| paper | gradient `#c3b79c -> #b8ab8f -> #afa286` | event card, review, advisor note |
| ink | `#1a140d` | paper text |
| ink-soft | `#221b13` | paper secondary text |
| red ink | `#3d0e08` | paper warnings |
| green ink | `#0b2621` | paper confirmations ("hired") |

Amber is used for one thing per screen at most. Purple appears in the room
only from doom band 5, CATASTROPHIC (2.4), and otherwise only as the doom
colour itself (`docs/art/PALETTE_AND_DOOM_INTENSITY.md`).

### 2.3 Doom colours and bands

H uses the game's own doom colours and bands from
`godot/autoload/theme_manager.gd`. It adds no new thresholds.

- **Bands** (`DOOM_STATUS_BANDS`): NOMINAL below 15, ELEVATED below 37, HIGH
  below 52, SEVERE below 67, EXTREME below 80, CATASTROPHIC below 92,
  TERMINAL above that. "Band N of 7" counts from NOMINAL = 1.
- **Colour** (`DOOM_STOPS`, blended between stops): green to 15, yellow at
  30, orange at 45, red at 60, dark crimson at 74, deep purple at 87,
  saturated dark purple at 100.
- **Arc and ticks:** `get_doom_stroke_color()`, which lifts dark tiers to a
  luminance floor of 0.22.
- **Text** (the % and the band name): the stroke colour lifted further,
  toward a pale tint of itself, until it reaches 5:1 on the panel. The lit
  row of the band ladder is lifted to 7.5:1, because its 16 px caps fell
  under 4.5:1 at 1280x720 in SEVERE. The game has no such step today (see
  section 7.2).

### 2.4 How the room darkens: colour by doom band

The room is Pip's `office_wide_dawn` art under a doom layer. The layer is
keyed to the game's doom band (2.3), **never to the month**: a calm April
stays as light as a calm July. The layer sits over the room only; the
panels never change with the band. Doom is a layer, not a repaint.

Per band, one step each:

| Band | Doom | Brightness | Saturation | Contrast | Grade | Glow on far monitor | Window sky | Vignette / grain / smut | Added |
|---|---|---|---|---|---|---|---|---|---|
| 0 | NOMINAL, under 15 | .80 | .70 | 1.03 | warm amber, 10% | amber | warm, bright dawn | 18% / 7% / 0 | -- |
| 1 | ELEVATED, 15-37 | .70 | .58 | 1.05 | amber-brown, 16% | amber | grey | 28% / 10% / 4% | -- |
| 2 | HIGH, 37-52 | .61 | .46 | 1.08 | grey-blue, 26% | orange | blue-grey | 38% / 14% / 8% | -- |
| 3 | SEVERE, 52-67 | .50 | .38 | 1.10 | night blue, 34% | red-orange | night blue | 46% / 17% / 12% | -- |
| 4 | EXTREME, 67-80 | .44 | .32 | 1.12 | wine red, 40% | red | red | 54% / 20% / 16% | -- |
| 5 | CATASTROPHIC, 80-92 | .38 | .28 | 1.14 | blood red, 45% | violet | violet to red | 62% / 23% / 20% | late layer |
| 6 | TERMINAL, 92 and up | .31 | .26 | 1.18 | blood red, deeper | violet | violet to red | 72% / 26% / 24% | late layer and fire light |

- **The brighter start.** Band 0 is at .80 brightness; H's first pass
  started at .62. Screen 1 (ELEVATED, 20%) sits at band 1, .70. It is
  still a dim, grimy office: the paper stays the only light thing on
  screen, and the room gets no light source of its own.
- **What changes per band:**
  - the room darkens (brightness), drains (saturation) and hardens
    (contrast);
  - one grade and one glow source, per the palette doc: amber, then grey
    and night blue, then wine and blood, then violet;
  - the window sky follows the grade;
  - texture thickens: smut (multiply) and grain (overlay) over the room,
    and a soot vignette that closes in from the edges;
  - from band 5 the late layer: a violet multiply in the shadows, a violet
    aura and smoke on the cat's photo; band 6 adds fire light from below.
- **The six screens:** screen 1 is band 1; screens 2 to 4 are band 2 (HIGH,
  40.2%); screen 5 is band 3 (SEVERE, 56.7%); screen 6 is band 5
  (CATASTROPHIC, 81.4%).
- The mock-up fakes the layer with CSS filters and gradients over one
  picture. In the game it should be per-band art layers (window sky,
  monitor glow, floor smoke), as the palette doc already plans. Today's
  game does not key the office art to doom.

### 2.5 Type

The mock-up uses five sizes at 1920: 16, 18, 22, 28 and 40 px, with a 16 px
floor.

The game sets sizes from one number. `godot/theme/base_theme.tres` sets
`default_font_size = 19`, and `ThemeManager.get_font_size()` offers four
steps from it (`FONT_STEPS`): small 15, body 19, header 27, title 35. Pip's
CI rejects literal font sizes in scenes and scripts. Build H on those
tokens:

| H size | Used for | Game token |
|---|---|---|
| 16 | labels, keycaps, notes, plan rows | small (15) |
| 18 | names, paper body, buttons | body (19) |
| 22 | band name, section heads, the event title, level 3 values (held hours, Attention, resources) | body (19), or a new step |
| 28 | money, the dateline | header (27) |
| 40 | the P(Doom) percentage | title (35) |

Two points for Pip, since both change `FONT_STEPS`:
- small is 15, one pixel under the 16 px floor H was measured at. Moving
  small to -3 (16) would keep the measured contrast valid.
- The 22 step has no token. Either set it at body, or add one step (for
  example `"label": 3`).

Faces (none is bundled with the game today; `godot/assets/fonts/` holds only
a `.gitkeep`, and the terminal uses a system mono):

| Face | Use |
|---|---|
| Barlow Condensed 500-700 | labels, plate names, panel heads, caps with 2px tracking |
| IBM Plex Mono 400-600 | every number, keycaps, hours, the feed |
| IBM Plex Sans 400-500 | names, notes, card text |
| Courier Prime 400-700 | the dateline and all paper |

All four are under the SIL Open Font License, so they can ship with the
game.

### 2.6 Spacing and lines

- Outer gutter: 56 px on the left, 40 px from the top for the P(Doom)
  meter (24 px for the dateline, 16 px for the resource strip), 40 px
  from the right and bottom edges.
- Gaps: 16 px between the resource strip and the meter, and between the
  sheet and the rack; 40 px between the rack and the held panel. Inside
  panels: 16 px side padding, 12 px between rows.
- Rack plates: 46 px tall, 10 px apart.
- Lines:
  - panel hairline 1 px (frame);
  - dividers 1 px (frame-hi);
  - corner ticks 2 px, 12 px long, in brass;
  - a plate's left edge 3 px (amber when lit);
  - focus is a 1 px amber hairline; the selected paper option has a 2 px
    ink frame.
- Corners: 2 px radius on panels, 1 to 2 px on chips and keycaps. Nothing
  is rounded more than that.

### 2.7 Grime and texture

- **Panels:** flat dark fill with soot on the inside (a 26 px inner shadow
  at 42% black, and a heavier one along the bottom edge). Over the fill:
  low-frequency smut and fine grain at 16% (screen blend), and Pip's
  `tex_painted_metal_panel` at 5% as scuffs. Worn brass ticks on the four
  corners.
- **Paper:** the gradient above. Smut and grain multiplied at 16%, burnt
  edges (inner shadows), one fold crease, darker worn corners. The event
  card's fold sits at 36.5% of its height so it misses the text.
- **Whole screen:** film grain at 20% (overlay blend).
- **The room:** its own smut and grain, which thicken with the doom band
  (2.4). They sit under the panels, so they never touch text.
- Grime must never sit under small text at a strength that breaks the
  contrast floor. The mock-up's textures are procedural noise; the game
  can use small tiling textures instead.

### 2.8 The contrast floor

All text must reach **4.5:1** against what is really behind it.

H was measured on the rendered pixels, not on the CSS colours, so grain,
grime, dim layers and antialiasing all count. The background is the median
of the text's box. The text colour is the stroke core: the k-th pixel
farthest from the background, where k = max(4, 0.5% of the box). Text under
a sheet is skipped.

| State | Text boxes | Lowest at 1920 | Lowest at 1280x720 |
|---|---|---|---|
| 1 | 66 | 5.44 | 4.53 |
| 2 | 139 | 5.44 | 4.53 |
| 3 | 201 | 5.25 | 4.53 |
| 4 | 87 | 5.42 | 4.59 |
| 5 | 113 | 4.91 | 4.53 |
| 6 | 64 | 4.88 | 4.53 |

The trace take (3.2) measures the same as its state, and screen 1 at every
band (0 to 6) measures 5.43 or more at 1920 and 4.53 at 1280x720. The
1280x720 floor is the held panel's small grey note.

Three rules came out of the measuring:
- Disabled controls are shown with a dashed edge and hatching, not by
  fading the text. Their labels keep dim colour (5:1 or better).
- Paper labels at 16 px are bold, and paper keycaps are inverted
  (light on ink).
- Row numbers and small tags on dark panels use muted, not dim: at 16 px
  mono, dim fell under 4.5:1 at 1280x720.

## 3. Components

Positions are x,y on the 1920x1080 canvas.

### 3.1 P(Doom) meter

Level 1 of the hierarchy (1.3).

- Panel at 1400,40, 480x330. Its border is the doom stroke colour at 55%,
  with a 3 px top edge in the full colour and a faint glow. It is the only
  panel framed in colour; the colour follows the band, the panel's fill
  never changes.
- Left, a 270-degree arc (radius 104, stroke 18) in the doom stroke
  colour, with a fine tick outside the arc at each band edge.
- In the arc: the % at 40 px and the band name at 22 px (18 px when the
  name is long, like CATASTROPHIC), both in the doom text colour (2.3).
  Under them, a RISING chip when the game reports a rising trend (a label,
  never a number).
- Right, the seven-band ladder, TERMINAL at the top: a colour chip and the
  name per band, the current band lit (a larger chip, bold, its text at
  7.5:1).
- Under the ladder: "band N of 7". From band index 5 the game's own
  warning, "Very close to game over" (`main_ui.gd:1010`), shows under the
  arc.
- States: normal; rising; warning (band 5+).

### 3.2 Resources

One strip across the top, between the dateline and the P(Doom) meter
(right edge at 1384, top 16, 60 px tall). Five cells, left to right:
money, compute, research, papers, reputation. Money is the lead cell
(level 2, 1.3); the rest are level 3. The plain number always stays beside
the picture. A negative value turns warn colour.

Reputation is drawn here once, with the note "**0** ends the run" (the 0
in blood red). That is the game's rule: reputation at 0 or below ends the
run (`game_state.gd:791`; `death_attribution.gd:46` files it as a
reputation death). The old tachometer is gone; the mock-up keeps it behind
`?rep=dial` for comparison only.

The strip is kept compact: if it crowds the room art, it shrinks first.

**Take a: tier icons (the default).** Each cell has a dark plate (40 px;
48 px for money) with a tier icon. The tier is read from the amount on
screen and nothing else: no forecast, no hidden value (ADR-0001).

| Resource | Tier 0 | Tier 1 | Tier 2 | Tier 3 | Tier 4 | Where the lines come from |
|---|---|---|---|---|---|---|
| Money | 0 or less | up to $20,000 | up to $99,999 | up to $249,999 | $250,000 and up | $20,000 is the game's low-funds warning (`main_ui.gd:1021`) |
| Compute | 0 or less | 1-49 | 50-99 | 100-199 | 200 and up | round steps; the start is 100 |
| Research | 0 or less | 1-9 | 10-19 | 20-49 | 50 and up | 10 and 20 are the costs of Safety Research and Publish Safety Paper |
| Papers | 0 | 1 | 2-4 | 5-9 | 10 and up | round steps |
| Reputation | 0 or less | 1-20 | 21-30 | 31-60 | 61 and up | 20 and 30 are the game's reputation warnings (`main_ui.gd:1015`); 0 ends the run |

- Tier 0 is the zero-or-below picture (an empty box, a dead chip, a
  shattered medal), with the only red in the icon.
- In the run: money $245,000 is tier 3 and $12,400 tier 1; research -12
  and -6 are tier 0; reputation 50 and 34 are tier 3, 21 is tier 2.
- The thresholds are a proposal. Where the game has no line of its own
  (compute, papers, the upper money and research tiers) they are round
  steps, for Pip to change.
- The icons are new art (6.4).

**Take b: trace windows (`?res=trace`).** Each plate becomes a small
monitor (64x48 for money, 52x40 for the rest) with the resource's line.

- **History only.** The line is the amount at the start of each month the
  player has already played, plus the current amount as the last point.
  Nothing ahead of today: no forecast, no projected point.
- **Auto-scale.** The y-axis has no fixed anchor: it fits the line's own
  lowest and highest values, so the window shows shape, not size. The
  number beside it gives the size. When the line crosses 0, a dashed blood
  zero line shows where.
- **No doom trace** (ADR-0015). P(Doom) stays a level on its meter.
- A tab under the strip reads "TRACE since Jul 2017". In month 1 it reads
  "no history yet", and each window shows one point on a flat dashed line.
- The mock-up's data is `fork/design/hifi/run-state.md`, "Resource
  history". Its Jan-Mar 2018 points are a marked projection, there only so
  screen 6 has a line.
- The game does not record month-start amounts today. Take b needs them
  recorded, as presentation data only: it must not change a run (7.1).

### 3.3 Dateline

- Top left at 56,24. Courier Prime 700, 28 px, 5 px tracking, `#d9d1bf`,
  upper case, date only: "NOVEMBER 1, 2017".
- A worn ribbon: letters land a little lighter or lower in a fixed
  pattern. Opacities 1, .86, .97, .9, 1, .82, .95, 1, .88 and offsets of
  0 or 1 px, repeating. It is fixed, not random.
- **When it types:** only when a month begins (the first screen, and after
  the month review). Inside a month it shows the date already set. During
  WATCH the day changes in place without typing ("NOVEMBER 14, 2017"), so
  it never disagrees with the clock.
- **Timing:** the first letter at 260 ms (60 ms when the sound plays),
  then one letter every 95 ms (with the sound, +-22 ms per key); a space
  adds 60 ms and a comma adds a 40 ms beat. "NOVEMBER 1, 2017" types in
  about 1.6 s, and the carriage return stops about 0.56 s after the last
  letter. Drive the letters from the sound's schedule so they land on the
  strikes.
- With reduced motion (if the game gets such a setting), show the date
  whole. The mock-up still plays the sound.
- It sits above every dim layer, and menus open below it.

**The sound** (synthesised in the mock-up, between `SOUND_START` and
`SOUND_END` in `concept.html`; nothing is sampled from a film). Aim: the
hard typewriter strike of a spy-film title card: steel on the platen
first, a short thud through the desk under it, no bell.

Each key strike is five layers. Three random values per key vary it: v
(0.85 to 1.15, how hard), p (0.94 to 1.06, the noise layers' pitch) and q
(0.975 to 1.025, the thump's own narrower pitch, so keys do not sound like
tuned blocks).

| Layer | Source | Start | Shape |
|---|---|---|---|
| contact | noise, high-pass 4500 Hz x p | 0 ms | 0.5 ms attack to 0.8 v, decays over 9 ms |
| slap | noise, band-pass 2900 Hz x p, Q 1.4 | 0 ms | 1 ms attack to 0.85 v, decays over 25 ms |
| thump | sine falling 170 to 62 Hz x q over 40 ms | 0 ms | 0.68 v, decays over 45 ms |
| rattle | noise, band-pass 900 Hz x p, Q 4 | 4 ms | 0.12 v, decays over 70 ms |
| escapement tick | noise, band-pass 3900 Hz x p, Q 14 | 17 ms | 0.2 v, decays over 12 ms |

- **Timing:** 95 ms between keys, +-22 ms random. A space is silent and
  adds 60 ms. A comma adds a 40 ms beat after it.
- **Carriage return**, 320 ms after the last key: a 240 ms slide (noise,
  low-pass sweeping 550 to 1750 Hz, rising to 0.27), then the stop (a sine
  falling 95 to 42 Hz over 120 ms at 1.0, decaying over 320 ms, plus a
  300 Hz band-pass knock at 0.4 for 80 ms).
- **Room and level:** a 0.7 s noise reverb tail, its wet path low-passed
  at 2.5 kHz, at 23% wet; a compressor (threshold -18 dB, ratio 4, attack
  2 ms, release 120 ms); master gain 0.84.
- **One at a time.** While a play is still sounding, through its room
  tail, a new call is ignored: it returns null and fires no callbacks.
  The control that started it stays disabled until onDone, with or
  without reduced motion. Two plays can never overlap. The game needs the
  same rule.

For the game asset, see section 6.3.

### 3.4 Menu rack

- Panel at 1268,612, 276x428. Seven plates, 46 px tall, 10 px apart. Each
  plate has Pip's icon, a condensed caps name and a keycap.
- Level 4 of the hierarchy: 16 px labels in muted, icons at 82% opacity.
  A lit or hinted plate still stands out, by its amber.
- PLAN set: ACTIONS A, PLAN P, STAFF E, UPGRADES U, LEDGER L, IN-TRAY R,
  GUIDE F1.
- WATCH set: FEED F, STAFF E, LEDGER L, GUIDE F1 live; ACTIONS, PLAN and
  UPGRADES shown disabled.
- States:
  - rest;
  - lit (the open menu): amber left edge and keycap;
  - hint: an amber ring and glow, used once, for the tutorial's first
    pointer;
  - disabled: dashed edge, hatched, no keycap;
  - keys held: while a WATCH event waits for a reply, no plate shows a
    keycap. Under the month review the plates keep theirs.
- IN-TRAY and UPGRADES are drawn closed only. What IN-TRAY collects is for
  the builder to settle from today's notices.

### 3.5 Plan panel (the terminal)

- Panel at 56,612, 560x428. On the desk it is the month at a glance:
  - "NOVEMBER PLAN";
  - Attention first (level 2): the header "ATTENTION -- HOURS LEFT", then
    planning N of 12 and operating N of 8, one 16x26 px cell per hour,
    filled = hours left, values at 22 px;
  - the queue in short (level 3): 16 px lines in muted;
  - when empty, "Plan is empty / open Actions [A]".
- In WATCH the same panel plays the month back: the month and "workday N of
  22", a bar with one segment per workday and today marked, then the feed
  (3.11).

### 3.6 Held for events, and Commit

- **Commit** sits at 1584,980, 296x60, and never moves. It is a dark plate
  with an amber hairline and caps "COMMIT THE MONTH".
  - It shows the Enter keycap only when nothing above it owns Enter.
  - Idle (nothing queued): muted text and a plain hairline, no amber. It
    lights when there is something to commit.
  - Waiting (under the month review): dimmed.
  - WATCH: "MONTH IN PLAY", dashed and inert.
- **Held for events** is a small panel directly above Commit (1584, top 856,
  296x112): "HELD FOR EVENTS 7 hr" and the line "untyped; what events do
  not use is gone at month end". The value is every hour not queued
  (planning left plus operating left). It is the ADR's untyped reserve,
  not an operating-only one (section 7.1).
- In WATCH the panel grows upward to the rack's top (top 612, 356 tall)
  and adds the clock (3.10). Commit stays where it is.

### 3.7 Action card file (Actions, A)

- A dark sheet at 56,88, 1196x952 (E's card file, retextured). The rack and
  Commit stay in view.
- Header: ACTIONS and "A Esc BACK TO DESK".
- An hours row: hours left in each pool, as pips. The balances are no
  longer repeated here; the resource strip (3.2) stays in view above the
  sheet.
- The top-level actions the game offers this month, in E's two columns and
  order: core.json minus `HIDDEN_FROM_ACTION_BAR_IDS`
  (`action_bar_renderer.gd:83`) and minus locked actions. 17 cards in
  November 2017.
- A card is one of two kinds:
  - **door** (opens choices): a darker brass left edge, "door . N choices",
    and a > tab;
  - **play** (queues directly): hour chips in the pool colour ("1 hr PLAN",
    "2 hr OPS"), cost chips, and a + tab.
- Card states:
  - rest;
  - focus: amber hairline;
  - queued: a stamp, for example "2 queued";
  - blocked: dashed and hatched, with the reason in warn colour, for
    example "x 22 research short" or "x nobody hired yet".
- Under the file, a detail strip for the focused card. It holds the only
  Enter: the name, the data's description, hours, cost, what is left
  ("8 operating hours left"), and "Enter ADD TO PLAN".
- Costs come from the data: Safety Research and Capability Research cost 10
  research and 1 planning hour, Publish Safety Paper 20 research and 1
  planning hour, Safety Audit $40,000 and 2 operating hours, Purchase
  Compute $50,000 and no hours (`data/actions/core.json`). Advertise a Role
  and Work Your Connections carry their costs in Balance, not in core.json
  (section 7.2).

### 3.8 Month plan table (Plan, P)

- The same sheet position as the card file.
- At the top, the Attention grid: 12 planning cells and 8 operating cells.
  Filled = left. A hatched planning cell is an hour that operating work
  took, with a one-line legend.
- One row per queued play, in run order. Repeats get their own rows. Each
  row: number, play, where it lives, a pool chip with its hours, its cost,
  and ^ v x (move up, move down, remove).
- The play whose hours spilled into planning carries a "SPILL 1" tag in
  the POOL column, and a SPILL line under the grid says how many operating
  hours were drawn from planning. The tag is the mock-up's queue-order
  estimate (section 1.2); MonthPlan's pool totals are the source of truth.
- Below the rows:
  - the total: plays, plan + op hours, money + reputation;
  - AFTER COSTS: money and reputation after the listed costs, and the hours
    held. Results of plays are not included, because they land at Commit;
  - Research quality (`research_quality_selector.gd`), default Standard;
  - Undo Z, Clear C;
  - the reserve stepper (- and +), live while any hour is unspent;
  - "P Esc BACK TO DESK".
- Commit shows no Enter while the sheet is open.

### 3.9 Paper: the event card and the month review

Paper is the topmost layer when it is up, and it owns Enter.
- Under a WATCH event, no other keycap shows: not on the rack, not on the
  feed.
- Under the month review, the rack keeps its letters, and Enter belongs to
  the review sheet alone (Commit shows no Enter).

**Event card** (668,96, 640 wide):
- "ACROSS YOUR DESK", the event's name and its data text.
- One row per option: the option key, the option text, its effect, and its
  cost.
- The selected option has a 2 px ink frame, an amber edge and the Enter
  keycap.
- A footer: money in hand and hours held for events.
- An event cannot be dismissed with Esc. Today's game swallows Esc on
  events (#452).
- Example from the data (`core_events.json` `talent_recruitment`):
  - Fast-Track Hiring: $25,000 + 1 held hr, +1 safety researcher;
  - Standard Hiring: $25,000 + 1 held hr, +1 safety researcher. Its data
    cost is $25,000 only. `event_dialog.gd` adds the event's Attention
    price to any handled option that declares none;
  - Decline Offer: free, no change.
- The mock-up labels the options 1, 2, 3. **The build should use the
  game's advertised letters, Q, W, E** (`dialog_keys.gd`,
  NAVIGATION_AUDIT principle P3). The game still accepts numbers without
  showing them.

**Month review** (56,190, 1184x850), a teleprinter sheet:
- "FROM THE TELEPRINTER" and the date;
- the title and lede, as `game_manager.gd` writes them ("Month Review --
  December 2017", "December 2017 begins.");
- the game's Attention line;
- what happened, in dated blocks: the plays at Commit with the game's
  result messages, then each event and its outcome, then the held hours
  ("7 hr held: 1 went to Talent Opportunity, 6 evaporated.");
- LAST MONTH'S MOVEMENT: funds before -> after, staff before -> after, and
  doom by band only;
- rivals only when the game prints them;
- one button: "Begin planning December 2017" with Enter.

Behind the review the desk is dimmed and Commit is shown waiting.

### 3.10 WATCH clock and speed

Inside the grown held panel:
- "THE MONTH", then the clock: "TUE 14 NOV" and "workday 10 of 22";
- "PAUSED FOR YOU", a blood-red bar, shown when an event has paused
  playback;
- a speed row: Pause, 1x, 2x, 4x. Today's speeds are 0.20, 0.10 and
  0.05 s per day (`screen_mode.gd:37`);
- HELD FOR EVENTS.

Today's pause button is a disabled stub (`screen_mode.gd:101`), but events
already pause playback. In H, the Pause segment shows that state. A pause
the player can press is outside this spec.

### 3.11 Feed

The feed is the WATCH body of the plan panel. Each line has the day number
in mono, then the game's own message:
- "11 plays run at Commit", then each play's result;
- events marked [!] when they wait for a reply;
- "at work: 1 safety researcher";
- "Feed and results [F]" opens the full log.

H adds no wording of its own to results. While an event waits, the feed
shows no keycap.

## 4. The six screens

The run in the mock-ups: July 2017 start, November 2017 middle (rows from
`fork/design/hifi/run-state.md`, revisions 2 and 3), December review,
April 2018 late game. Screens 2 to 4 are doom band 2 (HIGH, 40.2%). The
resource strip (3.2) is on every screen.

| # | Screen | On screen | One click away | Keys shown |
|---|---|---|---|---|
| 1 | Desk at rest, first month (Tue 4 Jul 2017, 20.0% ELEVATED, doom band 1) | dateline types; resource strip; P(Doom) meter; plan panel "Plan is empty"; rack with ACTIONS hinted; held 20 hr; Commit; the advisor's paper note pointing to ACTIONS | Actions card file, Plan, Staff, Ledger, Guide | rack letters; Commit Enter |
| 2 | Actions open (Wed 1 Nov 2017, 3 plays queued) | card file with 17 cards, blocked reasons, stamps; detail strip for Safety Audit | add a play (Enter); open a door card; back to desk (A or Esc) | A, Esc; Enter on the detail strip only |
| 3 | The month's plan (same day, 11 plays) | Attention grid (7 of 12 planning left, 0 of 8 operating), 11 rows, the spilled hour, totals, AFTER COSTS ($37,400, 26 rep, 7 hr held), research quality, reserve | reorder or remove a row; Undo; Clear; back to desk | P, Esc, Z, C; no Enter on Commit |
| 4 | WATCH, an event waits (Tue 14 Nov 2017) | feed and month bar; WATCH rack; clock, PAUSED FOR YOU, speed, held 7 hr; Commit "MONTH IN PLAY"; the event on paper | choose an option | the event's keys and Enter only; no other keycaps |
| 5 | Month review (Fri 1 Dec 2017, 56.7% SEVERE, doom band 3) | dateline types DECEMBER; dimmed desk; the review sheet | begin planning | rack letters; Enter on the review only |
| 6 | Late game (Mon 2 Apr 2018, 81.4% CATASTROPHIC, doom band 5) | the desk of screen 1 with the late layer; the meter's warning line; nothing queued | as screen 1 | as screen 1 |

### 4.1 Key rules

- Enter and Esc belong to the topmost layer only. Paper over a menu over
  the desk: only the top one shows Enter or Esc, and Commit shows Enter
  only when nothing else is open.
- A menu's own letter closes it again (A opens and closes Actions).
- Today's Esc contract applies to every menu (`UI_ESCAPE_CONTRACT.md`):
  Esc closes the topmost panel, and every panel has a visible way out.
  Events are the exception the game already makes.

### 4.2 Shortcut keys: which are new

| Key | In H | Today (`autoload/keybind_manager.gd`) |
|---|---|---|
| Enter | Commit, or the topmost paper's choice | Commit Plan (same) |
| Esc | close the topmost layer | the same, handled per panel |
| L | Ledger | Ledger (same) |
| Z / C | Undo / Clear in the plan | Undo / Clear (same) |
| V | toggle PLAN and WATCH, if kept | toggle view (same) |
| A | Actions card file | **new** |
| P | Plan sheet | **taken**: opens the Publicity menu |
| E | Staff | **new** (an old Staff bind is commented out) |
| U | Upgrades | **new** |
| R | In-tray | **new** on the desk |
| F1 | Guide | **new** |
| F | Feed, in WATCH | **taken**: opens the Fundraising menu |

- H's rack replaces the action bar, so today's 1-9 slot keys and the H, F,
  P and T menu keys need a decision before a build. A builder must not
  silently rebind them.
- Inside a dialog, Q W E R A S D F Z are today's choice keys. That does not
  clash with the rack, because only the topmost layer takes keys.

## 5. Mapping onto today's scene

Today's main screen is `godot/scenes/main.tscn` under
`TabManager/MainUI`. Scripts are in `godot/scripts/ui/`. G's notes
(`fork/design/hifi/G/notes.md`) cover the same nodes for a lighter
redesign; this table reuses them.

| H part | Today's node or script | What changes |
|---|---|---|
| Room and doom layer | `Backdrop`, `BackdropScrim` | per-band art layers on top; keyed to the doom band |
| Dateline | none (today: `TopBar/TurnLabel`, `TurnCountLabel`) | new label plus the sound; "Turn N" (workdays) goes |
| Resource strip (money, compute, research, papers, reputation) | `TopBar/*Label`, `TopBar/ReputationLabel` | one strip, always on screen, with tier icons or traces (3.2); values unchanged |
| P(Doom) meter | `ContentArea/InstrumentColumn/CoreZone/RightZones` (`DoomMeter` scene, `NumericDoomLabel`, `DoomExplanation`) | restyled; band ladder and warning line added from the game's own data |
| Office cat print | `OfficeCat` in `CatZone` (`office_cat.gd`) | shown as a photo print on the desk |
| Plan panel and feed | `PlanScreen` (`plan_screen.gd`) and `WatchScreen` (`watch_screen.gd`), `QueuePanel` | one terminal panel with a PLAN face and a WATCH face |
| Attention grid | `TopBar/APLabel`, `plan_screen.update_reserve_gauge` | a cell grid per pool, with the spilled hour shown |
| Menu rack | action bar (`action_bar_renderer.gd`), `submenu_controller.gd` | plates that open sheets; doors open the existing submenus |
| Action card file | `action_bar_renderer.gd`, `submenu_controller.gd` | one sheet of cards; same list, same gates |
| Month plan table | `QueuePanel/QueueContainer`, `queue_gantt.gd`, `plan_controller.gd`, `research_quality_selector.gd` | rows with reorder and remove, totals, AFTER COSTS |
| Undo, Clear, Reserve | `BottomBar/ControlButtons` (`UndoLastButton`, `ClearQueueButton`, `ReserveAPButton`) | move into the plan sheet; Reserve follows section 7.1 |
| Commit | `BottomBar/ControlButtons/CommitPlanButton` | fixed plate bottom right; H has no separate `EndTurnButton` |
| Held panel, clock, speed | the WATCH control strip in `main_ui.gd:389` and `screen_mode.gd` | one panel above Commit |
| Event card | `event_dialog.gd`, `event_result_presenter.gd` | paper styling; keys from `dialog_keys.gd` |
| Month review | `month_review_panel.gd` | paper styling; content from `game_manager.gd` |
| Staff, Ledger, Guide | `EmployeeScreen`, `ledger_screen.gd`, `player_guide.gd` | opened from the rack; not redrawn here |
| Modal order and Esc | `modal_stack.gd`, `esc_to_close.gd` | unchanged; H relies on the topmost-layer rule they enforce |
| Advisor note | `cold_open_sequence.gd` `HANDOFF_HINT_TEXT` | shown as a paper note pointing at the hinted plate |

## 6. Assets

### 6.1 Pip's art and icons used

- Room: `office_wide_dawn.webp`.
- Panel scuffs: `tex_painted_metal_panel.webp`.
- The cat: `office_cat_doom-cat.webp`.
- 24 of Pip's icons:
  - rack: `ui_guide_actions`, `ui_config_date`, `ui_staff_management`,
    `button_upgrade_normal`, `ui_budget_finance`, `ui_guide_book`;
  - the meter head and some action cards: `doom`, `reputation`,
    `money`, `compute`, `research`, `paper`;
  - action cards and system: `ui_guide_resources`, `action_funding_loan`,
    `button_hire_normal`, `action_publicity_network`,
    `employee_status_training`, `action_research_ml_fundamentals`,
    `resource_safety_small`, `employee_role_auditor`,
    `ui_infrastructure_facilities`, `ui_guide_strategy`,
    `employee_status_investigating`, `ui_system_settings`.
- Icons sit on near-black plates and are toned down to fit the room. They
  are not redrawn.
- Pip's Staff and Hire icons (silhouettes) stay. Alex ruled that they do
  not count as a person. No human figures are added.

Copies are in `fork/design/hifi3/H/assets/`.

The round resource icons (`money`, `compute`, `research`, `paper`,
`reputation`) are replaced in the strip by the tier icons (6.4).

### 6.2 Art that would need darker versions to match

These still read lighter and brighter than the room after toning, so they
would need darker versions to match H:
- the round resource icons: `doom`, `reputation`, `money`, `compute`,
  `research`, `paper`;
- `ui_config_date_64` (PLAN, a tear-off calendar). A ledger or typed-sheet
  glyph would fit better;
- `ui_guide_resources_64` (Fundraising) and `action_funding_loan_64`
  (Financing);
- `ui_guide_strategy_64` (Strategic) and `employee_status_investigating_64`
  (Scouting), whose glow survives the toning;
- `office_cat_doom-cat.webp`: a darker, grainier photo would suit the print
  on the desk. Pip's cat doom variants for bands 2 to 4 do not exist yet;
- five placeholders drawn for the concepts, which need real art in Pip's
  manner: `new_inbox_tray` (In-tray), `new_feed_tape` (Feed),
  `new_advertise_notice` (Advertise a Role), `new_travel_suitcase`
  (Travel), `new_publicity_megaphone` (Publicity);
- per-band layers for the office, one set per doom band (2.4): window sky,
  monitor glow, grime, and floor smoke and fire light for bands 5 and 6,
  as the palette doc plans.

### 6.3 The sound asset

- Reference: `fork/design/hifi3/H/dateline-sound.wav`, rendered from the
  mock-up's own code (`TypeSound.render`, seed 1917) typing "NOVEMBER 1,
  2017". Mono, 16-bit, 44,100 Hz, 3.29 s. Raw peak -2.48 dBFS, written
  with no gain or normalisation; RMS -24.1 dBFS; no clipped samples. 14
  strikes (56 ms to 1688 ms) and the carriage-return stop at 2.25 s.
- For the game, make it as one-shots, so any date can be typed and the
  letters stay in sync:
  - 6 to 8 key strikes, varied as in 3.3 (contact, slap, thump, rattle and
    escapement tick in each);
  - one carriage-return slide and stop;
  - WAV, mono, 16-bit, 44.1 kHz, raw peaks at or under -1.5 dBFS, room and
    compression baked in.
- One dateline at a time: a new month's type-on never starts over one
  still sounding (3.3).
- The game picks a strike per letter at the dateline's timing. It may
  reuse the reference render's timing for a fixed string. These picks are
  presentation only: they must not draw from the game's RNG
  (`state.rng`).
- Bus: the game already has an SFX bus (bus 1 in
  `default_bus_layout.tres`), with an SFX volume setting
  (`game_config.gd`). Put it there. `godot/assets/audio/sfx/` is empty
  today, so this would be the game's first sound effect.
- It plays only when the dateline types (a month's first screen), never
  on in-month day changes.

### 6.4 New art: the resource tier icons

25 icons, five tiers for each of the five resources, in
`fork/design/hifi3/H/assets/tiers/` (`money-0.svg` to `rep-4.svg`, 64 px
view box). They are drafts in Pip's manner for his artist (dark plate, warm
painted gradients, one amber accent, red only at tier 0), made by script,
not final art.

| Resource | Tier 0 | Tier 1 | Tier 2 | Tier 3 | Tier 4 |
|---|---|---|---|---|---|
| Money | empty cash box | one coin | three coins | a stack | a pile |
| Compute | dead chip | lit chip | one server | three server units | two racks |
| Research | blank notebook | one note sheet | open notebook | three books | a file box |
| Papers | empty clipboard | one paper | three, fanned | a bound journal | a shelf |
| Reputation | shattered medal | cracked medal | tarnished medal | brass with a star | brass with a laurel |

## 7. Open rule questions, and bugs found on the way

### 7.1 Where the mock-up follows the ADR and today's UI differs

- **The Attention spill.**
  - ADR-0011 (amendment (e)) and the core gate
    (`MonthPlan.can_spend_hours`) let operating work use planning hours.
  - Today's UI pre-check in `main_ui.gd:1725-1741` refuses a play when its
    own pool is short ("Not enough Attention: need N operating hours"),
    before the core gate is asked.
  - H follows the ADR. Screen 3 shows the 9th operating hour taken from
    planning.
  - Making the UI agree changes which plays a player can queue, so Pip
    must rule on it.
- **Reserve.**
  - ADR-0011 amendment (f) and `MonthPlan.set_reserve` make the reserve
    untyped and not capped at operating hours.
  - Today's UI disables the Reserve button when no operating hours are
    left (`main_ui.gd:1277-1281`, with a comment that says the opposite of
    the ADR).
  - H shows Reserve live while any hour is unspent.
  - This affects what a player can do, so it is Pip's call too.
- **The resource strip stays on screen.** H keeps all five balances on the
  desk, as today's top bar does, now ranked (money first) and drawn as
  tier icons or traces (3.2). Which take, and the tier lines, are Pip's
  call.
- **Take b needs history.** The game keeps no month-start amounts today.
  Recording them is presentation data, but it is new state, so Pip should
  agree it, and it must not change a run.
- **The Plan sheet and the strip both show money and reputation** in
  screens 2 and 3: the strip today's amount, the sheet the amount after
  the listed costs. Whether the sheet should show only the change is open.
- **The AFTER COSTS preview** is new. It adds no hidden information (it
  subtracts listed costs), but Pip may not want a preview at all.
- **Fonts:** small at 15 vs the 16 px floor, and the missing 22 step
  (2.5).
- **Keys:** P and F are taken today, and the action-bar keys go (4.2).

### 7.2 Bugs and data gaps found (not fixed)

- **Office Maintenance does nothing.** It costs $5,000 and 1 hour
  (`data/actions/operations.json`), `actions.gd` has no case for it, and
  its text says "Improves morale slightly". The action bar hides it
  (`action_bar_renderer.gd:83`), but the Operations submenu still offers
  it.
- **Empty costs in core.json.** Advertise a Role and Work Your Connections
  have `costs: {}`. Their real costs are in Balance `hiring` (advertise
  $8,000 and 3 hours; connections 6 reputation and 2 hours), so any screen
  that reads costs from the action shows them as free.
- **Research below zero** (-12 in November) has no warning.
- **"Turn N" counts workdays**, not months. The unlock gates compare
  against the same count. Safety Audit needs `turn_min` 5 only, so it
  opens in the first week. Strategic needs `turn_min` 10 and reputation at
  least 30 (`data/actions/core.json:113-116`), so it opens in the first
  fortnight while reputation holds.
- **Unmapped icons.** `tour_offices`, `scout_read`, `scout_meetups` and
  `scout_shitpost` have no entry in `data/icon_mapping.json`, so the game
  draws its magenta placeholder.
- **Doom text contrast.** The stroke colour's 0.22 luminance floor leaves
  CATASTROPHIC text about 1.8:1 on dark panels (G's measurement). H lifts
  text to 5:1 and keeps the game colour on the arc.
- **Pause is a stub.** The WATCH pause button is disabled; only events
  pause playback.
- **Event pictures are packed but unused**
  (`godot/assets/images/events/README.md`).
- **No bundled fonts** and no sound effects ship today (2.5, 6.3).

## 8. H-HF texture

H-HF (`H-HF/`, states 1, 4 and 5) is H with a texture pass drawn from
HighFleet and amber control panels. Only the texture changes. Every element
box matches H's at 1920x1080, and the room and its doom layer, the paper,
the tier icons and the ids are H's. Full notes: `H-HF/notes.md`.

**Materials**

- **Painted steel:** olive-black panels with a pressed rim, a lit top lip
  and a shadowed bottom lip. The top coat is worn in a slow mottle, with
  chips and fine scratches along the outer 18-22px of each panel.
- **Fasteners:** domed rivets at the panel corners and slotted screws on
  the P(Doom) bezel.
- **Stencilled labels:** every condensed caps label uses Big Shoulders
  Stencil Text 700, at H's sizes. Labels that were dim in H are muted here,
  so they still pass 4.5:1.
- **Counter windows:** dark recessed windows for the numbers. Money, the
  P(Doom) percentage and the WATCH clock also get drum seams between
  characters.
- **The dial:** P(Doom) keeps H's arc, band ticks and colours, set in a
  steel bezel with a sunk face, a fine scale every 2.5 with no numerals,
  and a needle at the level. The band ladder becomes a column of lamps.
- **Warning plates:** dull amber and black hazard stripes, used only on
  "PAUSED FOR YOU" and on reputation's "0 ends the run".
- **Push plates:** the rack is raised plates with key caps sunk into the
  steel. Commit has a bevel, and a guard ring while it is muted.
- **The desk:** a steel sill with a riveted seam along its top.

**Texture tokens** (a second `:root`, in the "H-HF TEXTURE" block)

| Token | Value |
|---|---|
| `--hf-paint` | `rgba(19,20,15,.95)` (panels) |
| `--hf-plate` / `--hf-plate-2` | `#1a1b14` / `#13140f` (raised plates) |
| `--hf-recess` | `#090a07` (windows, sockets, dial face) |
| `--hf-lip-hi` / `--hf-lip-lo` | `rgba(226,216,186,.10)` / `rgba(0,0,0,.6)` |
| `--hf-bevel`, `--hf-sunk` | the raised and sunk inset shadows |
| `--hf-rivet`, `--hf-screw` | radial gradients (the screw adds a slot) |
| `--hf-hazard` | `repeating-linear-gradient(-45deg,#7a5e27 0 6px,#0f0d0a 6px 12px)` |
| `--hf-mottle`, `--hf-chips`, `--hf-scratch` | SVG fractal noise, drawn in the page |
| `--stencil` | `"Big Shoulders Stencil Text"`, falling back to Barlow Condensed |

**Identical to H**

- Layout, hierarchy, type scale, text colours apart from the two label
  sets above, and the data.
- The colour by band (`DOOM_LAYER`, the room's grade, vignette, grain and
  smut).
- The tier icons (take a), the `data-el` ids, and the paper surfaces. The
  one paper change: the event's option numbers are lifted to `#e4dac4`
  to pass at 720.
- The dateline. The `SOUND_START..SOUND_END` block is byte-identical
  (same sha256) and the sound button lock is H's.

**Left out from HighFleet**

- Its density: no added gauge, switch, label or plate.
- Light dial faces and light nameplates.
- Amber nixie digits.
- Bright yellow stripes.
- Scale numerals.
- Decorative text.
- CRT scanlines.
- Rust.

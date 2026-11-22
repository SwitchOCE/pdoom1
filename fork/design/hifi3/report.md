# hifi3: report

## Summary

**The last design round (the addendum of 2026-11-22) is done. All three
reviewers say GOOD TO GO: opus (Claude), sol (Codex) and neon (Gemini).**
Round 2 found four small blocking items: two in the mixer, one in how the
resource icons round, and one clipped caption. All three agreed on them;
they were fixed in one round and re-checked.

- **What was made in this round:**
  - **H, revised** (`H/`): a clear order of importance (P(Doom) first,
    then Attention and money, then the plan; the rest recedes); the room's
    colour follows the doom band only, starting a little brighter at the
    lowest band and darkening band by band; resources as **tier icons**
    (one coin, a few, a stack, a pile; 25 new draft icons), with a second
    take as small **trace windows** of past months.
  - **H-HF** (`H-HF/`): the same H with a heavier texture drawn from
    HighFleet: painted steel, rivets, a needle dial, stencilled labels,
    warning plates. Three states (1, 4, 5). Same layout and rules as H.
  - **The mixer** (`mixer/index.html`): pick each element from H, H-HF,
    C, E or G, drag it, toggle it, set the doom band and the background,
    and share the layout as a short code. Reset reproduces H's state 3
    to within half a level per pixel on average.
  - **The spec** (`spec.md`) updated: hierarchy (1.3), colour by band with
    the band table and the art-band mapping (2.4), both resource takes
    with their thresholds (3.2), the tier icons as new art (6.4), and an
    H-HF texture section (8).
  - **The page** (`index.html`) updated: H first, the band strip, the two
    resource takes side by side, H-HF, C/E/G marked as the earlier
    texture, and a link to the mixer. Alex's PC session republishes it.
- **C, E and G** are unchanged from the main hifi3 pass and are labelled
  "earlier texture" on the page and in the mixer.
- **The outside reviewer's message** is not committed and not on the page;
  only Alex's decisions on it are quoted (in `brief.md`).
- **Disk:** this round's full-size PNGs (45 MB) are deleted. The
  page and the mixer together are about 15 MB with their images.

## Where to look

- `fork/design/hifi3/index.html`: the page to share. Rebuild it with
  `python3 fork/design/hifi3/build_page.py` after editing `spec.md`,
  `page.src.html`, `demo.js` or H's sound block.
- `fork/design/hifi3/mixer/index.html`: the mixer (open from disk or with
  the page). How to use it: pick a design per slot in the list; drag
  pieces, or Tab to one and nudge it with the arrow keys (Shift for 10
  px); copy the code to share a layout, paste one to load it.
- `fork/design/hifi3/H/concept.html`: H live. `?state=1..6`,
  `?band=0..6` (force the room's doom band), `?res=trace` (take b),
  `?rep=dial` (the old reputation dial, for comparison only).
- `fork/design/hifi3/H-HF/concept.html?state=1|4|5`: H-HF live.
- `fork/design/hifi3/spec.md`: the spec for a builder.
- `fork/design/hifi/run-state.md`, "Resource history": the months the
  trace windows draw, with their sources.
- `fork/design/hifi3/<H|H-HF|mixer>/notes.md`: per-design notes, contrast
  tables, open questions.
- `fork/design/hifi3/council/`: every review answer, verbatim
  (`r2-*.md` for this round), and the agreed lists.

## The addendum round

### Revised H (designer A)

- **Hierarchy (spec 1.3).** Four levels made by size, weight, contrast and
  position: 1, P(Doom) in a framed panel top right; 2, Attention left (the
  hour bars) and money (the lead resource cell, 1.3x); 3, the plan sheet;
  4, the rack, held hours, Commit and the feed, smaller and dimmer but
  still at least 4.5:1.
- **Colour by doom band (spec 2.4).** The room's light runs from .80 at
  NOMINAL down to .31 at TERMINAL; the palette, smut and glow shift band
  by band; violet appears first at CATASTROPHIC and fire only at
  TERMINAL. Panels and controls never move or change colour. The band
  strip (`H/band-0..6.webp`) is state 1 with only the room's band forced;
  the P(Doom) panel stays at 20.0% in all seven.
- **Resources, take a: tier icons (spec 3.2, the default).** Five cells:
  money, compute, research, papers, reputation. Five tiers each, at fixed
  amounts, plus a zero-or-below tier. The number stays beside the icon,
  and the icon is read from that same printed number, nothing else
  (ADR-0001). Reputation is drawn once, with "0 ends the run". 25 draft
  SVG icons in `H/assets/tiers/`.
- **Resources, take b: trace windows (`?res=trace`).** A small monitor per
  resource showing the amount at the start of each month already played,
  plus today. The y-axis scales to the line. No forecast, no doom trace
  (ADR-0015). Month 1 says "no history yet". July to November come from
  real game screenshots; December and April are the run-state fixtures;
  January to March are a marked projection.
- **Attention** keeps its hour bars (a month has a fixed number of
  hours).

### H-HF (designer G)

Texture only, from HighFleet and amber control panels: olive-black worn
paint, chips and scratches at panel edges, rivets and slotted screws,
recessed counter windows (drum seams on money, P(Doom) and the clock), a
needle on the P(Doom) dial, a lamp column for the band ladder, raised push
plates for the rack, and hazard plates only on real warnings. Not taken:
HighFleet's density, its extra gauges, its green CRT and any of its
pixels. Every element box matches H's (the resource strip is 27 px wider
to the left, for the reputation gap). Labels use Big Shoulders Stencil
Text, which the game would have to bundle.

### The mixer (designer E)

- 14 slots, 74 choices, cut from each design's own page in isolation
  (transparent WebPs), not redrawn; 21 band backgrounds.
- Drag (aimed by each piece's visible pixels), toggle, Tab and arrow
  keys with a visible focus ring, a band slider, a background picker,
  reset, and a share code (base64 JSON) that round-trips and refuses
  broken input. Pieces cannot leave the stage.
- The band slider changes the room only, as H does (doom is a layer on the
  room, not a repaint of the panels). C, E and G pieces keep their own
  colours.
- Saved in the browser (with a fallback when storage is blocked).
- **Reset against H's own state 3:** mean difference 0.496 per colour
  channel (0-255); 0.04% of pixels off by more than 2; largest 16 (text
  antialiasing). The same check with the trace take matches H's
  `?state=3&res=trace` render as closely.
- About 6.3 MB as served (60 pieces, 21 backgrounds, the hit masks).

### The page (orchestrator)

Sections: 01 H; 02 how the room darkens (the band strip); 03 two ways to
show resources (tabs for moments 3, 5 and 6, side by side); 04 the date,
typed in (the sound demo); 05 six moments across the designs; 06 other
takes (H-HF as "the same design, heavier texture", C/E/G as the earlier
texture); 07 mix your own (the mixer link); 08 the spec. The captions say
the P(Doom) panel is held at 20% in the band strip and that the late-game
trace is a projected example.

## Council, round 2

The same council at low sensitivity: opus (Claude), sol (Codex), neon
(Gemini). Questions: `council/round2-ask.md`.

| Member | Verdict | hierarchy | colour | resources | H-HF | mixer | spec | page |
|---|---|---|---|---|---|---|---|---|
| opus | GOOD TO GO | 9 | 9 | 8.5 | 8.5 | 9 | 9 | 9 |
| sol | CHANGES NEEDED | 9 | 9 | 8 | 9 | 7.5 | 8.5 | 9 |
| neon | CHANGES NEEDED | 9 | 9 | 8 | 9 | 9 | 9 | 9 |

**Blocking items, agreed by all three** (`council/r2-agreed.md`):

- **S1 (sol), mixer:** a transparent part of an upper piece took the drag
  from a visible piece under it. Fixed: pieces are picked by their
  visible pixels (masks built with the cut-outs).
- **S2 (sol), mixer:** a piece could be dragged or loaded off the stage,
  losing its focus ring. Fixed: every piece is kept on the stage on drag,
  nudge and code load; the focus ring is drawn inside the piece.
- **S3 (sol), H and H-HF:** the number was rounded but the tier icon used
  the raw value (reputation 60.25 showed "60" with the next tier's icon).
  Fixed: the number, icon, warn colour and trace samples all use the
  amount the game prints (whole units, halves away from zero, as
  `game_config.gd` formats them). The real loss rule stays on game state.
- **N1 (neon), H take b:** the plan sheet cut the "TRACE since Jul 2017"
  caption in half. Fixed: the caption is now the strip's first cell, clear
  of every sheet.

**Non-blocking items folded in:** a 12 px gap and rule between the
reputation number and "0 ends the run" (H and H-HF); H's event option
numbers brighter (#e4dac4, as in H-HF); more right padding on H-HF's
reputation cell; spec 2.4 maps the game's bands to the palette doc's art
bands; spec 7.1 says the AFTER COSTS comparison is screen 3 only; page
captions for the band strip and the projected trace; "the newer
hierarchy" instead of internal wording.

### Re-check (opus and sol first, neon last)

| Member | Verdict | hierarchy | colour | resources | H-HF | mixer | spec | page |
|---|---|---|---|---|---|---|---|---|
| opus | GOOD TO GO | 9 | 9 | 9 | 8.5 | 9 | 9 | 9 |
| sol | GOOD TO GO * | 9 | 9 | 8.5 | 8.5 | 9 | 8.5 | 9 |
| neon | GOOD TO GO | 9 | 9 | 9 | 9 | 9 | 9 | 9 |

\* Sol's re-check found S3 still open in H-HF only: research -0.4
printed as a plain "0", while H and the game print "-0" in the warn
colour. The orchestrator copied H's two formatting functions into H-HF
(its renders stayed pixel-identical); sol confirmed it and changed its
verdict to GOOD TO GO. Its scores were given before that fix.

**Checked by the re-check:** the transparent-drag repro now moves the
visible piece; no piece can be dragged, nudged or loaded off the stage;
the tier boundaries (60, 60.25, 60.5, 0.25, -0.4) agree with the number;
the TRACE caption clears the sheets by 13 px at 1920 and about 9 px at
720; contrast on the new renders at least 4.52:1 (opus) / 4.67:1 (sol)
for H and 4.74:1 / 4.80:1 for H-HF; the run's numbers and the agreed rules
hold; the page fits at 1440, 390 and 320 px.

Neon re-ran the mixer's pixel check (same result) and confirmed the page
is rebuilt fresh, ASCII only, with the sound block unchanged: the page is
8.55 MB with its images and the mixer 6.05 MB.

**Non-blocking notes left:** none open from this round. One process note:
the first mixer re-cut left one piece empty because the orchestrator ran
`git pull --autostash` while designer E was writing it; E re-cut it and
the final build has no empty or unused file.

## Decisions still open

Each is a real decision, in one sentence, with what happens if nobody
decides. The first seven come from this round.

1. **Which resource take.** Tier icons (take a) or trace windows (take
   b)? If nobody decides, the spec's default, tier icons, is built.
2. **The tier thresholds.** The lines are a proposal: money, reputation
   and research use the game's own warning levels and action costs, but
   compute, papers and the top money and research tiers are round steps.
   If nobody decides, the spec's table (3.2) is built as it stands.
3. **Recording month-start amounts.** Take b needs the game to keep each
   resource's amount at the start of every month, which it does not do
   today. If nobody decides, take b cannot be built; take a needs nothing
   new.
4. **H or H-HF texture.** Alex leaned away from HighFleet but asked for one
   take with it. If nobody decides, H's plainer texture is the reference
   and H-HF stays an alternative.
5. **H-HF's own questions** (`H-HF/notes.md` section 5): whether stencil
   letters suit the rack labels players read most, the drum seams around
   "$" and commas, whether the dial needs a needle, and whether wear should
   grow with the doom band. If nobody decides and H-HF is chosen, it is
   built as drawn, and the game bundles the Big Shoulders Stencil Text font
   (SIL Open Font License).
6. **The band-to-art-band mapping** (spec 2.4). No game document says which
   doom band takes which darkness step. If nobody decides, the builder uses
   H's mapping (purple first at CATASTROPHIC).
7. **Today's amount and the amount after costs** both show in screen 3 (the
   strip and the plan sheet's AFTER COSTS). If nobody decides, both stay,
   as drawn.
8. **Pip's agreement to H.** Alex prefers H, but Pip has not seen it yet.
   If nobody decides, H stays a proposal in Alex's fork; the spec's tokens
   and components would still apply to whichever layout Pip picks.
9. **The Attention spill.** Should the UI let operating work borrow
   planning hours, as ADR-0011 and the game core already allow? If nobody
   decides, today's UI keeps refusing it, and screen 3 shows something the
   game cannot do yet. This changes play, so it is Pip's call.
10. **Reserve.** Should Reserve stay usable when no operating hours are
    left, as the ADR says? If nobody decides, today's UI keeps disabling
    it, unlike the mock-ups. This is Pip's call.
11. **The AFTER COSTS preview.** The plan screen previews money and
    reputation after the queued costs, which the game does not do today.
    If nobody decides, it stays in the spec as a proposal and is built
    with H.
12. **Font sizes.** H's smallest text is 16 px, while the game's smallest
    size is 15 px and it has no 22 px size (spec 2.5). If nobody decides,
    the builder uses the game's sizes and H's small text drops by 1 px.
13. **Shortcut keys.** H's P (Plan) and F (Feed) are already the game's
    Publicity and Fundraising keys (spec 4.2). If nobody decides, H cannot
    ship those two keys as drawn and the builder has to choose new ones.
14. **Where the typewriter sound plays.** The spec puts it on the game's
    SFX bus with the SFX volume. If nobody decides, it goes there and
    becomes the game's first sound effect.
15. **Event pictures.** Some mock-ups show a toned picture on the event
    paper, but the game shows none today. If nobody decides, events ship
    as text on paper.
16. **The sound itself.** One reviewer listened and it fits the trope, but
    Alex is the judge. If nobody decides, `H/dateline-sound.wav` is the
    reference for the game asset.

Settled and no longer open:
- The always-on resource bar: H keeps all five balances on the desk, now
  ranked and drawn as tier icons or traces (this round).
- Reputation is drawn once, with its "0 ends the run" note; the old dial
  survives only as a mixer option (this round).
- Attention keeps its hour bars (this round).
- Pip's Staff and Hire icons stay; the dateline stays as it is (Alex).
- Event choices use the game's Q, W, E keys; the action menu keeps H's
  box.

## New art and sound needed

- **New this round:** 25 tier icons (`H/assets/tiers/`, five per
  resource), drafts by script in Pip's dark-plated manner, for Pip's
  artist to redraw (spec 6.4). H-HF's textures are drawn in CSS and need
  no art; it needs the stencil font bundled.
- **Art that would need darker versions to match** (spec 6.2): the round
  resource icons, the PLAN calendar icon, the Fundraising, Financing,
  Strategic and Scouting icons, the office cat photo (and cat doom
  variants for bands 2 to 4, which do not exist yet), and the per-band
  office layers (window sky, monitor glow, floor smoke).
- **Placeholders needing real art:** In-tray, Feed, Advertise a Role,
  Travel and Publicity.
- **The sound** (spec 6.3): 6 to 8 key-strike one-shots plus a carriage
  slide and stop; mono WAV, 16-bit, 44.1 kHz, peaks at or under -1.5
  dBFS; on the SFX bus; one dateline at a time; its random picks never
  draw from the game's RNG.

## Bugs found on the way (not fixed; spec 7.2)

- Office Maintenance charges $5,000 and an hour and does nothing.
- Advertise a Role and Work Your Connections have empty `costs` in
  core.json.
- Research below zero has no warning.
- Four actions have unmapped icons, so the game draws a magenta
  placeholder.
- CATASTROPHIC doom text is about 1.8:1 on dark panels.
- The WATCH pause button is a stub.
- The game prints "-0" for amounts between -0.5 and 0 (`game_config.gd`
  formatting). The mock-ups copy it; a builder may want a plain 0.
- Event pictures are packed but unused.


## Disk

- **Committed in `fork/design/hifi3/` (19 MB in all):**
  - H, H-HF, C, E and G, each with concept.html, notes.md, assets/ and
    WebPs (H also has the band strip and trace WebPs, and the 25 tier
    SVGs);
  - the mixer (6.4 MB: page, pieces.js with the hit masks, 60 cut-outs,
    21 band backgrounds, its build tools);
  - spec.md, the page and its sources, the briefs and every council
    answer.
  - The page plus its images is about 8.7 MB and the mixer 6.3 MB, so
    together under 16 MB.
- **Deleted:**
  - this round's full-size PNGs: 31 files, 45 MB (`H/*.png`, `H-HF/*.png`,
    never committed). The render scripts and concept pages make them
    again;
  - the C/E/G full-size PNGs from the main pass (46 MB), earlier;
  - every designer's and reviewer's scratch folder and Chromium profile,
    which each reported; Python caches; the orchestrator's scratch.
- **Uncommitted on the box, can go when Alex is done with them:**
  - `fork/design/research/reference-games/shots/` (16 MB, third-party
    references, including the eight HighFleet shots, excluded from git);
  - `fork/design/research/_dropped-refs/` (9.1 MB).
- **Disk:** 59% used (65 GB free); no `~/.disk-low`.

## Earlier in hifi3: the main pass (for the record)

The main hifi3 pass ended at 5c49c600 with all three reviewers GOOD TO
GO. What it made and how its council went, unchanged:

### What was made

#### H finished (designer A)

- **Removed as off-character:** "LAB TERMINAL 1" and its green LED (plan
  footer and desk panel), and the CRT scanlines in the plan panel (no CRT
  is drawn now). Kept: "ACROSS YOUR DESK" and "FROM THE TELEPRINTER",
  because the desk and the printout are drawn, and every label from Pip's
  UI.
- **The sound:**
  - synthesised with the Web Audio API, with no samples;
  - each key has five layers: a metallic contact click, a slap, a short
    low thump, a rattle and a late escapement tick;
  - slight random pitch and timing; spaces are silent;
  - a carriage-return slide into a low stop, then a small dark room;
  - keys are 95 ms apart, the same timing as the silent type-on Alex
    liked.
  - The automatic type-on stays silent. A visible button plays it with
    sound, also with reduced motion on.
  - It cannot overlap itself: a new play waits until the last one has
    finished.
- **Taste notes applied:**
  - a fold crease and worn corners on the paper;
  - soot on the panel frames;
  - the event slip no longer repeats the date;
  - bold event costs;
  - Commit dimmed under the month review;
  - state 6's room slightly brighter (.40), so it still reads.
- **Taste note skipped:** the action menu keeps H's box rather than A's
  wider frame, because the card file needs the height and the rack and
  Commit stay visible.

#### The darker C, E and G (designers C, E, G)

All three keep their layouts and take H's look:
- G's dark palette and meter for every instrument;
- paper as the only light thing;
- the typewriter dateline with the same sound;
- a small, quiet Commit with held-for-events beside it;
- the room darkening by doom band.

Each removed its own leftovers from earlier looks:
- **C:** the tear-off calendar, Form A-20, hole punches, brass plates and
  glossy stamps.
- **E:** the "LABTERM 90" CRT, its knobs and LED, the tape and the bright
  fills.
- **G:** the banner scanlines, the yellow and teal buttons, the glow on
  the ladder, the purple gradient rail buttons and the filled tags. Pip's
  own `## PLAN` / `## WATCH` banner and labels stay.

Every state in all four designs keeps the run's numbers and the agreed
rules:
- no printed doom deltas;
- the one-way spill;
- an untyped reserve;
- no NEW chips;
- filled bars mean hours left;
- Enter/Esc only on the top layer;
- Standard Hiring costs $25,000 + 1 held hour.

#### The spec (designer A)

`spec.md` has seven numbered sections:
1. aim and limits;
2. tokens;
3. eleven components with their states, including the sound layer by
   layer;
4. the six screens and their keys;
5. a mapping onto `main.tscn` and `scripts/ui/`;
6. assets;
7. open rule questions and bugs.

#### The page (orchestrator)

- `index.html` is built from `page.src.html` by `build_page.py`. The
  script converts `spec.md` and copies in H's sound block unchanged.
- It is written for an outside reader: no internal jargon, no dictated
  words, and Pip's art is described as art that "would need darker
  versions to match".
- It is in Alex's house style: warm paper, with the dark screens set in
  as figures.
- The page and its 24 WebPs total about 6.3 MB.
- Checked in headless Chromium at 320, 390 and 1440 px.

### Council

The council was opus (Claude), sol (Codex) and neon (Gemini), at low
sensitivity. Their answers are in `fork/design/hifi3/council/`.

#### Round 1

| Member | Verdict | H | C | E | G | spec | page | sound |
|---|---|---|---|---|---|---|---|---|
| opus | GOOD TO GO | 9 | 8 | 8.5 | 8.5 | 9 | 9 | 8 |
| sol | CHANGES NEEDED | 9 | 9 | 9 | 9 | 8 | 8 | 8 |
| neon | CHANGES NEEDED | 9 | 8 | 9 | 9 | 8 | 8 | 7 |

All three agreed on the blocking items (`council/r1-agreed.md`):

- **Sound:** replays could overlap and clip (1.14 peak with three quick
  presses).
- **Page:**
  - a wrapped bold phrase showed raw `**`;
  - long code paths overflowed at 320 px.
- **Spec:**
  - the Attention billing wording;
  - the travel exception;
  - the Strategic unlock leaves out reputation 30;
  - the spill tag's name;
  - where the balances show.

All three also agreed the sound tuning should go into this round. Two
splits were settled by majority:
- **Cadence:** it stays at 95 ms (opus and sol; neon proposed 115-125 ms).
- **C's state 3 clamp:** it was moved clear of the P(DOOM) panel (opus and
  sol; neon would have skipped it).

#### Fix round

- **Designer A:** the replay guard inside the sound block, the tuning,
  the 44.1 kHz WAV and the spec fixes.
- **Designer C:** the clamp.
- **Designers C, E and G:** copied H's new sound block exactly (the four
  copies hash the same) and locked their buttons.
- **Orchestrator:** the page converter and its wrapping, the demo's lock,
  and the rebuild.

#### Re-check

Opus and sol first, neon last. Every agreed item was checked done.

| Member | Verdict | H | C | E | G | spec | page | sound |
|---|---|---|---|---|---|---|---|---|
| opus | GOOD TO GO | 9 | 8.5 | 8.5 | 8.5 | 9 | 9 | 8.5 |
| sol | GOOD TO GO * | 9 | 9 | 9 | 9 | 9 | 8.5 | 9 |
| neon | GOOD TO GO | 9 | 8.5 | 9 | 9 | 9 | 9 | 9 |

\* Sol's re-check found one new blocking item in the page's date demo:
pressing "Another month" while a date typed left the old date on screen.
The orchestrator fixed it ("Another month" is disabled while a date types,
and the end of typing shows the selected month). Sol verified the fix with
normal motion, reduced motion and the silent fallback, and changed its
verdict to GOOD TO GO. Its page score of 8.5 was given before the fix.

**Neon's listening (the 44.1 kHz WAV):** a "night-and-day improvement",
now "right in the spy-film title-card typewriter trope":
- the metallic click and slap lead each letter, so the woody feel is gone;
- the shorter, less pitched thump keeps the weight without sounding like a
  woodblock;
- the escapement tick makes it read as a heavy machine;
- the carriage slide is audible before the heavy stop, with no bell;
- the room is dark and clean;
- no clipping, hiss or pops.

**Non-blocking notes left:**
- **Opus:** the replay guard uses the audio clock. If a browser suspends
  audio mid-play (an iOS interruption, a background tab), later presses
  could stay silent until reload. Fix: resume before the guard, or also
  expire the guard on the wall clock. The game's own build should handle
  the same case.
- **Opus:** "no Web Audio" and "busy" both return null. A builder may want
  them told apart.


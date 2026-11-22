# hifi3: report

## Summary

**Done. All three reviewers say GOOD TO GO with nothing blocking: opus
(Claude), sol (Codex) and neon (Gemini).** One fix round was needed. It
covered the sound overlapping itself, the sound tuning, five accuracy fixes
in the spec, and three page defects. A last page bug from the re-check (the
date demo could show the wrong month) was fixed and confirmed by sol.

- **What was made:**
  - **H finished.** "LAB TERMINAL 1", its green light and the old
    scanlines are gone. The dateline types in with a synthesised
    spy-film typewriter sound. Pip's Staff and Hire icons stay; that
    question is closed.
  - **C, E and G in H's darker look.** Each keeps its own layout. Every
    text label is at least 4.5:1 on the rendered pixels at 1920x1080 and
    1280x720.
  - **A design spec for H,** `fork/design/hifi3/spec.md`, checked against
    the game's code, data and ADRs.
  - **One page to share,** `fork/design/hifi3/index.html`. It shows H first
    as the preferred direction, then C, E and G as alternatives. It has
    the date demo with sound, three ways to view the screens, a full-size
    viewer, and the spec. Alex's PC session publishes it.
- **The sound:** it was heard by one reviewer (neon), who listened to the
  rendered WAV, and read as code by the other two. Alex is the final judge.
  Neon's verdict on the tuned sound: "genuinely sounds like the cold-war
  spy-film title-card typewriter strike now", with a crisp metallic
  attack, an audible carriage slide into a heavy stop, and no clipping.
- **Disk:** the hifi2 full-size PNGs were deleted after this push.
  hifi3's own full-size PNGs (64 MB, uncommitted) can go when Alex is done
  with them.

## Where to look

- `fork/design/hifi3/index.html`: the page to share (all four designs,
  the date demo, the spec). Rebuild it with
  `python3 fork/design/hifi3/build_page.py` after editing `spec.md`,
  `page.src.html`, `demo.js` or H's sound block.
- `fork/design/hifi3/H/concept.html?state=1..6`: H live. The "Mock-up:
  type the date with sound" button below the screen plays the sound.
- `fork/design/hifi3/H/dateline-sound.wav`: the sound, rendered from the
  same code, typing "NOVEMBER 1, 2017".
- `fork/design/hifi3/spec.md`: the spec.
- `fork/design/hifi3/<H|C|E|G>/notes.md`: per-state notes, removals,
  contrast tables, art lists.
- `fork/design/hifi3/council/`: every review answer, verbatim, and the
  agreed list.

## What was made

### H finished (designer A)

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

### The darker C, E and G (designers C, E, G)

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

### The spec (designer A)

`spec.md` has seven numbered sections:
1. aim and limits;
2. tokens;
3. eleven components with their states, including the sound layer by
   layer;
4. the six screens and their keys;
5. a mapping onto `main.tscn` and `scripts/ui/`;
6. assets;
7. open rule questions and bugs.

### The page (orchestrator)

- `index.html` is built from `page.src.html` by `build_page.py`. The
  script converts `spec.md` and copies in H's sound block unchanged.
- It is written for an outside reader: no internal jargon, no dictated
  words, and Pip's art is described as art that "would need darker
  versions to match".
- It is in Alex's house style: warm paper, with the dark screens set in
  as figures.
- The page and its 24 WebPs total about 6.3 MB.
- Checked in headless Chromium at 320, 390 and 1440 px.

## Council

The council was opus (Claude), sol (Codex) and neon (Gemini), at low
sensitivity. Their answers are in `fork/design/hifi3/council/`.

### Round 1

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

### Fix round

- **Designer A:** the replay guard inside the sound block, the tuning,
  the 44.1 kHz WAV and the spec fixes.
- **Designer C:** the clamp.
- **Designers C, E and G:** copied H's new sound block exactly (the four
  copies hash the same) and locked their buttons.
- **Orchestrator:** the page converter and its wrapping, the demo's lock,
  and the rebuild.

### Re-check

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

## Decisions still open

Each is a real decision, in one sentence, with what happens if nobody
decides.

1. **Pip's agreement to H.** Alex prefers H, but Pip has not seen it yet.
   If nobody decides, H stays a proposal in Alex's fork. The spec's tokens
   and components would still apply to whichever layout Pip picks.
2. **The Attention spill.** Should the game's UI let operating work borrow
   planning hours, as ADR-0011 and the game core already allow? If nobody
   decides, today's UI keeps refusing it, and screen 3 of every design
   shows something the game cannot do yet. This changes play, so it is
   Pip's call.
3. **Reserve.** Should Reserve stay usable when no operating hours are
   left, as the ADR says? If nobody decides, today's UI keeps disabling
   it, unlike the mock-ups. This is Pip's call.
4. **The always-on resource bar.** H shows money, compute, research and
   papers only in the action card file, not all the time. If nobody
   decides, a builder following the spec removes today's top bar.
5. **The AFTER COSTS preview.** The plan screen in every design previews
   money and reputation after the queued costs, which the game does not
   do today. If nobody decides, it stays in the spec as a proposal and is
   built with H.
6. **Font sizes.** H's smallest text is 16 px, while the game's smallest
   size is 15 px and it has no 22 px size (spec 2.5). If nobody decides,
   the builder uses the game's sizes and H's small text drops by 1 px.
7. **Shortcut keys.** H's P (Plan) and F (Feed) are already the game's
   Publicity and Fundraising keys (spec 4.2). If nobody decides, H cannot
   ship those two keys as drawn, and the builder has to choose new ones.
8. **When the room darkens.** No document says which doom band moves the
   office to the next darkness step. If nobody decides, the builder uses
   the mock-ups' mapping (spec 2.4).
9. **Where the typewriter sound plays.** The spec puts it on the game's
   existing SFX bus with the SFX volume setting. If nobody decides, it goes
   there and becomes the game's first sound effect.
10. **Event pictures.** Some mock-ups show a toned picture on the event
    paper, but the game shows none today. If nobody decides, events ship
    as text on paper.
11. **The sound itself.** One reviewer has listened, and it fits the
    trope, but Alex is the judge. If nobody decides, the tuned version in
    `H/dateline-sound.wav` is the reference for the game asset.

Settled during this pass and no longer open:
- Pip's Staff and Hire icons stay (Alex).
- The dateline stays as it is (Alex).
- Event choices use the game's Q, W, E keys (spec).
- The action menu keeps H's box (designer A).
- Small taste questions in each design (see each notes.md).

## New art and sound needed

- **Art that would need darker versions to match** (spec 6.2):
  - the round resource icons (doom, reputation, money, compute, research,
    paper);
  - the PLAN calendar icon (a ledger or typed-sheet glyph would fit);
  - the Fundraising and Financing icons;
  - the Strategic and Scouting icons;
  - the office cat photo; Pip's cat doom variants for bands 2 to 4 do not
    exist yet;
  - the per-band office layers (window sky, monitor glow, floor smoke).
- **New art:** five placeholders drawn for the concepts need real art in
  Pip's manner: In-tray, Feed, Advertise a Role, Travel and Publicity.
- **The sound** (spec 6.3):
  - 6 to 8 key-strike one-shots plus a carriage-return slide and stop;
  - mono WAV, 16-bit, 44.1 kHz, raw peaks at or under -1.5 dBFS;
  - on the game's SFX bus, which has no sound effects yet;
  - one dateline at a time;
  - the sound's random picks never draw from the game's RNG.

## Bugs found on the way (not fixed; spec 7.2)

- Office Maintenance charges $5,000 and an hour and does nothing.
- Advertise a Role and Work Your Connections have empty `costs` in
  core.json.
- Research below zero has no warning.
- Four actions have unmapped icons, so the game draws a magenta
  placeholder.
- CATASTROPHIC doom text is about 1.8:1 on dark panels.
- The WATCH pause button is a stub.
- Event pictures are packed but unused.

## Disk

- **Committed in `fork/design/hifi3/` (9.0 MB):**
  - four designs, each with concept.html, notes.md, assets/ and six WebPs;
  - the WAV (290 KB);
  - spec.md;
  - the page and its sources (page.src.html, build_page.py, demo.js);
  - the briefs and council files.
  - The page plus its 24 WebPs come to about 6.3 MB, under the 16 MB
    limit.
- **Deleted:**
  - the hifi2 full-size PNGs (`fork/design/hifi2/H/*.png`, 16 MB, never
    committed), after this push;
  - every designer's and reviewer's scratch, which each reported;
  - a stray headless Chromium left by a reviewer from the grim pass.
- **Uncommitted on the box, can go when Alex is done with them:**
  - `fork/design/hifi3/{H,C,E,G}/s*.png`: the 1920 and 720 full-size
    renders, 61 MB. Each design's render script or concept.html can make
    them again.
  - Still there from the grim pass:
    - `fork/design/research/_dropped-refs/` (9.1 MB);
    - the Frostpunk menu shots (5.7 MB, third-party, never committed).
- **Disk:** 58% used; no `~/.disk-low`.

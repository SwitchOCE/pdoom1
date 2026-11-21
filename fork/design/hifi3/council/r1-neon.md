VERDICT: CHANGES NEEDED

## Scores (/10)
- H: 9/10 -- Cleanest, most atmospheric pass yet; LAB TERMINAL 1, green LED, and scanlines are gone, paper wear and fold placement land cleanly, state 5 Commit is quieted, and state 6 keeps room structure legible under the violet doom layer at both 1080p and 720p.
- C: 8/10 -- Strong grim translation of the paperwork desk; tear-off calendar, Form A-20, hole punches, brass plates, and glossy stamps are gone, and all 6 states hold >= 4.5:1 composited contrast at both sizes.
- E: 9/10 -- Sharpest alternative; dropping the LABTERM 90 CRT, tape, and bright fills makes the five-station dock and dark panels feel completely native to the tone, with zero layout or contrast slips.
- G: 9/10 -- Keeps Pip's existing layout intact while cutting every glossy fill and scanline; highest composited contrast floor of the four (>= 4.78:1 at 720p) and clean paper-fold placement.
- spec: 8/10 -- Thorough, honest about mechanics boundaries and keybind clashes, and verified against Godot's scene nodes and scripts, but has two small factual drifts against H's own screens that would make a builder guess.
- page: 8/10 -- Crisp Pip-facing editorial copy, zero internal jargon, 5.96 MB total bundle, clean at 1440px and 390px, and byte-identical sound block, but one wrapped bold phrase renders raw `**` asterisks in the built HTML.
- sound: 7/10 -- Clean, clip-free, click-gated Web Audio synthesis that reads immediately as a typed dateline without a corny bell, though the strikes skew slightly woody/tonal rather than sharp steel-on-platen spy-film metal.

## Listening
Listened directly to `fork/design/hifi3/H/dateline-sound.wav` (22050 Hz mono, 3.05 s, peak -2.06 dBFS, 0 clipped samples, no hiss or pops).

What works:
- Immediately recognizable as `"NOVEMBER 1, 2017"` being typed; cadence (~95 ms per key with slight jitter and wider silent gaps on spaces/punctuation) feels human and deliberate, not robotic.
- Good restraint on the carriage return: skipping the bright cartoon bell keeps it serious, and the ending low thump punctuates the line cleanly.
- Zero clipping, no DC clicks, and clean decay tail with ~0.7 s of quiet room tail.

What sounds off (why it leans woody-percussive rather than cold steel spy-film title-card):
- Attack / metallic snap: the high-frequency contact click (`5200 Hz`, gain `0.45`, `6 ms` decay) is buried under the low-mid sine thump (`170 -> 62 Hz`, gain `0.85`, `90 ms` decay), so strikes read a bit muffled/woody instead of steel typebar hitting a hard rubber platen. Raising a crisp 2.5-6 kHz transient burst in the first 0-10 ms and tightening the bandpass slap (`2600 Hz`, shorter `20-30 ms` decay) will sharpen the mechanical impact.
- Pitch / body: the 90 ms sine sweep with `+/-6%` pitch spread (`p = 0.94..1.06`) makes consecutive letters sound faintly pitched like muted woodblocks. Shortening the platen thud decay to ~35-50 ms and narrowing the sine pitch spread (`+/-2-3%`, keeping wider variance on the noise bands instead) will make it read as heavy desk thud rather than a pitched tone.
- Rattle / escapement: real mechanical typewriters have a faint secondary metal click ~14-22 ms after impact (typebar rebound and carriage escapement tooth). Moving the `900 Hz` rattle burst slightly later with a narrower high-mid metallic ping (`3.5-4.5 kHz`, very low gain) would sell the mechanism.
- Carriage return: the `0.12`-gain low-pass slide is almost inaudible before the stop thump, so the end reads as a single dull knock. Lifting the slide slightly (or adding a brief muffled ratchet zip across `600 -> 1800 Hz`) into the heavy low stop would make the return unmistakable without adding a bell.
- Room: at 18% wet it sounds slightly dry/close-mic'd; a slightly stronger low-passed early-reflection slap (60-120 ms dark room) would add cinema title-card weight.

## Blocking items
1. [fork/design/hifi3/build_page.py:115-119, fork/design/hifi3/index.html:676-677] The markdown-to-HTML converter runs `inline()` on each physical line of a list item separately, so `spec.md:462-463`'s line-wrapped bold renders as literal `**The build should use the game's advertised letters, Q, W, E**` in the published page Pip will read -- Buffer continuation lines of each list item (like paragraphs already do) before calling `inline()`, then re-run `python3 fork/design/hifi3/build_page.py` and verify zero unparsed `**` or backticks remain in `index.html`.
2. [fork/design/hifi3/spec.md:430-431, fork/design/hifi3/spec.md:567] Two spec details contradict H's rendered screens: (a) `spec.md:430-431` states the spilled row is tagged `"1 from plan"` (which is G's label), whereas `H/s3.png` (`H/concept.html:772`) tags row 11 with `SPILL 1` in the `POOL` column; (b) `spec.md:567` says Money, Compute, Research, and Papers "move into the card file's balance strip and the plan panel", whereas in H only the card file (state 2) shows all four, the Plan sheet (state 3) shows Money and Reputation only in `AFTER COSTS`, and the desk plan panel at rest (states 1, 6) shows no balances -- Update `spec.md:430-431` to `SPILL 1` (matching `H/s3.webp` right above it on the page) and clarify `spec.md:567` on where Compute, Research, and Papers live when the card file is closed, then rebuild `index.html`.

## Non-blocking (at most 3)
1. [fork/design/hifi3/H/concept.html:562-655, H/dateline-sound.wav] If you want the dateline sound closer to the spy-film title-card feel before sharing with Pip, tighten the sine thump decay/pitch spread, boost the 3-6 kHz metallic contact transient, and bring up the carriage-return slide per the Listening notes above (keeping `H`, `C`, `E`, `G`, and `index.html` synced).
2. [fork/design/hifi3/C/s3.png, C/s3-720.png] The top clamp on the Schedule board (`.board .clp`, y=226) sits 2 px below the bottom border of the `P(DOOM)` panel (y=224), so they visually kiss at 720p; dropping `.board` by ~6-8 px or trimming `.clp`'s negative top offset gives clean breathing room.
3. [fork/design/hifi3/spec.md:284,492] Two minor Godot line-number drifts: `"Very close to game over"` is at `main_ui.gd:1010` (spec says `1009`), and `pause_stub.disabled = true` is at `screen_mode.gd:101` (spec says `98`).

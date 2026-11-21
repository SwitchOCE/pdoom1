# hifi3 council round 1 consensus -- neon

## Positions on other members' blocking items

1. **Item 1 (sol 1; opus non-blocking 2) -- Sound replay overlap / clipping:** Agree, with the lockout placed inside the shared sound block as well as the UI buttons. Checked `H/concept.html:647-668` and `demo.js:4-12`: `soundControl()` in `H/C/E/G` has no lockout at all, and `demo.js` skips setting `typing` on the `reduced()` branch (`demo.js:7-12`), so rapid clicks or Enter presses spawn overlapping compressors into the same destination and clip (1.143 peak). Putting a busy gate directly inside `TypeSound.play` / `playDateline` (ignoring replays until the previous tail finishes, in both normal and reduced-motion modes) plus locking the button until `onDone` fixes all five copies (`H`, `C`, `E`, `G`, and `index.html`) from one source of truth.
2. **Item 2 (sol 2) -- Page at 320 px with spec open:** Agree. Checked `page.src.html:115-126`: inline `<code>` inside `.spec` has no wrapping rule, so long paths like `godot/assets/images/events/README.md` push the viewport past 320 px. Adding `overflow-wrap: anywhere` to `.spec :not(pre) > code` fixes it cleanly while keeping horizontal scrolling local to `.tbl-wrap` and `.spec pre`.
3. **Item 3 (sol 3) -- Spec 1.2 Attention rule:** Agree. Checked `godot/scripts/game_manager.gd:716-717` (declared spends debit at queue time while self-charging plays like Work Your Connections debit at execution) and `docs/game-design/decisions/ADR-0011-effort-economy.md:169` ("conference travel drains OPERATING hours only, with overflow forbidden"). Tightening `spec.md:64,68-69` to scope the no-spill rule to conference travel and describe the row tag as a queue-order estimate (with pool totals authoritative) aligns section 1.2 with section 3.8 and the engine.
4. **Item 4 (sol 4) -- Spec 7.2 Strategic unlock:** Agree. Checked `godot/data/actions/core.json:113-116`: Strategic requires both `turn_min: 10` and `reputation_min: 30`. `spec.md:694-696` omits the reputation gate; add it.

Items 5 and 6 are my own blocking items and stand as filed.

## Sound tuning (opus 3, opus 2 WAV rate, neon Listening)

**Include in this fix round.** Because `TypeSound` is already being edited for Item 1 and re-synced across `H`, `C`, `E`, `G`, and `index.html`, tuning the synthesis now and re-rendering the reference WAV lets me listen again in the re-check and take the sound from "works, slightly woody" to genuine cold-war spy-film title-card weight. Keep the restraint of **no margin bell**.

Concrete changes to `TypeSound` (`H/concept.html` `SOUND_START..SOUND_END`, synced verbatim to `C`, `E`, `G`, and `index.html`):
- **44.1 kHz reference WAV** (opus NB 2; matches `spec.md` 6.3 and stops the 22,050 Hz render from cutting the click above 11 kHz).
- **Sharper steel-on-platen attack:** lift the high-pass contact click (`~4500-5500 Hz`, gain `~0.75-0.85`, `8-10 ms` decay) and tighten the bandpass slap (`~2800-3200 Hz`, `22-30 ms` decay) so the metallic impact leads the low thump.
- **Shorter, less tonal desk thump:** trim the platen sine decay from `90 ms` to `~40-50 ms` (gain `~0.65`) and narrow the sine's pitch spread from `+/-6%` to `+/-2-3%` (keep wider spread on the noise layers) so consecutive keys do not read as pitched woodblocks.
- **Later escapement/rebound tick:** shift the rattle slightly later (`+15-20 ms`) with a subtle high-mid metallic ping (`~3600-4200 Hz`, low gain) so it reads as mechanism rebound rather than blending into the initial thump.
- **Slightly heavier cadence:** nudge base spacing from `95 ms` to `~115-125 ms` (heavier than now per opus, without dragging a 16-character date past ~2.8 s).
- **More audible carriage-return slide and slightly deeper room:** raise the slide gain from `0.12` to `~0.24-0.28` (`500 -> 1700 Hz`) into the existing low stop thump (no bell), and lift wet room slightly (`0.18 -> ~0.24`, dark/low-passed), keeping peak <= -1.5 dBFS with zero clipping.
- Update `spec.md` section 3.3 if any listed timing/parameter numbers change.

## Non-blocking items to include vs skip

- **Include (cheap, 1-line spec edits while `spec.md` is open):**
  - **opus NB 1 + neon NB 3:** Fix the three Godot line-number citations in `spec.md` (`game_state.gd:617` -> `game_state.gd:791` and `death_attribution.gd:46`; `main_ui.gd:1009` -> `1010`; `screen_mode.gd:98` -> `101`).
  - **sol NB:** In `spec.md:444-445`, scope "the desk behind it shows no keycaps" to the WATCH event (H state 5 keeps dimmed rack letters behind the month review while giving Enter to the review alone).
- **Skip:**
  - **neon NB 2** (`C/s3` clamp 2 px below P(DOOM) at 720p): not worth re-rendering C's PNGs/WebPs for a 2 px visual kiss when layout and contrast already pass.

## Proposed joint fix list

1. **[Sound + all copies]** Add a replay lockout in `TypeSound` / `playDateline` and button handlers across both normal and reduced-motion modes so overlapping plays cannot clip; apply the spy-film typewriter synthesis tuning above (sharper metallic click, shorter/less-pitched thump, later escapement tick, ~115-125 ms spacing, louder carriage slide, slightly deeper dark room, no bell); sync `SOUND_START..SOUND_END` byte-for-byte into `H`, `C`, `E`, `G`, and `index.html`; re-render `H/dateline-sound.wav` at 44.1 kHz with peak <= -1.5 dBFS.
2. **[Page + build script]** Fix `build_page.py` to join list-item continuation lines before `inline()` (eliminating raw `**...**` at `index.html:676-677`, verified clean across the whole file) and add `overflow-wrap: anywhere` on inline code inside `.spec` in `page.src.html` so 320 px mobile has zero horizontal overflow outside `.tbl-wrap` and `<pre>`.
3. **[Spec + rebuild page]** Fix `spec.md` and rebuild `index.html`:
   - `spec.md:64,68-69`: scope the no-spill rule to conference travel (ADR-0011) and describe the row spill marker as a queue-order estimate with pool totals authoritative.
   - `spec.md:430-431`: change the spill tag from `"1 from plan"` to `"SPILL 1"` to match `H/s3.png`.
   - `spec.md:444-445`: scope hiding all background keycaps to the WATCH event (matching `H/s5.png`).
   - `spec.md:567`: clarify that all four balances live in the card file's balance strip (state 2), the Plan sheet shows Money and Reputation in `AFTER COSTS` (state 3), and the desk plan panel at rest shows no balances.
   - `spec.md:694-696`: note that Strategic requires `reputation >= 30` as well as `turn_min: 10`.
   - `spec.md:284,295,492`: fix the three line citations (`game_state.gd:791` + `death_attribution.gd:46`, `main_ui.gd:1010`, `screen_mode.gd:101`), and update section 3.3 sound numbers if changed.

## Scores
Unchanged: H 9 . C 8 . E 9 . G 9 . spec 8 . page 8 . sound 7. (The other reviews confirmed the visual work on H, C, E, and G, and my spec, page, and sound scores already reflect the items on this joint list.)

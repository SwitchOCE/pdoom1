# hifi3 council round 1 consensus -- opus

## On the blocking items

**1. (sol 1) Overlapping replays clip.** Agree. It moves up from my
non-blocking 2. Each `TypeSound.play` builds its own compressor and master
gain into `live.destination`, so overlapping plays add together after
compression. Sol measured three starts 60 ms apart peaking at 1.143. Any
one play alone peaks at about 0.79, so the overlap is the only clipping
path. The sound block is copied in all four concepts: H, C (:518), E
(:531) and G (:434). C's control (:634) has no guard either, and
demo.js's reduced-motion branch returns before setting `typing`.

Fix: put one guard in the sound block itself, so every copy and both
motion paths inherit it. `playDateline` returns null, or does nothing,
while a previous run is still sounding (until `sch.end`). The callers
also disable their button until onDone. Rebuild the page from H's block.

**2. (sol 2) Page at 320 px with the spec open.** Agree. At 390 I saw no
page scroll (scrollWidth = clientWidth), but I did not test 320. Long
`<code>` paths with no break points can widen the page.
`code{overflow-wrap:anywhere}` inside the spec section fixes it, and the
tables keep their own scroll. This is the orchestrator's item.

**3. (sol 3) Spec 1.2, billing order and the travel exception.** Agree.
game_manager.gd:715-717 says Attention is spent at queue time, and
self-charging plays (the hiring pipeline) also debit at execution. So
"hours are billed in queue order, so the play that spills is the first
operating play past the 8th" is a mock-up rule, not the game's. Fix:
- say the row's spill tag is the mock-up's queue-order estimate;
- say the pool totals (MonthPlan) are the authority;
- write "conference travel drains operating hours only, with no
  overflow", as ADR-0011 words it (:169-171), not "Travel".

**4. (sol 4) Strategic also needs reputation 30.** Agree.
core.json:113-115 has `turn_min 10` and `reputation_min 30`. I noted this
myself in the first hifi round and missed it in the spec. One sentence.

**5. (neon 1) Raw `**` in the built page.** Agree. It is a visible defect
for the outside reader, in the build script the orchestrator owns. Join
each list item's continuation lines before inline formatting. Then grep
the built page for `**` and stray backticks outside `<code>`.

**6. (neon 2) The spec contradicts H's screens.** Agree with both:
- (a) H s3 tags row 11 "SPILL 1" in the POOL column (I saw it on the
  render). "1 from plan" is G's label.
- (b) In H, compute, research and papers appear only in the card file's
  balance strip. The plan sheet shows money and reputation in AFTER
  COSTS. The desk at rest shows no balances.

Fix spec 3.8 and the section 5 row, and say plainly that with the card
file closed the four balances are not on screen in H. That is a real
open question for Pip, since today's top bar always shows them. Add it
to 7.1 in one line.

## Cheap non-blocking items to include

- Line-number fixes, all together:
  - game_state.gd:617 -> :791 (+ death_attribution.gd:46);
  - main_ui.gd:1009 -> :1010;
  - screen_mode.gd:98 -> :101 (opus 1, neon 3).
- Render the reference WAV at 44.1 kHz, as spec 6.3 asks (opus 2). The
  re-listen needs a new render anyway.
- C s3 at 720: drop the board, or trim the clamp, so it clears the
  P(DOOM) panel by 6-8 px (neon 2).
- Spec 3.9: limit "the desk shows no keycaps" to the WATCH event. Under
  the month review, the rack keeps its letters and only Enter belongs to
  the sheet (sol).

## The sound tuning: yes, in this round

Alex asked for it to sound "pretty similar to how those sounds in the
movies are". Neon's listening notes are concrete and cheap: a few numbers
in `strike`, `thunk` and `schedule`, synced to every copy by the shared
block. Withdraw my own slower-tempo suggestion: neon finds the 95 ms
cadence right, and the silent type-on Alex approved runs at 95 ms
(datelineTimes), so the timing stays as it is. Changes:

1. **Contact transient:** the click becomes high-pass about 3.5 kHz, peak
   about 0.7 v, decay 8-10 ms. The slap (2.6 kHz) decay goes from 45 ms
   to about 28 ms.
2. **Thump:** decay from 90 ms to about 45 ms, and peak from 0.85 to about
   0.7. Its pitch spread narrows to +-2.5% (a separate random value). The
   noise layers keep +-6%.
3. **Escapement ping:** a new narrow band-pass at about 4 kHz (Q about 8),
   about 0.08 v, 15 ms decay, starting about 16 ms after the strike.
4. **Carriage-return slide:** gain from 0.12 to about 0.3, sweep 600 to
   1800 Hz, so the return is heard before the stop. Still no bell.
5. **Room:** a slightly bigger, darker tail. 0.7 s instead of 0.5 s,
   low-passed at about 2.5 kHz on the wet path, and wet about 0.22.
6. **After the change:**
   - re-render at 44.1 kHz;
   - report the raw peak (it must stay under -1 dBFS with no
     normalisation gain);
   - update spec 3.3's layer table and 6.3;
   - neon listens again in the re-check.

## Proposed joint list

Blocking:
1. [sound block, H, C, E, G, page] Guard against overlapping plays inside
   the block, until the previous run's end. Buttons stay disabled until
   onDone, in both motion settings. Rebuild the page.
2. [page, orchestrator] At 320 px with the spec open there is no page
   scroll: inline code wraps, and tables scroll on their own.
3. [spec 1.2] The spill tag is a queue-order estimate and MonthPlan's
   totals are the authority. Self-charging plays debit at execution.
   Conference travel only, no overflow.
4. [spec 7.2] Strategic: workday 10 and reputation 30.
5. [page build, orchestrator] No raw `**` or backticks: join list
   continuation lines before inline formatting, then grep the built page.
6. [spec 3.8 and section 5] "SPILL 1", as H draws it. Balances: only the
   card file shows all four. Note in 7.1 that the always-on top bar
   goes, which is Pip's call.

Cheap, same round:
7. The line-number fixes (game_state :791, main_ui :1010,
   screen_mode :101).
8. Reference WAV at 44.1 kHz.
9. C s3 720: clear the clamp from the P(DOOM) panel.
10. Spec 3.9: keycaps hidden under the WATCH event only.
11. Sound tuning items 1-5 above. Peak stays under -1 dBFS, spec 3.3 and
    6.3 are updated, and neon re-listens.

## Scores (revised)
H 9 . C 8 . E 8.5 . G 8.5 . spec 8.5 . page 8.5 . sound 7.5

These are down from spec 9, page 9 and sound 8, because of items I
missed:
- the spec slips (3, 4, 6);
- the page's raw `**` and the 320 px overflow;
- overlap clipping, which I wrongly rated non-blocking.

The verdict becomes CHANGES NEEDED. Everything on the list fits one fix
round.

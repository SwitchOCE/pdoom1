VERDICT: GOOD TO GO

## Scores (/10)
H 9 . C 8.5 . E 8.5 . G 8.5 . spec 9 . page 9 . sound 8.5

- **H 9.** Nothing visible changed. The sound block and control are fixed
  (below).
- **C 8.5** (up from 8). The s3 clamp now clears the P(DOOM) panel at 720
  (a clear dark gap in the crop of s3-720.png). s3.png, s3-720.png and
  s3.webp were re-rendered together at 10:47.
- **E 8.5, G 8.5.** Unchanged apart from the sound block and the
  control's lockout.
- **Spec 9** (up from 8.5). Every agreed correction is in, and I found
  nothing new wrong.
- **Page 9** (up from 8.5). No raw `**` or stray backticks, and no page
  scroll at any width (checked below).
- **Sound 8.5** (up from 7.5). The guard holds, the tuning sits inside
  every agreed range, and the peak is under -1.5 dBFS with no gain
  applied. Reviewed as code and signal; neon judges the ear.

Checked at d27d06bb.

## Agreed items: done or not

**1. Sound**
- 1.1 Replay guard -- **done.**
  - `TypeSound.play` returns null while `live.currentTime < busyUntil`,
    and `busyUntil = sch.end`, which now includes the 0.7 s room tail
    (H/concept.html block :79, :83-89).
  - Then `playDateline` returns null and fires no callbacks.
  - onDone is timed by the block itself, at the end of the tail plus
    30 ms.
  - The callers:
    - H, C, E and G disable the control only after a play has started
      (H :675-680, C :647-650, E :660-663, G :564-567) and re-enable it
      in onDone;
    - demo.js returns early on `TypeSound.busy()`;
    - demo.js locks the button in both motion branches, and its
      reduced-motion branch now also sets `typing` and frees it in
      onDone.
  - Every path that starts a play holds a single compressor chain at a
    time, so the 1.14 overlap peak can no longer happen.
- 1.2 Tuning -- **done, all within the agreed ranges** (block :43-60,
  :66-68):

  | Layer | Agreed | Now |
  |---|---|---|
  | contact | HP 3.5-5.5 kHz, 0.7-0.85, 8-10 ms | HP 4500 Hz, 0.8 v, 9 ms |
  | slap | 2.6-3.2 kHz, 20-30 ms | BP 2900 Hz (Q 1.4), 25 ms |
  | thump | 0.65-0.7, 40-50 ms, own +-2.5% | 0.68 v, 45 ms, glide 40 ms, own `q` +-2.5% |
  | tick | 3.6-4.2 kHz, 15-20 ms late | BP 3900 Hz, Q 14, 0.2 v, 12 ms, at +17 ms |
  | slide | 0.24-0.3, 500-600 -> 1700-1800 Hz | 0.27, 550 -> 1750 Hz |
  | room | ~0.7 s, LP ~2.5 kHz, wet 0.22-0.24 | 0.7 s, LP 2500 Hz, wet 0.23 |

  - The noise layers keep +-6% (`p`).
  - The cadence is still 95 ms +-22.
  - There is no bell.
  - Master gain went from 0.8 to 0.84.
- 1.3 Reference WAV -- **done.** I read the file: 44,100 Hz, mono,
  16-bit, 3.29 s. Peak 0.752 = **-2.48 dBFS**, RMS -24.1 dBFS.
  `toWav` now writes the samples with no gain (it only clamps), so this
  is the raw peak.
- 1.4 Spec 3.3 and 6.3 -- **done.** They give five layers with the three
  random values, a table that matches the code number for number, the
  room and level, and a new "One at a time" rule. Section 6.3 gives the
  44.1 kHz file's duration, peak and RMS, and the strike and stop times.

**2. Spec**
- 2.1 -- **done** (spec :64-75).
  - The exception is conference travel only, citing ADR-0011 :169-171.
  - Declared hours are booked at queue time, and self-charging plays
    debit at Commit (game_manager.gd:715-717).
  - MonthPlan's totals are the authority.
  - The spill tag is the mock-up's queue-order estimate.
- 2.2 -- **done** (:725-728). Safety Audit needs turn_min 5. Strategic
  needs turn_min 10 and reputation 30 or more (core.json:113-116).
- 2.3 -- **done.**
  - "SPILL 1" in the POOL column (:448-450).
  - The section 5 row says where each balance shows (:590).
  - 7.1 has "The always-on resource bar goes ... Pip's call" (:703-706).
- 2.4 -- **done.**
  - game_state.gd:791 plus death_attribution.gd:46 (:300-301);
  - main_ui.gd:1010 (:290);
  - screen_mode.gd:101 (:515).
- 2.5 -- **done.** Keycaps are hidden "under a WATCH event" (:465), and
  "under the month review the plates keep theirs" (:376).

**3. Page**
- 3.1 -- **done.** With scripts, `<code>` and `<pre>` removed, the page
  text has 0 `**` and 0 backticks.
- 3.2 -- **done.** In headless Chromium, with every `<details>` opened, the
  page width equals the window width at 320, 390 and 1440 px (305/305,
  375/375, 1425/1425). `.spec :not(pre)>code` and `.spec td` now wrap.
- 3.3 -- **done.** The page's script is H's block, byte for byte (the
  build takes the text between the markers, and it is a substring of
  index.html). The embedded spec has the new 3.3, 6.3 and 7.1 text.

**4.1 C s3 clamp** -- **done** (see C above).

**5.1 Copies** -- **done.** The SOUND_START..SOUND_END blocks in H, C, E
and G have the same md5 (859ba13e...). Each control is locked until
onDone.

Nothing nearby broke:
- no render changed apart from C s3;
- the 95 ms type-on timing that Alex approved is untouched;
- `render()` now defaults to 44.1 kHz, and the seeded render still
  repeats exactly (same rng order).

All Chromium runs used `timeout` and a profile in my scratch folder. The
folder is deleted, and no headless process is left running.

## Blocking items
None.

## Non-blocking (at most 3)
1. [sound block, `play`] The guard runs on the audio clock, and
   `live.resume()` comes after it. If the browser suspends the context
   mid-play (an iOS audio interruption, or a backgrounded tab on some
   browsers), `currentTime` stops below `busyUntil`. `busy()` then stays
   true, and every later press returns null without ever reaching
   `resume()`. The sound is gone until reload, while the wall-clock onDone
   still re-enables the button. Fix: call `live.resume()` before the
   guard, or let `busy()` also expire at the same end on
   `performance.now()`. The same note goes into spec 3.3's "One at a
   time" for the game.
2. [sound block] null means both "busy" and "no Web Audio". demo.js
   checks `busy()` first, so its note is right. The concept buttons just
   do nothing on a busy press, which is fine for a mock-up. A builder
   copying the block may want two distinct returns.
3. [for Alex] The tuning matches the agreed numbers. Whether it now
   sounds like the title-card strike is neon's listening call and then
   Alex's. If it still reads light, the next dials are the slap and
   contact peaks. The cadence stays at 95 ms, matching the type-on Alex
   approved.

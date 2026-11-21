VERDICT: GOOD TO GO

## Scores (/10)
H 9 . C 8 . E 8.5 . G 8.5 . spec 9 . page 9 . sound 8

- **H 9.** Alex's decisions are applied:
  - "LAB TERMINAL 1", its LED and the scan lines are gone;
  - the Staff/Hire icons stay and the question is closed;
  - the dateline is unchanged;
  - the sound is in.
  The taste notes were handled sensibly: a fold crease and worn corners on
  paper, soot on frames, no date on the event slip, bold event costs, a
  quiet Commit under the review, and s6 brightness at .40. Real game text
  is kept ("ACROSS YOUR DESK" and "FROM THE TELEPRINTER" match drawn
  objects).
- **C 8.** The grim look is carried without breaking C's paperwork-desk
  layout (checked old against new, all six states). The removals are mock
  inventions only. Paper covers a lot of screen in s3/s4 (schedule, memo,
  teleprinter, schedule card, photo), but it is all paper, so the rule
  holds.
- **E 8.5.** E keeps its stations and card file. The LABTERM brand plate,
  CRT and tear-off calendar are gone. The AFTER COSTS slip and the event
  card are aged paper.
- **G 8.5.** Today's layout is kept, including Pip's own `## PLAN` /
  `## WATCH` banner (screen_mode.gd:196, rightly kept). Commit and Begin
  planning are no longer glossy. The ladder glow and the CRT scanlines are
  gone.
- **Spec 9.** It covers every point of brief item 3, and is usable
  without the mock-ups. I spot-checked it against the code; nearly all of
  it is right:
  - FONT_STEPS 15/19/27/35 and default_font_size 19;
  - the bands and DOOM_STOPS;
  - attention 24/20/16 and planning_share 0.6;
  - can_spend_hours at month_plan.gd:182 and amendments (e) and (f);
  - the Reserve pre-check at main_ui.gd:1277-1281;
  - the "Not enough Attention" pre-check;
  - the keybinds (P is Publicity, F is Fundraising, E is commented out,
    F1 is unbound);
  - dialog_keys Q W E;
  - the speeds at screen_mode.gd:37 and the pause stub;
  - HIDDEN_FROM_ACTION_BAR_IDS;
  - the SFX bus 1 and sfx_volume;
  - the empty sfx/ folder;
  - the unmapped scout and tour icons.
  One citation is wrong (non-blocking 1). It runs to 707 lines, but it is
  sectioned and has no padding.
- **Page 9.**
  - I checked it in headless Chromium:
    - 11 images load;
    - no horizontal scroll at 390 or 1440 (the 12 spec tables scroll
      inside `.tbl-wrap`);
    - the lightbox has role=dialog with focus in and focus back;
    - the view and design tabs work;
    - the date demo has its lockout and the reduced-motion path.
  - The page is about 6.3 MB in all.
  - It has none of these words: council, round, cartoony, corny, or agent
    names.
  - Alex's dictated words are not pasted in.
  - Pip's art is called art that "would need darker versions to match".
  - The only internal traces are inside the converted spec (repo paths,
    "E's card file", "Alex ruled"). The spec is linked to the repo, so
    those are acceptable.
- **Sound 8** (reviewed as code; nobody heard it).
  - Each strike has four layers: a band-passed noise slap at 2.6 kHz, a
    6 ms high-passed click, a 170->62 Hz sine thump over 50 ms, and a
    900 Hz rattle. That is a plausible heavy, punchy key with weight
    underneath.
  - Each key varies at random: velocity 0.85-1.15, pitch +-6%, timing
    +-22 ms.
  - Spaces are silent and add 60 ms; a comma adds 40 ms.
  - The carriage return is a slide, then a low 95->42 Hz stop and a knock.
  - A short generated-noise room at 18% wet, then a compressor
    (-18 dB, 4:1).
  - All of it is synthesised: noise and oscillators only, no samples, no
    copied material.
  - The sound starts only from a click: the AudioContext is created
    inside TypeSound.play, which only the button handlers call. The
    automatic type-on is silent.
  - With reduced motion, the concept's datelineType shows the date whole
    and the sound still plays; the page's demo does the same.
  - Clipping: the reference render's raw peak is -2.06 dBFS, so toWav
    applied no gain (it only scales above -1 dBFS). The live path uses
    the same graph, so it peaks at about 0.79 too. Rendering at 44.1 or
    48 kHz should not raise that: band-passed noise gets quieter as the
    rate goes up, and the loudest part is the carriage-return sine.
  - Letters are driven from the returned strike times, so text and sound
    stay in sync.

Checks 6 and 7 (all four designs, all six states, both sizes):
- I re-ran each concept's `?check=1` in headless Chromium and measured
  every reported text box on the committed PNGs (stroke core vs box
  median). All 24 states are at or above 4.5:1:
  - lowest at 1920: C s3 "op hr" 4.58, G s5 "56.7%" 4.78, E s6 / C s6
    CATASTROPHIC 4.82-4.84;
  - lowest at 720: C s3 "op hr" 4.57, G s4 Enter 4.56;
  - nothing under 4.5.
- The layout checks are clean, and every font size is 16 px or larger.
- The data still agree in C, E, G and H:
  - $102,600 + 6 rep, $140,000 -> $37,400, rep 32 -> 26 / 34, held
    17 / 7;
  - both hires $25,000 + 1 held hr, Decline free;
  - Dec $12,400 and HIGH -> SEVERE with no delta;
  - Apr 81.4% CATASTROPHIC, rep 21.
- The agreed rules hold:
  - the spill is tagged on row 11 (operating into planning only);
  - the reserve steppers are live at 0;
  - no NEW chips;
  - filled pips = hours left;
  - Enter/Esc only on the top layer: C s3 shows "CLOSE Esc" with Commit
    bare; C, E and G s5 each have one Enter, on "Begin planning" in the
    Commit slot or on the paper.

## Blocking items
None.

## Non-blocking (at most 3)
1. [spec.md 3.2, "reputation at 0 or below ends the run
   (`game_state.gd:617`)"] That line only clamps reputation and logs a
   warning. The run-end check is game_state.gd:791 (and
   death_attribution.gd:46). Fix the citation. Also, main_ui.gd:1009 is
   the `if`, and the warning text is on :1010.
2. [H/concept.html soundControl] The mock-up button has no lockout. A
   second click while it is typing starts a second strike sequence over
   the first and restarts the letters. The page's demo already guards
   with `typing`. Fix: ignore clicks until onDone, as demo.js does.
   Also, the reference WAV is rendered at 22,050 Hz, which cuts the
   click above 11 kHz. Render it at 44.1 kHz, as spec 6.3 asks for the
   asset, so the reference sounds like what the game would play.
3. [sound, for Alex's ear rather than the code] 95 ms a key (about 10
   keys a second) is brisk for the heavy title-card trope, which usually
   types slower and harder, at about 120-160 ms. There is no margin bell
   before the return. If Alex wants it heavier, the dials are the key
   spacing, the thump's level and decay, and an optional short bell. All
   are one-line changes in `schedule`/`strike`.

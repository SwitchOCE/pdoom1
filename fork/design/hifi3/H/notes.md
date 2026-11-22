# H. The Desk, Grim -- notes (grim pass hifi2, finished in hifi3)

Status: finished (hifi3). All six states built, rendered and checked; the
hifi2 council fixes applied; hifi3 changes (leftovers removed, the dateline
sound, taste notes) in the "hifi3" section at the end, which wins where an
earlier section disagrees.

Files:
- `concept.html`: `?state=1..6`. `?still=1` shows the dateline without its
  type-on; `?check=1` runs the layout check and writes the contrast lines.
- Renders: `s1.png`..`s6.png` (1920x1080), `s1-720.png`..`s6-720.png`
  (1280x720), `s1.webp`..`s6.webp`.
- `assets/`: only what the page uses (Pip's office background and cat, one
  texture, 24 icons and 5 placeholders).
- `dateline-sound.wav`: the dateline sound rendered from the page's own
  code (see "hifi3").

Alex's words this pass answers (from fork/design/hifi2/brief.md):

> "I like the meter, like the probability of doom meter, and the darker
> color tones. If we have paper on screen, it should be the only light
> thing ... light colors and bright colors kind of break that immersion ...
> the doom meter from the G is the style I want to go with pretty much for
> everything ... the calendar things feel too corny ... the commit the month
> in option A is just it's too big ... I like the action menu quite a lot
> from option E, but ... it's too light ... I think the main work is just
> changing the texture of it ... rather than the layouts so much."

## The states

**1 -- Month 1, the first screen (Tue 4 Jul 2017; ELEVATED 20.0%, art band 0).**
- The desk at rest, in A's places:
  - top right, the P(Doom) and reputation meters;
  - bottom left, the terminal panel: JULY PLAN, planning 12 of 12, operating
    8 of 8, "Plan is empty / open Actions [A]";
  - the cat's photo print on the desk;
  - the shortcut rack;
  - "Held for events 20 hr" above Commit, which shows Enter (no menu is open).
- "JULY 4, 2017" is typed top left.
- The advisor's hand-off (cold_open_sequence.gd HANDOFF_HINT_TEXT) is an aged
  paper note with a thin amber pointer to ACTIONS. That is the glowing
  button: an amber ring, the one accent on screen.
- The room is grim but readable. This is the lightest the game gets.

**2 -- Choosing an action (Wed 1 Nov 2017).**
- Three plays are queued (Hire: Safety Researcher, Read the Literature x2),
  and Actions [A] is open.
- E's card file, retextured dark, sits where the plan sheet sits in state 3
  (56,88, 1196x952). The rack (ACTIONS lit) and Commit stay visible on the
  right, as in E.
- Header: ACTIONS, with "A Esc BACK TO DESK". Below it a balance strip:
  money $140,000, compute 65, research -12 in warn colour with "BELOW ZERO",
  papers 0, and hours left as G pips (planning 9/12, operating 8/8).
- 17 cards in E's two columns and E's order:
  - Doors have a darker brass left edge, "door . N choices" and a > tab.
  - Plays have their hours and cost chips and a + tab.
  - Blocked cards are hatched, with a dashed edge, and say why in warn
    colour: "x 22 research short", "x 32 research short", "x nobody hired
    yet", "x coming soon", and on Travel "x Submit Paper: 27 research short".
  - Hire Staff carries "1 queued" and Scouting "2 queued". No NEW chips.
- Safety Audit has focus (amber hairline). The detail strip below carries
  the only Enter: "Safety Audit -- Comprehensive safety review", 2 hr OPS,
  $40,000, "8 operating hours left", "Enter ADD TO PLAN".
- Commit hides Enter.

**3 -- The month's plan (Wed 1 Nov 2017).** As in PASS 1: one flat dark
panel holding the Attention grid, the 11-play queue with its own ^ v x per
row, the spill line and tag, Undo/Clear, queued cost $102,600 + 6 rep,
AFTER COSTS ($140,000 -> $37,400, 32 -> 26, held 7 hr), research quality
Standard, and "P Esc BACK TO DESK". Since PASS 1, the P(Doom) panel gained
a "band 3 of 7" line under the ladder (G's), and key caps no longer pick
up their label's letter spacing.

**4 -- WATCH, an event asks for a choice (Tue 14 Nov 2017).**
- The dateline reads "NOVEMBER 14, 2017" (see "Dateline rules").
- The terminal plays the month back: "NOVEMBER / workday 10 of 22", a
  22-segment month bar with today marked, then the feed:
  - "01 11 plays run at Commit";
  - "01 Safety Researcher hired";
  - "01 Networking (+3 reputation)";
  - "14 Talent Opportunity [!]";
  - "at work: 1 safety researcher";
  - "Feed and results [F]".
- The rack is the WATCH set: FEED, STAFF, LEDGER and GUIDE live; ACTIONS,
  PLAN and UPGRADES disabled (dashed, hatched).
- While the event waits for a reply, no rack plate shows a keycap (the
  event owns the keys), and neither does the terminal's "Feed and results"
  line.
- The month panel above Commit grows to the rack's height (612-968):
  - THE MONTH clock "TUE 14 NOV / workday 10 of 22";
  - a dark-red "PAUSED FOR YOU" bar;
  - the speed row (Pause on, 1x, 2x, 4x);
  - "HELD FOR EVENTS 7 hr".
- Commit keeps its place but reads "MONTH IN PLAY", dashed and inert.
- The event (core_events.json talent_recruitment) is aged paper:
  "ACROSS YOUR DESK" (hifi3: its own date dropped), "Talent Opportunity", and three
  options, each with its effect:
  - Fast-Track Hiring: +1 safety researcher, $25,000 + 1 held hr, selected
    with Enter, a 2px ink frame and an amber edge;
  - Standard Hiring: +1 safety researcher, $25,000 + 1 held hr (REVISION 3);
  - Decline Offer: no change, free.
- The event's footer reads "in hand $37,400 / held for events 7 hr".
- Reputation reads 34 (REVISION 2).

**5 -- The month review (Fri 1 Dec 2017; SEVERE 56.7%, art band 2).**
- A new month, so "DECEMBER 1, 2017" types in above everything.
- The desk is dimmed. The review is A's teleprinter sheet (dated blocks,
  council r1) on aged paper, the largest light thing in the set:
  - header "Month Review -- December 2017 / December 2017 begins.";
  - the Attention line;
  - "1 NOV -- AT COMMIT" with the 11 plays and the game's result messages;
  - "14 NOV": Talent Opportunity fast-tracked, and "7 hr held: 1 went to
    Talent Opportunity, 6 evaporated.";
  - LAST MONTH'S MOVEMENT: funds $140,000 -> $12,400 (-$127,600), staff
    0 -> 2, doom HIGH -> SEVERE (crossed up), with no delta number;
  - the game's closing note and "Begin planning December 2017 [Enter]".
- Rivals are left out (the game prints them only when visible).

**6 -- Late game (Mon 2 Apr 2018; CATASTROPHIC 81.4%, art band 3).**
- The same desk as state 1. Only the doom layer changes:
  - the room drops to brightness .40 (hifi3; was .36) and saturation .30;
  - the window sky turns violet and red;
  - the glow on the far monitor is violet;
  - a soot vignette closes in from the edges and the violet bleeds into
    the shadows;
  - the cat's photo takes a violet aura, with smoke rising.
- The panels are not repainted.
- The P(Doom) meter swaps its "band N of 7" line for the game's own
  warning at band 5+, "Very close to game over" (main_ui.gd:1009), in the
  band's text tint.
- Reputation 21, money $12,300; the terminal reads "APRIL PLAN / nothing
  queued".

## Changes from A, item by item (brief.md "What this pass makes")

1. **Layout A, smaller Commit.**
   - A's 190px yellow dial and its 296x428 housing are gone. Commit is a
     296x60 dark button with an amber hairline and amber condensed caps,
     fixed at (1584,980) in every state.
   - The held-hours panel sits above it and grows upward:
     - PLAN states: 856-968, held hours only;
     - WATCH: 612-968, with the clock, PAUSED FOR YOU and the speed row.
   - Other positions are A's, with three exceptions:
     - the plan sheet and the card file start at top 88, to give the
       dateline a fixed place;
     - the Actions menu uses the plan sheet's box instead of A's
       1488x678 frame over the rack, because E's card file needs the
       height, and E keeps the rack and Commit in view;
     - the two meter panels are 330 tall.
2. **E's card file in state 2.** E's content, order and rules (blocked
   reasons, queued stamps, one Enter in the detail strip, no NEW). The
   cream manila cards became dark G panels. Doors are told apart by a brass
   left edge and the > tab, not by colour.
3. **G's palette, panels and meter for every instrument.**
   - P(Doom): G's ring as a 270-degree tachometer:
     - a flat 16px arc in the game's doom stroke colour;
     - ticks at the six band edges;
     - mono percentage and band name in the lifted text tint;
     - G's seven-band ladder and "band N of 7";
     - "RISING" when the run state says so.
     It shows level and band, never a delta (ADR-0015). Long band names
     (CATASTROPHIC) step down to 18px so they stay inside the arc.
   - Reputation: the same meter as a semicircle, in bone. The red mark at
     0 is the real rule (game_state.gd:617), and the panel says "0 ends the
     run".
   - Attention, everywhere (plan grid, terminal, card file strip): G's flat
     rectangular pips. Filled = hours left, empty = spent, hatched = the
     operating hour drawn from planning.
   - The WATCH month bar uses the same flat segments.
   - Panels: G's dark panel, flatter (2px radius), darker, low-contrast
     hairline frame, worn brass corner ticks, no glow.
4. **Paper is the only light thing.** Paper appears four times: the
   advisor's note (1), the event (4), the review (5) and the cat's photo
   print (1, 4, 6).
   - All four are aged, dimmed and dirty: a tan base, darker toward the
     bottom, burnt edges (inset shadow), grime and grain.
   - Ink is near-black, with oxide-red and dark-green inks for headings
     and effects.
   - Nothing else is light: text is bone, not white.
   - Fills are dark: no yellow dial, no teal or bright red buttons.
   - Accent is amber only where it needs attention: the open menu, the
     advisor's glowing button, Commit, the focused card and its Enter,
     the selected event option, and the review's Enter button.
   - The doom meter keeps its band colours (the exception Alex named).
5. **Typewriter dateline.** Top left at (56,24), Courier Prime bold 28px,
   wide tracking, date only. The worn ribbon is a fixed pattern of lighter
   and lower strikes. concept.html types it in at about 95 ms a key, with a
   bright strike and a caret that blinks out. `prefers-reduced-motion` and
   `?still=1` show it whole, and the renders use `?still=1`.
6. **Less cartoony.**
   - Removed: the bakelite CRTs, screws, glass glare, phosphor glow, brass
     bevel plates, the glossy dial, the red tear-off calendar, the tape on
     the event slip, rounded corners.
   - Added: film grain and smut (inline SVG noise, no image files), a faint
     painted-metal scuff, hairlines, corner ticks, dim light.
7. **Icons.** Pip's icons sit on near-black plates and are toned
   (`saturate(.42) sepia(.22) brightness(.95)`). Disabled ones drop to 45%
   (icons, not text).
8. **No person or operator silhouette.** None. Pip's Staff and Hire icons
   stay: Alex ruled they do not count as a person (hifi3).

## Dateline rules

- The dateline shows the game date.
- It types in only on a month's entry: states 1 (July), 5 (into December)
  and 6 (April). In-month states (2, 3, 4) and WATCH's day steps show the
  date already set (council r1 item 2).
- Within a month the day updates in place, without the type-on, so WATCH
  reads "NOVEMBER 14, 2017". This keeps it from contradicting the clock.
- It always sits above the dim layer, and the menus open below it.

## Room to get darker

- Room filter, art bands 0 / 1 / 2 / 3:
  - brightness .62 / .55 / .46 / .40 (hifi3; band 3 was .36);
  - saturation .55 / .45 / .35 / .30.
- Band 3 adds the late layer (soot vignette, violet multiply), the violet
  sky and glow, and cat smoke.
- Month 1 (state 1) is the top step, and state 6 is visibly darker than
  states 1 and 4.
- TERMINAL (band 4, not shown) still has headroom: a deeper vignette, more
  smoke, and the meter at its last colour.
- The panels never darken (a layer, not a repaint).

## Contrast (measured on composited pixels, every state, both sizes)

Method (fix round; council r1 item 1):
- `?check=1` writes the box of every text element. Text under a sheet (the
  terminal under the review) is skipped by an occlusion test; nothing is
  skipped for being under the dim layer, because the colours are read from
  the render.
- A script reads each box from the rendered PNG at 1920x1080 and at
  1280x720. Background = the median luminance of the box. Text = the stroke
  core: the k-th pixel farthest from the background, k = max(4, 0.5% of
  the box), so a few stray pixels cannot set it. No CSS colour is used, so
  the dim layer, grain, paper grime and antialiasing all count.

| State | Text boxes | Lowest at 1920 | Lowest at 1280x720 | Under 4.5:1 |
|---|---|---|---|---|
| 1 | 53 | 5.38 (reputation "100") | 4.58 (held note) | 0 |
| 2 | 134 | 5.38 (reputation "100") | 4.58 (held note) | 0 |
| 3 | 189 | 4.82 (row "11" on the spill tint) | 4.50 ("top level") | 0 |
| 4 | 76 | 5.35 (terminal "01") | 4.62 (reputation "0") | 0 |
| 5 | 100 | 4.91 ("SEVERE") | 4.58 (held note) | 0 |
| 6 | 50 | 4.88 ("CATASTROPHIC") | 4.58 (held note) | 0 |

What the pixel measure forced (beyond items 1-5):
- paper a little lighter (#c3b79c to #afa286) and inks darker (ink #1a140d,
  ink-soft #221b13, red #3d0e08, green #0b2621);
- 16px Courier on paper in bold where it is a label or footer (event
  footer, "no change", review row numbers and movement notes);
- paper keycaps inverted (paper-coloured on a dark ink fill);
- queue ^ v x glyphs in bone, weight 500; inert ones in muted, still told
  apart by the dashed, hatched box;
- the reserve - / + drawn as solid 3px bars, not text (a 1px minus broke up
  at 720).

Earlier (PASS 2) fixes still in place: the dim text token #968d7c, and
disabled controls shown by a dashed, hatched plate, never by faded text.

## Agreed rules, checked

- **16px floor:** sizes in use in every state are 16, 18, 22, 28 and 40 px.
- **Attention filled = hours left:** in the plan grid, terminal, card file
  and WATCH month bar.
- **Only the topmost layer shows Enter/Esc:**
  - state 1: Commit's Enter (no layer open);
  - state 2: the card file's "A Esc" and the detail strip's Enter;
  - state 3: "P Esc", Commit without Enter;
  - state 4: the event's Enter only; Commit inert; no keycaps on the
    rack or terminal;
  - state 5: the review's Enter; Commit without Enter and dimmed (hifi3);
  - state 6: Commit's Enter.
  Elsewhere the rack keeps its letter shortcuts, as in A; disabled plates
  never show one.
- **Every repeated play has its own edit target:** state 3, each row has
  its own ^ v x.
- **Council r1 fixes kept:**
  - Standard Hiring $25,000 + 1 held hr;
  - no NEW chips;
  - event options show their effect;
  - the review uses dated blocks.
- **Layout check** (overflow, text outside its box, off stage, overlaps
  within a layer): clean in all six states.

## Fixtures and data

Unchanged from A (fork/design/hifi/run-state.md, revisions 2 and 3):
- JUL: Tue 4 Jul 2017, $245,000, rep 50, 20.0 ELEVATED.
- NOV: Wed 1 Nov 2017, $140,000, rep 32, research -12, 40.2 HIGH rising,
  with the 11-play queue booked per month_plan.gd.
- WATCH: rep 34, money $37,400.
- DEC: Fri 1 Dec 2017, $12,400, rep 34, research -6, 56.7 SEVERE.
- APR: Mon 2 Apr 2018, $12,300, rep 21, 81.4 CATASTROPHIC.

State 2's card content follows E (hifi/E/concept.html): Advertise a Role's
$8,000 + 3 hr OPS and Work Your Connections' 2 hr OPS + 6 rep come from
Balance hiring.* (core.json has `costs: {}`; see E's notes).

## Icons

24 of Pip's icons, plus A's 5 new placeholders (29 files):
- rack: ui_guide_actions, ui_config_date, ui_staff_management,
  button_upgrade_normal, ui_budget_finance, ui_guide_book; new_inbox_tray,
  new_feed_tape;
- meters: doom, reputation;
- balances: money, compute, research, paper;
- the 17 actions: A's set, including new_advertise_notice,
  new_travel_suitcase and new_publicity_megaphone.

Needs grim art (still reads cartoony after toning, at 1920):
- doom.png, reputation.png, money.png, compute.png, research.png and
  paper.png: the glossy round "resource orb" set.
- ui_config_date_64 (PLAN): a tear-off calendar with "17", the motif Alex
  called corny. Wants a ledger or typed-sheet glyph.
- ui_guide_resources_64 (Fundraising, a money bag) and
  action_funding_loan_64 (Financing): bright, toy-like.
- ui_guide_strategy_64 (Strategic, a chess knight) and
  employee_status_investigating_64 (Scouting, a glowing eye): saturated
  cartoon glow survives the toning.
- new_inbox_tray, new_feed_tape, new_advertise_notice,
  new_travel_suitcase, new_publicity_megaphone: A's flat placeholders, still
  needing real art.
- office_cat_doom-cat.webp: a painted, cute cat. Toned as a photo print it
  sits in, but a darker, grainier photo would suit.

## Bugs and data gaps

Nothing new in this pass; A's and E's notes still stand:
- Office Maintenance charges and does nothing;
- Advertise a Role and Work Your Connections have empty `costs` in
  core.json;
- research below zero has no warning in today's game (shown here, as in
  A, E and G);
- Pip's cat doom variants do not exist.

## Open questions (for the report)

Settled in hifi3 and removed from this list: the typewriter sound (built),
the dateline (Alex likes it), "LAB TERMINAL 1" (gone), the Staff and Hire
icons (they stay), the Actions menu box and the council's taste notes (my
call, see "hifi3"). What is left is one real decision:

- **Typewriter sound in the game:** the mock-up synthesises it; the game
  needs it as an audio asset on a bus. If nobody decides, it plays on the
  UI sound bus and is muted with UI sounds.

## Visual pass

Every state was looked at by eye at 1920 (with crops of the meters,
Commit and the dateline) and at 1280x720, plus a six-up sheet of the 720
renders for consistency. Fixed in the pass:
- Commit with Enter crowded the button edge: tracking and gap reduced.
- "CATASTROPHIC" and the warning line overran the arc: the band name steps
  down, and the warning moved under the ladder.
- Key caps took their label's letter spacing ("E s c"): reset.
- The review's Enter button overflowed: 18px label.
- The paper grime tiled with a visible seam and read as cloud: stitched
  and reduced.
- The type-on animation was checked mid-run (a render stopped at 1.1 s
  shows "NOVEMBER 1").

## Fix round (council round 1, fork/design/hifi2/council/r1-agreed.md)

1. **Dim layer order (states 2, 3, 5).** `.dim` now goes straight after the
   room (state 5: after the room, the terminal and the cat print). P(Doom),
   reputation, the shortcut rack (with its lit plate), Held for events and
   Commit sit above it. Contrast re-measured on composited pixels at both
   sizes (table above).
2. **Dateline type-on only on a month's entry.** `dateline(d, entry)`:
   states 1, 5 and 6 type in; states 2, 3 and 4 (and WATCH's day steps)
   show the date set. `?still=1` and `prefers-reduced-motion` unchanged.
3. **WATCH Commit slot** reads "MONTH IN PLAY". The clock keeps "PAUSED FOR
   YOU".
4. **State 4 paper text in --ink:** the footer, the option costs and
   Decline's "no change". The pixel measure at 720 also needed them bold.
5. **No keycaps on disabled rack plates (any state), and none on the live
   plates while Talent Opportunity waits.** The terminal's "Feed and
   results" key is dropped in state 4 too, for the same reason.

WebPs re-exported at about 300 KB (quality 97-98): 169-303 KB.

## hifi3: finishing H (fork/design/hifi3/designer-brief-H.md)

### 1. Off-character leftovers removed

Swept all six states. Removed (mock-up inventions from earlier looks):
- "LAB TERMINAL 1" and its green light: from the plan sheet's footer
  (state 3) and from the desk panel's footer (states 1, 4, 5, 6). The desk
  panel's footer strip went with it.
- The faint CRT scanlines inside the plan sheet (state 3): the CRT is no
  longer drawn.

Kept on purpose (they fit the character, or are the game's own):
- "ACROSS YOUR DESK" over the event: the desk is drawn, and an event slip
  arriving on it is the scene.
- "FROM THE TELEPRINTER" over the review: the sheet is drawn as
  tractor-feed printout (the sprocket strip on its top edge).
- "ADVISOR", the cold-open line, "PAUSED FOR YOU", "band N of 7",
  "0 ends the run", "Very close to game over", research quality: the
  game's words or rules.

### 2. The dateline sound

(The numbers below are PASS 1's. The fix round changed the strike, the
room, the WAV and added the replay guard; see "hifi3 fix round" at the end.)

Where: concept.html, between `/* SOUND_START */` and `/* SOUND_END */`. The
block needs nothing else on the page. Entry point:

    playDateline(text, {onChar: function(i, ch){}, onDone: function(){}})
      -> array of strike times in ms from now (one per character, spaces
         included and silent), or null without Web Audio.

Call it from a click (browsers block audio before one). The times can be
used as CSS animation delays, or onChar can drive the animation. Also in
the block: `TypeSound.play(text)` (sound only), `TypeSound.render(text,
sampleRate, seed)` (OfflineAudioContext, seeded so it repeats) and
`TypeSound.toWav(buffer)` (16-bit PCM mono).

On the page: a small dashed "Mock-up: type the date with sound" button,
fixed to the bottom centre of the window, not part of the game screen. It
is hidden in renders (`?still=1`) and the check. The automatic type-on stays
silent. Pressing the button replays the dateline with sound, with the
letters landing on the strike times. With reduced motion on, the sound
still plays and the date is shown whole.

The design (judge it as code; no agent can listen):
- **One key strike** (a hard type bar on a platen, heard through a desk),
  four layers started together. v = 0.85-1.15 (how hard) and p = 0.94-1.06
  (pitch spread), both random per key:
  - slap: white noise, band-pass 2600 Hz x p (Q 1.2), attack 1 ms to
    0.9 v, exponential decay over 45 ms;
  - click: noise, high-pass 5200 Hz x p, attack 0.5 ms to 0.45 v, gone in
    6 ms;
  - thump: sine falling 170 to 62 Hz x p over 50 ms, attack 2 ms to
    0.85 v, decay 90 ms (the weight in the title-card sound);
  - rattle: noise, band-pass 900 Hz x p (Q 4), starting 4 ms late, 0.16 v,
    decay 110 ms.
- **Timing:** 95 ms between keys, +-22 ms random. A space is silent and
  adds 60 ms. A comma adds a 40 ms beat after it.
- **Carriage return** (after the last key, +320 ms): a 240 ms slide
  (noise, low-pass sweeping 400 to 1300 Hz, swelling to 0.12), then the stop:
  a sine falling 95 to 42 Hz over 120 ms, 1.0, decay 320 ms, plus a
  300 Hz band-pass noise knock, 0.4, 80 ms.
- **Space and level:** a short hard room (0.5 s generated noise tail,
  falling as (1-t)^4) at 18% wet. A compressor (threshold -18 dB, ratio 4,
  attack 2 ms, release 120 ms) gives the punch, then master gain 0.8.
- No samples, nothing taken from a film.

**The WAV** (`dateline-sound.wav`, to commit): rendered by the block's own
`TypeSound.render("NOVEMBER 1, 2017", 22050, 1917)` in headless Chromium
(OfflineAudioContext), written by `TypeSound.toWav`. It is mono, 16-bit,
22,050 Hz, 134 KB, 3.05 s long; peak -2.06 dBFS (no limiting needed), RMS
-21.7 dBFS. An onset scan finds 14 strikes (55 to 1645 ms, longer gaps at
the two spaces and the comma) and the carriage-return stop at 2210 ms.

Checked in headless Chromium: the button exists outside the stage; calling
`playDateline` gives 16 times and fires onChar 16 times, with no errors,
with and without reduced motion (with it on the date shows whole and the
sound is still scheduled). Nobody heard it: Alex is the judge.

### 3. Icons

Pip's Staff and Hire icons stay; they do not count as a person. The
question is closed.

### 4. Taste notes from the hifi2 council

Done:
- **Paper creases and edge wear:** one fold crease (a light edge and a
  shadow) and darkened worn corners on the event and the review. The fold
  sits in a gap between lines of type (event: between the lede and the
  options; review: between rows 05 and 06). The small advisor note has
  only the worn corners.
- **Soot on frames:** every dark panel has an inner soot shadow, heavier
  at the bottom edge. No bevel: a bevel would bring back the hardware look
  the grim pass took out.
- **The date three times in state 4:** the event slip no longer carries
  its own date. The dateline says the day and the clock says the weekday
  and workday, so the slip did not need it.
- **Bold event costs:** the option costs on the slip are bold, like the
  footer and the effects; they were the thinnest type on the paper at 720.
- **Commit dimmed during the month review:** in state 5 Commit is drawn
  in its quiet form (muted text, no amber, faint frame), not hidden, so it
  no longer looks pressable while the review owns the screen.
- **State 6 room brightness:** raised from .36 to .40. The office still
  reads at band 3, and TERMINAL (band 4) keeps headroom below it.

Skipped:
- **Action menu box vs A's wider frame:** kept H's box. E's card file needs
  the height, and the rack and Commit stay in view while choosing.
- **A chunkier dateline:** Alex likes the date as it is.

### 5. Contrast (composited pixels, both sizes)

Same method as the fix round: the text and background are both read from
the rendered PNG (stroke core vs box median), at 1920x1080 and 1280x720.

| State | Text boxes | Lowest at 1920 | Lowest at 1280x720 | Under 4.5:1 |
|---|---|---|---|---|
| 1 | 52 | 5.38 | 4.63 | 0 |
| 2 | 134 | 5.38 | 4.63 | 0 |
| 3 | 188 | 4.86 | 4.54 | 0 |
| 4 | 74 | 5.35 | 4.67 | 0 |
| 5 | 100 | 4.91 | 4.63 | 0 |
| 6 | 49 | 4.88 | 4.63 | 0 |

The layout check is clean in all six states (no overflow, nothing outside
its box or off stage, no overlaps); font sizes 16 / 18 / 22 / 28 / 40 px.
Every agreed rule from the hifi and hifi2 councils still holds.
WebPs re-exported at quality 97-98: 178-309 KB.

## hifi3 fix round (fork/design/hifi3/council/r1-agreed.md, sections 1 and 2)

### 1.1 Replay guard
- Inside the sound block: `TypeSound.play(text, onDone)` records when its
  last tail ends (the room tail included). While the audio clock is short
  of that, `play()` and `playDateline()` return null and fire no onChar or
  onDone. `TypeSound.busy()` says whether a play is still sounding. null
  still also means "no Web Audio".
- onDone now fires when the tail has died (30 ms after the guard
  releases), not at a fixed 900 ms after the last letter.
- The mock-up button disables itself on click and re-enables on onDone, in
  both motion settings, and gets a dimmed disabled style.
- Checked in headless Chromium, with and without reduced motion: a first
  `playDateline` returns 16 times; a second straight after returns null,
  and so does `TypeSound.play`; its callbacks never fire (16 onChar, 1
  onDone in all). Three clicks on the button start one play and the button
  is disabled; it is enabled again after the tail, and a new play then
  starts. No page errors.

### 1.2 Tuning (cadence kept at 95 ms)
- contact click: high-pass 5200 -> 4500 Hz, peak 0.45 -> 0.8 v, decay
  6 -> 9 ms; it leads the strike.
- slap: band-pass 2600 -> 2900 Hz, Q 1.2 -> 1.4, peak 0.9 -> 0.85 v, decay
  45 -> 25 ms.
- thump: decay 90 -> 45 ms, peak 0.85 -> 0.68 v, glide 50 -> 40 ms, and its
  own pitch draw q of +-2.5% (the noise layers keep p, +-6%).
- rattle: 0.16 -> 0.12 v, decay 110 -> 70 ms (room for the tick).
- new escapement tick: band-pass 3900 Hz x p, Q 14, 17 ms after the
  strike, 0.2 v, 12 ms.
- carriage-return slide: gain 0.12 -> 0.27, sweep 400-1300 -> 550-1750 Hz;
  the stop is unchanged.
- room: tail 0.5 -> 0.7 s, wet path low-passed at 2.5 kHz, wet 18 -> 23%.
- master gain 0.8 -> 0.84 (set so the raw peak lands near -2.5 dBFS).
- toWav no longer scales: it writes the samples as they are, clamped at
  full scale. render() defaults to 44,100 Hz.

### 1.3 Reference WAV
`dateline-sound.wav`, `TypeSound.render("NOVEMBER 1, 2017", 44100, 1917)`:
mono, 16-bit, 44,100 Hz, 290,088 bytes, 3.29 s. Raw peak -2.48 dBFS (no
gain applied), RMS -24.1 dBFS, no clipped samples. An onset scan finds 14
strikes (56 to 1688 ms) and the carriage-return stop at 2250 ms. Nobody
here can hear it; neon listens in the re-check.

### 1.4 and 2: spec
spec.md 3.3 and 6.3 match the new code and file, and 1.2, 3.4, 3.8, 3.9,
section 4's table, section 5's balances row, 7.1 and 7.2 carry the agreed
fixes (see the fix-round reply).

Nothing visible on the six screens changed (the button is hidden in
renders), so the stills were not redone.


## Addendum (fork/design/hifi3/designer-brief-H2.md)

What changed, in one list:

- The screen now ranks: P(Doom) first, then Attention left and money, then
  the plan; everything else is smaller and dimmer.
- The room's colour follows the doom band, never the month: seven steps,
  band 0 brighter than H was, each band darker, colder then redder, grimier.
- The resources are one strip at the top, money to reputation, drawn as
  tier icons (take a, the default) or as small trace windows (take b,
  `?res=trace`). Reputation is drawn once; the dial is off unless
  `?rep=dial`.
- Every element the mixer lifts carries `data-el` and an id.
- Kept as they were: the dateline and its sound (SOUND_START..SOUND_END
  untouched), the agreed rules, no person, Pip's icons.

New URL parameters: `?band=0..6` (forces the room layer only), `?res=trace`
(take b), `?rep=dial` (the old reputation dial, for comparison).

### Hierarchy

| Level | What | How it is made |
|---|---|---|
| 1 | P(Doom) | The largest panel (480 x 330, top right, the first place the eye lands after the dateline). The only panel framed in its own colour: the band's stroke on the border and a top edge, with a soft glow. Percent at 40px mono, band name at 22px, the 7-band ladder lit at the current row. |
| 2 | Money | The lead cell of the resource strip: 48px icon plate (others 40), 28px value (others 22), label in `--muted` (others `--dim`). First in the strip, nearest the dateline. |
| 2 | Attention left | The top block of the plan panel, under a "ATTENTION -- HOURS LEFT" header: 22px values, 16 x 26 hour pips, the pool colours (planning amber, operating teal). |
| 3 | The plan | Queue lines in the plan panel at 16px `--muted`, row numbers muted; the plan sheet in states 2-3 keeps its paper. |
| 3 | Compute, research, papers, reputation | 22px values in `--bone`, 40px plates, 16px condensed labels in `--dim`. Reputation adds "0 ends the run" with the 0 in red. |
| 4 | Menu rack, held-for-events, Commit | 16px labels in `--muted`, icons at .82 opacity. Held hours at 22px. Commit is muted (idle) while nothing is queued and lights only when there is something to commit. |
| -- | Dateline | A title, outside the ranking: it marks the month and then sits still. |

Nothing below level 1 is under 4.5:1 (table below): recession is done with
size, weight, position and a step from `--bone` to `--muted` to `--dim`,
never by going under the line.

### Colour by doom band

The room and the panels are two layers. The doom layer sits over the room
photo only (`room(d)` in concept.html); the panels never change colour with
the band. The layer is picked by `bandIndex(doom)` from the game's bands
(DOOM_STATUS_BANDS), not by month.

| Band | Name (P(Doom)) | Room brightness / saturation / contrast | Grade and glow | Sky | Texture: vignette / grain / smut | Extra |
|---|---|---|---|---|---|---|
| 0 | NOMINAL (under 15) | .80 / .70 / 1.03 | warm amber grade, amber monitor glow | warm, bright dawn | .18 / .07 / 0 | -- |
| 1 | ELEVATED (15-37) | .70 / .58 / 1.05 | amber-brown | grey | .28 / .10 / .04 | -- |
| 2 | HIGH (37-52) | .61 / .46 / 1.08 | cold grey-blue grade, orange glow | blue-grey | .38 / .14 / .08 | -- |
| 3 | SEVERE (52-67) | .50 / .38 / 1.10 | night blue, red-orange glow | night blue | .46 / .17 / .12 | -- |
| 4 | EXTREME (67-80) | .44 / .32 / 1.12 | wine-red grade, red glow | red | .54 / .20 / .16 | -- |
| 5 | CATASTROPHIC (80-92) | .38 / .28 / 1.14 | red grade, violet glow | violet-red (colour blend) | .62 / .23 / .20 | late layer: violet bleed, the cat's aura and smoke |
| 6 | TERMINAL (92+) | .31 / .26 / 1.18 | as 5, deeper | violet-red | .72 / .26 / .24 | late layer plus fire light from below |

- **Brighter start:** H used .62 brightness for its first month; band 0 is
  now .80 and band 1 (state 1, ELEVATED 20%) .70. Still a dim, grimy
  office: the paper (advisor note, plan sheet, review) stays the only light
  thing, and the room never gets a light source of its own.
- **What changes per band:** the room darkens (brightness), drains
  (saturation), hardens (contrast); the grade moves amber, grey-blue, night
  blue, wine, violet (the palette doc's order); one glow on the far monitor
  goes amber to red to violet; the window sky follows; soot and grain
  thicken; the vignette closes in. Bands 5-6 add the late layer.
- **States:** state 1 band 1; states 2-4 band 2 (HIGH 40.2); state 5 band 3
  (SEVERE 56.7); state 6 band 5 (CATASTROPHIC 81.4).
- **Band strip:** `band-0.webp` .. `band-6.webp` are state 1's desk with
  `?band=N`. The meter in them still reads 20% ELEVATED: `?band` forces the
  room only, so the strip compares rooms. In the game the band and the
  meter always agree.

### Resources, take a: tier icons (default)

Five cells, left to right: money (lead), compute, research, papers,
reputation. Each is a dark plate with a tier icon, then the label and the
plain amount. The tier is read from that same amount, nothing else: no
forecast, no hidden value (ADR-0001). Reputation keeps "0 ends the run".

| Resource | Tier 0 | Tier 1 | Tier 2 | Tier 3 | Tier 4 | Where the lines come from |
|---|---|---|---|---|---|---|
| Money | 0 or less | up to $20,000 | up to $99,999 | up to $249,999 | $250,000+ | $20,000 is the game's low-funds warning (main_ui.gd:1021) |
| Compute | 0 or less | 1-49 | 50-99 | 100-199 | 200+ | round steps; start is 100 |
| Research | 0 or less | 1-9 | 10-19 | 20-49 | 50+ | 10 and 20 are the costs of Safety Research and Publish Safety Paper |
| Papers | 0 | 1 | 2-4 | 5-9 | 10+ | round steps |
| Reputation | 0 or less | 1-20 | 21-30 | 31-60 | 61+ | 20 and 30 are the game's reputation warnings (main_ui.gd:1015); 0 ends the run |

In the run: money $245,000 is tier 3, $12,400 tier 1; research -12 and -6
are tier 0 (and the value turns `--warn`); reputation 50 and 34 tier 3, 21
tier 2.

**New art:** 25 SVGs in `assets/tiers/`, `{money,compute,research,papers,rep}-{0..4}.svg`,
64 viewBox, painted in Pip's icon manner (dark plate, warm gradients, one
amber accent, red only on tier 0). Money: empty cash box, one coin, three
coins, a stack, a pile. Compute: dead chip, lit chip, one server, three
units, two racks. Research: blank notebook, one sheet, open notebook, three
books, file box. Papers: empty clipboard, one paper, three fanned, bound
journal, shelf. Reputation: shattered medal, cracked medal, tarnished,
brass with star, brass with laurel. They are drafts for Pip's artist, made
by script, not final art.

### Resources, take b: trace windows (`?res=trace`)

The same five cells with a small monitor in place of the icon (48 x 46 for
money, 40 x 40 for the rest; sizes after the r2 fix round).

- The line is the amount at the start of each month the player has seen,
  plus today. Data: run-state.md "Resource history".
- The y-axis has no anchor: it scales to the line's own min and max, so it
  shows shape, not size. When the line crosses 0 a dashed red zero line
  appears (research in states 3, 5, 6).
- No forecast, no future point, and no doom trace (ADR-0015).
- The strip's first cell says "TRACE" over "since Jul 2017"; in month 1
  it says "no history yet" and each window shows a flat dashed line with
  one dot.
- State 6's Jan-Mar points are a marked projection in run-state; a real
  build draws what the run recorded.

**Compact first:** both takes fit in one 60px strip between the dateline
and the meter. Take b first ran into the dateline in state 6; the TRACE
note moved into a tab under the strip, which the plan sheet then covered
(council r2, N1). It is now back inside the strip as a compact first cell,
with smaller windows and tighter cells, not smaller art.

### Mixer ids

Every element has `data-el` and the same id (unless several exist):

| data-el / id | Element |
|---|---|
| room | the room photo and doom layer |
| dateline | the typed dateline |
| doom | P(Doom) meter |
| resources | the resource strip (both takes) |
| rack | menu rack |
| plan | plan panel (the terminal) |
| feed | the WATCH feed (state 4) |
| commit (id held) / commit (id commit) | held-for-events panel / the Commit button |
| actions | the action menu (card file) |
| plan-sheet | the plan sheet (states 2-3) |
| event | event card |
| review | month review |
| advisor | advisor note |
| cat | the cat photo |
| rep-dial | reputation dial (only with `?rep=dial`) |

The mixer's reset matches `?state=3`.

### Contrast (composited pixels, both sizes)

Same method as before: background is the median of the text box, text the
k-th most distant pixel; 1920 and 1280 x 720. Fixed this round: queue and
feed row numbers and the "top level" tag moved from `--dim` to `--muted`;
the lit ladder row uses the band colour lifted to 7.5:1 (it fell to 3.7 at
720 in SEVERE).

| Render | Lowest at 1920 | Lowest at 720 | Under 4.5 |
|---|---|---|---|
| s1 | 5.44 | 4.53 | 0 |
| s2 | 5.44 | 4.53 | 0 |
| s3 | 5.25 | 4.53 | 0 |
| s4 | 5.42 | 4.59 | 0 |
| s5 | 4.91 | 4.53 | 0 |
| s6 | 4.88 | 4.53 | 0 |
| s3-trace | 5.25 | 4.53 | 0 |
| s5-trace | 4.91 | 4.53 | 0 |
| s6-trace | 4.88 | 4.53 | 0 |
| band-0 .. band-6 | 5.43-5.44 | 4.53 | 0 |

The 720 floor (4.53) is the held panel's small grey note. Layout checks
(`?check=1`): no overflow, overlap or off-stage text in any render.

### Open questions

- `?band` moves only the room, so the band strip's meter reads 20% in every
  shot. Fine for comparing rooms; a reader may take it as a mismatch.
- The resource strip and the plan sheet both show money and reputation
  after the queue (states 2-3): the strip shows today's amount, the sheet
  the amount after the plan. Keep both, or let the sheet show only the
  change?
- The action menu's balance row was removed (the strip now holds it); the
  menu keeps hours only. Check that no one misses money beside the costs.
- Tier lines are round steps where the game has no line of its own
  (compute, papers, the upper money and research tiers). Pip may want
  different ones.
- Take b needs the game to record month-start amounts; it does not today.

## Fix round r2 (fork/design/hifi3/council/r2-agreed.md)

- **S3, one shown amount.** `shownAmount()` / `shownText()` turn each
  resource into the amount the game prints (game_config.gd format_money /
  format_scalar: whole units, round half away from zero, sign from the raw
  value). The number, the tier, the warn colour and the trace samples all
  read it. Checked in the page: rep 60 and 60.25 print "60", tier 3; 60.5
  prints "61", tier 4; 0.25 prints "0", tier 0; -0.4 prints "-0" (as the
  game does), tier 0; money 20,000.4 prints "$20,000", tier 1, and
  20,000.5 prints "$20,001", tier 2. `money()` now rounds too, as the game
  does. The real loss rule stays game state (game_state.gd:791, raw
  reputation <= 0).
- **N1, caption.** The TRACE caption is the strip's first cell (`.rc.cap`),
  inside top 16..76, so the plan sheet and actions sheet (top 88) and the
  event card (top 93) cannot cover it. Strip left edge with the caption,
  measured: x 462 (states 1-3), 479 (states 4-6); longest dateline text
  ends at 427 (state 4). Checked in states 1-6 with `?res=trace`, plus a
  new state 2 trace render for the check (not a deliverable).
- **opus 1.** "0 ends the run" sits 12 px after the number, behind a 1 px
  rule (frame-hi), so "21" and "0" no longer read as one figure.
- **neon 2.** Event option badge ink `#c9bc9f` -> `#e4dac4`.
- **opus 3, sol 1.** Spec only (2.4 mapping table; 7.1 says state 3).
- Element ids, classes and the SOUND block are unchanged. The caption's
  class changed from `.rs .cap` (a tab) to `.rc.cap` (a cell); it is still
  inside `#resources`.
- **Contrast after r2** (composited pixels; lowest at 1920 / 1280x720;
  nothing under 4.5): s1 5.44 / 4.53; s2 5.44 / 4.53; s3 5.25 / 4.53; s4
  5.42 / 4.93; s5 4.91 / 4.53; s6 4.88 / 4.53; s2-trace 5.42 / 4.53;
  s3-trace 5.25 / 4.53; s5-trace 4.91 / 4.53; s6-trace 4.88 / 4.53;
  band-0..6 5.41-5.44 / 4.53. Layout checks clean in every state.

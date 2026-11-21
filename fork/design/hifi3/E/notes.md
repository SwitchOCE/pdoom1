# E. Rooms and Stations, Grim -- notes (hifi3)

The darker E. It keeps E's layout from the hifi run (fork/design/hifi/E/)
and takes H's finished look (fork/design/hifi3/H/). This is a texture pass,
not a redesign.

Files:
- `concept.html`: `?state=1..6`. `?still=1` shows the dateline without its
  type-on; `?check=1` runs the layout check and writes one TXT line per
  visible text box for the contrast measure.
- Renders: `s1.png`..`s6.png` (1920x1080) and `s1-720.png`..`s6-720.png`
  (1280x720), not committed; `s1.webp`..`s6.webp` (1920 wide, 168-298 KB,
  quality 97-98), committed.
- `assets/`: Pip's mezzanine office, the figure-free crop of his event
  picture (from E's hifi version), H's painted-metal texture, and 34 icons.

Alex's words this pass answers (fork/design/hifi3/designer-brief-CEG.md):

> "Build the others with the darker look as well. ... if something doesn't
> fit the character design, like the lab terminal thing, it should go ...
> Date feels the date feels good. I like the date."

## Where things sit (all states, 1920x1080)

- The dateline is top left at (56,24), in H's type, where E's tear-off
  calendar was.
- P(Doom) is top centre (690-1230, 16-200), where E's dial housing was.
- Reputation is top right (1612-1872, 16-200).
- The station dock is on the left (48-458, from y 330): ACTIONS [A], PLAN
  [P], LAB FLOOR [F], PROCUREMENT [U], RECORDS [L]. These are E's rooms
  and keys.
- The month card is on the right (1500-1872, from y 216).
- Held for events (1540-1872, 856-968) sits above a quiet Commit
  (1540-1872, 980-1040). Commit never moves. In WATCH its slot becomes
  playback; in the Month Review it becomes Begin planning.
- Menus open in E's places, below the top row (from y 216): the card file
  (48-1244), the plan (384-1464) with the printout beside it, the event
  memo (612-1248) and the review (330-1450).

## The states

**1 -- Month 1, the first screen (Tue 4 Jul 2017; ELEVATED 20.0%, art band 0).**
- "JULY 4, 2017" types in.
- The office is grim but still readable, the lightest the game gets.
- The dock shows ACTIONS with the amber ring (the glowing station). Each
  station shows its key.
- THIS MONTH: planning 12 of 12 and operating 8 of 8 as G's flat pips, plus
  "Nothing queued yet."
- The advisor's note is aged paper with a thin amber pointer to ACTIONS. It
  carries the cold open's hand-off, split as in E's hifi version: "You do
  not know anything yet. Go and find out -- Scouting." / "Scouting is in
  Actions, the glowing station." It closes with a plain x box (no Esc
  keycap).
- "Held for events 20 hr" sits above "COMMIT THE MONTH [Enter]".

**2 -- Choosing an action (Wed 1 Nov 2017).**
- The room dims under the card file. P(Doom), reputation, held and Commit
  sit above the dim layer.
- The card file is E's (and H's): 17 cards in two columns, in E's order.
  - The balance strip: money $140,000, compute 65, research -12 in warn
    colour with "BELOW ZERO", papers 0, and hours left as pips (planning
    9/12, operating 8/8).
  - Blocked cards are hatched with a dashed edge and say why.
  - Hire Staff shows "1 queued" and Scouting "2 queued". There are no NEW
    tags.
- Safety Audit has focus: an amber hairline and a plain + tab. The detail
  strip carries the only Enter ("Enter ADD TO PLAN"). The header carries
  "Esc BACK TO DESK".
- Commit hides Enter. Held for events reads 17 hr (9 + 8 left).

**3 -- The month's plan (Wed 1 Nov 2017).**
- THE MONTH AHEAD is a flat dark panel where E's LABTERM CRT was, with
  "P Esc BACK TO DESK".
- Attention:
  - Planning has 7 filled, then one hatched box, then 4 empty: "7 left".
  - Operating has 8 empty: "0 left", in warn colour.
  - A thin arrow runs from the last operating hour up into the hatched
    planning hour, with the line "1 hr of operating work is using a
    planning hour".
- Beside it, "HELD FOR EVENTS AT COMMIT 7 hr", the reserve - / + at 0 hr,
  and "7 hr unspent + 0 hr reserve".
- The queue has 11 plays:
  - The two Read the Literature plays are a group row (02-03, x2, [-],
    with ^ v) opened into one row each. Each of those rows has its own
    ^ v x.
  - Row 10 is the second Go to Meetups.
  - Order Office Supplies carries the hatched spill swatch.
- The footer reads "Undo Z", "Clear C" and "11 plays . queued cost
  $102,600 + 6 rep".
- The printout beside the plan is aged paper, titled "AFTER COSTS":
  - money $140,000, plays -$102,600, after costs $37,400;
  - reputation 32, plays -6, after costs 26;
  - "Research (now) -12", "Below zero: research plays are blocked."
- Commit hides Enter.

**4 -- WATCH, an event asks for a choice (Tue 14 Nov 2017).**
- "NOVEMBER 14, 2017" is set, not typed: this is a day step.
- The dock: ACTIONS and PLAN are dashed and hatched (closed while the month
  plays). No station shows a key while the event waits.
- THE MONTH SO FAR:
  - TUE 14 NOV, "workday 10 of 22", and a 22-segment bar with today marked;
  - "At work: Safety Researcher";
  - the four latest feed lines from 01 Nov, in the game's words;
  - "+ 7 earlier lines in Records".
- Held for events shows 7 hr.
- The Commit slot is playback, stopped: "EVENT PAUSED" with Pause lit, then
  1x, 2x and 4x.
- The memo across the desk is aged paper:
  - "ACROSS YOUR DESK" (its own date dropped, as in H);
  - Pip's event picture, toned as a print;
  - "Talent Opportunity" and the data's line;
  - "Cash $37,400 / Held for events 7 hr";
  - three options keyed 1 / 2 / 3:
    - Fast-Track Hiring: +1 safety researcher, $25,000 + 1 held hr, with
      the only Enter;
    - Standard Hiring: +1 safety researcher, $25,000 + 1 held hr
      (REVISION 3);
    - Decline Offer: no change, free.
- Reputation reads 34. P(Doom) is held at 40.2% until the review.

**5 -- The Month Review (Fri 1 Dec 2017; SEVERE 56.7%, art band 2).**
- "DECEMBER 1, 2017" types in.
- The room dims. The review is a typed report on aged paper:
  - "MONTH REVIEW -- DECEMBER 2017 / December 2017 begins.";
  - LAST MONTH'S MOVEMENT: Funds $140,000 -> $12,400 (-$127,600), Staff
    0 -> 2 (+2), Doom HIGH -> SEVERE, crossed up, with no number;
  - ATTENTION: 20 fresh hours as two rows of full boxes, then "November
    held 7 hours for events; 1 went to Talent Opportunity. The other 6
    evaporated -- no banking.";
  - NOVEMBER'S PLAYS: each play with the game's result message, ending
    with the answered event.
- Rivals are left out: the game prints them only when a rival is visible.
- The Commit slot reads "BEGIN PLANNING / DECEMBER 2017 [Enter]", the
  review's one Enter. Held for events shows December's 20 hr.

**6 -- Late game (Mon 2 Apr 2018; CATASTROPHIC 81.4%, art band 3; fixture).**
- The same desk as state 1. Only the doom layer changes:
  - the room drops to brightness .40 and saturation .30;
  - the window sky turns violet and red;
  - the five monitors glow violet;
  - smoke lies on the floor;
  - soot closes in from the edges.
- No panel is repainted. P(Doom) swaps "band N of 7" for the game's warning
  "Very close to game over".

## What changed from E's hifi version (the brief's list)

1. **G's palette and meter style for every instrument.**
   - P(Doom) is G's flat 16px arc, as a semicircle:
     - the game's doom stroke colour, with ticks at the six band edges;
     - a mono percentage, plus 0 and 100 at the ends;
     - beside it the band name, RISING, G's seven-band ladder and "band N
       of 7".
     - It shows level and band, never a delta.
     - It replaces E's purple dial housing and its needle.
   - Reputation: the number beside a bone semicircle, with the red mark at
     0 and "0 ends the run" (the real rule, as in H). It replaces E's cream
     card and needle gauge.
   - Attention everywhere (month card, card-file strip, plan, review) is
     G's flat pips: filled = hours left, hatched = the hour operating work
     took from planning. E's solid orange and blue bars are gone.
   - The WATCH workday strip uses the same flat segments.
2. **Paper is the only light thing, aged and dimmed.**
   - Paper appears four times: the advisor's note (1), the AFTER COSTS
     printout (3), the memo (4) and the review (5). All of it uses H's aged
     paper (tan, grime, burnt edges, one fold).
   - The month card, the card file and the stations, which were cream
     paper, manila or brass in E, are now dark panels.
   - Accent is amber only where something needs attention: the glowing
     station, the focused card and its Enter, the selected event option
     and Commit.
3. **The typewriter dateline.** It is H's code and type, unchanged, and it
   replaces E's red tear-off calendar.
   - It types in on a month's entry (states 1, 5, 6) and is set in states
     2, 3 and 4.
   - `?still=1` and `prefers-reduced-motion` show it whole.
   - H's sound block is copied byte for byte (between SOUND_START and
     SOUND_END). A dashed "Mock-up: type the date with sound" button calls
     `playDateline` from a click.
   - Checked: a render stopped at 1.1 s shows "JULY 4," mid type-on.
     State 4 has no typing class. The button is in the DOM.
   - Nobody heard the sound.
4. **Commit quiet and small, held for events beside it.**
   - E's big teal button is now H's 332x60 dark button with an amber
     hairline.
   - A held-for-events panel sits above it in every state.
   - In WATCH the slot is E's playback, in the same dark style. In the
     review it is "Begin planning".
5. **Nothing glossy or cartoony.**
   - Gone: the bakelite CRT, glass, knobs and LED; the clipboard and its
     clip; the tape on the memo; the glossy teal and brass; rounded
     corners; text glow.
   - Added: H's film grain and smut, hairlines, worn corner ticks and soot.
   - Pip's icons sit on near-black plates, toned with H's filter.
6. **Room to darken by doom band.**
   - The room filter is H's: brightness .62 / .55 / .46 / .40 and
     saturation .55 / .45 / .35 / .30 for art bands 0-3, under H's grade,
     glow and shade.
   - Band 3 adds E's own layer (sky, violet monitors, smoke) plus H's soot
     vignette.
   - Month 1 is clearly lighter than state 6, and TERMINAL still has
     headroom.
   - Panels never darken, and no control moves between states.
7. **Text at least 4.5:1 on the composited pixels:** see the contrast
   table.
8. **Off-character leftovers removed:** see "Removed".
9. **People:** none drawn. Pip's Staff (LAB FLOOR) and Hire icons stay, per
   Alex. The event picture is the figure-free crop from the hifi run.
10. **Same run and rules as the hifi version:**
    - REVISION 2 numbers and messages;
    - Standard Hiring $25,000 + 1 held hr;
    - no NEW tags;
    - filled = hours left;
    - only the topmost layer shows Enter/Esc;
    - every repeated play has its own edit target;
    - text at least 16px at 1920;
    - no doom deltas.

## Removed (mock-up inventions from E's earlier look)

- "LABTERM 90", the brand plate on the plan CRT, with its vent, two knobs
  and green LED. The CRT bezel and glass went with them; the plan is a flat
  panel.
- The CRT's phosphor glow and scanline tint.
- The clipboard clip on the month card.
- The strip of tape on the memo and the tear-off edge on the printout.
- The red binding and "MONTH n" line of the tear-off calendar. The date now
  lives in the dateline. The month number is not shown, as in H.
- The decorative check icon on Commit and Begin planning.
- The icons on the event options (Pip's Hire icon and the cancel cross).
  They crowded the option names, and H's options have none.
- The "Held for events" row in THE MONTH SO FAR. The held panel beside the
  playback slot now shows it, so it no longer appears twice.

Kept on purpose (the game's own words or rules): "ADVISOR" and the
cold-open line, "ACROSS YOUR DESK", "EVENT PAUSED", "band N of 7", "Very
close to game over", "0 ends the run", "Below zero: research plays are
blocked." The station names and subtitles are E's own design, not leftovers
of a drawn object.

## Art that would need darker versions to match

Pip's icons are toned on dark plates. Even so, these would need darker
versions to match:
- `doom.png`, `reputation.png`, `money.png`, `compute.png`, `research.png`
  and `paper.png`: the round resource set, still bright and glossy at 1920.
- `ui_config_date_64.png` (PLAN, THIS MONTH): a tear-off calendar with "17",
  the motif the dateline replaced.
- `ui_guide_resources_64.png` (Fundraising), `action_funding_loan_64.png`
  (Financing), `ui_guide_strategy_64.png` (Strategic) and
  `employee_status_investigating_64.png` (Scouting): saturated glow
  survives the toning.
- `ui_guide_actions_64.png` (ACTIONS station): a bright blue hand.
- New placeholders still needing real art: `new_post_online`,
  `new_meetup_badge`, `new_supplies`, `new_advertise`, `new_publicity`,
  `new_travel` (all .svg).
- Art, not icons: per-band window-sky and monitor-glow layers for Pip's
  mezzanine office (state 6 fakes them with CSS blends), and a darker,
  grainier event picture (the memo's is a toned crop).

## Contrast (composited pixels, every state, both sizes)

Method (H's): `?check=1` lists every visible text box. A script reads each
box from the rendered PNG at 1920x1080 and at 1280x720 (boxes scaled by
2/3). Background is the median luminance of the box; text is the k-th
pixel farthest from it (k = max(4, 0.5% of the box)). No CSS colour is
used, so the dim layer, grain, paper grime and antialiasing all count.

| State | Text boxes | Lowest at 1920 | Lowest at 1280x720 | Under 4.5:1 |
|---|---|---|---|---|
| 1 | 51 | 5.45 ("band 2 of 7") | 4.59 (held note) | 0 |
| 2 | 120 | 5.48 (a "0") | 4.59 (held note) | 0 |
| 3 | 167 | 4.85 (row "11" on the spill tint) | 4.59 (held note) | 0 |
| 4 | 78 | 5.25 (feed "01 Nov") | 4.61 (held note) | 0 |
| 5 | 70 | 4.86 ("RISING") | 4.59 (held note) | 0 |
| 6 | 49 | 4.82 ("CATASTROPHIC") | 4.59 (held note) | 0 |

The measure forced one change: the subtitle on a closed station (state 4)
measured 4.29 at 720 in the dim token. It now uses the muted token; the
closed state is shown by the dashed, hatched plate, as in H.

## Agreed rules, checked

- **16px floor:** the sizes in use are 16, 18, 22, 28 and 40 px, in every
  state.
- **Filled = hours left:** month card, card-file strip, plan, and review.
- **Only the topmost layer shows Enter/Esc:**
  - state 1: Commit's Enter; the stations' letter keys;
  - state 2: "Esc" on the card file and the detail strip's Enter; Commit
    has no Enter;
  - state 3: "P Esc" on the plan; Commit has no Enter;
  - state 4: the memo's Enter only; no keys on the dock or the playback;
  - state 5: Begin planning's Enter only;
  - state 6: Commit's Enter and the stations' keys.
- **Every repeated play has its own edit target:** in state 3, rows 02 and
  03 each have ^ v x, and both Go to Meetups rows have their own.
- **Layout check** (overflow, text outside its box, off stage, overlaps
  within a layer, and panels covering each other): clean in all six
  states.

## Bugs and data gaps

Nothing new in this pass. E's hifi notes still stand:
- Office Maintenance charges $5,000 and does nothing; it is not queueable
  (v0.13.1).
- Work Your Connections and Advertise a Role have `costs: {}` in core.json.
  Their hours and costs come from Balance hiring.*.
- Research below zero (-12, then -6) gets no warning in today's game; it is
  shown here.
- Event pictures are packed but unused by the game; the memo uses one.
- Pip's cat doom variants do not exist. E shows no cat, as before.
- Strategic unlocks at turn 10 with reputation 30. In state 6 reputation is
  21, so it would lock again; the home screen does not show this.

## Open questions (one real decision)

- **Art band per doom band.** The mock-ups read SEVERE and EXTREME as band
  2 and CATASTROPHIC as band 3; the palette doc gives no cut points. If
  nobody decides, the game keeps whatever mapping its builder picks, and
  the room may darken at different moments than these screens show.

Settled here, not open:
- the per-row spill swatch stays, with the arrow in the Attention grid;
- the Month Review keeps its play list, as run-state asks;
- the Staff and Hire icons stay (Alex);
- RISING shows in states 2-6, as in E's hifi version (fixture).

## Visual pass

Every state was looked at by eye at 1920 and at 1280x720, plus a six-up
sheet for consistency. Fixed in the pass:
- The event options' names ran into their costs: the option icons were
  dropped and the memo widened to 636.
- The feed's "01 Nov" touched its text: the date column was widened.
- Reputation's "0" label crowded "0 ends the run": both were moved.
- "Very close to game over" touched the P(Doom) panel edge: the panel was
  widened to 540.
- The plan panel had a gap at the bottom: the queue rows are now 40px.
- The band-3 monitors read as flat purple slabs: lower opacity and a
  slight blur.

## hifi3 fix round (council r1 item 5.1)

- The sound block between SOUND_START and SOUND_END is H's new block,
  byte for byte (with its replay guard and `TypeSound.busy()`), and
  `soundControl()` is H's: the "play with sound" button is disabled on
  click and enabled again in onDone, in both motion settings. Checked in
  headless Chromium, with and without reduced motion: three fast clicks
  make one `TypeSound.play` call and start one play; the button is
  disabled after them and enabled again after onDone. The button is
  hidden in renders (`?still=1`), so nothing was re-rendered.

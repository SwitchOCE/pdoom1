# H. The Desk, Grim -- notes (grim pass, hifi2)

Status: all six states built, rendered and checked; council round 1 fixes
applied (see "Fix round").

Files:
- `concept.html`: `?state=1..6`. `?still=1` shows the dateline without its
  type-on; `?check=1` runs the layout check and writes the contrast lines.
- Renders: `s1.png`..`s6.png` (1920x1080), `s1-720.png`..`s6-720.png`
  (1280x720), `s1.webp`..`s6.webp`.
- `assets/`: only what the page uses (Pip's office background and cat, one
  texture, 29 icons).

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
  "ACROSS YOUR DESK / TUE 14 NOV 2017", "Talent Opportunity", and three
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
  - the room drops to brightness .36 and saturation .30;
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
8. **No person or operator silhouette.** None. The icons with heads
   (Hire, Staff) are Pip's own, as in A.

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
  - brightness .62 / .55 / .46 / .36;
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
  - state 5: the review's Enter, Commit without Enter;
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

29 of Pip's icons, plus A's new placeholders:
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

- **Typewriter sound:** one key strike per character and a carriage return
  at the end? Which mix bus, and is it muted with UI sounds? Not built.
- **Dateline:** settled by the council for the mock-up (types in on a
  month's entry only, including month 1); the in-month day update is still
  the design's reading.
- **"LAB TERMINAL 1":** the plan and home panels are no longer CRTs. Keep
  the name as a footer label, or drop it?
- **Actions menu box:** it now uses the plan sheet's box (rack and Commit
  stay visible) rather than A's wide frame over the rack. Keep this, or go
  back to A's frame with a shorter card file?
- **Not in the fix round (council r1, to the report):** the "LAB TERMINAL
  1" label and green LED; the date shown three times in state 4; whether
  the dateline is chunky enough; paper creases, frame bevel and soot;
  state 6 room brightness (.36 vs .42).
- **The Staff and Hire icon question** from the hifi report is still open
  (carried, not decided).

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

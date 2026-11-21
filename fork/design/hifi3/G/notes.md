# G. The Existing UI, Modernised -- grim (hifi3)

The darker G. It keeps G's layout and copies H's finished look (fork/design/hifi3/H/).
This is a texture pass, not a redesign.

G's layout, unchanged:
- today's PLAN screen kept in place: the resource bar, the `## PLAN` / `## WATCH` banner
  with the PLAN/WATCH view switch, the P(Doom) card top right, the Attention card bottom
  right and Commit bottom right;
- everything else lives in menus on Pip's left rail (Actions, Upgrades, Staff, Ledger,
  Guide);
- the centre changes with the state.

Files:
- `concept.html`:
  - `?state=1..6` picks the state;
  - `?still=1` shows the dateline without its type-on (used for the renders);
  - `?check=1` runs the layout check (result in `body[data-check]`) and writes one line
    per text box for the contrast measure.
- `render.sh N ...`:
  - makes `sN.png` (1920x1080) and `sN-720.png` (1280x720), which stay uncommitted;
  - makes `sN.webp` (1920 wide, quality 97-98, 145-301 KB), which are committed;
  - prints the layout check and the pixel contrast for both sizes.
  - It runs one headless Chromium at a time and deletes its scratch.
- `contrast.py`: the pixel contrast measure (see "Contrast").
- `assets/`: only what the page uses:
  - Pip's office_wide_day and the records-room crop (event_records_drawer);
  - H's painted-metal texture;
  - 40 icons.

## The states

**1. Month 1, the first screen (Tue 4 Jul 2017; ELEVATED 20.0%, art level 0).**
- "JULY 4, 2017" types in at the top left of the resource bar.
- The resources read $245,000, compute 100, research 0, papers 0 and reputation 50 (on its
  small gauge).
- The advisor's hand-off is an aged paper note beside the rail. Its text is the game's own
  line (GameConfig.first_lever_hint_text), plus "Scouting is in Actions, the glowing
  button."
- A thin amber arrow points to ACTIONS, which glows (the one accent on screen).
- The note is not modal. It closes with its x, so Commit keeps Enter and Menu keeps Esc.
- Attention: planning 12 of 12 and operating 8 of 8, filled (filled = hours left).
  "Nothing queued yet" and "Choose actions [A]".
- Bottom right: "HELD FOR EVENTS 20 hr" beside a quiet "COMMIT THE MONTH [Enter]".
- The room is dim but readable. This is the lightest the game gets.

**2. Choosing an action (Wed 1 Nov 2017).**
- The dateline reads "NOVEMBER 1, 2017", already set (no type-on inside a month).
- The Actions menu is open beside the rail, with 17 rows in G's five groups.
  - Doors end in ">" and plays in "+".
  - Hire Staff carries "1 in plan" and Scouting "2 in plan".
  - Blocked rows are hatched with a dashed edge and give the reason in the warn colour:
    22, 22 and 32 short, "no hires waiting", Submit Paper 27 research short.
  - Advertise a Role is COMING SOON.
  - No NEW chips.
- Safety Audit is selected (amber hairline). Its detail card holds the only Enter and Esc:
  2 operating hours, $40,000, "Comprehensive safety review", and the fit line. The menu
  shows only its x, and Commit hides Enter.
- Attention: 9 of 12 and 8 of 8, with three plays queued ($60,000). Held for events:
  17 hr.

**3. The month's plan (Wed 1 Nov 2017).**
- The Plan drawer (THE MONTH AHEAD) lists all 11 plays, one row each, every row with its
  own ^ v x. Repeats included: Read the Literature 2 and 3, Go to Meetups 7 and 10.
- Order Office Supplies shows "1 op" plus a hatched cell and "1 from plan" (the spill).
- Total: 4 plan + 9 op, $102,600 + 6 rep. "AFTER THESE COSTS": $37,400, 26 rep.
- Research Quality is set to Standard. Undo, Clear and Reserve hours [R] are live.
- The Attention card shows:
  - planning 7 left, with the hatched spill cell;
  - operating 0 left, in the warn colour;
  - the spill legend;
  - "Reserved, up to 7 hr: none yet";
  - the rule in one sentence;
  - Close plan [Q].
- The drawer owns Esc. Held for events: 7 hr. Commit has no Enter.

**4. WATCH, an event asks for a reply (Tue 14 Nov 2017).**
- The dateline reads "NOVEMBER 14, 2017": the day updates in place, without the type-on.
- The banner shows `## WATCH` and the playback, drawn as 22 flat workday segments (the
  meter style). Today is marked, labelled "workday 10 of 22". Pause is lit; 1x, 2x and 4x
  follow. The view switch is dashed (inert while the event waits).
- Top bar: $37,400, research -6 BELOW ZERO, reputation 34 (run-state REVISION 2).
- Rail: Actions and Upgrades are dashed and hatched. No keycaps anywhere behind the event.
- The event is an aged paper slip:
  - headed "ACROSS YOUR DESK", with an ink "NEEDS A REPLY" stamp;
  - a dim, sepia print of Pip's records-room art (no figure);
  - "Talent Opportunity" and the data's line;
  - three options, each with its effect:
    - Fast-Track Hiring: $25,000 + 1 held hr, selected, with the only Enter;
    - Standard Hiring: $25,000 + 1 held hr (REVISION 3);
    - Decline Offer: no change, free;
  - footer: "in hand $37,400 / held for events 7 hr".
- The feed (bottom left) shows "+ 7 more lines from Wed 1 Nov", then four Wed 1 Nov lines
  in queue order (plays 5, 8, 10, 11), then "Talent Opportunity: needs a reply."
- The Attention card is the hold in WATCH: held 7 of 7 (neutral bone, not purple), "Spent
  at Commit 13 hr", "This reply would cost 1 hr", and STAFF AT WORK: 1 Safety Researcher.
- Commit keeps its place, dashed and inert: MONTH IN PLAY.

**5. The Month Review (Fri 1 Dec 2017; SEVERE 56.7%, art level 2).**
- A new month, so "DECEMBER 1, 2017" types in.
- The review is aged paper:
  - "December 2017 begins.";
  - the Attention line (12 planning + 8 operating; 6 held hours evaporated);
  - LAST MONTH'S MOVEMENT: Funds $140,000 -> $12,400 (-$127,600), Staff 0 -> 2 (+2), Doom
    HIGH -> SEVERE (crossed up), with the band only and no number;
  - "Begin planning December 2017 [Enter]" as a dark ink button with an amber ring.
- No rivals section: the game prints one only when a rival is visible.
- Top bar: $12,400 LOW, research -6, reputation 34.
- The feed keeps the same four Wed 1 Nov lines, word for word, plus the Fast-Track line
  and "Month Review -- December 2017".
- The Attention card reads "November, closed": held 0 left, 1 hr used, 6 evaporated.
- Commit is inert: MONTH COMPLETE.

**6. Late game (Mon 2 Apr 2018; CATASTROPHIC 81.4%, art level 3).**
- The same home screen as state 1, in the same places; "APRIL 2, 2018" types in.
- Top bar: $12,300 LOW, research 4, reputation 21 LOW (the game warns at 30 or less).
- The P(Doom) header carries the game's own "Very close to game over" (band 5 and up).
- Doom is a layer, not a repaint, and the panels and controls do not move:
  - the room drops to brightness .40 and saturation .30;
  - the window sky turns red-violet;
  - the two lit CRTs glow violet;
  - smoke lies along the floor;
  - soot closes in from the edges.
- Purple appears only here, plus the doom meter's own band colours.

## What changed from hifi G, item by item (designer-brief-CEG.md "What to make")

1. **G's palette and meter for every instrument.**
   - P(Doom) keeps G's ring. It is now flat (16px stroke on a faint track, no glow), with
     a mono percentage, the band name in the lifted text tint, G's seven-band ladder
     without the glow, "band N of 7", and RISING as a hairline tag. The ring keeps the
     game's band colours.
   - Reputation gets a small semicircle gauge in the same style, in bone, with the one red
     mark at 0 (the real rule: reputation 0 ends the run).
   - Attention keeps G's flat pips in the dulled plan and op colours. The held pips are a
     neutral bone.
   - WATCH's playback bar is now 22 flat segments.
2. **Paper is the only light thing.**
   - Paper appears three times: the advisor note (1), the event (4) and the review (5).
     All three use H's aged paper: tan, darker at the bottom, burnt edges, grime and
     grain, worn corners, one fold set in a gap between lines, near-black ink.
   - Everything else is near-black and bone. No fills are bright:
     - the yellow Commit, the yellow "Begin planning", the teal "Add to plan", the teal
       selected row, the amber PLAN segment and the red LOW fills are all gone;
     - in their place: hairlines, a dark ink button, and an underline on the selected
       segment.
   - Amber is used only where something needs attention: the glowing Actions button and
     its arrow (1), the selected action and its Enter (2), Close plan (3), the selected
     event option (4), the review's Enter (5), Commit, and today's feed line.
3. **The typewriter dateline.**
   - It replaces G's month label in the top bar ("NOVEMBER 2017") and the banner's date
     ("Wed 1 Nov 2017"). It sits top left in the resource bar, 420px wide, so the
     resources never move between months.
   - H's code, unchanged:
     - Courier Prime bold 28px, wide tracking, a worn-ribbon pattern;
     - types in only on a month's entry (states 1, 5, 6); states 2, 3 and 4 show it set;
     - `?still=1` and `prefers-reduced-motion` show it whole.
   - The sound block is H's SOUND_START..SOUND_END, copied whole. The page has H's dashed
     "Mock-up: type the date with sound" button, fixed bottom centre and hidden in the
     renders. It calls `playDateline(text)` from the click and replays the type-on on the
     strike times.
   - Checked in headless Chromium: state 1 starts typing, state 3 is set, and the button
     is present (absent with `?still=1`). Nobody heard the sound; it is H's code, and Alex
     is the judge.
4. **Commit is quiet and small, with held-for-events beside it.**
   - Commit was 416x48, yellow, with a glow. It is now 296x48 at (1600,1024): dark, with
     an amber hairline and amber condensed caps.
   - A "HELD FOR EVENTS N hr" plate sits beside it in the bottom bar (1276-1584) in the
     PLAN states (20 / 17 / 7 / 20 hr).
   - In WATCH the Attention card directly above Commit is the hold, so the plate is not
     repeated. Commit reads MONTH IN PLAY or MONTH COMPLETE, dashed.
   - State 3's Attention card dropped its "Held for events at Commit" line, which the
     plate now carries.
5. **Nothing glossy or cartoony.**
   - Flat 2px panels (H's) with a hairline frame, worn brass corner ticks, an inner soot
     shadow, smut and grain, and a faint painted-metal scuff.
   - Film grain over the room.
   - Pip's icons sit on near-black square plates, toned
     (`saturate(.42) sepia(.22) brightness(.95)`). Disabled ones drop to 45% (icons, not
     text).
6. **Room to darken by band.**
   - The room uses H's ladder: brightness .62 / .55 / .46 / .40 and saturation
     .55 / .45 / .35 / .30 for art levels 0-3. Each level adds one ambient grade and one
     glow on G's two lit CRTs (amber, orange, red, violet).
   - Level 3 adds the window sky, the violet CRTs, floor smoke and soot as layers.
   - State 6 is clearly darker than state 1. TERMINAL (band 4, not shown) keeps headroom
     below it.
7. **Text at least 4.5:1, measured on composited pixels** at both sizes (table below).
8. **Off-character leftovers removed** (list below).
9. **People.**
   - Pip's Staff icon (rail) and the Hire icon (Hire Staff row) stay.
   - The Safety Researcher role icon (a shield) is on the Hire play and STAFF AT WORK.
   - No person or silhouette anywhere. The records-room print has an empty chair.
10. **Same run-state and agreed rules.**
    - Numbers as in hifi G after REVISIONS 2 and 3.
    - Filled = hours left.
    - Only the topmost layer shows Enter/Esc (per state above).
    - Every play has its own row and edit target.
    - Text is at least 16px at 1920. Sizes in use: 16, 18, 22, 28, 40.
    - No doom deltas, no NEW chips, Standard Hiring $25,000 + 1 held hr.
    - The feed's shared queue-order list is kept from the council round.

## Removed (mock-up inventions from hifi G's earlier look)

- The amber scanline texture on the `## PLAN` / `## WATCH` banner (a CRT look). The
  banner itself and the view switch are Pip's and stay.
- The month label in the top bar and the date in the banner (now the dateline).
- The event slip's own date line, "Tue 14 Nov 2017". The dateline already says it.
- The yellow glossy Commit and its glow; the yellow "Begin planning" button; the teal "Add
  to plan" button and the teal selected row.
- The glow on the current band in the doom ladder.
- The aubergine gradient fill and rounded corners on the rail buttons. A dark aubergine
  left edge is kept as a trace of Pip's rail colour (see Open questions).
- The red tint on the queue's x buttons, and the filled red and amber LOW / BELOW ZERO
  tags (now hairline tags).
- The amber triangle pointer on the advisor (now H's thin arrow); the amber "NEEDS A REPLY"
  tag over the picture (now an ink stamp on the paper).
- Kept on purpose (the game's own, or rules): `## PLAN` / `## WATCH`, the view switch and
  V, Feedback [N], "band N of 7", "Very close to game over", Research Quality, the rail
  labels and counts, "ACROSS YOUR DESK" (the desk scene H uses for events).

## Art that would need darker versions to match

These still read bright or toy-like after toning, at 1920:
- The round resource set: money.png, compute.png, research.png, paper.png,
  reputation.png, doom.png (top bar, P(Doom) header, Publish Safety Paper).
- resource_money_64 (Fundraising, a gold coin) and action_funding_loan_64 (Financing, a
  money bag).
- action_research_monitoring_64 (Scouting, a green radar) and ui_guide_strategy_64
  (Strategic).
- indicator_doom_rising_64: a red arrow, small but saturated.
- G's six placeholder icons, which still need real art: new_post_online, new_meetups,
  new_supplies, new_advertise, new_travel, new_publicity.
- The office per art level. The doom layer is faked in CSS over the one office_wide_day
  painting; the game needs a window-sky layer, a monitor-glow layer and floor smoke per
  level.
- The records-room print (event_secret_v3 crop) works as a dim sepia photo. Pip's event
  art is unused by the game today.

## Contrast (composited pixels, both sizes)

Method (`contrast.py`, H's method, with one change):
- `?check=1` lists every visible text element's own text extent (a DOM Range, not the
  element's box), so a short label in a wide grid cell is not measured mostly against
  background.
- The script reads each extent from the rendered PNG at 1920x1080, and at 1280x720 scaled
  by 2/3.
- Background is the median luminance of the box. Text is the stroke core: the k-th pixel
  farthest from the background, k = max(4, 0.5% of the box).
- No CSS colour is used, so the doom layer, grain, paper grime and antialiasing all count.

| State | Text boxes | Lowest at 1920 | Lowest at 1280x720 | Under 4.5:1 |
|---|---|---|---|---|
| 1 | 63 | 5.34 ("band 2 of 7") | 5.33 ("band 2 of 7") | 0 |
| 2 | 137 | 5.29 ("2-3") | 5.29 ("2-3") | 0 |
| 3 | 178 | 5.08 ("HOURS") | 5.08 ("HOURS") | 0 |
| 4 | 92 | 5.40 ("band 3 of 7") | 4.87 ("Enter" on the event) | 0 |
| 5 | 87 | 4.78 ("56.7%") | 4.78 ("56.7%") | 0 |
| 6 | 64 | 5.25 ("Very close to game over") | 5.24 (same) | 0 |

What the measure forced:
- Plan row numbers and the "where it lives" line moved from dim to muted (both were 4.3
  at 720).
- The Month Review's movement rows went to bold type. "0 -> 2" in regular Courier was
  2.6.
- The event's option numbers became mono 600 on a darker tile (the condensed bold was
  3.6 at 720).
- The folds on the review and the advisor note were moved off the text (the review's
  fold had crossed the Staff row).

## Bugs and data gaps

Unchanged from hifi G (fork/design/hifi/G/notes.md); nothing new found in this pass:
- Office Maintenance charges $5,000 and does nothing, and the Operations submenu still
  offers it.
- tour_offices and the scout_* plays are unmapped in icon_mapping.json.
- Work Your Connections and Advertise a Role have empty `costs` in core.json.
- The Attention spill: today's UI pre-check refuses what the core and the ADR allow.
- Reserve: main_ui.gd disables it at 0 operating hours, but the ADR's hold is untyped. G
  draws the ADR.
- Research below zero has no warning in today's game.
- Safety Audit's and Strategic's unlock gates count workdays.

## Open questions (real decisions only)

- **Typewriter sound in the game** (shared with H): if nobody decides, it plays on the UI
  sound bus and is muted with UI sounds.
- **The rail's colour:** G keeps a dark aubergine edge as a trace of Pip's purple rail
  buttons; if nobody decides, the trace stays and the buttons are otherwise the dark
  plates.
- **Event pictures:** the game shows none today; if nobody decides, events ship as text
  on paper and the records-room print stays a mock-up idea.

## Visual pass

- Every state was looked at by eye at 1920 and at 1280x720.
- The layout check is CLEAN in all six states. It covers:
  - text under 16px;
  - overflow and content wider than its box;
  - one-line labels that wrap;
  - anything outside its panel or off stage;
  - panels that overlap;
  - a plan list that scrolls;
  - broken images.

Fixed along the way:
- Key caps took the buttons' upper case ("ENTER", "ESC"): reset to the key's own case.
- The fold on the review crossed the Staff row, and the advisor note had a fold through
  its text. Both moved.
- The P(Doom) percentage used a 34px size outside the scale. It is now 40px with tighter
  tracking, and it fits the ring.
- State 1 first hid Commit's Enter behind the advisor note. The note is not modal, so
  Enter is back (as in hifi G).
- The violet CRT glow in state 6 read as a decorative light at full strength, so it was
  toned down (.85 to .6).

Not judged from stills: the type-on, the sound, hover and motion.

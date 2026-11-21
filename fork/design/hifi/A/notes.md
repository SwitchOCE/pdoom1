# A. The Desk -- high-fidelity pass

Built from fork/design/research/concepts/A (rounds 1-3) and the run in
fork/design/hifi/run-state.md, including its REVISION 2 (2026-11-22: row 10
is a second Go to Meetups, and the fixed results applied at Commit). `concept.html?state=1..6` draws each state on a
1920x1080 stage that scales uniformly to the window, so 1280x720 is the same
layout at 2/3 size. `&check=1` prints a layout self-check (overflow, text
outside its box, elements off the stage, overlaps within one object, every
font size in use).

The fiction is unchanged: home is Pip's empty office seen from the desk, with
a wall calendar, the P(Doom) dial, the reputation meter, the desk terminal
(Attention and the plan at a glance), the shortcut rack and Commit. Every
detail lives in a menu opened from the rack, and Commit never moves. New in
this pass: a photo of the office cat on the desk (Pip's cat art), which
carries the doom layer with the window sky and the far monitor's glow.

## The states

**State 1 -- first month, first screen (Tue 4 Jul 2017).** The cold open has
just ended. The office is quiet: JULY on the calendar, the dial at 20.0%
ELEVATED, reputation 50, the terminal reading "JULY PLAN -- nothing queued"
with all 12 planning and 8 operating hours lit, and "Plan is empty [A]".
Commit shows its Enter and "Held for events 20 hr". The one tutorial element
is the advisor's card, carrying the cold open's own hand-off line
(cold_open_sequence.gd HANDOFF_HINT_TEXT): "You do not know anything yet. Go
and find out -- scouting (the glowing button)." In this concept Scouting is a
folder inside the hand, so the glowing button is the ACTIONS plate (a glow
ring, not the lit "open" style), and the card's foot says "ACTIONS >
Scouting [A]". Nothing else is added to home.

**State 2 -- choosing an action (Wed 1 Nov 2017).** Three plays are queued
(Hire: Safety Researcher, Read the Literature x2). The player pressed A: the
hand rises from the desk over the dimmed office; only the ACTIONS plate's
menu owns the keys (A / Esc in its header). The header carries the menu's own
state: money $140,000, compute 65, research -12 [!] in red, papers 0,
planning 9/12 left, operating 8/8 left. All 17 top-level actions are slips
(add) or folders (open), with Pip's icons. Research blocks are stamped with
the shortfall: Safety Research and Capability Research SHORT 22 RESEARCH,
Publish Safety Paper SHORT 32 RESEARCH, and the Travel folder SUBMIT PAPER:
SHORT 27. Nothing is marked NEW: Safety Audit's and Strategic's unlock gates
count workdays (and Strategic needs reputation 30), so nothing shows a
November unlock (run-state REVISION 3). Hire Staff shows "1 in plan", Scouting "2 in plan". Safety Audit is focused
(lit), and the empty 18th place in the grid holds its detail card: 2 op hr .
$40,000, "Comprehensive safety review", "add to plan [Enter]". That place is
the same for whichever slip has focus.

**State 3 -- the month's plan (Wed 1 Nov 2017).** The player has pressed P
(or the PLAN plate): the desk terminal fills the left of the view and the
office behind it dims; the dial, meter, rack and Commit stay where they
always are, with only the PLAN plate lit. Top to bottom:
- Attention, filled = hours left. Planning 7 of 12 left: seven lit squares,
  one hatched teal square (the hour operating work took), four spent.
  Operating 0 of 8 left. Beside each bar, what spent it: "4 hr planning work
  + 1 hr operating (spill)" and "8 hr operating work". The explicit reserve
  sits at 0 hr with its - / + controls.
- One terminal line states the rule as the system applies it: "[SPILL] 1 hr
  of operating work is drawn from planning. Planning work never draws on
  operating hours."
- The queue: 11 plays, one row each, with where it lives, its pool, hours,
  cost and its own ^ / v / x targets (^ is inert on row 1, v on row 11).
  Go to Meetups appears twice (rows 7 and 10), each row with its own targets.
  Order Office Supplies carries SPILL 1: it is the operating play that ran
  past the 8 operating hours.
- Undo [Z], Clear [C], queued cost $102,600 + 6 rep.
- "After costs" (costs only, not results): money $140,000 -> $37,400,
  reputation 32 -> 26, held for events 7 hr untyped. Commit's housing repeats "Held for events 7 hr".
- The bezel: Research Quality (Standard) and the only Esc on screen,
  "P / Esc back to desk". Commit hides its Enter while the terminal owns
  the keys.
It follows from state 2: the Safety Audit being added is row 5, and the six
operating plays after it fill the month.

**State 4 -- WATCH, an event asks for a choice (Tue 14 Nov 2017).** The month
was committed on 1 Nov; every play ran at Commit. Commit's housing has become
the month's clock: TUE 14 NOV, workday 10 of 22, PAUSED FOR YOU, speed
Pause / 1x / 2x / 4x, held for events 7 hr. The rack keeps Feed, Staff,
Ledger and Guide live and dims Actions, Plan and Upgrades. The desk terminal
plays the month back: a 22-day bar with the playback position at day 10,
the feed so far (01 "11 plays run at Commit", 01 "Safety Researcher hired",
01 "Networking (+3 reputation)", 14 "Talent Opportunity [!]"),
who is at work (1 safety researcher), and "Feed and results [F]". No play
has its own progress bar: the game runs them all at Commit. Across the desk
lies the event slip, Talent Opportunity, in the data's own words with its
three options, each with its effect and cost: Fast-Track Hiring "+1 safety
researcher", $25,000 + 1 held hr (focused, Enter); Standard Hiring "+1
safety researcher", $25,000 + 1 held hr; Decline Offer "no change", free.
Standard Hiring's held hour is the window's Attention price, which
event_dialog.gd folds into any handled option without its own (run-state
REVISION 3). Its foot shows in hand
$37,400 and held for events 7 hr. Reputation reads 34: 32 - 6 (Work Your
Connections) - 1 (Post Online) + 1.5 + 1.5 (two Meetups) + 3 (Networking)
+ 3 (Safety Audit), the fixed results actions.gd applies at Commit. Research
is -6 (-12 + 3 + 3) but this concept shows research only in the hand. The
dial holds 40.2% HIGH.

**State 5 -- end of month (Fri 1 Dec 2017).** The player picked Fast-Track.
The calendar has turned to DECEMBER, the dial reads 56.7% SEVERE, the meter
34, the office has slipped to art band 2. Over the dimmed desk lies the month
review as a teleprinter sheet (Commit hides its Enter; the sheet owns it).
It uses the game's own review content (game_manager.gd
_finish_month_playback): "Month Review -- December 2017", "December 2017
begins.", the Attention line, "Last month's movement" (Funds $140,000 ->
$12,400 (-$127,600); Staff 0 -> 2 (+2); Doom HIGH -> SEVERE (crossed up) --
a band move, no number), the closing line, and "Begin planning December
2017 [Enter]". The rivals section is left out: the game prints it only when
a rival is visible, and the source run shows none. To its left, "November
2017 -- what happened", in two dated blocks: "1 Nov -- at Commit" (the 11
plays, numbered 01-11 in queue order) and "14 Nov" (Talent Opportunity and
the held hours). Each line uses the game's own
result messages (actions.gd, hiring_pipeline.gd, core_events.json; Tour
Offices uses the data's description because its message lists random
quotes), and the hours:
"7 hr held: 1 went to Talent Opportunity, 6 evaporated."

**State 6 -- late game, CATASTROPHIC (Mon 2 Apr 2018).** The same home as
state 1, in the same places: APRIL 2018, dial 81.4% CATASTROPHIC, reputation
21, terminal "APRIL PLAN -- nothing queued", 12/12 and 8/8 hours, Commit with
Enter and 20 hr held. Only the doom layer has changed (art band 3,
Eldritch): a deep red ambient grade over the room, one violet glow source
(the far monitor), a red-violet sky in the back windows, a violet aura and
faint smoke around the cat's photo. The cat itself is not repainted. No
control moves, no colour changes on the UI hardware.

## Fixtures

Values not from run-state.md's sourced lines or the data:
- State 3 queue order is run-state's table order. The game books hours in the
  order plays are queued (month_plan.gd `_debit_hours`), so the spill lands
  on the last operating play. Another order moves the SPILL tag, not the
  totals.
- State 3 "After costs" money and reputation are arithmetic on run-state's
  numbers (costs only); the game has no such preview today.
- State 2 and 3 Commit note ("Held for events 17 hr" in state 2, 7 hr in
  state 3): the unspent hours of the plan so far, as at Commit.
- State 4 feed lines: "Networking (+3 reputation)" is the game's message;
  "11 plays run at Commit", "Safety Researcher hired" and "at work: 1 safety
  researcher" are mine; the game's feed format is not copied.
- State 4 and 5: reputation 34 and research -6 are run-state REVISION 2's
  sums of the fixed results. Which Meetups play found a candidate ("Someone
  unvetted ..." on row 7, "No leads you have room for." on row 10) depends
  on the candidate pool (run-state fixture).
- State 4: P(Doom) held at 40.2% until the month review (run-state fixture);
  the dial shows the band and the word "rising" from November, no delta.
- State 5: Funds -$127,600 (plays $102,600 + Fast-Track $25,000) has no
  payroll line, and research the new staff produce is not modelled
  (run-state fixtures).
- State 5 is drawn at art band 2 (Spooky) for SEVERE, the designers' reading
  in run-state REVISION 2 (ELEVATED 0-1, HIGH 1, SEVERE and EXTREME 2,
  CATASTROPHIC 3, TERMINAL 4). An open question for Pip.
- State 6: every number is run-state's projection. Research 4 (Safety
  Research short 6) and money $12,300 are not on home in this concept; they
  appear in the hand's header and stamps (as drawn in state 2).
- The doom layer's colours and amounts follow the palette doc's STUB ladder
  (band 0 amber rim, 1 orange low, 2 red-orange + stormy blue sky, 3 violet
  aura + smoke, red-violet sky, dark dread). They are first-pass values.
- Reputation meter: the short red mark at 0 marks where the run ends
  (reputation <= 0, game_state.gd:617). Its width is drawn, not a threshold.
- Research Quality on Standard: the game's default.
- **Attention spill (ADR-0011 amendment 2026-07-28) over today's UI.** The
  mock-up lets operating work spill into planning hours. Today's UI
  pre-checks (main_ui.gd ~1737, submenu_controller.gd ~143) compare a play's
  hours with its own pool only, so they refuse the 9th operating hour; the
  core (month_plan.gd `can_spend_hours`, `_debit_hours`) already allows and
  books the spill. The mock-up follows the ADR and the core.
- What the spill rule forbids (a planning play with only operating hours
  left) does not arise in this run: planning hours never run out. In this
  concept such a slip would carry the stamp "NO PLANNING HRS LEFT", as the
  round-2 hand did.

## New copy (not in the game today)

- State 1 card foot: "ACTIONS > Scouting" (the route to the glowing button in
  this concept). Card heading "ADVISOR". The body is the game's text.
- State 2: stamp "SUBMIT PAPER: SHORT 27", detail card heading
  "FOCUSED", "add to plan".
- State 4: "ACROSS YOUR DESK", "PAUSED FOR YOU", "THE MONTH", "held for
  events 7 hr" on the slip.
- State 5: "FROM THE TELEPRINTER", "November 2017 -- what happened", the
  held-hours line.

## People

- The office art (`office_wide_dawn.webp`) is empty in every state. No
  operator, no silhouette.
- STAFF plate (rack, states 1-6): Pip's `ui_staff_management`, three
  silhouettes at a table. Kept, per the brief.
- Hire Staff folder (state 2): Pip's `button_hire_normal`, head and
  shoulders with a +. Kept, per the brief.
- No event picture: the event slip (state 4) is text only. Pip's event
  images (`event_opportunity_v2/v4`) show people, so they are not used.
- The cat's photo is a cat (Pip's `cats/simple/web-doom-cat.jpg`, cropped).

## Icons

Pip's icons, always beside a label, never instead of one; one size per kind
of place (rack 32px, slips 36px, menu title 30px, plates 24px, header
readouts 22px). Copied from godot/assets/icons/.
- Rack: ACTIONS `ui_guide_actions` (hand pointing); PLAN `ui_config_date`
  (calendar); STAFF `ui_staff_management`; UPGRADES `button_upgrade_normal`;
  LEDGER `ui_budget_finance`; IN-TRAY `new_inbox_tray` (new); GUIDE
  `ui_guide_book`; FEED (WATCH) `new_feed_tape` (new).
- Plates: P(DOOM) `doom.png`; REPUTATION `reputation.png`.
- Hand header (state 2): MONEY `money.png`, COMPUTE `compute.png`, RESEARCH
  `research.png`, PAPERS `paper.png`; title THE HAND `ui_guide_actions`.
- Slips and folders (state 2): Fundraising `ui_guide_resources` (money bag);
  Financing `action_funding_loan`; Hire Staff `button_hire_normal`;
  Advertise a Role `new_advertise_notice` (new); Work Your Connections
  `action_publicity_network` (handshake); Onboard New Hires
  `employee_status_training` (cap); Safety Research `resource_safety_small`
  (shield); Capability Research `action_research_ml_fundamentals`
  (network); Publish Safety Paper `paper.png`; Safety Audit
  `employee_role_auditor` (magnifier on a checklist); Travel & Conferences
  `new_travel_suitcase` (new); Scouting `employee_status_investigating`
  (eye); Publicity `new_publicity_megaphone` (new); Purchase Compute
  `compute.png`; Operations `ui_system_settings` (gear); Office
  `ui_infrastructure_facilities` (building); Strategic `ui_guide_strategy`
  (knight).
- The CRT screens (states 3 and the desk terminal) carry no painted icons:
  pools are amber "planning" / teal "operating", spill is a hatched tag.

New, needs art (SVG stand-ins in the same teal-glyph style, from round 3):
`new_inbox_tray` (In-tray), `new_feed_tape` (Feed), `new_advertise_notice`
(Advertise a Role), `new_travel_suitcase` (Travel & Conferences),
`new_publicity_megaphone` (Publicity).

Other new art needed: per-band doom layers for the office (window sky plate,
monitor glow, ambient grade) are drawn here as CSS gradients over
`office_wide_dawn.webp`; the real version needs Pip's sky and glow plates.
The cat's photo needs a doom aura asset (the palette doc's "glow, smoke,
collar") rather than a CSS glow.

## Bugs and data gaps

- Work Your Connections: `costs: {}` and no `hour_type` in core.json. Its 2
  hours and 6 reputation come from hiring_pipeline.gd `use_connections`, and
  it bills OPERATING because `spend_attention` defaults to operating.
- UI pre-check vs core on the spill (see Fixtures).
- Talent Opportunity, Standard Hiring: core_events.json gives only
  `costs: {money: 25000}`, but the game charges the window's 1 Attention too
  (event_dialog.gd folds it into handled options without their own). So the
  data reads cheaper than the game is. Drawn as the game shows it.
- Run-state's first version said Safety Audit and Strategic unlock in
  November; their gates count workdays (turn_min 5 / 10), not months.
- Advertise a Role: no costs in core.json, but Balance `hiring.advertise`
  has cost_money 8000 and cost_attention 3; today's game shows it as SOON.
  Drawn as COMING SOON.
- Doom-variant cat art (`cats/default/*.svg`) is orphaned placeholder art;
  `office_cat.gd update_doom_level()` is a no-op (cats/README.md). Pip's
  event images are packed but unused (images/events/README.md).
- Office Maintenance cannot be queued in today's game (hidden from the
  action bar since v0.13.1, action_bar_renderer.gd
  HIDDEN_FROM_ACTION_BAR_IDS, because it charged $5,000 and did nothing).
  Run-state's first version queued it; REVISION 2 replaced it, and so did
  this mock-up. The Operations folder still says "3 choices" in state 2 (the
  data's count); the game may show 2.
- Today's month 1 HUD says "Turn 1" (workdays, not months); drawn as the
  month on the calendar.

## Open questions (for Alex or Pip)

- Should PLAN show an "after Commit" preview (money and reputation once the
  queue runs)? It is a view of existing numbers, but the game does not show
  it today.
- Where does the office cat live in this concept? Drawn as a photo on the
  desk because the doom layer needs a cat to glow around; the game shows a
  random contributor's cat photo today.
- Money and research are not on home (they live in the hand's header since
  round 2). In the late game (state 6) a player may want money at a glance.
- The tutorial card names the route "ACTIONS > Scouting" because Scouting is
  a folder in the hand, not a home button. Alternatively the game's glowing
  button could be the Scouting folder itself, one step later.
- Which art band SEVERE maps to (drawn as band 2, run-state's reading).

## Visual pass

All six states at 1920x1080 and 1280x720, looked at by eye, plus the page's
self-check on each.
- Self-check: no overflow, no text outside its box, nothing off the stage, no
  overlaps within one object, in all six states. Font sizes in use: 16, 18,
  22, 28 and 40 px only; nothing under 16px. Overlaps between layers (a menu
  or sheet laid over the desk) are deliberate and were checked by eye: each
  covers what it lies on whole, or the dim covers it.
- Fixed during the pass:
  - State 2: the rack's plates painted through the hand (stacking); each
    housing now isolates its own layers. The hand's header ran 12px past
    the menu edge; tightened the gaps and the hour pips.
  - State 2: research cost lines wrapped mid-phrase; Safety Audit's cost ran
    under its icon; the detail card overflowed. Each now breaks on a line of
    its own.
  - State 5: the first review sheet overflowed its paper and partly covered
    the rack and the terminal; rebuilt as one sheet over the whole desk
    area left of the rack, results on the left, movement, rivals and the
    button on the right. "Hire: Safety Researcher" no longer wraps.
  - State 6: the first doom layer read as merely dim; deepened the red
    grade, added the vignette and the smoke.
  - State 3 (pass 1): the money cell wrapped; the dial's rim was clipped;
    "9 operating work" double-counted the spilled hour.
  - State 1: the advisor's line broke on "Go"; set the breaks.
  - Revision 2: the longer result messages overflowed the review sheet;
    dropped the rivals slot, narrowed the right column, kept "Begin planning
    December 2017" on one line. "After costs" wrapped in its cell; widened.
- Numbers checked across states: money $140,000 -> $37,400 (states 3, 4)
  -> $12,400 (state 5); reputation 32 (2, 3; after costs 26) -> 34 (4, 5)
  -> 21 (6, projected); held
  hours 17 (state 2), 7 (3, 4), 7 = 1 + 6 (5), 20 (1, 5 Commit, 6); P(Doom)
  20.0 / 40.2 / 40.2 / 40.2 / 56.7 / 81.4.
- Icons: each sits beside its label, same size and position within its
  group; the dimmed WATCH plates keep their icons.
- Not judged (stills): motion, hover, feel, the glow's flicker.

## Council round 1 fixes

From fork/design/hifi/council/r1-agreed.md ("All four" and "A. The Desk"
items only).
- All four, 1 (state 4): Standard Hiring now shows $25,000 + 1 held hr, as
  the game charges it (run-state REVISION 3). Fast-Track stays the choice;
  state 5 is unchanged. The "Standard Hiring" open question and bug entry
  are rewritten to match.
- A1 (state 2): removed the NEW clips from Safety Audit and Strategic.
- A2 (state 4): each option shows its effect under its name: "+1 safety
  researcher" on both hiring options, "no change" on Decline Offer. The
  option rows grew from 52 to 62px; the slip still clears the dial.
- A3 (state 5): the results list is split into dated blocks, "1 NOV -- AT
  COMMIT" over the 11 numbered plays and "14 NOV" over Talent Opportunity
  (no number) and the held hours. To fit the two headings, the sheet moved
  up 10px (still clear of the calendar), rows lost 1px of padding each,
  and the "held hours" line sits in the 14 Nov block rather than a third
  block.
- Re-rendered states 2, 4 and 5 at 1920x1080 and 1280x720 plus their WebPs.
  Layout self-check on all three: no overflow, no text outside its box,
  nothing off the stage, no overlaps; font sizes 16, 18, 22, 28, 40 px only.

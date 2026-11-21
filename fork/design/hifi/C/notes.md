# C. The Paperwork Desk -- high-fidelity run

Status: all six states drawn (pass 2).

The concept is the one the council agreed in Rounds 2 and 3. Home is Pip's
empty office, with a few desk objects along the bottom and four wall
instruments along the top:
- Desk objects: card box (A), schedule clipboard (P), the office cat's
  framed photo, Staff file (S), Upgrades (U), Ledger (L), Guide (G), and the
  Commit stamp, always bottom-right.
- Wall instruments: calendar, accounts slip, P(Doom) counter, reputation
  dial.

Each desk object opens one menu. A menu covers the desk band from x 48 to
1560 and now ends at y 1056, inside the stage, with desk wood visible below
it. No desk object shows as a sliver under a menu.

Files:
- `concept.html`: `?state=1`..`6`; `&check=1` adds a layout self-check.
- `render.sh`: renders states at 1920x1080 and 1280x720 and prints the check.
- `assets/`, and `s1.webp`..`s6.webp` (committed).
- `s1.png`..`s6.png` and `s*-720.png` (not committed).

## States

**State 1 -- first month, first screen (Tue 4 Jul 2017).** This is home:
Pip's dawn office, almost empty.
- **Wall:** JUL calendar ("Plan, month 1"); slip $245,000 / 100 / 0 / 0;
  P(Doom) 20.0% with the band ELEVATED; reputation 50.
- **Desk:** the card box ("15 on file"; Safety Audit and Strategic are not
  open yet); the schedule clipboard with all boxes filled (12 of 12
  planning, 8 of 8 operating, "Form blank"); the framed Doom Cat; Staff
  file "No staff hired"; Upgrades "7 on offer"; Ledger "Clean"; Guide
  "Player Guide"; the Commit stamp ("Held for events: 20 hr", Enter).
- **Tutorial:** the first step is the cold open's own hand-off line
  (cold_open_sequence.gd HANDOFF_HINT_TEXT), shown as an Advisor note: "You
  do not know anything yet. Go and find out -- scouting (the glowing
  button)." In this concept Scouting is a folder in the card box, so the
  card box glows amber and an amber pen arrow runs from the note to it. The
  note closes with "Got it [Esc]". No other hint is on screen, and it goes
  once the player has opened the card box.

**State 2 -- choosing an action (Wed 1 Nov 2017).** The player has opened
the card box. Three plays are already on the form.
- **Header:** Planning 9 of 12 left, Operating 8 of 8 left, Money $140,000,
  Research -12, Close [Esc].
- **17 cards in five tabbed rows:**
  - Funds: Fundraising, Financing, Purchase Compute
  - People: Hire Staff, Advertise a Role, Work Your Connections, Onboard
    New Hires
  - Research: Safety Research, Capability Research, Publish Safety Paper,
    Safety Audit
  - Outreach: Scouting, Travel & Conferences, Publicity
  - The lab: Operations, Office, Strategic
- **Card types:** doors are manila folders ("N choices >"); single plays are
  ruled index cards showing hours and cost.
- **Blocked by research:** red stamps give the shortfall: Safety Research
  and Capability Research "Short 22 research", Publish Safety Paper "Short
  32 research", Travel's Submit Paper "short 27 research".
- **Other stamps:** Advertise a Role is grey-stamped "Soon" (the game shows
  SOON on it). Onboard New Hires is grey-stamped "Nobody hired yet".
- **On the form:** Hire Staff carries "on form: 1" and Scouting "on form: 2".
- **Focus:** Safety Audit is the focused card (amber ring). It shows "2 op
  hr, $40,000", the game's description "Comprehensive safety review", and
  "Add to form [Enter]". The focused card owns Enter and the drawer owns
  Esc (council rule 2).

**State 3 -- the month's plan (Wed 1 Nov 2017, month 5).** The player has
lifted the schedule clipboard off the desk: Form A-20, "Schedule of the
month", for November 2017.
- **The list:** the eleven plays of run-state.md in queue order. Each has
  its own icon, its source door, its hours in the pool it bills (plan hr in
  amber-brown, op hr in teal), its cost, and its own up/down and remove
  controls (council rule 4). Totals: 4 plan hr + 9 op hr, $102,600 + 6 rep.
  Row 10 is a second Go to Meetups (run-state REVISION 2: Office Maintenance
  is off the board since v0.13.1), so rows 7 and 10 are a repeated play,
  each with its own controls.
- **Hours:** planning 7 of 12 left (seven filled boxes; council rule 1),
  operating 0 of 8 left.
- **The spill:** the ninth operating hour is drawn from planning.
  - The twelfth planning box is struck through in operating teal.
  - A dashed teal line runs up into it, labelled "1 hr spills up".
  - The hours list says "of which from planning hours ... 1 hr".
  - Row 11 is tinted and tagged "from planning".
  - The printed rule (Para. 2) states the asymmetry.
- **Below that:** set aside for events 0 (stepper); "Held for events at
  Commit ... 7 hr"; "After costs" money $140,000 -> $37,400 and
  reputation 32 -> 26 (costs only, as REVISION 2 asks); research quality
  on Standard.
- **Behind it:** the Commit stamp sits dimmed with no Enter.
- **Pass 2 fix:** the clipboard now ends inside the stage (y 1056). The
  last printed line sits 22px above the paper's edge, the board edge shows,
  and desk wood shows below it.

**State 4 -- WATCH: an event that asks for a choice (Tue 14 Nov 2017).**
Commit ran on Wed 1 Nov, and the month is playing back. The office stays in
view under a light dim.
- **Wall:** the calendar flipped to "NOV 2017 / 14 / Tue, workday 10"; slip
  $37,400 and research -6; P(Doom) 40.2% HIGH (held at the month-start
  reading); reputation 34 (the plays' fixed results, applied at Commit).
- **Progress behind the event:**
  - The desk clipboard now reads "Committed Wed 1 Nov / 11 plays", with a
    22-box workday strip: 9 days done, day 10 in red, "Workday 10 of 22",
    and "Held for events: 7 hr".
  - The Staff file says "1 on payroll" (the new Safety Researcher).
  - The teleprinter on the right lists the month feed so far: the commit,
    the hire, then each play's own result message from actions.gd
    ("Read for a day (+3.0 research). Nobody noticed." x2, "Posted ...",
    "Safety audit (+scrutiny, +3 reputation)", both "Worked the room ..."
    variants, "Networking (+3 reputation)", "Three landlords will quote you
    terms", "Office supplies restocked (+50 stationery, now at 100)"), Work
    Your Connections "done", "Held for events: 7 hr", and in red "14 Nov MEMO:
    Talent Opportunity".
  - There are no per-play progress bars (the game has none).
- **The event:** a memo clipped to the middle of the room: "Talent
  Opportunity / A brilliant researcher wants to join your lab at reduced
  cost!", with a paper-clipped CV (no face).
- **The choices,** each with its key, the data's effect and its cost:
  - [1] Fast-Track Hiring: +1 safety researcher; $25,000 + 1 held hr. This
    one is ticked in red pen.
  - [2] Standard Hiring: +1 safety researcher; $25,000.
  - [3] Decline Offer: no change; free.
- **Footer:** "In hand: $37,400, 7 held hr" and "File answer [Enter]". The
  memo has no Esc: an unanswered event swallows Esc on purpose (#452).
- **Desk:** the card box is locked ("Closed this month"). The stamp has
  turned grey: "Paused, for your answer", with 1x / 2x / 4x (the game's
  speeds). Background key caps are hidden while the memo waits.

**State 5 -- end of month, before the next PLAN (Fri 1 Dec 2017).** The
month review prints as a perforated ledger sheet over the dimmed desk. It
follows the game's Month Review (game_manager.gd _finish_month_playback).
- **Wall:** the calendar reads "DEC / Month review"; slip $12,400 and
  research -6; P(Doom) 56.7% SEVERE (the counter turns red, and the room
  wash moves to art band 2); reputation 34.
- **The sheet,** headed "Founder's office -- month review / NOVEMBER 2017 /
  December 2017 begins.":
  - **Last month's movement** (the game's rows): Funds $140,000 -> $12,400,
    -$127,600; Staff 0 -> 2, +2; Doom HIGH -> SEVERE, "crossed up". Band
    words only, no doom number for the move.
  - **Money:** opened $140,000; plays on the form -$102,600; Fast-Track
    Hiring -$25,000; closed $12,400.
  - **Founder's hours:** held for events 7, used on Talent Opportunity 1,
    lapsed at month end 6. Then the game's own line: "Attention: 20 fresh
    decisions this month (last month's unspent reserve evaporated -- no
    banking)."
  - **What happened in November:** one line per play with the game's own
    result message (the same words as the teleprinter), "done" for Work
    Your Connections, and the memo line with the game's message
    "Fast-tracked hiring process! (+1 safety researcher)".
  - **No rivals section.** The game prints it only when a rival is
    visible, and this run has no rival data (REVISION 2 allows leaving it
    out). Round 2's dashed slot is gone.
- **The stamp:** it takes the next step, as Commit did: a green "Begin
  planning December 2017 [Enter]" (the game's button label).

**State 6 -- late game, high P(Doom) (Mon 2 Apr 2018, month 10;
fixture).** Home again, laid out exactly as in state 1, with nothing
queued.
- **Wall:** APR 2018 "Plan, month 10"; slip $12,300 / 65 / 4 / 0; P(Doom)
  81.4% CATASTROPHIC; reputation 21.
- **Desk:** clipboard 12 of 12 and 8 of 8; Staff file "2 on payroll";
  Ledger "Clean"; card box "17 on file"; Commit "Held for events: 20 hr".
- **The doom layer** (art band 3, Eldritch; "a layer, not a repaint"):
  - one ambient grade: a dark multiply plus a light violet tint over the
    room and the desk wood;
  - one glow hue, violet;
  - the window sky turns red-purple;
  - both monitors glow violet;
  - the Doom Cat's frame gets a violet aura and faint smoke, with the cat
    itself unchanged.
- **The counter:** violet-magenta digits on a darker violet screen. Every
  control keeps its place, size and colour. Purple appears only in this
  state.

## Fixtures and places I followed the ADR over today's game

- **Attention spill (ADR-0011, amendment 2026-07-28).** Today's UI pre-check
  refuses an operating play once operating hours are gone (main_ui.gd ~1737,
  submenu_controller.gd ~143); the core already allows it. State 3 follows
  the ADR: 1 operating hour spills into planning, leaving planning 7,
  operating 0, held 7.
- **Which row spilled** (row 11) is my presentation choice. The game keeps
  the pools in aggregate.
- **Reserve 0:** run-state.md.
- **State 2, Held for events 17 hr on the dimmed stamp:** derived (9 + 8
  unspent if committed now), not from a screenshot.
- **State 2, "Nobody hired yet" on Onboard New Hires:** my wording for "no
  one to onboard". The data has no such string. Advertise a Role's "Soon"
  matches the SOON label in game-shots/main.png.
- **State 2:** no "new this month" marks on Safety Audit or Strategic. Their
  unlock gates count workdays (`turn_min` 5 and 10 in core.json), so I could
  not confirm which month each first opened (see bugs).
- **State 4:** P(Doom) held at 40.2% until the month review (run-state.md).
  The "RISING" word is shown only in states 2 and 3, where run-state.md
  states it.
- **State 4, Standard Hiring** shows no Attention cost, as in the data.
  Round 1 said every handled option costs 1 held hour. Open question.
- **State 4, "no change" under Decline Offer:** my words for `effects: {}`.
- **States 3-5 follow run-state REVISION 2:** queued cost $102,600 + 6
  rep; WATCH money $37,400, reputation 34, research -6; review funds
  $140,000 -> $12,400.
- **The second Go to Meetups' message** ("... No leads you have room for.")
  is a fixture: which variant shows depends on the candidate pool.
- **State 3 "After costs"** is a preview the game does not have today
  (fixture; open question 7).
- **State 5, payroll** for the two hires during November is not modelled,
  nor research the new staff produce during playback. Money closes at
  $12,400 = $140,000 - $102,600 - $25,000. The real figure may be lower.
- **State 5,** Work Your Connections shows "done": its message was not
  given. Today's
  closing line ("Queue this month's actions, then press COMMIT THE MONTH
  ...") is left out: it repeats every month, and the stamp already says
  what is next. It belongs to the tutorial.
- **State 5, rivals:** left out (no visible rival in this run). No names
  invented.
- **State 6:** every value is a run-state.md fixture. "7 on offer"
  (Upgrades) assumes none bought. "Doom Cat" is one of the game's eight
  live cat photos (office_cat.gd picks one at random each run), used in
  every state.
- **P(Doom) counter colours** come from ThemeManager's DOOM_STOPS ramp at
  each level:
  - 20.0% #7ECA4B
  - 40.2% #E79625
  - 56.7% #D74429
  - 81.4% #882271 (stroke colour). I lifted it to #B84AA0 for the digits,
    because #882271 on the dark screen falls under 3:1. Open question.
- **Room washes** follow docs/art/PALETTE_AND_DOOM_INTENSITY.md art bands:
  amber faint (band 0), orange low (1), red-orange (2), violet (3).
- **Ten-lamp strip removed.** The Round 3 counter had one; it is replaced
  by a lit band strip ("BAND HIGH"), because "CATASTROPHIC" would not fit
  beside the number, and the band label is what ADR-0015 asks to show.
- **Diegetic names, not game terms:** "Form A-20", "Para. 2", "Schedule of
  the month", "Teleprinter", "Memo", "Founder's office -- month review".

## People

- **No human figure** in any state's art, memo or cat photo. The office is
  empty.
- **State 4 memo:** a drawn CV sheet, no portrait. Round 3's
  dossier_people_pleaser portrait is gone. The unused event pictures in
  godot/assets/images/events (opportunity_v2/v4) show two figures, so I did
  not use them.
- **Pip's icons with figures, kept as the brief asks:**
  - `ui_staff_management` (three silhouettes at a table) on the Staff file,
    states 1-6;
  - `button_hire_normal` (head and shoulders) on the Hire Staff folder,
    state 2.
- **Hands:** `network_64` (Networking, state 3) and
  `action_publicity_network` (Work Your Connections, states 2 and 3) show
  two hands shaking.
- **Figures removed since Round 3:**
  - Hire: Safety Researcher in the form now uses the game's own shield
    icon `employee_role_safety_specialist`.
  - Go to Meetups uses a new name-badge icon instead of
    `action_management_team_building` (three figures).

## Icons

All are 64px PNGs copied from godot/assets/icons/ unless marked new.

| Where | Icon file | Button / readout |
|---|---|---|
| Accounts slip, chips | resource_money_64, resource_compute_small_64, resource_research_small_64, resource_papers_small_64 | Money, Compute, Research, Papers |
| Wall | resource_doom_small_64; resource_reputation_64 | P(Doom) counter; Reputation dial |
| Card box, drawer title | ui_guide_actions_64 | Action cards |
| Clipboard, form title | ui_config_date_64 | Schedule |
| Desk | ui_staff_management_64; button_upgrade_normal_64; ui_budget_finance_64; ui_control_help_64 | Staff file; Upgrades; Ledger; Guide |
| Stamp | button_confirm_normal_64; ui_control_pause_64; ui_control_forward_64 | Commit the month; Paused; Begin planning |
| Menus | ui_control_cancel_64 | Close |
| Form rows | ui_control_up_64 / ui_control_down_64; ui_control_remove_64 | Move play up / down; Remove play |
| Form tools | ui_control_back_64; ui_control_clear_64 | Undo; Clear form |
| Hours chips, form | resource_action_points_64 | Planning / Operating / Founder's hours |
| Form side column | resource_money_64; resource_research_small_64 | After Commit; Research quality |
| Card: Fundraising | ui_guide_resources_64 | |
| Card: Financing | action_funding_loan_64 | |
| Card: Purchase Compute | action_facility_upgrade_compute_64 | |
| Card: Hire Staff | button_hire_normal_64 (game's mapping) | |
| Card: Advertise a Role | new_advertise_notice.svg (new, Round 3) | |
| Card / row: Work Your Connections | action_publicity_network_64 (game's mapping) | |
| Card: Onboard New Hires | employee_status_training_64 (game's mapping) | |
| Card: Safety Research | action_research_alignment_64 (game's mapping) | |
| Card: Capability Research | action_research_capability_control_64 (game's mapping) | |
| Card: Publish Safety Paper | action_research_formal_verification_64 (game's mapping) | |
| Card / row: Safety Audit | employee_role_auditor_64 (game's mapping) | |
| Card: Scouting | action_research_monitoring_64 | |
| Card: Travel & Conferences | new_travel_suitcase.svg (new, Round 3) | |
| Card: Publicity | new_publicity_megaphone.svg (new, Round 3) | |
| Card: Operations | employee_role_engineer_64 | |
| Card: Office | action_facility_expand_office_64 (game's mapping) | |
| Card: Strategic | ui_guide_strategy_64 | |
| Row: Hire: Safety Researcher | employee_role_safety_specialist_64 (game's mapping) | |
| Row: Read the Literature | ui_guide_book_64 | |
| Row: Post Online | new_post_online_bubble.svg (new, Round 3) | |
| Row: Go to Meetups | new_meetup_badge.svg (new) | |
| Row: Networking | network_64 on a CSS dark tile (the file is unframed; game's mapping) | |
| Row: Tour Offices | ui_infrastructure_facilities_64 (a building) | |
| Row: Order Office Supplies | new_supplies_box.svg (new) | |

Choices made:
- **Where I chose differently from the game's mapping:**
  - Research cards now use the game's own mapping (Round 3 had
    resource_safety_small and the Papers icon).
  - Order Office Supplies and Tour Offices both map to
    `action_facility_expand_office` in the game. That would put two
    identical icons in one form, so they differ here.
  - Scouting maps to `network_64` in the game, which Networking already
    uses, so Scouting keeps Round 3's radar.
  - Travel and Publicity keep Round 3's new icons instead of the game's
    globe-handshake and transparency icons.
  - Financing keeps action_funding_loan, because the game's
    ui_budget_finance is the Ledger here.
- **Glyphs instead of icons:** the reserve - / + stay printed boxes, so the
  remove icon keeps one meaning. The event choices use number keys, not
  icons.

**New, needs art** (SVG in the dark-tile style):
- Advertise a Role (pinned notice), Travel & Conferences (suitcase),
  Publicity (megaphone), Post Online (speech bubble): all from Round 3.
- Go to Meetups (name badge on a lanyard), Order Office Supplies (box of
  pencils): new this run.
- Not icons:
  - an eldritch-band cat. Doom variants of the cats are unbuilt
    (assets/cats/README.md); state 6 adds the glow around the unchanged
    photo instead.
  - per-band window skies. The room uses one office background with a CSS
    sky grade.

## Bugs and data gaps met (not fixed)

- **Scouting choices have no icon.** Read the Literature, Go to Meetups and
  Post Online have no entry in godot/data/icon_mapping.json. The game draws
  its magenta missing-texture checkerboard for them
  (game-shots/m5_plan_queued.png).
- **Unlock gates count workdays.** `unlock_conditions.turn_min` on Safety
  Audit (5) and Strategic (10) counts workdays (GameState.turn), not
  months. Safety Audit would open in month 1's second week. The "STRATEGIC
  MOVES UNLOCKED" popup shows in month 5 (game-shots), so the effective
  gate needs checking.
- **Costs that live only in code or are missing:**
  - Work Your Connections has `costs: {}` in core.json; its hours and
    reputation cost live in code.
  - Advertise a Role's description says it costs money and Attention, but
    its `costs` is empty.
- **The cats:** the eight live cat photos have no doom variants, and
  assets/cats/default (five doom SVGs) is orphaned.
- **The event pictures** in assets/images/events are packed but unused, and
  two show human figures.
- **Doom deltas in PLAN:** today's PLAN prints "Doom this turn: Panic +0.5
  ..." (breaks ADR-0015). Not copied.
- **"Turn" on the HUD:** today's HUD says "Turn 87" on Wed 1 Nov 2017 (it
  counts workdays). The calendar here says the month.
- **Negative research:** research can go negative (-12) with no warning. It
  is shown in red on the slip, and the shortfall stamps count from it.

## run-state.md vs the game

Run-state REVISION 2 (Office Maintenance off the board; fixed results in
actions.gd) arrived during pass 2 and is applied to states 3-5. Apart from
what it corrected, nothing in run-state.md contradicted the data I read. I checked costs,
hour types and descriptions of all 11 plays and 17 cards in
godot/data/actions; talent_recruitment in core_events.json; and the month
review strings and movement rows in game_manager.gd. I used its
"Corrections" section as written.

## Open questions (for Alex or Pip)

1. Should the plan attribute the spill to one play (row 11), or only show it
   on the hour boxes?
2. Is the printed rule line (Para. 2) a standing part of the form, or
   tutorial text to drop once learned?
3. Does Standard Hiring cost 1 held hour like Fast-Track? The data says no;
   Round 1 said every handled option does.
4. At 81.4% the game's stroke colour (#882271) is too dark for a dark CRT
   screen. Is lifting it for legibility acceptable, or should the counter's
   screen be lighter?
5. Do Pip's Staff and Hire icons, and the handshake icons, count as "the
   person" Alex wants gone? (Carried from Round 3.)
6. Should the first-month Advisor note name the card box ("Action cards >
   Scouting") rather than the game's "(the glowing button)"? I kept the
   game's line and made the card box glow.
7. Should PLAN show an "after costs" preview? The game has none today;
   state 3 shows one, costs only (REVISION 2 fixture).

## Visual pass

Every state was checked at 1920x1080 and 1280x720. I looked at each render
in full and at crops of the form, the side column, the drawer header, the
memo choices and the ledger. The page's self-check (`&check=1`) passes on
all six states: no text under 16px, no clipped or spilling text, nothing
off-stage, and no overlapping wall or desk objects.

Type scale:
- 16px: labels and captions.
- 18px: values, rows and keys' surroundings.
- 22px: card names, section heads and the held-hours total.
- 30px: titles.
- Display sizes on the instruments only: 40 reputation, 64 calendar,
  96 P(Doom).

Fixed in pass 2:
- **State 3:** the clipboard ran off the bottom of the stage. Every menu
  now ends at y 1056, inside the stage.
- **State 2:** the "ACTION CARDS" plate wrapped to two lines (nowrap); the
  Close button ran past the drawer's edge (dropped the redundant "On the
  form" chip; the cards carry "on form" tags).
- **State 4:**
  - Choice names and costs wrapped (two-line choices, wider cost column).
  - Background key caps showed under the event (now hidden).
  - The Tour Offices line was cut short (now the data's full words with a
    hanging indent).
- **State 5:**
  - The memo line ran off the ledger (wraps now).
  - A narrow ledger left slivers of the clipboard and shortcuts showing
    (the ledger now covers the desk band from x 356 to 1560, like a menu).
  - About 200px of blank paper (added the Money section).
- **REVISION 2 (late):** the longer result messages overflowed the
  teleprinter into the desk (now wider, taller, tighter lines), and the
  review's last line sat on the sheet's edge (rows tightened).
- **State 6:**
  - The sky grade first showed as a hard pink rectangle (now a soft overlay
    shaped like the windows).
  - The desk wood was untouched by the grade (now graded).
  - The violet wash was too strong (reduced).

Consistency: the four wall instruments and the desk objects keep the same
place and size in all six states. The numbers agree across states:
- money: $245,000 -> $140,000 -> $37,400 (after costs and in WATCH) ->
  $12,400 -> $12,300
- reputation: 50 -> 32 -> 26 (after costs) -> 34 -> 34 -> 21
- research: 0 -> -12 -> -6 -> -6 -> 4
- held hours: 7 in states 3, 4 and 5
- staff: none -> 1 on payroll -> 2

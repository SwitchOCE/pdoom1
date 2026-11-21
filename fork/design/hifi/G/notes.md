# G. The Existing UI, Modernised -- high-fidelity notes

Concept: today's PLAN screen kept in place (resource bar, `## PLAN` banner with
the PLAN/WATCH view switch, P(Doom) ring top right, plan card bottom right,
Commit bottom right), with everything else moved into menus on Pip's
left-bound rail, so the empty office shows. History:
fork/design/research/concepts/G/ (its notes.md maps each change to the
main.tscn nodes).

Files:
- `concept.html?state=N` draws states 1 to 6. Add `&check=1` to run the layout
  check; the result goes to `body[data-check]`.
- `render.sh N ...` makes sN.png (1920x1080), sN-720.png (1280x720) and
  sN.webp (quality 88), and prints the check. Scratch goes in
  /tmp/claude-1000/gscratch.
- `new-icons.html` is the source of the `new_*_64.png` icons.

The stage is 1920x1080 and scales uniformly to the window (canvas_items
stretch), so the 720p render is the same layout at 2/3 size. The page loads
every font face before it lays anything out, so measured heights are final.

What stays fixed in every state: the resource bar; the banner with the view
switch; the rail (Actions A, Upgrades U, Staff E with a count, Ledger L with
"clean", Guide F1); the P(Doom) card; the lower-right card; and Commit. The
centre changes with the state, and so does the doom layer on the office.

## The states

**State 1 -- first month, first screen (Tue 4 Jul 2017).** The home screen
with nothing queued:
- Top bar: Money $245,000, Compute 100, Research 0, Papers 0, Reputation 50.
- P(Doom) card: 20.0%, ELEVATED, band 2 of 7. No RISING, because there is no
  history yet.
- Attention card: Planning 12 of 12 and Operating 8 of 8, all filled (filled
  = hours left). THIS MONTH says "Nothing queued yet", with a "Choose actions
  A" button.
- The tutorial's first step is the game's own hand-off line after the cold
  open (`GameConfig.first_lever_hint_text`): "You do not know anything yet. Go
  and find out -- scouting." It sits in an ADVISOR callout pinned to the
  Actions rail button. That button glows, because Scouting lives inside
  Actions in G. One more line says where: "Scouting is in Actions, the glowing
  button." That replaces the game's "(the glowing button)".
- The callout closes with its x. Menu keeps Esc and Commit keeps Enter,
  because the callout is not modal.
- The office is at art band 0-1: warm amber monitor glow, faint.

**State 2 -- choosing an action (Wed 1 Nov 2017).**
- The plan already holds three plays (Hire: Safety Researcher, then Read the
  Literature x2). The Attention card shows Planning 9 of 12, Operating 8 of 8,
  and THIS MONTH lists those three plays ($60,000).
- The Actions menu (A) opens beside the rail. Its header reads "Hours left: 9
  plan, 8 op".
- It lists the 17 top-level actions the game shows this month, in five groups:
  money; people; research; operations and the office; outward.
  - Doors end in ">" with their choice counts.
  - Direct plays end in "+" with their costs.
  - Hire Staff carries "1 in plan" and Scouting "2 in plan".
- Blocked rows are dimmed and give the reason in orange:
  - Safety Research and Capability Research: "22 short".
  - Publish Safety Paper: "32 short".
  - Travel & Conferences: "Submit Paper 27 research short".
  - Onboard New Hires: "no hires waiting".
  - Advertise a Role: COMING SOON, as the game labels it.
- No NEW chips: Safety Audit's and Strategic's unlock gates count workdays,
  so nothing unlocks in November (council round 1).
- Safety Audit is selected. Its detail card shows: 2 operating hours, $40,000,
  the data's description "Comprehensive safety review", and whether it fits
  (8 operating hours left, $80,000 left after the plan so far). It offers
  "Add to plan [Enter]" and "Back [Esc]".
- The detail card owns Enter and Esc. The menu shows only its x; Menu's Esc
  and Commit's Enter are hidden.

**State 3 -- the month's plan (Wed 1 Nov 2017).**
- After Safety Audit and seven more plays, the player opens the Plan drawer
  (Q, "THE MONTH AHEAD").
- It lists the 11 plays in run order, one row per play, all visible without
  scrolling. Repeats (Read the Literature 2 and 3, Go to Meetups 7 and 10)
  each have their own row and their own up/down/remove.
- Each row shows the play, where it lives, its hours in its pool (amber
  "plan", teal "op", with a stripe of the same colour), its cost, and order
  controls.
- Order Office Supplies, the ninth operating hour, shows "1 op" plus a hatched
  cell and "1 from plan": the hour that spilled into the planning pool.
- Total: 11 plays, 4 plan + 9 op, $102,600 + 6 rep. "After these costs":
  $37,400, 26 rep. The label is "costs", not "Commit", because results land
  at Commit as well (see Fixtures). The game has no such preview today.
- Below: Research Quality, then Undo, Clear and Reserve hours [R]. Reserve
  hours is live: under the ADR the hold is untyped, so up to the 7 held hours
  can be reserved even with no operating hours left.
- Attention card:
  - Planning 7 of 12 filled, one hatched cell (the spilled hour), 4 empty.
  - Operating 0 of 8.
  - A legend line for the hatch.
  - "Held for events at Commit: 7 hr" and "Reserved, up to 7 hr: none
    yet".
  - The rule in one sentence.
- The drawer owns Esc.

**State 4 -- WATCH, an event that needs a reply (Tue 14 Nov 2017).**
- Commit ran on Wed 1 Nov, and every play executed then.
- The banner reads `## WATCH` and Tue 14 Nov 2017. A playback bar shows
  "workday 10 of 22", and the speed controls are paused (`||` lit). The view
  switch is dimmed while the event waits.
- Top bar: Money $37,400, Research -6, Reputation 34. These are the game's
  Commit-time results (run-state REVISION 2); see Fixtures.
- Rail: Staff shows 1, the Safety Researcher hired at Commit. Actions and
  Upgrades are dimmed in WATCH.
- The feed (bottom left) holds the month so far, in the game's own result
  messages, on Wed 1 Nov, in queue order: "+ 7 more lines from Wed 1 Nov",
  then "Safety audit (+scrutiny, +3 reputation)" (play 5), "Networking (+3
  reputation)" (8), the second Meetups "Worked the room (+1.5 reputation).
  No leads you have room for." (10) and "Office supplies restocked (+50
  stationery, now at 100)" (11). State 5 shows the same four lines,
  word for word, from the same list.
  On Tue 14 Nov comes "Talent Opportunity: needs a reply."
- The event card in the centre:
  - Picture: Pip's unused records-room art, cropped to an open personnel
    drawer, a lamp and an empty chair. No figure.
  - The NEEDS A REPLY tag, the title, the date, and the data's text "A
    brilliant researcher wants to join your lab at reduced cost!"
  - Three choices on keys 1, 2 and 3, each with its effect and the data's
    cost: Fast-Track Hiring ($25,000 + 1 held hr, selected), Standard Hiring
    ($25,000 + 1 held hr), Decline Offer (free).
  - Money ($37,400) and held hours (7) under the choices.
- Lower-right card: Held 7 of 7 (untyped, a neutral silver), "Spent at Commit 13 hr",
  "This reply would cost 1 hr", and STAFF AT WORK: 1 Safety Researcher.
- Commit reads MONTH IN PLAY (idle).
- No progress bar for single plays: the game resolves them all at Commit.
- The event owns the keys. Every background key cap is hidden, and the event
  swallows Esc (#452).

**State 5 -- end of month (Fri 1 Dec 2017).**
- Playback has reached the end: the bar is full and reads "November played
  out".
- The Month Review card shows the game's content
  (`game_manager.gd _finish_month_playback`):
  - "December 2017 begins."
  - The Attention line, rewritten for the ADR split: "20 fresh hours this
    month, 12 planning and 8 operating. November's 6 unspent held hours
    evaporated; there is no banking."
  - LAST MONTH'S MOVEMENT: Funds $140,000 -> $12,400 (-$127,600: the plays'
    $102,600 plus Fast-Track's $25,000); Staff 0 -> 2 (+2); Doom HIGH ->
    SEVERE (crossed up). Doom moves only by band, never by number.
  - No rivals section. The game prints one only when a rival is visible, and
    run-state REVISION 2 allows leaving it out.
  - "Begin planning December 2017 [Enter]".
- Top bar: Money $12,400 with a LOW tag (the game's critical-funds threshold
  is at most $20,000); Research -6; Reputation 34.
- P(Doom) card: 56.7%, SEVERE, band 4 of 7.
- The feed keeps November's record: the same four Wed 1 Nov lines as state
  4, "Fast-tracked hiring process! (+1 safety researcher)" on Tue 14 Nov and "Month Review --
  December 2017" on Fri 1 Dec.
- Lower-right card: held hours 0 left; 1 hr used on Talent Opportunity, 6
  evaporated. STAFF AT WORK: 2 Safety Researchers.
- Commit reads MONTH COMPLETE. The office is at art band 2: dimmer and less
  saturated, with a red-orange glow.

**State 6 -- late game, CATASTROPHIC (Mon 2 Apr 2018, fixture).**
- The same home screen as state 1, in the same places:
  - Money $12,300 with a red LOW tag.
  - Research 4.
  - Reputation 21 with an amber LOW tag (the game warns at 30 or less).
  - Staff 2, Ledger clean.
  - Attention 12 of 12 and 8 of 8, nothing queued.
- P(Doom) card: 81.4%, CATASTROPHIC, RISING, band 6 of 7. Its header carries
  the game's own free warning, "Very close to game over" (main_ui.gd, band 5
  and up).
- Doom is a layer, not a repaint:
  - The controls are unchanged.
  - The office takes art band 3, Eldritch: a dark, low-key grade (one
    ambient), and the two lit CRTs glowing violet #7A3B8F (one glow source).
  - The back windows turn a doomy red-purple, and violet smoke wisps lie
    along the floor.
  - Purple appears only here.
- Safety Research is still blocked (6 research short). That shows only in
  the Actions menu, which is not open here.

## Fixtures, and where the game overrode run-state

**Results at Commit (run-state REVISION 2, which agrees with the game).**
Every queued play executes at Commit, and several of this month's plays have
fixed, unrandomised effects in the code (godot/scripts/core/actions.gd and
data/balance/defaults.json):
- Networking: +3 reputation (actions.gd:676-678).
- Safety Audit: +3 reputation (actions.gd:700-705).
- Go to Meetups: +1.5 reputation each, two plays (scouting.meetups).
- Post Online: -1 reputation and +4 hype (scouting.shitpost).
- Read the Literature: +3 research each (scouting.read).
- Work Your Connections: -6 reputation as its cost.

So reputation after Commit is 32 - 6 - 1 + 1.5 + 1.5 + 3 + 3 = 34, and
research is -12 + 3 + 3 = -6. States 4 and 5 use 34 and -6. State 3's drawer
labels $37,400 and 26 rep as "After these costs", which is exact for costs
only. Pass 1 had found the same thing (33 with one Meetups) before the
revision.

Other fixtures and choices:
- **Research -6 in state 5** is run-state's fixture: research the new staff
  produce during playback is not modelled, nor payroll.
- **Which Meetups message goes where** is run-state's fixture: the first play
  adds a candidate, the second finds no room. The real message depends on
  the candidate pool.
- **State 6** values are run-state's projection: reputation 21, research 4,
  money $12,300.
- **Spill rule (ADR-0011 amendment 2026-07-28)**:
  - The mock-up lets operating work spill into planning hours.
  - Today's UI pre-check refuses it (main_ui.gd:1735-1739,
    submenu_controller.gd:142-150).
  - The core gate already allows it (MonthPlan.can_spend_hours,
    month_plan.gd:182-193, used by game_manager.gd:226 and
    game_state.gd:544).
  - So the mock-up follows the ADR and the core, not the UI pre-check.
  - A planning play blocked while operating hours are free is not drawn. In
    state 2, planning is never the short pool. The Attention card states the
    rule in one line instead.
- **Which play spills.** Hours are billed in queue order, so the ninth
  operating hour (Order Office Supplies) is marked. The game books the spill
  per spend and does not label a row; marking the row is a display choice.
- **Held for events at Commit: 7 hr** is the unspent remainder. After the
  event, 1 hr is used and 6 evaporate.
- **Reserve hours live** in state 3, per the ADR's untyped hold (council
  round 1). Today's main_ui.gd:1277-1280 disables it when no operating hours
  are left ("the crisp reserve is operating capacity by definition"); see
  Bugs.
- **Standard Hiring costs $25,000 + 1 held hr** (run-state REVISION 3):
  event_dialog.gd folds the window's Attention price into any handled option
  that does not declare its own. Decline is the free option.
- **Doom held at 40.2% in state 4.** That is run-state's fixture: the level
  stays at the month-start value until the review. RISING carries over as a
  trend label, not a delta.
- **The Month Review's Attention line** splits the game's "20 fresh
  decisions" into 12 planning + 8 operating, and names the 6 evaporated held
  hours. The game's closing line ("Queue this month's actions, then press
  COMMIT THE MONTH ...") is dropped, because the button carries it and G
  keeps standing instructions off screen. The rivals section is left out; no
  rival names or numbers are invented.
- **Feed lines** are the game's result messages as listed in run-state
  REVISION 2, drawn from one list of the 11 Commit lines in queue order;
  states 4 and 5 show the same four. "+ 7 more lines from Wed 1 Nov" counts
  the folded ones: the hire (random researcher name), Read x2, Post Online,
  Work Your Connections, the first Meetups and Tour Offices (random lease
  quotes). "Talent Opportunity: needs a reply." is a fixture line.
- **Workday 10 of 22** is run-state's playback position.
- **Band strip, "Band N of 7" and the doom colours** come from ThemeManager:
  DOOM_STATUS_BANDS, DOOM_STOPS and get_doom_stroke_color, ported to the page.
  The ring uses the game's stroke colour. Text labels lift it toward a pale
  tint of itself until the contrast reaches 4.5:1 (see Bugs).
- **The LOW tags** use main_ui.gd's own danger thresholds (funds at most
  $20,000 is critical; reputation at most 30 is a warning). The game prints
  those as log lines; G puts them on the values.
- **Research Quality: Standard** (today's default) is assumed.
- **Actions menu contents**: core.json minus action_bar_renderer.gd's hidden
  ids (interview_next, hire_best), minus Team Building (locked until 2
  staff), gives 17 rows. That matches run-state's "15 + Safety Audit and
  Strategic". Office Maintenance is not queued (run-state REVISION 2); row 10
  is a second Go to Meetups. The game's Operations submenu still offers it
  (see Bugs).
- **The doom layer on the office** is CSS over Pip's single office_wide_day
  art: a filter grade, radial glows on the two lit CRTs, a window-sky tint,
  and an SVG smoke layer. The in-game version needs per-band art (see New,
  needs art).

## People

- The office art (office_wide_day) is empty in every state: no person, no
  operator outline.
- State 4's event picture is Pip's `event_secret_v3` (records room: open
  drawer, lamp, empty chair), cropped so the dark left edge is out. No figure.
  The other packed event pictures (opportunity, board) have figures, so they
  were not used. These pictures are packed but unused by the game today
  (godot/assets/images/events/README.md).
- Pip's `ui_staff_management` (three silhouettes at a table) is on the Staff
  rail button in every state, as agreed in round 3, pending Alex's answer.
- Pip's `button_hire_normal` (head and shoulders) is on the Hire Staff row in
  state 2 only.
- The Hire play and STAFF AT WORK use Pip's mapped role icon for a Safety
  Researcher (`employee_role_safety_specialist`, a shield), not a figure.
- No new human figures are added.

## Icons

One size per kind of place:
- 28px in the top bar and rail.
- 24px in panel headers, small buttons and plan-card rows.
- 32px on a dark tile in plan rows, the staff row and the event.
- 40px on a dark tile in action rows and the detail card.

Every row icon sits on the same tile, so Pip's tile-less icons
(network_64, money/paper) line up with the rest.

| Where | Icon file | Source |
|---|---|---|
| Money / Compute / Research / Papers / Reputation | money.png, compute.png, research.png, paper.png, reputation.png | Pip |
| Menu | ui_system_settings | Pip |
| Rail: Actions / Upgrades / Staff / Ledger / Guide | ui_guide_actions, button_upgrade_normal, ui_staff_management, ui_budget_finance, ui_guide_book | Pip |
| P(Doom) header / RISING | doom.png, indicator_doom_rising | Pip |
| Attention header, Reserve hours | resource_action_points (hourglass) | Pip (mapping: attention) |
| Undo / Clear / Feedback | ui_control_back, ui_control_clear, ui_control_bug | Pip |
| Fundraising | resource_money | Pip (mapping fundraise) |
| Financing | action_funding_loan | Pip (kept distinct from Ledger, round 3) |
| Hire Staff | button_hire_normal | Pip (mapping hire_staff) |
| Advertise a Role | new_advertise | **new, needs art** |
| Work Your Connections | action_publicity_network | Pip (mapping use_connections) |
| Onboard New Hires | employee_status_training | Pip (mapping onboard_next) |
| Safety Research | action_research_alignment | Pip (mapping) |
| Capability Research | action_research_capability_control | Pip (mapping) |
| Publish Safety Paper | paper.png (same as Papers) | Pip (round 3 agreed) |
| Purchase Compute | action_facility_upgrade_compute | Pip (mapping buy_compute) |
| Safety Audit | employee_role_auditor | Pip (mapping audit_safety) |
| Operations | ui_control_settings (gear) | Pip; the mapping's office icon is shared with three other things |
| Office | action_facility_expand_office | Pip (mapping office) |
| Scouting | action_research_monitoring (radar) | Pip; the mapping's network_64 is Networking's icon |
| Travel & Conferences | new_travel | **new, needs art** |
| Publicity | new_publicity | **new, needs art** |
| Strategic | ui_guide_strategy (chess knight) | Pip; the mapping's red hand is Emergency Pivot's |
| Hire: Safety Researcher, STAFF AT WORK | employee_role_safety_specialist | Pip (mapping hire_safety_researcher) |
| Read the Literature | resource_papers_small | Pip |
| Post Online | new_post_online | **new, needs art** |
| Go to Meetups | new_meetups | **new, needs art** |
| Networking | network_64 | Pip (mapping network) |
| Tour Offices | ui_infrastructure_facilities (building) | Pip; tour_offices is unmapped |
| Order Office Supplies | new_supplies | **new, needs art** |

**New, needs art:**
- Icons: Advertise a Role (pinned notice), Travel & Conferences (suitcase),
  Publicity (megaphone), Post Online (speech bubble), Go to Meetups (two
  glasses), Order Office Supplies (carton with pencils). They are drawn in
  `new-icons.html` as SVG and cut to 64px, in Pip's painted manner (dark teal
  ground, stone-coloured object with soft shading, one orange accent).
- Per-band doom art for the office, which today is faked in CSS:
  - a window-sky layer per band;
  - a monitor-glow layer per band;
  - floor smoke for band 3 and up.
- The eldritch office cat (band 3), if Pip's office cat returns to G. G
  dropped the OfficeCat instrument in round 2.

## Bugs and data gaps (not fixed)

- **Office Maintenance does nothing.** actions.gd has no case for
  `office_maintenance`, so it charges $5,000 and 1 hour for no effect.
  action_bar_renderer.gd:81-83 hides it from the action bar for that reason,
  but the Operations submenu still offers it: GameActions.get_operations_options
  reads all of operations.json, and submenu_controller.gd `_build_grid_submenu`
  does not filter HIDDEN ids. So "cannot be queued" (run-state REVISION 2)
  holds for the bar, not for the submenu; G follows the revision and queues
  it nowhere. Its data text, "Improves morale slightly", contradicts the
  code.
- **Unmapped icons.** `tour_offices`, `scout_read`, `scout_meetups` and
  `scout_shitpost` have no entry in icon_mapping.json, so the game draws its
  magenta placeholder (visible in game-shots/m5_plan_queued.png).
- **Shared interim icons.** Operations, Office, Order Office Supplies and
  Office Maintenance all share `action_facility_expand_office` in
  icon_mapping.json (#762, #768, #791).
- **Work Your Connections** has `costs: {}` in core.json. Its 2 hours and 6
  reputation live in hiring_pipeline.gd and Balance hiring.connections, and
  the hours bill operating (MonthPlan.spend_attention default).
- **The spill:** the UI pre-check and the core gate disagree (see Fixtures).
- **Reserve:** main_ui.gd:1277-1280 treats the reserve as operating capacity
  and disables it at 0 operating hours; the ADR's hold is untyped. G draws
  the ADR (Reserve live).
- **Doom text contrast.** get_doom_stroke_color's floor (luminance 0.22) leaves
  CATASTROPHIC text about 1.8:1 on the dark panels. The page lifts text
  labels to 4.5:1; the ring keeps the game colour.
- **Repeated popup.** "STRATEGIC MOVES UNLOCKED" appears in both the m5 and m6
  screenshots. It may repeat each month, or the scripted run may have
  reloaded. Not confirmed.
- **Hire can fail.** `hire_safety_researcher` hires from the candidate pool
  and refunds if the pool is empty (actions.gd:340-346). Run-state assumes it
  succeeds.
- **Negative research.** Research can go below zero (-12) with no warning;
  shown, not hidden.
- **"Turn".** The HUD's "Turn 87" counts workdays; G shows the month.
- **Unlock gates count workdays.** Safety Audit's unlock (`turn_min: 5`) and
  Strategic's (`turn_min: 10`) compare against GameState.turn, which counts
  workdays, so both open in the first fortnight, not in month 5 or 10.
  Check whether that was meant.

## Open questions (for Alex or Pip)

- Should PLAN show an "after costs" preview at all? The game has none today
  (fixture in state 3).
- Mark the spilled hour on the play that caused it, or only in the Attention
  card? G does both, with the card as the source of truth.
- Reserve hours: the ADR's untyped hold (drawn) or today's operating-only
  code? Pip's call.
- Pip's Staff icon (silhouettes) and Hire icon (head and shoulders): still
  open from round 3.
- New shortcut keys on the rail (A, U, E, F1, Q) are proposals; only L exists
  today.
- Event pictures: the game uses none today. Is a picture per event wanted,
  and may it show people?

## Council round 1 fixes

From fork/design/hifi/council/r1-agreed.md ("All four" and "G"), plus run-state
REVISION 3:
- All four, state 4: Standard Hiring shows "$25,000 + 1 held hr". Fast-Track
  stays selected; state 5 is unchanged. The open question on event costs is
  closed.
- G1, state 2: the NEW chips on Safety Audit (row and detail card) and
  Strategic are gone.
- G2, state 3: Reserve hours [R] is enabled; the Attention card reads
  "Reserved, up to 7 hr: none yet" in place of "Reserve (needs operating
  hours): none". The main_ui vs ADR mismatch stays in Bugs.
- G3, state 3: Read the Literature is two rows (2 and 3); the group row, its
  `+` expander, the empty expander slot and `&expand=read` are removed. Play
  rows went from 54px to 50px so all 11 fit with Order Office Supplies above
  the fold; the check confirms no scroll.
- G4, states 3-5: `--held` is now a neutral silver (#C9D2D8), not lilac.
  Purple appears only in state 6's doom layer (and the aubergine rail chrome,
  left as non-blocking).
- G5, states 4-5: the Wed 1 Nov lines come from one shared list in queue
  order (plays 5, 8, 10, 11), and both states show the same four lines word
  for word under "+ 7 more lines from Wed 1 Nov". State 4 used to show the
  first Meetups line out of queue order; state 5 used to say "+ 8 more lines
  from November".
- Not changed: state 2's home card still groups "2-3 Read the Literature x2"
  (a summary, not the edit list; outside the agreed items).

## Visual pass

Every state was checked at 1920x1080 and 1280x720, by eye and with
`?check=1`. The check flags:
- text under 16px;
- clipped, ellipsised or overflowing text;
- one-line labels that wrap;
- content wider than its box;
- anything outside the stage or outside its panel;
- panels that overlap;
- a plan list that scrolls when it should fit;
- images that fail to load (the check waits until every image has loaded
  or failed).

Final result: CLEAN on all six states at both sizes (after council round 1).

Fixed along the way:
- Fonts loaded after the first layout, so bottom-anchored cards measured too
  short and slid under the bottom bar. The page now loads every face first,
  and the cards are anchored with CSS `bottom`.
- "12 left" wrapped in the Attention card, and then the Attention grid was
  8px wider than its card. The check now catches wide grids.
- "CATASTROPHIC" ran past the P(Doom) card. Band labels are now 22px and
  never wrap.
- The game's doom colour was too dark for text at band 5 (contrast lift
  above).
- The event's option class collided with the Research Quality buttons and
  made the state 3 drawer scroll. The check now flags a scrolling plan list.
- "2-3" wrapped in the home plan card.
- Odd spaces in "Hours left: 9 plan , 8 op" and in "Actions , the glowing
  button".
- A stray violet glow floated in mid-air in state 6.
- Pass 1 fixes for state 3: the expander slot is on every row so icons align;
  every row icon sits on one tile; the ring is wider for "40.2%"; the columns
  are narrowed so "Hire: Safety Researcher" fits.

Consistency across states:
- Money: $245,000 -> $140,000 -> $37,400 (after $102,600) -> $12,400 (after
  $25,000).
- Reputation: 50 -> 32 -> 34 -> 34 -> 21. Research: 0 -> -12 -> -6 -> -6 -> 4.
- Staff: 0 -> 1 -> 2.
- Held hours: 7 -> 7 -> 0 left (1 used, 6 evaporated).
- Doom: 20.0 ELEVATED -> 40.2 HIGH -> 56.7 SEVERE -> 81.4 CATASTROPHIC.
- The research shortfalls in state 2 (22, 32, 27) all follow from -12.

Not judged from stills: motion (glow pulse, playback), hover, feel.

# G. The Existing UI, Modernised -- high-fidelity notes

Concept: today's PLAN screen kept in place (resource bar, `## PLAN` banner with
the PLAN/WATCH view switch, P(Doom) ring top right, plan card bottom right,
Commit bottom right), with everything else moved into menus on Pip's
left-bound rail, so the empty office shows. History:
fork/design/research/concepts/G/ (notes.md there maps each change to the
main.tscn nodes).

Files: `concept.html?state=N` (N = 1..6; `&check=1` runs the layout check and
writes it to `body[data-check]`; `&expand=read` opens the Read the Literature
group in state 3). `render.sh N ...` makes sN.png (1920x1080), sN-720.png
(1280x720), sN.webp and prints the check. `new-icons.html` is the source of
the `new_*_64.png` icons. The stage is 1920x1080 and scales uniformly to the
window (canvas_items stretch), so the 720p render is the same layout at 2/3.

Pass 1 (this checkpoint): state 3 only. States 1, 2, 4, 5, 6 follow in pass 2.

## The states

**State 3 -- the month's plan (Wed 1 Nov 2017, month 5).** The player has
opened the Plan drawer (`Q`, "THE MONTH AHEAD") from the plan card. It lists
the 11 plays of run-state.md in the order they run, one row each, except the
two adjacent Read the Literature plays, which share one row ("2-3", x2) with a
`+` that opens one row per play, each with its own up/down/remove
(`?expand=read`). Each row shows the play, where it lives (Hire Staff,
Scouting, Actions, Publicity, Office, Operations), its hours in its pool
(amber "plan", teal "op", with a matching stripe at the row's left edge), its
other cost and its order controls. Order Office Supplies, the ninth operating
hour, shows "1 op" plus a hatched cell and "1 from plan": the one operating
hour that spilled into the planning pool. The Total row reads 11 plays, 4
plan + 9 op hours, $107,300 + 6 rep; "After Commit" reads $32,700, 26 rep.
Research Quality (Rushed / Standard / Thorough, today's control) and the
Undo / Clear / Reserve hours footer sit under it; Reserve hours is disabled
because a reserve is operating capacity and none is left. On the right the
Attention card shows the split: Planning 7 of 12 cells filled (filled =
hours left), one hatched cell for the spilled hour, 4 empty; Operating 0 of 8;
the legend line for the hatch; "Held for events at Commit: 7 hr"; Reserve
none; and the rule in one sentence ("Operating work can use planning hours.
Planning work can never use operating hours."). The P(Doom) card shows 40.2%,
the band HIGH, RISING and a seven-band strip with band 3 lit; no doom delta
anywhere. The top bar shows Research -12 in red with a BELOW ZERO tag. With
the drawer on top, only the drawer shows Esc; Menu's Esc and Commit's Enter
are hidden. Commit stays reachable. It follows from state 2 (the player was
adding Safety Audit from the Actions menu): the plan grew to 11 plays and the
player opened the plan to check hours and money before committing.

## Fixtures and ADR-over-game choices

- **Spill rule (ADR-0011 amendment 2026-07-28).** The mock-up lets operating
  work spill into planning hours. Today's UI pre-check refuses it: it compares
  the cost with the hours of the action's own type only
  (godot/scripts/ui/main_ui.gd:1735-1739, submenu_controller.gd:142-150). The
  core gate already allows it (MonthPlan.can_spend_hours,
  godot/scripts/core/month_plan.gd:182-193, used by game_manager.gd:226 and
  game_state.gd:544). So the mock-up follows the ADR and the core, not the UI
  pre-check.
- **Which play spills.** Hours are billed in queue order, so the ninth
  operating hour (Order Office Supplies, play 11) is the one drawn from
  planning. The game books the spill per spend (`_debit_hours`); it does not
  label a row. Marking the row is a display choice.
- **"Held for events at Commit: 7 hr"** is the unspent remainder (run-state).
- **Reserve hours disabled.** main_ui.gd:1277-1280 disables the Reserve
  button when no operating hours are left ("the crisp reserve is operating
  capacity by definition"). Shown as the game does it.
- **"Band 3 of 7"** and the band strip use ThemeManager.DOOM_STATUS_BANDS and
  the doom colours from ThemeManager.DOOM_STOPS / get_doom_stroke_color
  (godot/autoload/theme_manager.gd), ported to the page. The strip shows band
  thresholds, which are free; no doom number other than the level.
- **RISING** is run-state's "rising"; the icon is Pip's
  `indicator_doom_rising`. Round 2's five-month sparkline is dropped (no real
  history for it).
- **After Commit** money and reputation are $140,000 - $107,300 and 32 - 6
  (run-state).
- **Research Quality: Standard** (today's default) is assumed.

## People

- State 3: no human figure. The Hire play uses Pip's mapped role icon for a
  Safety Researcher (`employee_role_safety_specialist`, a shield), not the
  head-and-shoulders Hire icon. Pip's `ui_staff_management` (three
  silhouettes at a table) is on the Staff rail button, as agreed in round 3,
  pending Alex's answer.
- The office art (office_wide_day) is empty: no person, no operator outline.

## Icons

One size per kind of place: 28px in the top bar and rail, 24px in panel
headers and small buttons, 32px (on a dark tile) in plan rows.

| Where | Icon file | Source |
|---|---|---|
| Money / Compute / Research / Papers / Reputation | money.png, compute.png, research.png, paper.png, reputation.png | Pip |
| Menu | ui_system_settings_64 | Pip |
| Rail: Actions / Upgrades / Staff / Ledger / Guide | ui_guide_actions, button_upgrade_normal, ui_staff_management, ui_budget_finance, ui_guide_book | Pip |
| P(Doom) header / RISING | doom.png, indicator_doom_rising | Pip |
| Attention header, Reserve hours | resource_action_points (hourglass) | Pip (mapping: attention) |
| Undo / Clear / Feedback | ui_control_back, ui_control_clear, ui_control_bug | Pip |
| Hire: Safety Researcher | employee_role_safety_specialist | Pip (icon_mapping hire_safety_researcher) |
| Read the Literature | resource_papers_small | Pip |
| Post Online | new_post_online | **new, needs art** |
| Safety Audit | employee_role_auditor | Pip (mapping audit_safety) |
| Work Your Connections | action_publicity_network | Pip (mapping use_connections) |
| Go to Meetups | new_meetups | **new, needs art** |
| Networking | network_64 | Pip (mapping network) |
| Tour Offices | action_facility_expand_office | Pip (the Office family's icon; tour_offices is unmapped) |
| Office Maintenance | employee_role_engineer (wrench) | Pip |
| Order Office Supplies | new_supplies | **new, needs art** |

**New, needs art** (`assets/icons/new_*_64.png`, drawn in new-icons.html as
SVG, cut to 64px): Post Online (speech bubble), Go to Meetups (two glasses),
Order Office Supplies (carton with pencils), plus, for pass 2, Advertise a
Role (pinned notice), Travel & Conferences (suitcase), Publicity (megaphone).
They are redrawn for this run in Pip's painted manner (dark teal ground with a
vignette, a stone-coloured object with soft shading, one orange accent),
answering round 3's note that G's new icons were flatter than Pip's.

## Bugs and data gaps (not fixed)

- `tour_offices` and the three Scouting plays (`scout_read`, `scout_meetups`,
  `scout_shitpost`) have no entry in godot/data/icon_mapping.json, so the game
  draws its magenta placeholder (visible in the Scouting popup of
  fork/design/research/ui-pass/game-shots/m5_plan_queued.png).
- Operations, Office, Order Office Supplies and Office Maintenance all share
  `action_facility_expand_office` in icon_mapping.json (interim notes #762,
  #768, #791).
- Work Your Connections has `costs: {}` in core.json; its 2 hours and 6
  reputation live in hiring_pipeline.gd (Balance hiring.connections.*), and
  its hours bill operating via MonthPlan.spend_attention's default.
- The UI pre-check and the core gate disagree on the spill (see Fixtures).
- Research can go negative (-12) with no warning (run-state; shown, not
  hidden).
- The HUD's "Turn 87" counts workdays (run-state); G shows the month.

## Open questions (for Alex or Pip)

- Is marking the spilled hour on the play that caused it (rather than only in
  the Attention card) the right reading of ADR-0011? Conservative choice
  made: both, with the Attention card as the source of truth.
- Should "Reserve hours" stay operating-only (today's code) under the ADR's
  untyped hold? Drawn as today's code.
- Pip's Staff icon (silhouettes) and Hire icon (head and shoulders): still
  open from round 3.

## Visual pass

State 3, 1920x1080 and 1280x720, by eye and with `?check=1` (text under
16px, clipped or ellipsised text, anything outside the stage or its panel,
panels overlapping): CLEAN. Fixed along the way: the Read the Literature group
row's expander pushed its icon and name 38px right of the other rows (every
row now has the expander slot); Pip's Networking icon has no tile of its own
while the others do (every row icon now sits on the same dark tile); "40.2%"
touched the ring (ring widened to 168px); the tile padding clipped "Hire:
Safety Researcher" (hours and cost columns narrowed).

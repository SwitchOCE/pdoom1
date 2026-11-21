# C. The Paperwork Desk -- high-fidelity run

Status: pass 1 (state 3 drawn). States 1, 2, 4, 5 and 6 follow in pass 2.

The concept is unchanged from Round 3: home is Pip's empty office with a few
desk objects (card box, schedule clipboard, Staff, Upgrades, Ledger, Guide,
Commit stamp) and four wall instruments (calendar, accounts slip, P(Doom)
counter, reputation dial). Each desk object opens one menu; the menu covers
the desk band, so no object or second set of hour boxes shows under it.

Files: `concept.html` (`?state=1`..`6`; `&check=1` adds a layout self-check),
`render.sh` (renders a state at 1920x1080 and 1280x720 and prints the check),
`assets/`, `s3.webp` (committed), `s3.png` / `s3-720.png` (uncommitted).

## States

**State 3 -- the month's plan (Wed 1 Nov 2017, month 5).** The player has
lifted the schedule clipboard off the desk: Form A-20, "Schedule of the
month", for November 2017. The register lists the eleven plays of
run-state.md in queue order, each on its own row with its own icon, its
source door in small type, its hours in the pool it bills (plan hr in
amber-brown, op hr in teal), its cost, its own up/down and remove controls
(council rule 4). Totals: 4 plan hr + 9 op hr, $107,300 + 6 rep. The side
column is the founder's hours: planning 7 of 12 left (seven filled boxes,
council rule 1), operating 0 of 8 left. The ninth operating hour has nowhere
to go in the operating pool, so it is drawn from planning: the twelfth
planning box is struck through in operating teal, a dashed teal line runs
from the operating row up into it ("1 hr spills up"), the ledger line says
"of which from planning hours ... 1 hr", and the register row that caused it
(11, Order Office Supplies) is tinted and tagged "from planning". The
form's printed rule (Para. 2) states the asymmetry in one line: operating
work may spill into planning hours; planning work may never use operating
hours. Below: set aside for events 0 (stepper), and "Held for events at
Commit ... 7 hr" with one line saying unspent hours wait for this month's
events and lapse at month end. "After Commit" shows money $140,000 -> $32,700
and reputation 32 -> 26. Research quality is the game's three-way switch on
Standard with the game's own caption. The wall stays readable above the
dimmed office: NOV calendar, accounts slip (research -12 in red), P(Doom)
40.2% HIGH (RISING), reputation 32. The Commit stamp sits dimmed under the
menu with no Enter cap (council rule 2); Esc belongs to the form.

## Fixtures and places I followed the ADR over today's game

- **Attention spill (ADR-0011, amendment 2026-07-28).** Today's pre-check
  refuses an operating play once operating hours are gone; the form follows
  the ADR and lets 1 operating hour spill into planning. Planning hours left
  7 = 12 - 4 - 1; operating 0; held for events 7.
- **Which row spilled** is my presentation choice: the operating hours past
  the eighth, counted in queue order, land on row 11. The game accounts the
  pools in aggregate and does not attribute the spill to a play. Open
  question below.
- Reserve 0: run-state.md ("none here").
- "RISING" on the P(Doom) counter: run-state.md ("40.2%, rising"). The band
  label HIGH is the primary readout; no delta is printed anywhere (ADR-0015).
- The ten-lamp strip under the counter lights one lamp per full 10% (4 lit).
  It restates the level; it is not a delta.
- Research Quality on Standard with "Baseline speed. No side effects.": from
  game-shots/m5_plan_queued.png.
- Work Your Connections 2 op hr + 6 reputation: from the game code, not
  core.json (`costs: {}`), as run-state.md says.
- Diegetic names, not game terms: "Form A-20 / Founder's office", "Para. 2",
  "Schedule of the month". They label the existing PLAN queue.

## People

- State 3: none. The Hire row uses Pip's `employee_role_safety_specialist`
  (a shield; it is the game's own icon for Hire: Safety Researcher in
  icon_mapping.json), not the head-and-shoulders `button_hire_normal`.
- Networking uses Pip's `network_64` (two hands shaking; hands only, no
  figure). Listed in case hands count.
- Go to Meetups no longer uses `action_management_team_building` (three
  figures, Round 3); it now has a new name-badge icon with no figure.

## Icons (state 3)

All 64px PNGs copied from godot/assets/icons/ unless marked new.

| Where | Icon file | Button / readout |
|---|---|---|
| Accounts slip | resource_money_64, resource_compute_small_64, resource_research_small_64, resource_papers_small_64 | Money, Compute, Research, Papers |
| Wall | resource_doom_small_64; resource_reputation_64 | P(Doom) counter; Reputation dial |
| Form title | ui_config_date_64 | Schedule (same as the clipboard on the desk) |
| Form | ui_control_cancel_64 | Close |
| Rows | ui_control_up_64 / ui_control_down_64 | Move play up / down (Round 3 had glyph-only ^ v) |
| Rows | ui_control_remove_64 | Remove play (Round 3 had a glyph-only x) |
| Form tools | ui_control_back_64; ui_control_clear_64 | Undo; Clear form |
| Side column | resource_action_points_64; resource_money_64; resource_research_small_64 | Founder's hours; After Commit; Research quality |
| Row 1 | employee_role_safety_specialist_64 | Hire: Safety Researcher (game's mapping) |
| Rows 2-3 | ui_guide_book_64 | Read the Literature |
| Row 4 | new_post_online_bubble.svg (new) | Post Online |
| Row 5 | employee_role_auditor_64 | Safety Audit (game's mapping) |
| Row 6 | action_publicity_network_64 | Work Your Connections (game's mapping) |
| Row 7 | new_meetup_badge.svg (new) | Go to Meetups |
| Row 8 | network_64, seated on a dark tile by CSS (the file is unframed) | Networking (game's mapping) |
| Row 9 | ui_infrastructure_facilities_64 | Tour Offices (a building: looking at offices on the market) |
| Row 10 | employee_role_engineer_64 | Office Maintenance (wrench: repairs) |
| Row 11 | new_supplies_box.svg (new) | Order Office Supplies |
| Commit stamp | button_confirm_normal_64 | Commit the month |

The game maps Office, Operations, Order Office Supplies and Office
Maintenance all to `action_facility_expand_office`; three identical icons in
one register would not say which row is which, so rows 9-11 use distinct
icons. Reserve - / + are printed form boxes, not icons, so the remove icon
keeps one meaning.

**New, needs art** (SVG in the same dark-tile style as Round 3's new icons):
Post Online (speech bubble, from Round 3), Go to Meetups (name badge on a
lanyard), Order Office Supplies (box of pencils).

## Bugs and data gaps met

- The three Scouting choices (Read the Literature, Go to Meetups, Post
  Online) have no entry in godot/data/icon_mapping.json; the game draws its
  magenta-and-black missing-texture checkerboard for them
  (game-shots/m5_plan_queued.png).
- Work Your Connections has `costs: {}` in core.json; its hours and
  reputation cost live in code.
- Today's PLAN prints "Doom this turn: Panic +0.5 ..." (breaks ADR-0015);
  not copied.
- Today's HUD says "Turn 87" on Wed 1 Nov 2017 (workdays, not months); the
  calendar here says "Plan, month 5".
- Research can be negative (-12) with no warning; shown in red on the slip.

## Open questions (for Alex or Pip)

1. Should the plan attribute the spill to a play (row 11 here), or only show
   it on the hour boxes? The game keeps one aggregate count.
2. Is the printed rule line (Para. 2) on the form tutorial text that should
   go once the player has learned it (game-ui rule 1), or a standing part of
   the form? I kept it, one line, inside the menu only.

## Visual pass

State 3, 1920x1080 and 1280x720:
- One type scale: 16 labels and captions, 18 values and rows, 22 section
  heads and the held-hours total, 30 form title; display sizes only on the
  instruments (40 reputation, 64 calendar, 96 P(Doom)). Nothing below 16px
  (checked by the page's self-check).
- Fixed: the side column ran past the sheet's right edge; the accounts slip
  ran under the P(Doom) counter (slip tightened, counter moved to x 800);
  the spill arrow crossed "0 of 8 left" (hour counts moved beside their
  labels, the arrow now rises clear of text); the printed rule wrapped off
  the bottom (shortened to one line); "Hire: Safety Researcher / Hire Staff"
  was clipped (columns rebalanced); the play icon sat flush against the
  order arrows (gap added); totals now align with the Play column.
- Self-check: no clipped text, nothing off-stage, no overlapping wall or
  desk objects.
- Looked at both renders in full and at crops of the register and side
  column; the 720 render is the same layout at 2/3 and stays legible.

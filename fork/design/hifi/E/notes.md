# E. Rooms and Stations -- high fidelity

Concept as agreed in Rounds 2 and 3: Pip's mezzanine office fills the screen
and stays empty; a fixed frame (wall calendar top left, hanging P(Doom) dial
top centre, reputation gauge top right, Commit bottom right) never moves;
everything else is a station opened from the desk (Actions card file, Plan
CRT, Lab Floor, Procurement, Records), and each station owns its own state.
`concept.html?state=1` .. `?state=6` draws the six states of
fork/design/hifi/run-state.md on a 1920x1080 stage scaled to the window.

Status: pass 1 (state 3) done; states 1, 2, 4, 5, 6 follow in pass 2.

## States

**State 3 -- the month's plan (Wed 1 Nov 2017, month 5).** The player has
pressed P (or the Plan station) and the LABTERM CRT comes forward over the
dimmed office. Top: the two Attention pools, filled boxes = hours left.
Planning shows 7 left, then one hatched blue box, then 4 spent; operating
shows all 8 spent, and a blue lead runs from the last operating box up into
the hatched planning box, with one line under it: "1h of operating work is
using a planning hour". Beside it, "Held for events at Commit: 7h" (7h
unspent + 0h reserve, reserve - / + controls). Below, the queue in order:
11 plays, the two Read the Literature plays shown as a group (02-03, x2, [-])
opened into one row each, every row with its own ^ v x; each row names
where the play lives (HIRE STAFF, SCOUTING, PUBLICITY, OFFICE, OPERATIONS or
TOP LEVEL), its hours chip (PLAN amber / OPS blue) and its cost. The play
that takes the spilled hour (Order Office Supplies, the operating hour past
8 in queue order) carries the same hatched swatch. Footer: Undo, Clear, and
"11 plays . queued cost $107,300 + 6 rep". Beside Commit, a printout from
the terminal ("After Commit") shows the books: money $140,000 - $107,300 =
$32,700; reputation 32 - 6 = 26; research -12, "Below zero: research plays
are blocked." The frame reads NOV / WED 1 . MONTH 5, P(Doom) 40.2% HIGH,
RISING, reputation 32. Commit keeps Enter (the CRT owns only Esc).

## Fixtures and places I followed the ADR over today's game

- **Spill rule (ADR-0011 amendment 2026-07-28):** the mock-up lets the 9th
  hour of operating work take a planning hour. Today's UI shows one pool
  ("ATTENTION 0/20 allocated") and its pre-check refuses an operating play
  once operating hours run out; the mock-up follows the ADR, not that
  pre-check.
- **Which play carries the spilled hour** (the hatched swatch on Order Office
  Supplies): drawn as the operating hour past 8 in queue order. The game
  accounts the spill in aggregate; the per-row marker is a presentation
  choice, not a game rule. If Pip prefers, drop the row marker and keep the
  pool boxes.
- **What the spill rule forbids** (no room drawn for it): if operating hours
  were free and planning hours ran out, a planning play could not use them;
  in this concept the Actions card file would show that play blocked with
  "no planning hours".
- **After Commit printout:** money and reputation after Commit are the
  queued costs only (run-state: $32,700, 26). Payroll for the new hire is
  not modelled (run-state fixture).
- **Doom dial bands:** the arc is cut at the game's DOOM_STATUS_BANDS edges
  (15/37/52/67/80/92) and coloured with DOOM_STOPS from
  godot/autoload/theme_manager.gd; the value and band word use the stroke
  colour. RISING is the game's trend indicator; no delta is printed
  (ADR-0015).
- **Under Way** (dated bars in the Round 2-3 Plan view) is gone: nothing is
  in flight in this run's November, and the old rows were round-1 fixtures.

## People

- State 3 shows no human figure. Hire: Safety Researcher uses Pip's mapped
  `employee_role_safety_specialist` (a shield), not the head-and-shoulders
  Hire button; Go to Meetups uses a drawn name badge instead of Pip's
  `action_management_team_building` (three figures).

## Icons (state 3)

| Icon file | Sits on |
|---|---|
| `ui_config_date_64.png` | Plan CRT title (the Plan station) |
| `resource_action_points_64.png` | Held for events at Commit |
| `employee_role_safety_specialist_64.png` | Hire: Safety Researcher (Pip's mapping) |
| `ui_guide_book_64.png` | Read the Literature |
| `new_post_online.svg` | Post Online |
| `employee_role_auditor_64.png` | Safety Audit (Pip's mapping) |
| `action_publicity_network_64.png` | Work Your Connections (Pip's mapping) |
| `new_meetup_badge.svg` | Go to Meetups |
| `network_64.png` | Networking (Pip's mapping) |
| `ui_home_hq_64.png` | Tour Offices |
| `new_maintenance.svg` | Office Maintenance |
| `new_supplies.svg` | Order Office Supplies |
| `money.png`, `reputation.png`, `research.png` | After Commit printout rows |
| `doom.png`, `indicator_doom_rising_64.png` | P(Doom) dial label, RISING |
| `reputation.png` | Reputation gauge label |
| `ui_control_confirm_64.png` | Commit the Month |

Changed from Round 3 to follow Pip's own icon_mapping.json: Safety Audit
(was `action_policy_audit_requirement`), Work Your Connections and
Networking (Pip maps the blue handshake to Work Your Connections and the
dark handshake to Networking). Two handshakes appear in one queue; they are
Pip's choice, kept.

**New, needs art** (drawn in the same dark tile, `assets/icons/new_*.svg`):
Post Online (speech bubble, from Round 3), Go to Meetups (name badge on a
lanyard), Office Maintenance (wrench), Order Office Supplies (box of paper
and a pencil). Pip's mapping gives the last two his office floor-plan icon
as an interim, which does not show either play.

## Bugs and data gaps met

- Work Your Connections has `costs: {}` in core.json; its 2 operating hours
  and 6 reputation come from hiring_pipeline.gd (Balance
  hiring.connections.*), so a data-driven cost display shows it as free.
- Research can sit below zero (-12) with no warning in today's game
  (run-state, known bug); shown here, not hidden.
- Today's HUD "Turn N" counts workdays; the calendar shows the month.

## Run-state conflicts

None found for state 3: every play's pool, hours and cost match
godot/data/actions/*.json (hour_type) and month_plan.gd KIND_FAMILY;
$60,000 + $40,000 + $300 + $5,000 + $2,000 = $107,300.

## Visual pass

State 3, 1920x1080 (s3.png) and 1280x720 (s3-720.png), both opened and read.
A DOM check (`?check=1`, read with --dump-dom) reports no text under 16px,
no overflow, nothing outside the stage, no text spilling its parent.
Fixed on the way: the spill lead pointed down instead of up; the dial's 0
and 100 crowded the arc ends; the printout's last line ran out of the paper.
One type scale (16 / 18 / 22 / 28 / 44); queue columns share one grid with
the heading row; every Pip icon sits on the same dark tile at one size per
place (28 rows, 24 sub-rows and printout, 22 frame labels, 36 titles and
Commit). WebP at quality 90 (191 KB) to keep the CRT text crisp.

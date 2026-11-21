# A. The Desk -- high-fidelity pass

Built from fork/design/research/concepts/A (rounds 1-3) and the run in
fork/design/hifi/run-state.md. `concept.html?state=1..6` draws each state on a
1920x1080 stage that scales uniformly to the window, so 1280x720 is the same
layout at 2/3 size. `&check=1` prints a layout self-check (overflow, text
outside its box, elements off the stage, overlaps, every font size in use).

Status: pass 1 (state 3) done. States 1, 2, 4, 5, 6 come in pass 2.

## The states

**State 3 -- the month's plan (Wed 1 Nov 2017).** The player has pressed P
(or the PLAN plate): the desk terminal fills the left of the view and the
office behind it dims; the P(Doom) dial, reputation meter, shortcut rack and
Commit stay where they always are, with only the PLAN plate lit. The screen
reads top to bottom as the decision runs:
- Attention, filled = hours left. Planning shows 7 of 12 left: seven lit
  squares, one hatched teal square (the hour operating work took), four spent.
  Operating shows 0 of 8 left. Beside each bar, what spent it: "4 hr planning
  work + 1 hr operating (spill)" and "8 hr operating work". The explicit
  reserve sits at 0 hr with its - / + controls.
- One terminal line states the rule as the system applies it: "[SPILL] 1 hr
  of operating work is drawn from planning. Planning work never draws on
  operating hours."
- The queue: 11 plays, one row each, with where it lives (Hire Staff,
  Scouting, top level ...), its pool, hours, cost and its own ^ / v / x
  targets (^ is inert on row 1, v on row 11). Row 11, Order Office Supplies,
  carries the SPILL 1 tag because it is the operating play that ran past the
  8 operating hours.
- Undo [Z], Clear [C] and the queued cost: $107,300 + 6 rep.
- "At Commit": money $140,000 -> $32,700, reputation 32 -> 26, held for
  events 7 hr untyped. Commit's housing repeats "Held for events 7 hr".
- The bezel holds the Research Quality switch (Standard) and the only
  Esc on screen: "P / Esc back to desk". Commit hides its Enter while the
  terminal owns the keys (council rule 2).
It follows from state 2: the Safety Audit the player was adding is row 5,
and the eight plays after it are what filled the month.

## Fixtures

- Queue order is run-state's table order. The game books hours in the order
  plays are queued (month_plan.gd `_debit_hours`), so the spill lands on the
  last operating play, Order Office Supplies. A different order would move
  the SPILL tag, not change the totals.
- "AT COMMIT ... Wed 1 Nov": the after-Commit money and reputation are
  arithmetic on run-state's numbers ($140,000 - $107,300; 32 - 6), not a
  game readout. The game has no "after Commit" preview today.
- Reserve 0 hr (run-state: no explicit reserve).
- Research Quality on Standard: the game's default (`_current_mode`
  "standard", research_quality_selector.gd).
- "HIGH . rising" on the dial: run-state's "rising". It is a direction word
  only; no number for the change (ADR-0015).
- Reputation meter: the short red mark at 0 marks where the run ends
  (reputation <= 0, game_state.gd:617). Its width is drawn, not a threshold.
- **Attention spill (ADR-0011 amendment 2026-07-28) over today's UI.** The
  mock-up lets operating work spill into planning hours. Today's UI
  pre-checks (main_ui.gd ~1737, submenu_controller.gd ~143) compare a play's
  hours with its own pool only, so they refuse the 9th operating hour before
  the core is asked. The core already follows the ADR: month_plan.gd
  `can_spend_hours` lets operating eat planning and `_debit_hours` books the
  spill. So the mock-up follows the ADR and the game's own core; only the UI
  pre-check disagrees.
- What the spill rule forbids (a planning play with only operating hours
  left) cannot happen in this state: planning still has 7 hours. A planning
  play in that case would show the same red stamp the Actions menu uses
  ("NO PLANNING HRS LEFT"); drawn in state 2 if there is room.

## People

State 3:
- Rack: STAFF plate uses Pip's `ui_staff_management` (three silhouettes at
  a table). Kept, per the brief.
- No other human figure. The office art (`office_wide_dawn.webp`) is empty.

## Icons

State 3 (all beside a label, never instead of one; one size per place):
- Rack (32px): ACTIONS `ui_guide_actions` (hand pointing); PLAN
  `ui_config_date` (calendar); STAFF `ui_staff_management`; UPGRADES
  `button_upgrade_normal`; LEDGER `ui_budget_finance`; IN-TRAY
  `new_inbox_tray.svg` (new, needs art); GUIDE `ui_guide_book`.
- Plates (24px): P(DOOM) `doom.png`; REPUTATION `reputation.png`.
- The terminal has no painted icons: it is an amber CRT, and Pip's painted
  tiles would break it. Pools are told apart by colour and a word (amber
  "planning", teal "operating") and spill by a hatched tag.

New, needs art (so far): `new_inbox_tray` (In-tray plate).

## Bugs and data gaps

- Work Your Connections: `costs: {}` and no `hour_type` in core.json. Its 2
  hours and 6 reputation come from hiring_pipeline.gd `use_connections`
  (Balance hiring.connections.cost_attention 2, cost_reputation 6), and it
  bills OPERATING because `spend_attention` defaults to operating. Run-state's
  table is right; its general line "no hour_type = planning" does not hold
  for this action.
- UI pre-check vs core on the spill (see Fixtures).

## Open questions (for Alex or Pip)

- Should PLAN show an "after Commit" preview (money and reputation once the
  queue runs)? It is a view of existing numbers, but the game does not show
  it today.

## Visual pass

State 3, at 1920x1080 and 1280x720:
- Self-check: no overflow, no text outside its box, nothing off the stage,
  no overlaps. Font sizes in use: 16, 18, 22, 28, 40 px only (the page's
  type scale); nothing under 16px.
- Fixed: the money cell in "At Commit" wrapped onto two lines (widened the
  column, no-wrap); the P(Doom) dial's brass rim was clipped at the top
  (viewBox widened); the operating line said "9 operating work" while the
  planning line counted the spilled hour too (now "8 hr operating work").
- Checked by eye: columns line up under their headings; every row's order
  buttons sit on one right edge; the 720 render keeps the same layout with
  nothing cut.

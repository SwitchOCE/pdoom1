# The bar for the PLAN-screen redesign (council, 2026-11-21)

Agreed by Opus, Sol and Neon after one discussion round. The text is Neon's joint proposal, which folds in Opus's and Sol's; the commit line is the majority (Opus, Neon). Sol's position on it is below and is being put to Sol.

## Targeted outcomes

1. **Legible monthly decisions at a glance.** Within seconds, a player can identify every available action or submenu door, see what it costs and whether they can afford it (money and planning/operating Attention), and find out why an action is unavailable without hovering blind icons.
2. **A clear monthly plan on a clean, teachable screen.** The player can read back the queued month, the reserve and the single Commit control on a clutter-free screen whose elements have stable positions, plain names and targets a later tutorial can point at.

## Statements

1. **Self-describing hand, all live top-level actions reachable.** Each direct action shows name, Attention cost and hour type, money cost, and a non-colour affordability cue. Submenu doors are marked as doors, with costs on the choices inside. Effect and "why unavailable" open by focus, a selection panel or an info control, never hover only and never by changing a click's existing behaviour. No action hidden, merged or re-nested (`is_submenu` untouched). (Pip's brief element 4; UI_PROPOSALS D3; FTL; XCOM 2.)
2. **Attention as units at the point of spending, by hour type, shown once.** Remaining, planning, operating, allocated and reserved are distinct; queuing or reserving visibly updates the pool; the populated view includes an action blocked by hour type while total Attention remains. (FTL; Into the Breach; Pip elements 1, 3; main_ui.gd:1733; ADR-0011.)
3. **The Month Ahead is the main workspace.** Empty and populated states in the same place; queued plays in order with costs; Undo, Clear and Reserve beside them; in-flight work with duration/ETA only where QueueGantt already has it, as a date not a turn; read-only order; no unearned future events. (Pip element 2; D2; queue_gantt.gd; XCOM 2.)
4. **One Commit, fixed place, the single action accent, one advertised key.** Replaces "COMMIT THE MONTH >", "Plan (Enter)" and "Do Nothing"; both existing keybinds route to it so none goes inert; never moves across states or open panels; says what committing does with leftover Attention (held for events) and with an empty queue. (Into the Breach; Football Manager; FTL; Pip element 6.)
5. **One compact strip, 8 or fewer, counted against the baseline**, with the mode label and month/year (not "Turn N"), core resources with negative values marked, no duplicates and no unearned rates. P(Doom) in one fixed spot, no deltas (ADR-0015), no new unearned breakdown (existing one flagged to Pip); reputation readable as the second lose condition. (XCOM 2; Against the Storm; Terra Invicta as contrast.)
6. **Secondary panels open inside a persistent frame.** Upgrades behind one door; Upgrades, Research Quality, Hire, Fundraise, Travel, Employees and Ledger open while strip, lose conditions, Attention gauge, queue and Commit stay visible; Esc and [X] close. (Against the Storm; XCOM 2; Football Manager; D6.)
7. **Staff and ledger obey Not yet.** Compact staff summary once someone is hired; read-only lists hidden while empty or clean; the doors never hidden. (FTL; Into the Breach; Pip element 5.)
8. **No permanent teaching text, shown in three views**: month 1 with one removable marker, the same state without it (no shift), and a populated month 5 (staff, queued and in-flight work, an hour-type-blocked action, an open drawer). Glance items compared with today's ~55, counted the same way. (game-ui; Pip's brief; critique.)

## Reference screenshots

Today's `main.png` and `m5_plan_queued.png`; `into-the-breach-1`, `ftl-1`, `xcom2-1`, `xcom2-2` (or `against-the-storm-2`); `terra-invicta-1` as the contrast.

## Open with Sol

Sol's discussion reply: keep one commit control visually primary but "preserve the existing routes"; "Do Nothing queues a pass and leaves the player in PLAN"; a later consolidation should verify behaviour in empty, populated and warning states. Opus and Neon checked the code: all three routes reach the same queued state and `end_month()` reserves the remainder either way (game_manager.gd:734-735), so one Commit passes the same-seed test.

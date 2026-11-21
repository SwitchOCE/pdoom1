# Bar, round 1: the three proposals

Relayed by the orchestrator. Each proposal below is condensed (link lists shortened); every statement, source and note is kept. If a condensation misstates your own proposal, say so. The members agree on most lines. Open points the orchestrator sees (a neutral list, not a ruling):

1. Commit. Opus and Sol: keep both existing commit effects ("COMMIT THE MONTH >" commits without reserving; "Plan (Enter)" commits and reserves all remaining Attention; Opus cites main_ui.gd:989-999 and 1053-1074, main.tscn:376-378) because merging them changes runs; one primary button plus a labelled secondary route. Neon: one Commit replacing all three controls, stating what an empty queue does. Please check Opus's claim in the code and settle.
2. Readout strip size: Opus "about 10 or fewer", Neon "<= 8", Sol "compact, counted against the baseline".
3. In-flight work / ETA in the queue area: Neon shows QueueGantt in-flight operations with duration/ETA where known; Opus no ETA unless supported; Sol only where already available.
4. Views: Opus and Neon two views (month 1 with marker, returning); Sol adds a populated month-5 view.
5. Reference screenshots: overlapping lists.

---

## Claude Opus

Targeted outcomes:
- A. Within a few seconds, a new player can name every action available this month, what it costs, and whether they can afford it.
- B. The player can see their plan for the month and finish the month with one obvious control.

Bar:
1. Every available action is a labelled card with its cost, greyed out when the player can't afford it. Each card shows its name, its Attention cost with the hour type, and its money cost. The reason a card is greyed out opens by focus or a separate info control; clicking the card still queues it. Today's top-level actions only: none hidden, merged or re-nested. (Pip's brief element 4; Into the Breach; FTL.)
2. The budget is shown as units where they are spent. Attention left reads without opening anything, split into planning and operating hours; queuing visibly moves units out of the pool; Attention is shown once on the screen. (Draft 1; Pip element 1; FTL.)
3. The month's queue is the main area. Queued actions in order with cost; Reserve beside the queue as part of the gauge; no ETA bars and no reordering unless the game already supports them. (Pip elements 2-3; Into the Breach.)
4. One main commit button, in a fixed place, with a visible key, that says why when blocked. "Commit and reserve the rest" is a different effect today; it stays reachable and labelled with that effect, e.g. as a Reserve option, not as a second commit button. (Into the Breach; Football Manager; Pip element 6.)
5. Both lose conditions in fixed spots, readable in under a second. Doom level, no deltas (ADR-0015); reputation shown. The per-stream breakdown stays as is and is flagged to Pip. (XCOM 2; Against the Storm.)
6. One strip at one edge, about 10 or fewer readouts; month and year, not "Turn N"; detail by click or focus; no rates or per-month changes the game hasn't already given free (Terra Invicta contrast). "Next known event" removed (ADR-0001/0004). (XCOM 2.)
7. Secondary panels open beside the main area and keep strip, lose meters, queue and commit visible: upgrades, Research Quality (#1090 open), submenus, ledger, staff, each behind one control. Staff compact, absent while the team is empty. (Against the Storm, Frostpunk, FM, Pip element 5.)
8. Mock-up shows two views: first month (pointer marker only) and returning player (no teaching sentences; about 15 kinds of glance item, from about 55). Every action reachable in both. (game-ui; video F4; Terra Invicta.)
Screenshots: main.png, m5_plan_queued.png, into-the-breach-1, ftl-1, xcom2-1, against-the-storm-1, frostpunk-2, football-manager-2024-1, terra-invicta-1.
Notes: (1) Pip's brief contains new mechanics (queue order = execution priority with reorder, Gantt ETA, situational cards); the mock-up must not assume them. (2) Merging the two commit buttons fails the same-seed test; "Do Nothing" queues the same pass action as an empty commit (main_ui.gd:989-999). (3) Fix the limits against today's count before pass/fail.

## GPT Sol

Targeted outcomes:
- A new player can identify an available action, explain what it costs, and tell whether they can afford it before selecting it.
- A player can read back the month they've planned, see what Attention they're holding back, and find the control that starts WATCH.

Bar:
1. The hand reads as a set of choices: along the lower edge, visible names and availability cues that work without colour; actual cost on each direct action; submenu doors labelled as doors with costs at the choices inside; every action reachable; effect and blocking reason by focus or a separate info control. (Pip's hand brief; XCOM 2 research selection.)
2. Attention explains what the player can still spend: remaining total, planning and operating hours, allocated and reserved, in one labelled group; a before/after example where a queued action updates the figures it debits; include a state where total Attention remains but the hour type blocks an action. (Pip elements 1, 3; FTL; main_ui.gd:1733.)
3. "The Month Ahead" is the main work area: empty and populated states in the same place; names, displayed order, known costs; duration/ETA only for work that already has one available to the player; read-only where no reorder control exists. (Pip element 2; critique; queue_gantt.gd:31.)
4. One commit control is visually primary and stays put; a player can point to what starts WATCH in empty and populated states; the mock-up accounts for both existing commit paths and their shortcut, warning and empty-queue behaviour; any secondary route has a label describing when to use it. (Into the Breach; main_ui.gd:599, 989.)
5. The header answers when this is and how close the lab is to losing: PLAN and month/year; one labelled P(Doom) level and a visible reputation readout with both thresholds understandable; other readouts compact and counted against the baseline; no event forecast, per-action doom prediction or unearned source detail. (XCOM 2; game_state.gd:788; ADR-0004.)
6. Secondary choices stay reachable without taking over the plan: one open detail state shown; budget and plan readable; commit in the same place; visible routes to Upgrades, Research Quality, Employees, Ledger; compact staff summary when staff exist. (Pip element 5; XCOM 2; FTL.)
7. The same layout works with the teaching cue removed: first-month view with a marker on a real control and the same state without it; hand, queue and commit in place; plus a populated month-five view. (Pip's Startup brief; plan.)
Screenshots: ftl-1, into-the-breach-1, xcom2-1, xcom2-2, terra-invicta-1, and the current PLAN captures beside their matching mock-up states.
Notes: drop the event-dialog criterion (WATCH out of scope); Pip's brief is enough to proceed, leave reprioritisation and project-level Research Quality out; confirm outcomes later with an unaided walkthrough in the running game.

## Gemini Neon

Targeted outcomes:
1. Legible monthly decisions at a glance: what actions, cost and change, affordability (money and planning/operating Attention), what is in this month's plan, how to commit, without hovering blind icons or fighting the Upgrades block.
2. A clean veteran screen that is ready to teach: no permanent tutorial prose or competing commit buttons; every decision element has a stable home, plain name and highlightable target.

Bar:
1. Every top-level action is self-describing without hover, all live actions reachable: each of today's 15 tiles shows name, Attention cost + hour type, money cost, affordability state; effect and why-unaffordable by focus, selection panel or info control, never hover-only, never changing existing click behaviour; no is_submenu merges. (Pip brief element 4; UI_PROPOSALS D3; game-ui; XCOM 2.)
2. Attention as visible units at the point of spending, split planning/operating, shown in one place only (removing the duplicate top-bar counter): allocated, reserved, free by hour type; queueing or changing Reserve shifts units. (FTL; Into the Breach; Pip elements 1, 3; ADR-0011.)
3. The month ahead (queue + in-flight work) is the primary workspace: this month's queue with costs, Undo, Clear and Reserve beside it, plus in-flight multi-month operations (QueueGantt: duration/ETA where known; read-only order numbers since no reorder API); only player-known commitments, never unearned events. (Pip element 2; D2; queue_gantt.gd:11-20; XCOM 2.)
4. One Commit button, fixed spot, the screen's single action accent and one key, replacing "COMMIT THE MONTH >", "Plan (Enter)" and "Do Nothing"; stays put across states and panels; secondary in the eye path until ready; makes clear what an empty-queue commit does (reserves all). (Into the Breach; FM; FTL; Pip element 6; game-ui.)
5. One compact global strip (<= 8 items) with month/year and both lose conditions legible: Month + Year, Money, Compute, Research, Reputation (flag negative/low), zero duplicates; P(Doom) in one fixed spot, no per-action deltas, no newly added unearned stream detail; Reputation legible as a lose condition. (XCOM 2; Against the Storm; Frostpunk; Terra Invicta contrast.)
6. Secondary drawers and submenus open inside a persistent frame: Upgrades behind one door; opening Upgrades, Hire, Fundraise, Travel or Ledger keeps strip, Attention gauge, P(Doom) and Commit visible; Esc and [X] close. (Against the Storm; Frostpunk; FM; XCOM 2; D6.)
7. Compact staff and ledger readouts that obey Not yet on month 1: staff as compact edge list once hired; lists hidden while 0 staff / ledger clean; the doors themselves never hidden. (FTL; Into the Breach; Pip element 5.)
8. Zero permanent teaching clutter, verified in two views: returning view strips instructional prose, keeps a short PLAN/WATCH mode label and Pip's terminal register, sharp drop from ~55 glance items; month-1 view adds one removable marker on one named element without shifting positions. (game-ui; Pip brief; critique.)
Screenshots: into-the-breach-1, ftl-1, xcom2-1 (+ xcom2-2 or against-the-storm-2 for an open drawer), terra-invicta-1.
Notes: (1) draft 5 violates ADR-0001/0004, replace with player-known in-flight work; draft 7 is WATCH and conflicts with NAVIGATION_AUDIT's Q W E keys. (2) Keep 15 top-level actions, read-only priority numbers (queue_gantt.gd:17-20: MonthPlan has no reorder API), flag the free per-stream breakdown. (3) Fits the "proposed" A/B lane.

---

## What to send back

For each open point 1-5 and anything else you disagree with: agree, disagree, or a different fix, with evidence (check the code for point 1). End with your proposed joint bar: the two outcomes and at most 8 numbered statements, plus the screenshot list. Read-only.

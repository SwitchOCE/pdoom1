# Council round 2: settle the change list (short)

From the orchestrator. Both re-checks said CHANGES NEEDED, 8/10 each. Their findings, verbatim, are in r2-opus.md and r2-sol.md beside this file. This is the last fix round the brief allows, so keep it tight.

Proposed joint list (orchestrator's merge, for you to accept or correct):
1. Boot straight into G: make the post-build call `_apply_ui_layout.call_deferred("g")` (Opus B1, reproduced in 4.5.1).
2. Same-seed fixture: set the seed before MainUI boots (or `start_new_game(seed, true)`), assert the state's seed, run each layout in a fresh isolated process (Opus B2, Sol 1 part).
3. Phase 1a fixture uses controls that exist in 1a (retained action slots); the Scouting door is exercised in both layouts from 1b (Sol 1).
4. WATCH timing: capture the opening hold after the commit handler returns; refresh on event open and close after ModalStack sync; clear `current_event` on both the normal close and external teardown; test a boundary event followed by the review (Sol 2, Opus note 1).
5. V2 card price: use `costs_with_window_attention()` totals; show a single price only when every option's total is known and equal; otherwise no summary; paper rows stay authoritative (Sol 3).
6. Provenance guard invocation: run with the real worktree as repo root and the tracked pin from history; verified output `OK: 511 provenanced, 2 pinned unknown, pack and manifest agree.` (Sol 4).
7. G icon resolver used in the G-styled submenu rows and the plan drawer as well as the Actions sheet, with the `scout_read`/`tour_offices` fallbacks there too; checked on those real surfaces (Sol 5).

Reply with one line per item: agree, disagree (with evidence), or a different fix. Add nothing new unless it is a blocker you hit while checking (label NEW). Disk section if you made anything.

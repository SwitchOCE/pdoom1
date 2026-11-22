VERDICT: CHANGES NEEDED

I checked every agreed item (A1-A11, V1-V7, N1-N3) against the code at f122435a, and they all landed correctly. Two blocking items remain: one NEW that I reproduced in Godot 4.5.1, and one slip in how A8 was applied.

## Blocking items

**B1 (NEW). Booting straight into G fails in Godot 4.5.1.**
- **Problem:**
  - Spec 2.1 runs the second `_apply_ui_layout("g")` call "right after `main_ui.gd:316-317`", which is inside `MainUI._ready()` (`_ready` runs from `main_ui.gd:153` to `:362`).
  - Step 1 of `_apply_g()` adds `GDesk` to `TabManager`, the parent of MainUI.
  - While a child's `_ready` is running, Godot refuses to add nodes to that child's parent. So the boot path the A1 test exercises does not work.
- **Evidence:** a scratch project with the same tree (a Control `TabManager` holding a VBox `MainUI` whose `_ready` calls `get_parent().add_child(...)`), run on the official 4.5.1 binary:
  - `ERROR: Parent node is busy setting up children, add_child() failed. Consider using add_child.call_deferred(child) instead.`
  - The child list stayed `[MainUI, Other]` on the next frame.
- **Fix:** make that one call `_apply_ui_layout.call_deferred("g")`.
  - Deferred calls run at the end of the current frame, and `_boot_game()` waits a whole frame first (`main_ui.gd:360-362`). So GDesk exists before the first state arrives, and the new-game dateline trigger still sees that state.
  - F9 and Settings flips happen at run time, so they are unaffected.
  - State this in spec 2.1.

**B2. The same-seed fixture never uses its seed.**
- **Problem:**
  - The fixture in spec 12.1 item 5 (and build-prompt step 5) calls `game_manager.start_new_game("g-parity-1")` without `force`.
  - `main.tscn` has already booted a game by then (`main_ui.gd:362` calls `_boot_game` -> `start_new_game("", true)`), so `start_new_game` refuses: `if is_initialized and not force: push_warning(... REFUSED ...)` (`scripts/game_manager.gd:72-73`).
  - Both runs therefore play on the boot seed, which is the player's configured seed or else the weekly seed. That changes from week to week, so "no event in the first month" can come and go between weeks.
- **Fix:** call `start_new_game("g-parity-1", true)`, or set `GameConfig.game_seed = "g-parity-1"` in the isolated profile before `main.tscn` loads. Either way, assert that the state's seed is `g-parity-1` before queueing anything.

## The writer's readings: all accepted

- **V1:** with an empty queue the plate says "HOLD ALL HOURS FOR EVENTS". Accepted. It describes what `_on_commit_plan_button_pressed` does (`append_reserve_all`, `main_ui.gd:1063-1066`), and Q17 asks Alex about the wording.
- **V2:** the card shows one price only when every option shares it. Accepted. Prices come from `window_attention_for_option` (`event_dialog.gd:86`).
- **V3:** only Tab and Shift+Tab pass through to the sheet. Accepted. Enter and Space stay blocked, which keeps Pip's Enter ruling.
- **V6:** no close fade. Accepted.
- **A5:** refusals use the new `rejection_reported` signal. Accepted. Every refusal goes through `present_error`.
- **A8:** the build prompt leaves the pinned commit as `PIN=<fill in ...>`. Accepted, as long as the orchestrator fills it in before Alex approves.

## Notes

1. `current_event` would go stale. Spec 2.5 clears it "where `_pending_event` is cleared (`:539`)", but that is only the external-teardown path. The normal answer path (`report_choice_result`, `event_dialog.gd:500-525`) never clears `_pending_event`. W3 and W4 also check `top_kind`, so no wrong face shows. Still, clear `current_event` when `dialog_closed` fires on both paths.

SCORE: 8/10

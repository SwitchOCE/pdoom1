VERDICT: GOOD TO GO

## Blocking items
None. All seven round 2 items landed correctly at e49be6fe, and nothing else broke.

- **R2-1 (boot into G):** the second layout call is now deferred. In a scratch 4.5.1 project, the deferred `add_child` onto MainUI's parent succeeds (`added=true`) with no "busy" error.
- **R2-2 (seeded fixture):** setting the seed in each profile works: `game_config.gd:315` reads `[game] last_seed`; `get_display_seed()` returns it when it is not empty (`:637-640`); `start_new_game` uses it when given an empty seed (`game_manager.gd:77-78`); `game_seed_str` exists for the assert (`game_state.gd:209`).
- **R2-3 (1a fixture):** 1a queues through the action slots and 1b goes through the Scouting door. Both match the phase split.
- **R2-4 (WATCH timing):** `end_month()` emits the state update, then sets the reserve, with no `await` in between (`game_manager.gd:696-735`). A deferred read at the end of the frame therefore sees the reserve. `dialog_closed` exists (`event_dialog.gd:19`), and both close paths are named.
- **R2-5 (card price):** `costs_with_window_attention` (`:111`) and the static `WindowResolver.window_config` (`:25`) both exist.
- **R2-6 (provenance guard):** the `sed` targets the guard's `REPO =` and `PIN =` lines (`check_provenance.py:83, 86`), which exist.
- **R2-7 (icons):** the change hooks the line that loads each submenu icon (`submenu_controller.gd:229`) and the Plan drawer.

## Notes
1. **"GDesk exists before the first state" is only true when the game reaches `main.tscn` through a scene change.** I tested the order in 4.5.1:
   - Through `change_scene_to_file` (how `SceneTransition` loads it): the deferred G call runs first, then the boot after `await process_frame`.
   - With `main.tscn` as the startup scene: the boot runs first. The output was `AFTER_AWAIT_boot frame=0` before `DEFERRED_apply_g frame=0`.

   The capture harness or a test may well launch `main.tscn` directly. A1's seeding from `_last_state` already covers the faces, so nothing breaks. But the phase 4 "new game types the dateline" trigger would see the date shown set. Fix: when `GDesk.setup` finds a fresh game (turn 0, not a load), treat that as the new-game trigger. Or have the harness load `main.tscn` through `SceneTransition`.

## SCORE
9/10

(Disk, relayed by the orchestrator: Opus left `godot/boot.tscn` and `godot/switcher.gd` untracked in the checkout by a failed `cd`; the orchestrator removed both. No tracked file changed. Its /data scratch was removed.)

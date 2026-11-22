# Council round 2: the agreed change list

Opus and Sol agreed all seven items in r2-consensus-ask.md as written, with these preferences folded in:

- Item 2: both prefer setting `GameConfig.game_seed` in each fresh isolated profile before `main.tscn` loads (the boot path already passes force=true), asserting the state's seed before queueing, one fresh isolated process per layout.
- Item 3: in 1a both layouts queue through slots 1-9 (`_trigger_action_by_index`); from 1b the Scouting door is opened in both layouts.
- Item 6: the provenance guard matters only once Q15 is approved, or on an `up/<slug>` branch.
- Item 7: the submenu grid gets icons from `IconLoader.get_action_icon(opt_id)` (`submenu_controller.gd:229`); the G map and fallbacks reach the Actions sheet, the submenu rows and the Plan drawer; rendered textures checked on all three.

Neon re-checks after the writer applies this list (Neon last, per the council skill).

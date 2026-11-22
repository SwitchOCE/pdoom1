VERDICT: CHANGES NEEDED

## Blocking items

1. **NEW — R2-1 still races the first state update.** In an isolated Godot 4.5.1 project with the same parent-child setup, the prescribed deferred call followed by `await process_frame` printed `G_DESK_BEFORE_BOOT=false`. Moving `_apply_ui_layout("g")` after the existing await and immediately before `_boot_game()` printed `G_DESK_BEFORE_BOOT=true`. Specify that ordering so GDesk can receive the first state. [Revised boot sequence](spec.md:157) · [MainUI boot](godot/scripts/ui/main_ui.gd:360)

2. **NEW — R2-3's phase 1a fixture selects a disabled action.** The first non-door slot is Advertise a Role, which the renderer disables as coming soon. The slot handler skips disabled buttons, so the first queue-growth assertion fails. Pin three known admissible inputs, such as three presses of the Purchase Compute slot in the standard starting profile. Assert the slot ID, active layout, and queue growth. The Scouting fixture from 1b can stay. [Phase 1a fixture](spec.md:2000) · [Coming-soon gate](godot/scripts/ui/action_bar_renderer.gd:289) · [Slot handler](godot/scripts/ui/main_ui.gd:725) · [Purchase Compute](godot/data/actions/core.json:13)

3. **NEW — R2-7's screenshot gate requires views the game cannot produce.** The resolver now reaches all three surfaces, as agreed. The spec also requires every mapped ID on every surface. Scouting choices do not appear in the top-level Actions sheet, and door IDs such as Travel open a submenu without entering the queue. Require each ID on the surfaces where it can appear. Check fallbacks in 1b and commissioned textures after import in 2b. [Icon gate](spec.md:1003) · [Top-level action source](godot/scripts/core/actions.gd:207) · [Door handler](godot/scripts/ui/main_ui.gd:1707)

## Notes

- R2-2, R2-4, and R2-5 are correctly specified. The seed loads before boot, WATCH captures the hold after commit and refreshes after modal synchronization, and the card summarizes only known equal prices.
- R2-6 passed with the exact revised audit command. It reported `OK: 511 provenanced, 2 pinned unknown, pack and manifest agree.`

SCORE: 9/10

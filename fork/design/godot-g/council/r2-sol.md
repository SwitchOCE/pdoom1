VERDICT: CHANGES NEEDED

The revised spec resolves the layout boot order, input ownership, theme overrides, and room fallback. Five implementation details still block sign-off.

## Blocking items

1. **NEW — The phase 1a parity fixture requires controls that do not exist yet.** The gate calls for G sheet rows in 1a, but phase 1b builds those sheets. The chosen actions, `scout_read` and `scout_meetups`, are also choices inside the Scouting submenu, so neither layout exposes them as top-level rows. Give 1a a fixture through the retained action slots, then exercise the Scouting door in both layouts from 1b. Set the seed before MainUI boots and run each layout in a fresh isolated process. The prescribed `start_new_game(seed)` call refuses if a run is already live. [Parity fixture](spec.md:1918) · [Phase split](spec.md:1950) · [Scouting choices](godot/data/actions/scouting.json:3) · [New-game guard](godot/scripts/game_manager.gd:61)

2. **A6 — WATCH reads the right reserve field at the wrong time.** `end_month()` emits the phase and state before setting the implicit reserve, so the first W2 update can record `0` and later subtract a positive closing balance. The binding table also omits modal open and close notifications, although the state and phase signals can both precede event registration. Capture the opening hold after the existing commit handler returns, refresh on event open and close after stack synchronization, and clear `current_event` on both successful close and external teardown. Test a boundary event followed by the review. [WATCH bindings](spec.md:860) · [Commit signal order](godot/scripts/game_manager.gd:707) · [Event registration](godot/scripts/ui/main_ui.gd:2152) · [Successful close](godot/scripts/ui/event_dialog.gd:501)

3. **V2 — The proposed uniform price can falsely say all replies are free.** `window_attention_for_option()` returns the supplemental display charge. It returns zero for options with their own declared Attention cost and for hiring prompts whose option text already names the price. I accept the uniform-price reading when every option's total is known. Use `costs_with_window_attention()` for structured prices and leave the card's summary off for self-priced or unknown options. Keep the existing paper rows authoritative. [Spec](spec.md:871) · [Displayed cost merger](godot/scripts/ui/event_dialog.gd:86) · [Hiring option stamps](godot/scripts/core/window_resolver.gd:300)

4. **NEW — The approved provenance command exits 1.** I ran the prescribed copy-and-link method. The font and timer guards passed, but provenance printed `RED: no pin at tools/assets/provenance_unknown_pin.json.` Its Git blob lookup also runs from the scratch directory, which has no Git index. Use the actual worktree as the provenance guard's repository root and supply the tracked pin from history. I verified that combination reports `OK: 511 provenanced, 2 pinned unknown, pack and manifest agree.` The agreed fork-only staging default can stay as written. [Provenance command](spec.md:1875)

5. **A11 — The icon map misses the screens that render several commissioned icons.** The spec puts the map in `GActionsPanel`, which receives top-level actions. Post Online, Go to Meetups, and Order Office Supplies are submenu choices. The `scout_read` and `tour_offices` fallbacks have the same gap. Use the G icon resolver in the existing G-styled submenu rows and the plan drawer as well as the Actions sheet. Check the chosen texture on those real surfaces. [G icon map](spec.md:964) · [Top-level action source](godot/scripts/core/actions.gd:207) · [Submenu row builder](godot/scripts/ui/submenu_controller.gd:199)

## Notes

- I accept V1's **HOLD ALL HOURS FOR EVENTS** caption and the two click paths. I also accept the A5 rejection signal. The refusal test should verify the toast is visible with a sheet or submenu open.
- I accept V3's Tab and Shift+Tab exception and V6's immediate hide and focus release. Godot 4.5 exposes the focus links and `Viewport.gui_release_focus()` the spec uses.
- I accept the A8 placeholder during review. The handoff should pin the reviewed spec commit before workers start. The spike runner now sends captures to scratch by default.

SCORE: 8/10

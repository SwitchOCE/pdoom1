extends GutTest
## G phase 7 (fork/design/godot-g/spec.md 6, 12.2 "Phase 7"): every motion of the 6.2 table on
## the real main.tscn, its "Reduced motion" column (6.5), input during a motion (6.2 "Input
## during it", 6.4), and the pause freeze (6.3): every G tween freezes under a real tree pause
## and goes on after, and nothing in G runs while paused.
##
## Mid-motion cases hold the tween still (pause + custom_step) so the check does not depend on
## how fast this box draws frames; the pause checks let the tweens run on the real clock.

const MAIN_SCENE := "res://scenes/main.tscn"

var _prev_hint: bool
var _prev_action: String
var _prev_text: String
var _prev_baseline: int


func before_each() -> void:
	_prev_hint = GameConfig.show_first_lever_hint
	_prev_action = GameConfig.first_lever_action_id
	_prev_text = GameConfig.first_lever_hint_text
	GameConfig.show_first_lever_hint = false
	# No background baseline thread per boot (the unjoined-thread flake, see test_g_paper).
	_prev_baseline = GameConfig.baseline_mode
	GameConfig.baseline_mode = 2
	GPrefs.set_reduced_motion(false, false)


func after_each() -> void:
	get_tree().paused = false
	GameConfig.show_first_lever_hint = _prev_hint
	GameConfig.first_lever_action_id = _prev_action
	GameConfig.first_lever_hint_text = _prev_text
	GameConfig.baseline_mode = _prev_baseline
	GAdvisorNote.plain_dismissed_this_session = false
	GAdvisorNote.dismissed_this_session = false
	GPrefs.reload_prefs()
	GameManager.month_playback_active = false


# --- helpers -----------------------------------------------------------------------------

func _boot() -> Node:
	GPrefs.set_desk(true, false)
	var root: Node = load(MAIN_SCENE).instantiate()
	add_child_autofree(root)
	var main_ui: Node = root.find_child("MainUI", true, false)
	for _i in range(120):
		await get_tree().process_frame
		if GameManager.is_initialized and String(main_ui.current_turn_phase).to_upper() == "ACTION_SELECTION":
			break
	await _frames(2)
	return main_ui


func _lever_on() -> void:
	GameConfig.show_first_lever_hint = true
	GameConfig.first_lever_action_id = "scouting"
	GameConfig.first_lever_hint_text = "Advisor: you do not know anything yet. Go and find out -- scouting (the glowing button)."


func _frames(n: int = 2) -> void:
	for _i in range(n):
		await get_tree().process_frame


func _press(code: int) -> void:
	var ev := InputEventKey.new()
	ev.keycode = code
	ev.physical_keycode = code
	ev.pressed = true
	get_viewport().push_input(ev)
	var up := ev.duplicate() as InputEventKey
	up.pressed = false
	get_viewport().push_input(up)


func _event(id: String) -> Dictionary:
	var opts: Array = []
	for t in ["Handle it", "Delegate it", "Let it go"]:
		opts.append({"id": "opt%d" % opts.size(), "text": t, "costs": {}, "effects": {}})
	return {"id": id, "name": "Test event %s" % id, "description": "Something needs a reply.",
		"type": "popup", "options": opts}


func _review_event() -> Dictionary:
	return {
		"id": "__month_review__", "name": "Month Review -- August 2017", "type": "popup",
		"description": "August 2017 begins.",
		"options": [{"id": "begin_planning", "text": "Begin planning August 2017", "costs": {}, "effects": {}}],
		"review": {"heading": "Month Review", "period": "August 2017", "lede": "August 2017 begins.",
			"attention": "Attention: 20 fresh decisions this month.", "movement": [], "rivals": [],
			"closing": "Queue this month's actions, then press COMMIT THE MONTH to play the month out."},
	}


func _hold_choices(main_ui: Node, ed) -> Array:
	"""Record choices instead of resolving them in the real game (the dialog stays up)."""
	var seen: Array = []
	if ed.choice_selected.is_connected(main_ui._on_event_choice_selected):
		ed.choice_selected.disconnect(main_ui._on_event_choice_selected)
	ed.choice_selected.connect(func(_ev, cid): seen.append(cid))
	return seen


func _finish(t) -> void:
	if t is Tween and (t as Tween).is_valid():
		(t as Tween).custom_step(10.0)


func _wait_until(cond: Callable, max_frames: int = 600) -> bool:
	for _i in range(max_frames):
		if cond.call():
			return true
		await get_tree().process_frame
	return cond.call()


func _focus_inside(n: Node) -> bool:
	var f := get_viewport().gui_get_focus_owner()
	return f != null and n.is_ancestor_of(f)


# --- sheets (6.2 "Sheet open", "Sheet close", "Switch sheet") -----------------------------

func test_sheet_open_fades_and_slides_and_is_top_from_the_first_frame() -> void:
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	var sh: GSheet = desk.actions_panel
	assert_true(desk.open_sheet("g_actions"))
	assert_true(sh.opening(), "the open fade runs")
	var t: Tween = sh._tween
	t.pause()
	var base: float = sh._panel_base_x
	assert_eq(sh.modulate.a, 0.0, "starts transparent")
	assert_almost_eq(sh.panel.position.x, base - GSheet.OPEN_SHIFT, 0.01, "starts 8 px to the left")
	# Top from the first frame: registered, the barrier takes clicks, focus is inside.
	assert_eq(main_ui.modal_stack.top_kind(), "g_actions")
	assert_eq(sh.barrier.mouse_filter, Control.MOUSE_FILTER_STOP)
	assert_true(_focus_inside(sh), "the sheet has the keyboard focus at once")
	t.custom_step(GSheet.OPEN_SECONDS / 2.0)
	assert_between(sh.modulate.a, 0.01, 0.99, "half way: part faded in")
	assert_between(sh.panel.position.x, base - GSheet.OPEN_SHIFT + 0.01, base - 0.01, "half way: part slid")
	assert_gt(sh.modulate.a, 0.5, "ease out: more than half faded at half time")
	t.custom_step(GSheet.OPEN_SECONDS)
	assert_false(sh.opening(), "the fade is over after 0.12 s")
	assert_eq(sh.modulate.a, 1.0)
	assert_almost_eq(sh.panel.position.x, base, 0.01, "at rest")
	desk.close_g_sheets()
	await _frames()


func test_esc_and_the_letter_mid_open_hide_the_sheet_at_once() -> void:
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	for close_key in [KEY_ESCAPE, KEY_A]:
		var sh: GSheet = desk.actions_panel
		_press(KEY_A)
		assert_true(sh.visible, "A opens the Actions sheet")
		assert_true(sh.opening(), "its fade runs")
		var t: Tween = sh._tween
		t.pause()
		t.custom_step(GSheet.OPEN_SECONDS / 3.0)
		assert_lt(sh.modulate.a, 1.0, "mid-open")
		_press(close_key)
		assert_false(sh.visible, "key %d mid-open hides it in the same call" % close_key)
		assert_false(t.is_valid(), "the open tween was killed")
		assert_eq(sh.modulate.a, 1.0, "no half-faded state left behind")
		assert_almost_eq(sh.panel.position.x, sh._panel_base_x, 0.01, "nor a half-slid panel")
		assert_eq(sh.barrier.mouse_filter, Control.MOUSE_FILTER_IGNORE, "the barrier is off")
		assert_false(_focus_inside(sh), "focus released")
		assert_eq(main_ui.modal_stack.depth(), 0, "nothing left on ModalStack")
		assert_false(main_ui.pause_menu.visible, "Esc on the opening sheet does not open the menu")
		await _frames(2)


func test_switch_sheet_closes_the_old_at_once_and_fades_the_new() -> void:
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	desk.open_sheet("g_plan")
	_finish(desk.plan_panel._tween)
	assert_true(desk.plan_panel.visible)
	_press(KEY_A)
	assert_false(desk.plan_panel.visible, "the Plan drawer closes at once")
	assert_eq(desk.plan_panel.modulate.a, 1.0)
	assert_true(desk.actions_panel.visible, "Actions is open")
	assert_true(desk.actions_panel.opening(), "with its 0.12 s fade")
	assert_eq(main_ui.modal_stack.top_kind(), "g_actions")
	assert_eq(main_ui.modal_stack.depth(), 1, "one sheet on ModalStack")
	desk.close_g_sheets()
	assert_false(desk.actions_panel.visible, "close is instant")
	assert_eq(desk.actions_panel.modulate.a, 1.0)
	await _frames()


# --- PLAN <-> WATCH (6.2) ------------------------------------------------------------------

func test_view_flip_fades_the_watch_parts_and_a_second_v_mid_fade_kills_it() -> void:
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	var parts: Array = [desk.feed_panel, desk.playback_bar]
	for p in parts:
		assert_false((p as Control).visible, "PLAN: %s hidden" % p.name)
	_press(KEY_V)
	assert_eq(main_ui.screen_mode.current_mode, ScreenModeController.Mode.WATCH, "V flips at once")
	for p in parts:
		assert_true((p as Control).visible, "%s shows at once" % p.name)
		assert_true(desk.view_fading(p), "%s fades in" % p.name)
		var t: Tween = desk.view_fades[p]
		t.pause()
		assert_eq((p as Control).modulate.a, 0.0)
		t.custom_step(GDesk.VIEW_FADE_SECONDS / 2.0)
		assert_between((p as Control).modulate.a, 0.01, 0.99, "%s half way" % p.name)
	var held: Array = [desk.view_fades[parts[0]], desk.view_fades[parts[1]]]
	_press(KEY_V)
	assert_eq(main_ui.screen_mode.current_mode, ScreenModeController.Mode.PLAN, "a second V flips back at once")
	for i in range(parts.size()):
		var p: Control = parts[i]
		assert_false(p.visible, "%s hides at once" % p.name)
		assert_false((held[i] as Tween).is_valid(), "%s: its fade was killed" % p.name)
		assert_eq(p.modulate.a, 1.0, "%s: no half-faded state left" % p.name)
	# A third flip fades in again from transparent, and the fade ends on its own.
	_press(KEY_V)
	for p in parts:
		assert_true(desk.view_fading(p), "%s fades in again" % p.name)
		assert_lt((p as Control).modulate.a, 1.0)
	assert_true(await _wait_until(func(): return not desk.view_fading(parts[0]) and not desk.view_fading(parts[1])),
		"the 0.15 s fades end")
	for p in parts:
		assert_eq((p as Control).modulate.a, 1.0)
	_press(KEY_V)
	await _frames()


# --- event paper and month review (6.2) ------------------------------------------------------

func test_event_paper_arrives_and_a_key_answers_during_the_fade() -> void:
	var main_ui: Node = await _boot()
	var ed = main_ui.event_dialog
	var seen := _hold_choices(main_ui, ed)
	ed.present(_event("arrive"))
	var dialog: Control = ed._showing_dialog
	assert_true(GPaper.arriving(dialog), "the paper arrives with a fade")
	var t: Tween = dialog.get_meta("g_arrive")
	t.pause()
	assert_eq(dialog.modulate.a, 0.0, "from transparent")
	assert_almost_eq(dialog.position.y, GPaper.TOP + GPaper.ARRIVE_SHIFT, 0.01, "12 px low")
	t.custom_step(GPaper.ARRIVE_SECONDS / 2.0)
	assert_between(dialog.modulate.a, 0.01, 0.99, "half way")
	assert_between(dialog.position.y, GPaper.TOP + 0.01, GPaper.TOP + GPaper.ARRIVE_SHIFT - 0.01, "half way")
	# A content resize mid-slide keeps the slide (the resting place is under it).
	var y_mid := dialog.position.y
	(dialog.get_meta("g_fit") as Callable).call()
	assert_almost_eq(dialog.position.y, y_mid, 0.01, "a refit mid-slide does not cut the slide short")
	# The buttons are live from the first frame: a key answers during the fade.
	assert_eq(main_ui.modal_stack.top_kind(), "event")
	assert_eq(main_ui.active_dialog_buttons.size(), 3)
	_press(KEY_W)
	await _frames(1)
	assert_eq(seen, ["opt1"], "W answered while the paper was still fading in")
	t.custom_step(GPaper.ARRIVE_SECONDS)
	assert_false(GPaper.arriving(dialog))
	assert_eq(dialog.modulate.a, 1.0)
	assert_almost_eq(dialog.position.y, GPaper.TOP, 0.01, "at rest at top 132")
	dialog.queue_free()
	await _frames(2)
	# An answer frees the dialog mid-fade: its tween goes with it.
	ed.present(_event("freed"))
	var d2: Control = ed._showing_dialog
	var t2: Tween = (d2.get_meta("g_arrive") if d2.has_meta("g_arrive") else null)
	assert_true(t2 != null and t2.is_running(), "the second paper is arriving")
	d2.queue_free()
	await _frames(2)
	assert_false(t2.is_valid(), "a freed paper's tween is gone with it")


func test_review_arrives_and_space_advances_during_the_fade() -> void:
	var main_ui: Node = await _boot()
	var ed = main_ui.event_dialog
	var seen := _hold_choices(main_ui, ed)
	ed.present(_review_event())
	var dialog: Control = ed._showing_dialog
	assert_eq(String(dialog.name), "GReviewPaper")
	assert_true(GPaper.arriving(dialog), "the review arrives with the same fade")
	var t: Tween = dialog.get_meta("g_arrive")
	t.pause()
	t.custom_step(GPaper.ARRIVE_SECONDS / 4.0)
	assert_lt(dialog.modulate.a, 1.0, "mid-fade")
	_press(KEY_SPACE)
	await _frames(1)
	assert_eq(seen, ["begin_planning"], "Space went through the door at once")
	t.custom_step(GPaper.ARRIVE_SECONDS)
	assert_almost_eq(dialog.position.y, 132.0, 0.01)
	dialog.queue_free()
	await _frames(2)


# --- P(Doom) arc and the room (6.2) ------------------------------------------------------------

func test_arc_eases_while_the_text_and_band_name_switch_at_once() -> void:
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	var card: GDoomCard = desk.doom_card
	card.update_from_state({"doom": 10.0})
	_finish(card._arc_tween)
	assert_almost_eq(card.shown_doom, 10.0, 0.001)
	card.update_from_state({"doom": 70.0})
	assert_true(card.arc_tweening(), "the arc tweens")
	card._arc_tween.pause()
	assert_eq(card._pct.text, "70.0%", "the % text switches at once (ADR-0015: never counts)")
	assert_eq(card._band_name.text, ThemeManager.get_doom_status_label(70.0), "the band name too")
	assert_eq(card.band_index, ThemeManager.get_doom_band_index(70.0), "and the ladder's band")
	assert_almost_eq(card.shown_doom, 10.0, 0.001, "the arc starts from the old value")
	card._arc_tween.custom_step(GDoomCard.ARC_SECONDS / 2.0)
	var mid := card.shown_doom
	assert_between(mid, 10.01, 69.99, "half way")
	assert_gt(mid, 40.0, "ease out: past half the way at half time")
	# A further change mid-tween starts from where the arc is drawn.
	card.update_from_state({"doom": 30.0})
	assert_almost_eq(card.shown_doom, mid, 0.001, "no jump back to 10 or on to 70")
	assert_eq(card._pct.text, "30.0%")
	card._arc_tween.pause()
	card._arc_tween.custom_step(GDoomCard.ARC_SECONDS)
	assert_almost_eq(card.shown_doom, 30.0, 0.001, "lands on the new value after 0.4 s")
	assert_false(card.arc_tweening())


func test_a_band_change_mid_tween_starts_from_where_the_room_is() -> void:
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	var room: GRoom = desk.room
	room.set_band(0, true)
	room.update_from_state({"doom": 60.0})
	var b := GRoom.band_for_doom(60.0)
	assert_gt(b, 0)
	var t: Tween = room._tween
	assert_not_null(t, "the room tweens to the new band")
	t.pause()
	t.custom_step(GRoom.TWEEN_S / 2.0)
	var mid := room.shown_band
	assert_between(mid, 0.01, float(b) - 0.01, "half way")
	room.update_from_state({"doom": 5.0})
	assert_almost_eq(room.shown_band, mid, 0.001, "the next band starts from the current value")
	room._tween.pause()
	room._tween.custom_step(GRoom.TWEEN_S)
	assert_almost_eq(room.shown_band, float(GRoom.band_for_doom(5.0)), 0.001)


# --- first-lever pulse (6.2, 5.13) -------------------------------------------------------------

func test_first_lever_pulse_runs_over_a_steady_ring() -> void:
	_lever_on()
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	assert_eq(desk.advisor_mode(), "lever")
	assert_eq(desk.plate_actions.theme_type_variation, &"GPlateHint", "the ACTIONS plate carries the amber ring")
	assert_true(desk._advisor_pulse != null and desk._advisor_pulse.is_valid(), "and pulses")
	desk.open_sheet("g_actions")
	_finish(desk.actions_panel._tween)
	assert_true(desk.actions_panel.hint_pulsing(), "the hinted row pulses")
	assert_true(desk.actions_panel.hint_ring_shown(), "over its own steady ring")
	desk.close_g_sheets()
	main_ui._clear_first_lever_nudge()
	assert_eq(desk.plate_actions.modulate.a, 1.0, "the pulse stops at full alpha")
	assert_ne(desk.plate_actions.theme_type_variation, &"GPlateHint", "and the ring goes")
	await _frames()


# --- reduced motion: every row takes its column (6.5) ---------------------------------------

func test_reduced_motion_every_row_takes_its_column() -> void:
	GPrefs.set_reduced_motion(true, false)
	_lever_on()
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	# First-lever: a steady ring, no pulse, on the plate and on the row.
	assert_eq(desk.plate_actions.theme_type_variation, &"GPlateHint", "plate: the steady ring")
	assert_true(desk._advisor_pulse == null, "plate: no pulse")
	assert_eq(desk.plate_actions.modulate.a, 1.0)
	# Sheet open and switch: instant.
	desk.open_sheet("g_actions")
	var sh: GSheet = desk.actions_panel
	assert_false(sh.opening(), "sheet: no fade")
	assert_eq(sh.modulate.a, 1.0)
	assert_almost_eq(sh.panel.position.x, sh._panel_base_x, 0.01, "sheet: no slide")
	await _frames(2)
	assert_true(desk.actions_panel.hint_ring_shown(), "row: the steady ring")
	assert_false(desk.actions_panel.hint_pulsing(), "row: no pulse")
	assert_eq(desk.actions_panel._hint_row.modulate.a, 1.0)
	desk.open_sheet("g_plan")
	assert_false(desk.plan_panel.opening(), "switch: no fade")
	desk.close_g_sheets()
	# PLAN <-> WATCH: no fade.
	_press(KEY_V)
	assert_true(desk.feed_panel.visible)
	assert_false(desk.view_fading(desk.feed_panel), "view: no fade")
	assert_eq(desk.feed_panel.modulate.a, 1.0)
	assert_eq(desk.playback_bar.modulate.a, 1.0)
	_press(KEY_V)
	# Event paper: there at once, at rest.
	var ed = main_ui.event_dialog
	_hold_choices(main_ui, ed)
	ed.present(_event("still"))
	var dialog: Control = ed._showing_dialog
	assert_false(GPaper.arriving(dialog), "paper: no fade")
	assert_eq(dialog.modulate.a, 1.0)
	assert_almost_eq(dialog.position.y, GPaper.TOP, 0.01, "paper: no slide")
	dialog.queue_free()
	await _frames(2)
	# P(Doom) arc: lands at once.
	desk.doom_card.update_from_state({"doom": 55.0})
	assert_false(desk.doom_card.arc_tweening(), "arc: no tween")
	assert_almost_eq(desk.doom_card.shown_doom, 55.0, 0.001)
	# Room: band at once, grain static.
	assert_true(desk.room.reduced_motion, "the room took the pref at attach")
	desk.room.update_from_state({"doom": 85.0})
	assert_almost_eq(desk.room.shown_band, float(GRoom.band_for_doom(85.0)), 0.001, "room: instant")
	assert_false(desk.room.is_processing(), "room: static grain")
	# Tier icon: swaps at once.
	var cell: GResourceCell = desk.resource_cells["research"]
	cell.set_amount(0.0)
	cell.set_amount(40.0)
	assert_false(cell.is_fading(), "tier: no crossfade")
	# Dateline: shown set, no sound.
	desk.dateline.type_text("AUGUST 1, 2017")
	assert_false(desk.dateline.typing(), "dateline: shown set")
	assert_false(desk.dateline.busy)


# --- pause (6.3) ----------------------------------------------------------------------------

func test_nothing_in_g_runs_while_the_tree_is_paused() -> void:
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	var nodes: Array = [desk]
	nodes.append_array(desk.find_children("*", "", true, false))
	assert_gt(nodes.size(), 50, "walked the whole desk")
	var always: Array = []
	for n in nodes:
		var pm: int = (n as Node).process_mode
		if pm != Node.PROCESS_MODE_INHERIT and pm != Node.PROCESS_MODE_PAUSABLE:
			always.append(String((n as Node).get_path()))
	assert_eq(always, [], "every node in GDesk is pausable (none ALWAYS, WHEN_PAUSED or DISABLED)")
	get_tree().paused = true
	var running: Array = []
	for n in nodes:
		if (n as Node).can_process():
			running.append(String((n as Node).get_path()))
	get_tree().paused = false
	assert_eq(running, [], "nothing in GDesk processes in pause")


func test_every_desk_tween_freezes_under_the_pause_menu_and_goes_on_after() -> void:
	_lever_on()
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	desk.room.set_band(0, true)
	desk.dateline.stop_typing()   # the new game's own type-on may still run
	desk.doom_card.update_from_state({"doom": 5.0})
	_finish(desk.doom_card._arc_tween)
	var cell: GResourceCell = desk.resource_cells["research"]
	cell.set_amount(0.0)
	# Start every desk motion in the same frame, then pause through the real menu (Esc).
	desk.room.update_from_state({"doom": 85.0})
	desk.doom_card.update_from_state({"doom": 65.0})
	cell.set_amount(40.0)
	_press(KEY_V)
	desk.dateline.type_text("AUGUST 1, 2017")
	assert_true(desk.dateline.typing())
	_press(KEY_ESCAPE)
	assert_true(main_ui.pause_menu.visible, "Esc with nothing open opens the pause menu")
	assert_true(get_tree().paused, "which pauses the tree")
	var snap := {
		"room": desk.room.shown_band, "arc": desk.doom_card.shown_doom,
		"tier": (cell.icon_rects()[1] as TextureRect).modulate.a,
		"feed": desk.feed_panel.modulate.a, "bar": desk.playback_bar.modulate.a,
		"dateline": desk.dateline.visible_count, "pulse": desk.plate_actions.modulate.a,
		"grain": desk.room.grain_step,
	}
	await _frames(30)
	var now := {
		"room": desk.room.shown_band, "arc": desk.doom_card.shown_doom,
		"tier": (cell.icon_rects()[1] as TextureRect).modulate.a,
		"feed": desk.feed_panel.modulate.a, "bar": desk.playback_bar.modulate.a,
		"dateline": desk.dateline.visible_count, "pulse": desk.plate_actions.modulate.a,
		"grain": desk.room.grain_step,
	}
	assert_eq(now, snap, "every G motion is frozen in pause")
	assert_true(desk.room._tween.is_valid() and desk.doom_card.arc_tweening() and cell.is_fading()
		and desk.view_fading(desk.feed_panel) and desk.dateline.typing(), "and still pending, not dropped")
	main_ui.pause_menu.hide()
	get_tree().paused = false
	var done := await _wait_until(func():
		return not desk.room._tween.is_valid() and not desk.doom_card.arc_tweening() \
			and not cell.is_fading() and not desk.view_fading(desk.feed_panel) \
			and not desk.view_fading(desk.playback_bar) and not desk.dateline.typing(), 900)
	assert_true(done, "after the pause every motion runs to its end")
	assert_almost_eq(desk.room.shown_band, float(GRoom.band_for_doom(85.0)), 0.001)
	assert_almost_eq(desk.doom_card.shown_doom, 65.0, 0.001)
	assert_eq(desk.feed_panel.modulate.a, 1.0)
	assert_eq(desk.dateline.text, "AUGUST 1, 2017")
	assert_true(desk.dateline.visible_count == -1 or desk.dateline.visible_count == "AUGUST 1, 2017".length(),
		"the date is typed out")
	assert_gt(desk.room.grain_step, int(snap["grain"]), "the grain moves again")
	_press(KEY_V)
	await _frames()


func test_sheet_and_paper_fades_freeze_in_pause() -> void:
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	desk.open_sheet("g_actions")
	get_tree().paused = true
	await _frames(20)
	assert_eq(desk.actions_panel.modulate.a, 0.0, "the sheet's fade is frozen")
	assert_true(desk.actions_panel.opening())
	get_tree().paused = false
	assert_true(await _wait_until(func(): return not desk.actions_panel.opening()), "and finishes after")
	assert_eq(desk.actions_panel.modulate.a, 1.0)
	desk.close_g_sheets()
	var ed = main_ui.event_dialog
	_hold_choices(main_ui, ed)
	ed.present(_event("paused"))
	var dialog: Control = ed._showing_dialog
	get_tree().paused = true
	assert_false(dialog.can_process(), "the paper (on the root) is pausable too")
	await _frames(20)
	assert_eq(dialog.modulate.a, 0.0, "the paper's arrival is frozen")
	get_tree().paused = false
	assert_true(await _wait_until(func(): return not GPaper.arriving(dialog)), "and finishes after")
	assert_eq(dialog.modulate.a, 1.0)
	assert_almost_eq(dialog.position.y, GPaper.TOP, 0.01)
	dialog.queue_free()
	await _frames(2)

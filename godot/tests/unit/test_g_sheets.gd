extends GutTest
## G desk phase 1b (fork/design/godot-g/spec.md 12.2 "1b"): the three sheets, standalone and
## on the real main.tscn. Close on Esc, x and their letter; Esc mid-open; Tab stays inside;
## an event replacing an open sheet; door return and its guards; E and F1 over a G sheet and
## over an event (V5); a saved bind on a G key (V7); the refusal toast from a sheet row (A5);
## blocked rows match today's refusals (A5); 1-9 parity; the fallback icons on the surfaces
## where their ids can appear (5.7.1, R3-3); the plain WATCH feed.

const MAIN_SCENE := "res://scenes/main.tscn"
const SHEET_SCENES := {
	"g_actions": "res://scenes/ui/g_actions_panel.tscn",
	"g_plan": "res://scenes/ui/g_plan_panel.tscn",
	"g_upgrades": "res://scenes/ui/g_upgrades_panel.tscn",
}
const LETTERS := {"g_actions": KEY_A, "g_plan": KEY_Q, "g_upgrades": KEY_U}

var _prev_hint: bool
var _root: Node = null


func before_each() -> void:
	_prev_hint = GameConfig.show_first_lever_hint
	GameConfig.show_first_lever_hint = false


func after_each() -> void:
	GameConfig.show_first_lever_hint = _prev_hint
	GAdvisorNote.plain_dismissed_this_session = false
	GPrefs.reload_prefs()
	GameManager.month_playback_active = false


# --- helpers -----------------------------------------------------------------------------

func _boot(desk_on: bool = true) -> Node:
	GPrefs.set_desk(desk_on, false)
	var root: Node = load(MAIN_SCENE).instantiate()
	add_child_autofree(root)
	_root = root
	var main_ui: Node = root.find_child("MainUI", true, false)
	for _i in range(120):
		await get_tree().process_frame
		if GameManager.is_initialized and String(main_ui.current_turn_phase).to_upper() == "ACTION_SELECTION":
			break
	await get_tree().process_frame
	await get_tree().process_frame
	return main_ui


func _press(code: int, shift := false) -> void:
	var ev := InputEventKey.new()
	ev.keycode = code
	ev.physical_keycode = code
	ev.shift_pressed = shift
	ev.pressed = true
	get_viewport().push_input(ev)
	var up := ev.duplicate() as InputEventKey
	up.pressed = false
	get_viewport().push_input(up)


func _frames(n: int = 2) -> void:
	for _i in range(n):
		await get_tree().process_frame


func _fake_event(main_ui: Node) -> Control:
	"""What EventDialog does when an event arrives: mount a panel and register it at
	PRIORITY_MUST_ANSWER through main_ui._on_event_dialog_opened."""
	var p := Panel.new()
	p.name = "FakeEvent"
	p.set_meta("is_event_dialog", true)
	get_tree().root.add_child(p)
	main_ui._on_event_dialog_opened(p, [])
	return p


func _play_rows(desk) -> Array:
	var out: Array = []
	for id in desk.actions_panel.row_ids():
		var st: Dictionary = desk.actions_panel.row_state(id)
		if not bool(st.get("door", false)) and not bool(st.get("coming_soon", false)):
			out.append(id)
	return out


# --- standalone (no host) ---------------------------------------------------------------

func test_each_sheet_closes_standalone_on_esc_and_x() -> void:
	for kind in SHEET_SCENES:
		var sh: GSheet = load(SHEET_SCENES[kind]).instantiate()
		add_child_autofree(sh)
		await _frames()
		sh.show_panel()
		assert_true(sh.visible, "%s shows" % kind)
		_press(KEY_ESCAPE)
		await _frames()
		assert_false(sh.visible, "%s closes on Esc with no host" % kind)
		sh.show_panel()
		sh.close_button.pressed.emit()
		assert_false(sh.visible, "%s closes on its x with no host" % kind)
		assert_eq(sh.barrier.mouse_filter, Control.MOUSE_FILTER_IGNORE, "%s barrier off when closed" % kind)


func test_a_closed_sheet_never_takes_esc() -> void:
	var sh: GSheet = load(SHEET_SCENES["g_actions"]).instantiate()
	add_child_autofree(sh)
	await _frames()
	var catcher := _EscCatcher.new()
	add_child_autofree(catcher)
	_press(KEY_ESCAPE)
	await _frames()
	assert_true(catcher.got_esc, "Esc passes a closed sheet by")


class _EscCatcher:
	extends Node
	var got_esc := false

	func _unhandled_input(event: InputEvent) -> void:
		if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
			got_esc = true


# --- live: open and close ---------------------------------------------------------------

func test_sheets_open_from_their_plates_and_close_on_esc_x_and_letter() -> void:
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	var plates := {"g_actions": desk.plate_actions, "g_upgrades": desk.plate_upgrades}
	for kind in ["g_actions", "g_plan", "g_upgrades"]:
		var sh: GSheet = desk.sheet_for(kind)
		# Esc
		assert_true(desk.open_sheet(kind), "%s opens" % kind)
		assert_eq(main_ui.modal_stack.top_kind(), kind, "%s is registered in ModalStack" % kind)
		assert_eq(main_ui.active_dialog_buttons, [], "no dialog letters map into a G sheet")
		_press(KEY_ESCAPE)
		await _frames()
		assert_false(sh.visible, "%s closes on Esc" % kind)
		assert_eq(main_ui.modal_stack.depth(), 0, "Esc closed only the sheet")
		assert_false(main_ui.pause_menu.visible, "Esc on a sheet does not open the menu")
		# x
		desk.open_sheet(kind)
		sh.close_button.pressed.emit()
		await _frames()
		assert_false(sh.visible, "%s closes on its x" % kind)
		assert_eq(main_ui.modal_stack.depth(), 0)
		# its letter, both ways
		_press(LETTERS[kind])
		await _frames()
		assert_true(sh.visible, "%s opens on its letter" % kind)
		_press(LETTERS[kind])
		await _frames()
		assert_false(sh.visible, "%s closes on its letter" % kind)
		# its plate, both ways
		if plates.has(kind):
			plates[kind].pressed.emit()
			await _frames()
			assert_true(sh.visible, "%s opens from its plate" % kind)
			assert_true(plates[kind]._lit, "its plate is lit while open")
			plates[kind].pressed.emit()
			await _frames()
			assert_false(sh.visible, "%s closes from its plate" % kind)


func test_letter_switches_between_sheets() -> void:
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	_press(KEY_A)
	await _frames()
	assert_true(desk.actions_panel.visible)
	_press(KEY_Q)
	await _frames()
	assert_false(desk.actions_panel.visible, "the old sheet closes at once")
	assert_true(desk.plan_panel.visible, "the new one opens")
	assert_eq(main_ui.modal_stack.depth(), 1, "one modal at a time")
	assert_eq(desk.attention_card.choose_button.text.begins_with("CLOSE PLAN"), true,
		"the Attention card offers CLOSE PLAN while the drawer is open")
	desk.attention_card.choose_button.pressed.emit()
	await _frames()
	assert_false(desk.plan_panel.visible, "CLOSE PLAN closes the drawer")


func test_esc_mid_open_closes_at_once() -> void:
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	desk.open_sheet("g_actions")
	assert_true(desk.actions_panel.opening(), "the 0.12 s open fade is running")
	_press(KEY_ESCAPE)
	await _frames(1)
	assert_false(desk.actions_panel.visible, "Esc mid-open hides it at once")
	assert_false(desk.actions_panel.opening(), "the fade was killed")
	assert_eq(desk.actions_panel.modulate.a, 1.0, "no half-faded state is left behind")
	assert_eq(main_ui.modal_stack.depth(), 0)


func test_tab_stays_inside_a_sheet() -> void:
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	for kind in ["g_actions", "g_plan"]:
		desk.open_sheet(kind)
		await _frames()
		var sh: GSheet = desk.sheet_for(kind)
		var f := get_viewport().gui_get_focus_owner()
		assert_not_null(f, "%s gives focus to its first control" % kind)
		var seen := {}
		for i in range(40):
			_press(KEY_TAB, i % 7 == 6)
			await _frames(1)
			f = get_viewport().gui_get_focus_owner()
			assert_true(f != null and sh.is_ancestor_of(f), "%s: Tab %d keeps focus inside (%s)" % [
				kind, i, f])
			if f != null:
				seen[f.get_instance_id()] = true
		assert_gt(seen.size(), 1, "%s: Tab moves between controls" % kind)
		desk.close_sheet(kind)
		await _frames()
		assert_null(get_viewport().gui_get_focus_owner(), "closing releases focus")


func test_an_event_replaces_an_open_sheet() -> void:
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	desk.open_sheet("g_plan")
	var ev := _fake_event(main_ui)
	await _frames()
	assert_false(desk.plan_panel.visible, "the event popped the sheet")
	assert_eq(main_ui.modal_stack.top_kind(), "event")
	assert_eq(desk.plan_panel.barrier.mouse_filter, Control.MOUSE_FILTER_IGNORE, "no live barrier left")
	assert_false(desk.open_sheet("g_actions"), "no sheet opens over an unanswered event")
	_press(KEY_A)
	await _frames()
	assert_false(desk.actions_panel.visible, "A over an event does nothing")
	ev.queue_free()
	await _frames()


func test_action_rows_have_no_tooltip_the_detail_card_shows_the_description() -> void:
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	desk.open_sheet("g_actions")
	await _frames()
	for id in _play_rows(desk):
		var row: Button = desk.actions_panel.row_for(id)
		assert_eq(row.tooltip_text, "", "%s: no hover tooltip over the next row" % id)
	var row6: Button = desk.actions_panel.row_for("buy_compute")
	assert_not_null(row6, "Purchase Compute has a row")
	row6.mouse_entered.emit()
	await _frames()
	var want := String(GameActions.get_action_by_id("buy_compute").get("description", ""))
	assert_ne(want, "", "the action has a description")
	assert_eq(desk.actions_panel.detail_id, "buy_compute", "hover shows the row in the detail card")
	assert_eq(desk.actions_panel._d_desc.text, want, "the card carries the description")


# --- doors (spec 5.7.4) -------------------------------------------------------------------

func test_door_from_the_sheet_returns_to_the_sheet() -> void:
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	desk.open_sheet("g_actions")
	await _frames()
	var row: Button = desk.actions_panel.row_for("scouting")
	assert_not_null(row, "the Scouting door has a row")
	row.pressed.emit()
	await _frames()
	assert_false(desk.actions_panel.visible, "the submenu popped the sheet")
	assert_eq(String(main_ui.active_dialog.get_meta("submenu_id", "")), "scouting", "today's submenu")
	assert_gt(main_ui.active_dialog.position.x, 860.0, "it sits beside the sheet's right edge")
	_press(KEY_ESCAPE)
	await _frames(3)
	assert_true(desk.actions_panel.visible, "Esc from a door goes back to the sheet")
	assert_eq(main_ui.modal_stack.top_kind(), "g_actions")
	_press(KEY_ESCAPE)
	await _frames()
	assert_false(desk.actions_panel.visible, "Esc again goes to the desk")
	assert_eq(main_ui.modal_stack.depth(), 0)


func test_picking_a_choice_returns_to_the_sheet_with_the_play_queued() -> void:
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	desk.open_sheet("g_actions")
	desk.actions_panel.press_row("scouting")
	await _frames()
	var opts := GameActions.get_scouting_options()
	var idx := -1
	for i in range(opts.size()):
		if String(opts[i].get("id", "")) == "scout_read":
			idx = i
	var before: int = main_ui.plan_controller.queue_size()
	(main_ui.active_dialog_buttons[idx] as Button).pressed.emit()
	await _frames(3)
	assert_eq(main_ui.plan_controller.queue_size(), before + 1, "the choice was queued")
	assert_true(desk.actions_panel.visible, "and the sheet is back")
	assert_eq(desk.actions_panel.row_state("scouting").get("door"), true)


func test_door_return_guards() -> void:
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	# (a) a door opened by its hotkey with the sheet closed does not return to the sheet.
	main_ui._toggle_submenu("fundraise")
	await _frames()
	_press(KEY_ESCAPE)
	await _frames(3)
	assert_false(desk.actions_panel.visible, "(a) only a door the sheet opened returns")
	# (c) a newer modal on top when the door closes: no return.
	desk.open_sheet("g_actions")
	desk.actions_panel.press_row("scouting")
	await _frames()
	main_ui._show_ledger_screen()   # replaces the submenu
	await _frames(3)
	assert_false(desk.actions_panel.visible, "(c) a newer modal holds the top: no return")
	main_ui.modal_stack.dismiss_all()
	await _frames()
	# (d) the phase left the plan: no return.
	desk.open_sheet("g_actions")
	desk.actions_panel.press_row("scouting")
	await _frames()
	var phase: String = main_ui.current_turn_phase
	main_ui.current_turn_phase = "turn_end"
	_press(KEY_ESCAPE)
	await _frames(3)
	assert_false(desk.actions_panel.visible, "(d) not the plan: no return")
	main_ui.current_turn_phase = phase
	# (b) the layout left g: no return, nothing re-presented on a freed desk.
	desk.open_sheet("g_actions")
	desk.actions_panel.press_row("scouting")
	await _frames()
	main_ui._apply_ui_layout("classic")
	await _frames(3)
	assert_null(main_ui.get_g_desk(), "(b) the desk is gone")
	main_ui.modal_stack.dismiss_all()
	await _frames(3)
	assert_true(main_ui.modal_stack.depth() == 0, "(b) nothing came back")


# --- E and F1 (V5) --------------------------------------------------------------------------

func test_e_and_f1_over_a_g_sheet() -> void:
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	desk.open_sheet("g_actions")
	_press(KEY_F1)
	await _frames()
	assert_eq(main_ui.modal_stack.top_kind(), "g_guide", "F1 over a sheet opens the guide")
	assert_false(desk.actions_panel.visible, "the guide replaced the sheet")
	_press(KEY_F1)
	await _frames()
	assert_false(desk.guide_open(), "F1 with the guide on top closes it")
	desk.open_sheet("g_upgrades")
	_press(KEY_E)
	await _frames()
	assert_false(main_ui.visible, "E opened the Employee screen")
	assert_eq(main_ui.modal_stack.depth(), 0, "E first closed the G sheet (nothing left behind)")
	assert_false(desk.upgrades_panel.visible)
	main_ui.tab_manager.show_main_screen()
	await _frames()


func test_e_and_f1_do_nothing_over_an_event() -> void:
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	var ev := _fake_event(main_ui)
	await _frames()
	_press(KEY_E)
	await _frames()
	assert_true(main_ui.visible, "E over an event does not open Staff")
	_press(KEY_F1)
	await _frames()
	assert_false(desk.guide_open(), "F1 over an event does not open the guide")
	assert_eq(main_ui.modal_stack.top_kind(), "event", "the event still holds the top")
	ev.queue_free()
	await _frames()


# --- V7: a saved bind on a G key wins -------------------------------------------------------

func test_saved_commit_on_a_wins_over_the_actions_key() -> void:
	var old_key: int = int(KeybindManager.keybinds["commit_plan"]["key"])
	KeybindManager.rebind("commit_plan", KEY_A)
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	assert_true(desk.skipped_binds.has("g_actions"), "the G bind on A is skipped")
	assert_false(desk.plate_actions.keycap_shown(), "the Actions plate shows no key")
	_press(KEY_A)
	await _frames(3)
	assert_false(desk.actions_panel.visible, "A did not open the sheet")
	assert_ne(String(main_ui.current_turn_phase).to_upper(), "ACTION_SELECTION", "A committed the plan")
	KeybindManager.rebind("commit_plan", old_key)
	assert_false(desk.skipped_binds.has("g_actions"), "rebinding back frees A for G")
	# Stop the committed month's playback so its pending tick never reaches the next boot.
	GameManager.month_playback_active = false
	await get_tree().create_timer(GameManager.day_tick_seconds + 0.1, false).timeout


# --- refusal toast from a sheet row (A5) --------------------------------------------------

func test_unaffordable_row_click_shows_the_g_toast() -> void:
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	desk.open_sheet("g_actions")
	await _frames()
	var st: Dictionary = desk.actions_panel.row_state("publish_paper")
	assert_true(bool(st.get("blocked", false)), "Publish Safety Paper is blocked at the start (no research)")
	assert_true(String(st.get("reason", "")).ends_with("research short"), "reason names the shortfall: %s" % st.get("reason"))
	var before: int = main_ui.plan_controller.queue_size()
	desk.actions_panel.row_for("publish_paper").pressed.emit()
	await _frames()
	assert_eq(main_ui.plan_controller.queue_size(), before, "today's handler refused it")
	assert_true(desk.toast.visible, "the refusal shows in the G toast over the sheet")
	assert_string_contains(desk.toast.message_text(), "Cannot afford")
	GameManager.error_occurred.emit("Backend says no")
	assert_eq(desk.toast.message_text(), "[!] Backend says no", "a backend rejection shows too")


# --- blocked rows match today's refusals (A5) ---------------------------------------------

func _check_rows_match_refusals(main_ui, desk, label: String) -> void:
	for id in _play_rows(desk):
		desk.actions_panel.refresh()
		var blocked: bool = bool(desk.actions_panel.row_state(id).get("blocked", false))
		var before: int = main_ui.plan_controller.queue_size()
		var name := String(GameActions.get_action_by_id(id).get("name", id))
		main_ui._on_dynamic_action_pressed(id, name)
		var accepted: bool = main_ui.plan_controller.queue_size() == before + 1
		assert_eq(blocked, not accepted, "%s: %s shown %s, today's click %s" % [
			label, id, "blocked" if blocked else "live", "accepted" if accepted else "refused"])
		if accepted:
			main_ui._remove_queued_action(id, name)


func test_blocked_rows_match_refusals_empty_queue() -> void:
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	desk.open_sheet("g_actions")
	assert_gt(_play_rows(desk).size(), 3, "there are plays to check")
	_check_rows_match_refusals(main_ui, desk, "empty queue")


func test_blocked_rows_match_refusals_reserved_pool() -> void:
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	# Hold operating hours until the Reserve button says no more, so the aggregate check bites.
	for _i in range(40):
		if main_ui.reserve_ap_button.disabled:
			break
		main_ui._on_reserve_ap_button_pressed()
		await _frames(1)
	desk.open_sheet("g_actions")
	_check_rows_match_refusals(main_ui, desk, "reserved pool")
	# And with the planning hours spent down too: queue plays until one is refused.
	for _round in range(3):
		for id in _play_rows(desk):
			main_ui._on_dynamic_action_pressed(id, String(GameActions.get_action_by_id(id).get("name", id)))
	_check_rows_match_refusals(main_ui, desk, "hours spent")


func test_blocked_rows_match_refusals_unaffordable_action() -> void:
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	desk.open_sheet("g_actions")
	var st: Dictionary = desk.actions_panel.row_state("publish_paper")
	assert_true(bool(st.blocked) and String(st.reason).contains("short"))
	_check_rows_match_refusals(main_ui, desk, "unaffordable")
	# Spend money down with Purchase Compute (admission does not deduct queued costs, so the
	# money check stays on current money: rows stay as they are -- exactly as today).
	for _i in range(3):
		main_ui._on_dynamic_action_pressed("buy_compute", "Purchase Compute")
	_check_rows_match_refusals(main_ui, desk, "after three buys")


# --- 1-9 parity ---------------------------------------------------------------------------

func _slot_ids(main_ui) -> Array:
	var out: Array = []
	for c in main_ui.actions_list.get_children():
		if c is Container:
			for b in c.get_children():
				out.append(String(b.get_meta("action_id", "")))
			break
	return out


func test_number_slots_queue_the_same_action_as_the_classic_bar() -> void:
	var classic_ui: Node = await _boot(false)
	var classic_slots := _slot_ids(classic_ui)
	var i := classic_slots.find("buy_compute")
	assert_true(i >= 0 and i < 9, "Purchase Compute is in slots 1-9 (slot %d)" % (i + 1))
	_press(KEY_1 + i)
	await _frames()
	var classic_last := String(classic_ui.plan_controller.queued_actions[-1].get("id", ""))
	GameManager.month_playback_active = false
	_root.queue_free()
	await _frames(3)

	var main_ui: Node = await _boot(true)
	var desk = main_ui.get_g_desk()
	assert_eq(desk.actions_panel.row_ids(), _slot_ids(main_ui), "the sheet lists the grid's ids in order")
	assert_eq(_slot_ids(main_ui), classic_slots, "the same slots as the classic bar")
	desk.open_sheet("g_actions")
	await _frames()
	_press(KEY_1 + i)
	await _frames()
	assert_true(desk.actions_panel.visible, "a play keeps the sheet open")
	assert_eq(String(main_ui.plan_controller.queued_actions[-1].get("id", "")), classic_last,
		"key %d in the sheet queues the same action as the classic bar" % (i + 1))
	var row: Button = desk.actions_panel.row_for("buy_compute")
	var kc: Label = row.get_node("H/Slot").get_meta("label")
	assert_eq(kc.text, str(i + 1), "the row's keycap names its slot")


# --- fallback icons on their surfaces (5.7.1, R3-3) ---------------------------------------

func _surfaces(id: String) -> Array:
	"""From the data: Actions sheet for top-level actions, the submenu grid for choices of a
	grid submenu, the Plan drawer for anything that can enter the queue (a play)."""
	var out: Array = []
	var top_level := false
	for a in GameActions.get_all_actions():
		if String(a.get("id", "")) == id:
			top_level = true
	if top_level:
		out.append("actions_sheet")
	var parent := ""
	for sub in SubmenuController.GRID_CONFIG.keys():
		var probe = SubmenuController.new(null, null)
		for o in probe._options_for(sub):
			if String(o.get("id", "")) == id:
				parent = sub
	if parent != "":
		out.append("submenu:" + parent)
	var a := GameActions.get_action_by_id(id)
	if not a.is_empty() and not bool(a.get("is_submenu", false)) \
			and not ActionBarRenderer.COMING_SOON_ACTION_IDS.has(id):
		out.append("plan_drawer")
	return out


func test_fallback_icons_render_on_their_surfaces() -> void:
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	for id in GIcons.FALLBACKS:
		var want: String = GIcons.ICON_ROOT + String(GIcons.FALLBACKS[id])
		var surfaces := _surfaces(id)
		assert_false(surfaces.is_empty(), "%s has at least one surface" % id)
		for s in surfaces:
			if s == "actions_sheet":
				desk.open_sheet("g_actions")
				await _frames()
				var row: Button = desk.actions_panel.row_for(id)
				var ic: TextureRect = row.find_child("Icon", true, false)
				assert_eq(ic.texture.resource_path, want, "%s on the Actions sheet" % id)
				desk.close_sheet("g_actions")
			elif s.begins_with("submenu:"):
				var sub := String(s).substr(8)
				desk.open_sheet("g_actions")
				desk.actions_panel.press_row(sub)
				await _frames()
				var opts := SubmenuController.new(null, null)._options_for(sub)
				var idx := -1
				for k in range(opts.size()):
					if String(opts[k].get("id", "")) == id:
						idx = k
				var btn: Button = main_ui.active_dialog_buttons[idx]
				assert_not_null(btn.icon, "%s has an icon in the %s grid" % [id, sub])
				assert_eq(btn.icon.resource_path, want, "%s in the %s grid is G's fallback" % [id, sub])
				btn.pressed.emit()   # queue it, so the drawer check below has it
				await _frames(3)
				main_ui.modal_stack.dismiss_all()
				await _frames()
			elif s == "plan_drawer":
				if main_ui.plan_controller.queued_actions.filter(func(q): return q.id == id).is_empty():
					continue  # only reachable through its submenu, checked above
				desk.open_sheet("g_plan")
				await _frames()
				var found := false
				for k in range(desk.plan_panel.row_count()):
					var t: Texture2D = desk.plan_panel.row_icon(k)
					if String(main_ui.plan_controller.queued_actions[k].id) == id:
						assert_eq(t.resource_path, want, "%s in the Plan drawer" % id)
						found = true
				assert_true(found, "%s has a Plan drawer row" % id)
				desk.close_sheet("g_plan")
	assert_eq(_surfaces("scout_read"), ["submenu:scouting", "plan_drawer"])
	assert_eq(_surfaces("tour_offices"), ["submenu:office", "plan_drawer"])
	assert_true(_surfaces("advertise").has("actions_sheet"), "top-level ids are checked on the sheet")


func test_classic_grid_keeps_todays_icons() -> void:
	var main_ui: Node = await _boot(false)
	main_ui._open_submenu("scouting")
	await _frames()
	var opts := GameActions.get_scouting_options()
	for k in range(opts.size()):
		var id := String(opts[k].get("id", ""))
		var btn: Button = main_ui.active_dialog_buttons[k]
		assert_eq(btn.icon, IconLoader.get_action_icon(id), "classic %s keeps IconLoader's icon" % id)
	main_ui.modal_stack.dismiss_all()


# --- Plan drawer and Upgrades ------------------------------------------------------------

func test_plan_drawer_lists_the_queue_and_runs_todays_handlers() -> void:
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	for _i in range(2):
		main_ui._on_dynamic_action_pressed("buy_compute", "Purchase Compute")
	main_ui._on_dynamic_action_pressed("scout_read", "Read the Literature")
	desk.open_sheet("g_plan")
	await _frames()
	assert_eq(desk.plan_panel.row_count(), 3, "one row per queued play")
	assert_false(desk.plan_panel.undo_button.disabled, "UNDO mirrors today's button")
	desk.plan_panel.remove_entry("buy_compute", "Purchase Compute")
	assert_eq(main_ui.plan_controller.queue_size(), 2, "x removed one copy")
	assert_eq(String(main_ui.plan_controller.queued_actions[0].id), "buy_compute",
		"it removed the FIRST copy, as today's tiles do")
	_press(KEY_Z)
	await _frames()
	assert_eq(main_ui.plan_controller.queue_size(), 1, "Z in the drawer undoes the last play")
	_press(KEY_C)
	await _frames()
	assert_eq(main_ui.plan_controller.queue_size(), 0, "C in the drawer clears")
	assert_true(desk.plan_panel.undo_button.disabled, "UNDO disabled on an empty queue, as today")
	var held_before: int = int(GameManager.state.month_plan.attention_reserved)
	_press(KEY_R)
	await _frames()
	assert_eq(int(GameManager.state.month_plan.attention_reserved), held_before + 1, "R reserves 1 hour")
	assert_true(desk.plan_panel.visible, "the drawer stays open throughout")
	var rqs = main_ui.research_quality_selector
	assert_true(desk.plan_panel.is_ancestor_of(rqs), "today's research-quality selector is in the drawer")
	assert_true(rqs.g_style, "with the G style flag on")


func test_upgrades_sheet_hosts_todays_list_with_g_rows() -> void:
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	assert_true(desk.upgrades_panel.is_ancestor_of(main_ui.upgrades_list), "today's list is in the sheet")
	desk.open_sheet("g_upgrades")
	await _frames()
	var rows: Array = main_ui.upgrades_list.get_children().filter(func(c): return not c.is_queued_for_deletion())
	assert_gt(rows.size(), 0, "upgrades are listed")
	for b in rows:
		assert_eq(String((b as Button).theme_type_variation), "GUpgradeRow", "G row path (A4)")
		assert_eq((b as Button).modulate, Color(1, 1, 1, 1), "no modulate dimming in G")
	# Leaving g puts the nodes back where they were.
	var parent_classic: Node = main_ui.plan_screen
	main_ui._apply_ui_layout("classic")
	await _frames()
	assert_eq(main_ui.plan_screen.upgrades_scroll.get_parent(), parent_classic, "upgrades back in the plan screen")
	assert_eq(main_ui.research_quality_selector.get_parent(), parent_classic, "selector back")
	assert_false(main_ui.research_quality_selector.g_style, "G style off in classic")


# --- the advisor's pulse reaches the row (5.13) -----------------------------------------

func test_advisor_pulses_the_hinted_row_inside_the_sheet() -> void:
	GameConfig.show_first_lever_hint = true
	GameConfig.first_lever_action_id = "scouting"
	GAdvisorNote.dismissed_this_session = false
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	desk.open_sheet("g_actions")
	await _frames()
	assert_true(desk.actions_panel.hint_pulsing(), "the Scouting row pulses")
	main_ui._clear_first_lever_nudge()
	await _frames()
	assert_false(desk.actions_panel.hint_pulsing(), "first_lever_cleared stops it")
	GameConfig.first_lever_action_id = ""


func test_opening_the_sheet_with_the_nudge_scrolls_the_glowing_row_into_view() -> void:
	# The advisor points the player at "the glowing button"; at 1080p the Scouting row starts
	# below the fold, so the sheet must scroll it into view when it opens with the nudge on.
	GameConfig.show_first_lever_hint = true
	GameConfig.first_lever_action_id = "scouting"
	GAdvisorNote.dismissed_this_session = false
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	var ap = desk.actions_panel
	# Make the sheet end at y 600 so the row is below the fold whatever the test window is.
	ap.panel.offset_bottom = 600.0 - desk.get_viewport_rect().size.y
	ap._scroll.scroll_vertical = 0
	desk.open_sheet("g_actions")
	await _frames(6)
	var row: Control = ap.row_for("scouting")
	var view: Rect2 = ap._scroll.get_global_rect()
	assert_gt(ap._scroll.scroll_vertical, 0, "the list had to scroll to show the row")
	assert_true(view.encloses(row.get_global_rect()),
		"the pulsing row %s is inside the list's visible rect %s" % [row.get_global_rect(), view])
	assert_true(ap.hint_pulsing(), "and it is the pulsing row")
	assert_true(row.has_focus(), "the glowing row takes the focus, so the card describes it")
	assert_eq(ap.detail_id, "scouting", "the detail card shows the row in view")
	# Without the nudge the sheet opens where it was (no scroll of its own).
	desk.close_sheet("g_actions")
	main_ui._clear_first_lever_nudge()
	await _frames()
	ap._scroll.scroll_vertical = 0
	desk.open_sheet("g_actions")
	await _frames(6)
	assert_eq(ap._scroll.scroll_vertical, 0, "no nudge: the list stays at the top")
	GameConfig.first_lever_action_id = ""


# --- plain WATCH feed (orchestrator addition 2) ----------------------------------------

func test_feed_panel_shows_in_watch_from_todays_feed_lines() -> void:
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	assert_false(desk.feed_panel.visible, "PLAN: no feed")
	main_ui.screen_mode.toggle_mode()
	await _frames()
	assert_true(desk.feed_panel.visible, "WATCH: the feed shows")
	main_ui.log_message("[color=cyan]G feed probe[/color]")
	await _frames()
	assert_string_contains(desk.feed_panel.plain_text(), "G feed probe", "a new line reaches the G feed")
	main_ui.log_message("hidden flavour line", "flavour")
	await _frames()
	assert_false(desk.feed_panel.plain_text().contains("hidden flavour line"), "today's filter applies")
	main_ui.screen_mode.toggle_mode()


func test_strips_span_the_full_width() -> void:
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	var vw: float = desk.size.x
	assert_almost_eq(desk.top_strip.get_rect().end.x, vw, 1.0, "TopStrip L,T,R")
	assert_almost_eq(desk.banner.get_rect().end.x, vw, 1.0, "Banner L,T,R")
	assert_almost_eq(desk.bottom_strip.get_rect().end.x, vw, 1.0, "BottomStrip L,B,R")
	var commit_r: Rect2 = desk.commit_plate.get_global_rect()
	assert_almost_eq(commit_r.end.x, vw - 24.0, 2.0, "Commit plate anchored bottom-right")
	assert_gt(desk.held_plate.get_global_rect().position.x, vw / 2.0, "held plate bottom-right")


func test_sheet_plates_show_their_keys_only_in_the_plan() -> void:
	# The plates start disabled until the first plan phase; their keycaps must follow the
	# phase, not the state at build time (a month-1 shot showed ACTIONS without its A).
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	assert_false(desk.plate_actions.disabled, "PLAN: ACTIONS is live")
	assert_true(desk.plate_actions.keycap_shown(), "PLAN: ACTIONS shows A")
	assert_true(desk.plate_upgrades.keycap_shown(), "PLAN: UPGRADES shows U")
	var prev = main_ui.current_turn_phase
	main_ui.current_turn_phase = "turn_end"
	desk._refresh_phase()
	assert_true(desk.plate_actions.disabled, "outside the plan ACTIONS rests")
	assert_false(desk.plate_actions.keycap_shown(), "and shows no key")
	assert_false(desk.plate_upgrades.keycap_shown())
	main_ui.current_turn_phase = prev
	desk._refresh_phase()
	assert_true(desk.plate_actions.keycap_shown(), "back in the plan the key returns")


# --- scope review fixes: today's readouts kept in G -----------------------------------------

func _shown_left(desk) -> int:
	return int(String(desk.attention_card._left.text).split(" ")[0])


func _lit(desk) -> int:
	var n := 0
	for c in desk.attention_card._cells.get_children():
		if is_equal_approx((c as ColorRect).color.a, 1.0):
			n += 1
	return n


func test_fit_line_leaves_out_hours_for_a_play_that_costs_none() -> void:
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	var ap = desk.actions_panel
	var compute := GameActions.get_action_by_id("buy_compute")
	assert_eq(GameActions.attention_cost(compute), 0, "Purchase Compute costs no hours")
	assert_false(ap.fit_line(compute).contains("hours"), "no hours part: %s" % ap.fit_line(compute))
	assert_string_contains(ap.fit_line(compute), "left after the plan so far")
	var read := GameActions.get_action_by_id("scout_read")
	assert_string_contains(ap.fit_line(read), "hours left", "a play with hours keeps it")
	assert_false(ap.fit_line(read).contains("planning"), "the total, no per-pool figure (Q1)")


func test_hours_left_follow_the_queue_and_agree_with_the_held_plate() -> void:
	# Q1 (Alex 2026-11-22): one figure, the TOTAL hours left -- the game's own aggregate,
	# MonthPlan.available() (total - spent - reserved; select_action puts a queued play's
	# hours into spent). No per-pool "left".
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	desk.open_sheet("g_actions")
	await _frames()
	var gs = GameManager.state
	var h0: int = gs.month_plan.available()
	assert_eq(_shown_left(desk), h0, "empty queue: the game's own available hours")
	assert_eq(GAttentionCard.hours_left(main_ui._last_state), int(main_ui._last_state.get("attention", -1)),
		"the same figure as the state's attention")
	assert_eq(desk.attention_card.get("_plan_left"), null, "no per-pool N left on the card")
	assert_eq(desk.attention_card.get("_op_left"), null)
	main_ui._on_dynamic_action_pressed("scout_read", "Read the Literature")      # 1 planning hr
	main_ui._on_dynamic_action_pressed("scout_meetups", "Go to Meetups")         # 1 operating hr
	await _frames()
	assert_eq(main_ui.plan_controller.queue_size(), 2, "both plays queued")
	assert_eq(gs.month_plan.available(), h0 - 2, "the game counts the queue once")
	assert_eq(_shown_left(desk), h0 - 2, "the card's total drops with the queue, once")
	assert_eq(desk.actions_panel.header_right.text, "Hours left: %d" % (h0 - 2),
		"the sheet header agrees, one figure")
	var mp: Dictionary = main_ui._last_state.get("month_plan", {})
	assert_eq(desk.attention_card.get("_plan_cells"), null, "no planning bar")
	assert_eq(desk.attention_card.get("_op_cells"), null, "no operating bar")
	assert_eq(desk.attention_card._cells.get_child_count(), int(mp.attention_total),
		"one bar: a cell per hour of the month's total")
	assert_eq(_lit(desk), h0 - 2, "lit cells = hours left, the readout's figure")
	var held := int(String(desk.held_value.text).split(" ")[2])
	assert_eq(held, h0 - 2, "the total agrees with the held plate's figure")
	main_ui._on_clear_queue_button_pressed()
	await _frames()
	assert_eq(_shown_left(desk), h0, "clearing the queue gives them back")
	assert_eq(_lit(desk), h0, "and the bar follows")


func test_watch_shows_the_held_hours_not_the_plan_rows() -> void:
	# After Commit the queue is gone and today's game never booked its hours into the typed
	# pools, so WATCH hides the PLAN-face rows (until 1c) and shows the held hours that remain
	# -- the number classic's WATCH strip shows ("reserve N") -- on the card and the plate.
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	var card = desk.attention_card
	var st: Dictionary = main_ui._last_state.duplicate(true)
	st["month_plan"]["attention_total"] = 20
	st["month_plan"]["attention_spent"] = 3
	st["month_plan"]["attention_reserved"] = 17
	card.update_plan_face(st, [], {}, false)
	assert_true(card._left_row.visible, "PLAN: the hours bar and the total hours left")
	assert_eq(card._left.text, "0 hr", "20 - 3 spent - 17 reserved")
	assert_eq(card._reserved.text, "Reserved: 17 hr", "PLAN: the plan-time reserve (classic's 'N reserved')")
	card.update_plan_face(st, [], {}, true)
	assert_false(card._left_row.visible, "WATCH: no hours bar or figure (held hours instead, until 1c)")
	assert_true(card._reserved.visible, "WATCH: the held hours show")
	main_ui.screen_mode.update_from_state(st)
	assert_eq(main_ui.screen_mode._reserve_label.text, "reserve 17", "classic's WATCH strip says 17")
	assert_eq(card._reserved.text, "Reserved: 17 hr", "and so does the card")
	st["month_plan"]["attention_reserved"] = 0
	card.update_plan_face(st, [], {}, true)
	main_ui.screen_mode.update_from_state(st)
	assert_eq(main_ui.screen_mode._reserve_label.text, "reserve 17", "nothing reserved: classic shows total - spent")
	assert_eq(card._reserved.text, "Reserved: 17 hr", "the card follows the same rule")
	# The held plate stays up in WATCH with the same number.
	st["month_plan"]["attention_reserved"] = 12
	desk._last_state = st
	main_ui.screen_mode.toggle_mode()
	desk._refresh_held()
	assert_true(desk.held_plate.visible, "WATCH: the held plate stays")
	assert_eq(desk.held_value.text, "12 hr", "with the held hours that remain")
	main_ui.screen_mode.toggle_mode()
	main_ui.screen_mode.update_from_state(main_ui._last_state)


func test_doom_card_carries_todays_lose_line() -> void:
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	var ex: Label = main_ui.find_child("ExplanationLabel", true, false)
	assert_not_null(ex, "classic's lose line exists")
	assert_false(ex.is_visible_in_tree(), "and is hidden in G with the classic chrome")
	var lose: Label = desk.doom_card.lose_label
	assert_eq(lose.text, ex.text, "the same text, read from the classic label")
	assert_true(lose.is_visible_in_tree(), "shown on the P(Doom) card")
	assert_eq(lose.get_theme_color("font_color"), GDesk.C.muted, "in muted text")
	assert_gte(GDesk.contrast_ratio(GDesk.C.muted, GDesk.C.panel_solid), 4.5, "which reaches 4.5:1")
	assert_lte(lose.get_global_rect().end.y, desk.doom_card.get_global_rect().end.y + 0.5,
		"inside the card")


func test_ledger_plate_shows_todays_due_soon_warning() -> void:
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	var ls = main_ui.ledger_screen
	var t := int(main_ui._last_state.get("turn", 0))
	ls.update_summary({"outstanding_payable": 40000.0, "soonest_fuse": 1, "secret_count": 0,
		"entries": []}, t)
	desk._refresh_ledger_plate()
	assert_true(ls.summary_due_soon(), "classic shows the [!] due-soon warning")
	assert_eq(desk.plate_ledger.get_status(), "[!] " + ls.summary_word(), "the plate carries it")
	assert_true(String(desk.plate_ledger.tooltip_text).begins_with("[!] Ledger:"),
		"the full classic line is the plate's tooltip")
	assert_string_contains(String(desk.plate_ledger.tooltip_text), "due")
	assert_eq(desk.plate_ledger.tooltip_text, ls.summary_text(), "read from the summary, not retyped")
	ls.update_summary({"outstanding_payable": 40000.0, "soonest_fuse": 6, "secret_count": 0,
		"entries": []}, t)
	desk._refresh_ledger_plate()
	assert_false(String(desk.plate_ledger.get_status()).begins_with("[!]"), "no warning when not due soon")
	ls.update_summary({}, t)
	desk._refresh_ledger_plate()
	assert_eq(desk.plate_ledger.get_status(), "clean")


func test_resource_cells_carry_todays_last_turn_chips() -> void:
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	assert_false(desk.resource_chips.has("doom"), "no doom delta chip (ADR-0015)")
	assert_eq(desk.resource_chips.keys(), ["money", "compute", "reputation"])
	var st: Dictionary = main_ui._last_state.duplicate(true)
	var t := int(st.get("turn", 0)) + 100
	st["turn"] = t
	main_ui._update_delta_chips(st)
	var nxt := st.duplicate(true)
	nxt["turn"] = t + 1
	nxt["money"] = float(st.get("money", 0)) - 1500.0
	nxt["compute"] = float(st.get("compute", 0)) + 50.0
	main_ui._update_delta_chips(nxt)
	desk._refresh_delta_chips()
	for key in ["money", "compute", "reputation"]:
		var src: Label = main_ui._delta_labels[key]
		var chip: Label = desk.resource_chips[key]
		assert_eq(chip.text, src.text, "%s chip text is classic's" % key)
		assert_eq(chip.visible, src.text != "", "%s chip shows only with a change" % key)
		if src.text != "":
			assert_eq(chip.get_theme_color("font_color"), src.get_theme_color("font_color"),
				"%s chip colour is classic's" % key)
	assert_true(desk.resource_chips["money"].visible, "a money change shows")
	assert_string_contains(desk.resource_chips["money"].text, "-")


func test_hint_scroll_lands_on_a_whole_row() -> void:
	# The hint reveal never leaves a row cut by the top edge of the Actions list.
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	var ap = desk.actions_panel
	desk.open_sheet("g_actions")
	await _frames()
	await ap.reveal_hint()
	await _frames()
	var v: int = ap._scroll.scroll_vertical
	var tops := [0]
	for r in ap._list.get_children():
		tops.append(int(round((r as Control).position.y)))
	assert_true(tops.has(v), "scroll %d lands on a row top %s" % [v, str(tops)])
	# Forced: from a scroll in the middle of a row, the snap moves to the next row's top.
	var rows: Array = ap._list.get_children()
	assert_gt(rows.size(), 2, "the list has rows")
	ap._tail.custom_minimum_size.y = 2000   # room to scroll even when the list fits
	await _frames(3)
	ap._scroll.scroll_vertical = int((rows[1] as Control).position.y) + 5
	await _frames()
	await ap._snap_to_whole_row()
	await _frames()
	assert_eq(ap._scroll.scroll_vertical, int(round((rows[2] as Control).position.y)),
		"a cut row gives way to the next whole row")
	ap._tail.custom_minimum_size.y = 0

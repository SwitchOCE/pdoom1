extends GutTest
## GKeys.route table test (fork/design/godot-g/spec.md 8.2, 12.2 "1b") with a stub key
## matcher, so the decision is tested on its own, without KeybindManager or a live MainUI.

const PLAN := "action_selection"
const WATCH := "turn_end"


class StubKb:
	extends RefCounted
	## bind name -> keycode (no modifiers), like KeybindManager's defaults.
	var binds := {
		"g_actions": KEY_A, "g_upgrades": KEY_U, "g_staff": KEY_E, "g_plan": KEY_Q,
		"g_reserve": KEY_R, "g_guide": KEY_F1, "undo_action": KEY_Z, "clear_queue": KEY_C,
		"action_1": KEY_1, "action_2": KEY_2, "action_3": KEY_3, "action_4": KEY_4,
		"action_5": KEY_5, "action_6": KEY_6, "action_7": KEY_7, "action_8": KEY_8,
		"action_9": KEY_9, "end_turn": KEY_SPACE, "commit_plan": KEY_ENTER,
	}

	func is_action_pressed(event: InputEvent, action: String) -> bool:
		return event is InputEventKey and binds.has(action) \
			and (event as InputEventKey).keycode == binds[action] and event.pressed


func _key(code: int) -> InputEventKey:
	var e := InputEventKey.new()
	e.keycode = code
	e.pressed = true
	return e


func _r(code: int, top: String, phase: String = PLAN, skipped: Array = []) -> String:
	return GKeys.route(_key(code), top, phase, StubKb.new(), skipped)


func test_desk_letters_open_their_sheets_in_plan() -> void:
	assert_eq(_r(KEY_A, ""), "toggle_actions")
	assert_eq(_r(KEY_U, ""), "toggle_upgrades")
	assert_eq(_r(KEY_Q, ""), "toggle_plan")
	assert_eq(_r(KEY_E, ""), "staff")
	assert_eq(_r(KEY_F1, ""), "guide")


func test_sheet_letters_do_nothing_outside_the_plan() -> void:
	assert_eq(_r(KEY_A, "", WATCH), "", "A is PLAN-only")
	assert_eq(_r(KEY_U, "", WATCH), "", "U is PLAN-only")
	assert_eq(_r(KEY_Q, "", WATCH), "", "Q is PLAN-only")
	assert_eq(_r(KEY_E, "", WATCH), "staff", "E works in both")
	assert_eq(_r(KEY_F1, "", WATCH), "guide", "F1 works in both")


func test_a_g_sheet_on_top_toggles_or_switches() -> void:
	assert_eq(_r(KEY_A, "g_actions"), "toggle_actions", "A over Actions closes it (desk decides)")
	assert_eq(_r(KEY_U, "g_actions"), "toggle_upgrades", "U over Actions switches")
	assert_eq(_r(KEY_Q, "g_upgrades"), "toggle_plan", "Q over Upgrades switches")
	assert_eq(_r(KEY_E, "g_plan"), "staff", "E over a G sheet: staff (V5)")
	assert_eq(_r(KEY_F1, "g_actions"), "guide", "F1 over a G sheet opens the guide")
	assert_eq(_r(KEY_F1, "g_guide"), "guide", "F1 over the guide closes it (V5)")
	assert_eq(_r(KEY_E, "g_guide"), "staff", "E over the guide: staff (V5)")


func test_any_other_modal_keeps_every_key() -> void:
	for top in ["event", "modal", "bug_report", "employee_card"]:
		for code in [KEY_A, KEY_U, KEY_Q, KEY_E, KEY_F1, KEY_R, KEY_Z, KEY_C, KEY_1]:
			assert_eq(_r(code, top), "", "%s over %s goes to the dialog block" % [
				OS.get_keycode_string(code), top])


func test_plan_drawer_routes_z_c_r() -> void:
	assert_eq(_r(KEY_Z, "g_plan"), "undo")
	assert_eq(_r(KEY_C, "g_plan"), "clear")
	assert_eq(_r(KEY_R, "g_plan"), "reserve")
	assert_eq(_r(KEY_R, ""), "", "R is free on the desk")
	assert_eq(_r(KEY_R, "g_actions"), "", "R only in the Plan drawer")
	assert_eq(_r(KEY_Z, ""), "", "Z on the desk stays today's handler")
	assert_eq(_r(KEY_Z, "g_actions"), "", "Z inside Actions is blocked like any modal key")


func test_actions_sheet_routes_the_number_slots() -> void:
	for i in range(9):
		assert_eq(_r(KEY_1 + i, "g_actions"), "slot_%d" % i)
	assert_eq(_r(KEY_1, ""), "", "1-9 on the desk stay today's handler")
	assert_eq(_r(KEY_1, "g_plan"), "", "1-9 only inside Actions")


func test_other_keys_return_nothing() -> void:
	for top in ["", "g_actions", "g_plan", "g_upgrades"]:
		for code in [KEY_SPACE, KEY_ENTER, KEY_ESCAPE, KEY_V, KEY_L, KEY_TAB, KEY_W]:
			assert_eq(_r(code, top), "", "%s with top '%s'" % [OS.get_keycode_string(code), top])


func test_skipped_binds_are_never_matched() -> void:
	assert_eq(_r(KEY_A, "", PLAN, ["g_actions"]), "", "a skipped G bind is not G's key")
	assert_eq(_r(KEY_R, "g_plan", PLAN, ["g_reserve"]), "")
	assert_eq(_r(KEY_U, "", PLAN, ["g_actions"]), "toggle_upgrades", "others still route")


func test_route_ignores_non_key_events() -> void:
	assert_eq(GKeys.route(InputEventMouseButton.new(), "", PLAN, StubKb.new(), []), "")
	assert_eq(GKeys.route(null, "", PLAN, StubKb.new(), []), "")


func test_skipped_binds_detects_a_saved_bind_on_a_g_key() -> void:
	var binds := {
		"commit_plan": {"key": KEY_A},
		"g_actions": {"key": KEY_A},
		"g_upgrades": {"key": KEY_U},
		"g_reserve": {"key": KEY_R, "shift": true},
		"undo_action": {"key": KEY_R},
	}
	var s := GKeys.skipped_binds(binds)
	assert_true(s.has("g_actions"), "Commit on A wins over the G bind (V7)")
	assert_false(s.has("g_upgrades"))
	assert_false(s.has("g_reserve"), "modifiers must match too")


func test_default_binds_have_no_conflict() -> void:
	assert_eq(GKeys.skipped_binds(KeybindManager.keybinds), [],
		"the shipped defaults put no G bind on a key another bind uses")
	for b in ["g_actions", "g_upgrades", "g_staff", "g_plan", "g_reserve", "g_guide"]:
		assert_true(KeybindManager.keybinds.has(b), "%s is a rebindable bind" % b)
		assert_true(String(KeybindManager.keybinds[b]["description"]).ends_with("(G desk)"),
			"%s is labelled as a G desk bind in the rebind screen" % b)

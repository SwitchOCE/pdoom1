extends GutTest
## G desk, phase 1a (fork/design/godot-g/spec.md 12.2 "1a"): GPrefs round trip, the advisor
## note's exact-string trims, the THIS MONTH grouping, and on the real main.tscn: the refusal
## toast (an early UI refusal and a backend rejection), the advisor note's hand-off and clear,
## the rail doors (Staff, Ledger, embedded Guide), and that the desk stays a pure view.

const MAIN_SCENE := "res://scenes/main.tscn"
const TEST_PREFS := "user://g_ui_test_roundtrip.cfg"

var _prev_hint: bool
var _prev_hint_text: String
var _prev_action: String


func before_each() -> void:
	_prev_hint = GameConfig.show_first_lever_hint
	_prev_hint_text = GameConfig.first_lever_hint_text
	_prev_action = GameConfig.first_lever_action_id
	GAdvisorNote.dismissed_this_session = false
	GAdvisorNote.plain_dismissed_this_session = false


func after_each() -> void:
	GameConfig.show_first_lever_hint = _prev_hint
	GameConfig.first_lever_hint_text = _prev_hint_text
	GameConfig.first_lever_action_id = _prev_action
	GAdvisorNote.dismissed_this_session = false
	GAdvisorNote.plain_dismissed_this_session = false
	if FileAccess.file_exists(TEST_PREFS):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(TEST_PREFS))
	GPrefs.reload_prefs()
	GameManager.month_playback_active = false


# --- GPrefs ------------------------------------------------------------------------------

func test_gprefs_default_is_one_named_constant_and_on() -> void:
	assert_true(GPrefs.DESK_DEFAULT, "Alex's decision: G is on by default in the fork's builds")
	GPrefs.reload_prefs("user://g_ui_does_not_exist.cfg")
	assert_eq(GPrefs.desk(), GPrefs.DESK_DEFAULT, "no file -> the named default")


func test_gprefs_round_trip() -> void:
	GPrefs.reload_prefs("user://g_ui_does_not_exist.cfg")
	GPrefs.set_desk(false, false)
	assert_eq(GPrefs.save_prefs(TEST_PREFS), OK, "save must succeed")
	GPrefs.reload_prefs("user://g_ui_does_not_exist.cfg")
	assert_true(GPrefs.desk(), "defaults back before reading the file")
	GPrefs.reload_prefs(TEST_PREFS)
	assert_false(GPrefs.desk(), "desk survives the round trip")


func test_gprefs_never_writes_gameconfig_file() -> void:
	assert_ne(GPrefs.PATH, "user://config.cfg", "G keeps its own file")
	assert_eq(GPrefs.PATH, "user://g_ui.cfg")


# --- advisor note trims (spec 5.13) ------------------------------------------------------

func test_advisor_trims_exact_prefix_and_suffix() -> void:
	assert_eq(GAdvisorNote.trim_hint(
		"Advisor: you do not know anything yet. Go and find out -- scouting (the glowing button)."),
		"you do not know anything yet. Go and find out -- scouting")


func test_advisor_body_starts_with_a_capital_for_display() -> void:
	assert_eq(GAdvisorNote.display_case("you do not know anything yet."), "You do not know anything yet.")
	assert_eq(GAdvisorNote.display_case("Each month: click"), "Each month: click", "already upper")
	assert_eq(GAdvisorNote.display_case(""), "")
	assert_eq(GAdvisorNote.display_case("-- dash"), "-- dash", "no letter first: unchanged")


func test_advisor_trim_leaves_other_text_alone() -> void:
	assert_eq(GAdvisorNote.trim_hint("Hire someone."), "Hire someone.", "no prefix, no suffix")
	assert_eq(GAdvisorNote.trim_hint("advisor: lower case"), "advisor: lower case",
		"the prefix check is exact (case)")
	assert_eq(GAdvisorNote.trim_hint("Advisor:no space"), "Advisor:no space",
		"the prefix check is exact (space)")
	assert_eq(GAdvisorNote.trim_hint("Go (the glowing button)"), "Go (the glowing button)",
		"the suffix check is exact (full stop)")
	assert_eq(GAdvisorNote.trim_hint("Advisor: only the prefix"), "only the prefix")
	assert_eq(GAdvisorNote.trim_hint("only the suffix (the glowing button)."), "only the suffix")
	assert_eq(GAdvisorNote.trim_hint(""), "")


func test_advisor_where_line() -> void:
	assert_eq(GAdvisorNote.where_line("Scouting"), "Scouting is in Actions, the glowing button.")
	assert_eq(GAdvisorNote.where_line(""), "", "no action name -> no second line")


# --- THIS MONTH grouping (spec 5.5) -------------------------------------------------------

func test_this_month_groups_consecutive_repeats_with_row_range() -> void:
	var q := [
		{"id": "buy_compute", "name": "Purchase Compute"},
		{"id": "scout_read", "name": "Read the Literature"},
		{"id": "scout_read", "name": "Read the Literature"},
		{"id": "buy_compute", "name": "Purchase Compute"},
	]
	var g := GAttentionCard.group_queue(q)
	assert_eq(g.size(), 3)
	assert_eq(g[0].rows, "1")
	assert_eq(g[1].rows, "2-3")
	assert_eq(int(g[1].count), 2)
	assert_eq(g[2].rows, "4")
	assert_eq(GAttentionCard.group_queue([]).size(), 0)


# --- live desk on main.tscn ---------------------------------------------------------------

func _boot(desk_on: bool) -> Node:
	GPrefs.set_desk(desk_on, false)
	var root: Node = load(MAIN_SCENE).instantiate()
	add_child_autofree(root)
	var main_ui: Node = root.find_child("MainUI", true, false)
	for _i in range(120):
		await get_tree().process_frame
		if GameManager.is_initialized and String(main_ui.current_turn_phase).to_upper() == "ACTION_SELECTION":
			break
	await get_tree().process_frame
	return main_ui


func test_boot_with_desk_on_builds_the_desk_and_hides_classic_chrome() -> void:
	var main_ui: Node = await _boot(true)
	assert_eq(main_ui.get("_ui_layout"), "g")
	var desk: Control = main_ui.get_g_desk()
	assert_not_null(desk, "the desk exists")
	assert_eq(desk.get_parent(), main_ui.get_parent(), "the desk is a TabManager child")
	assert_eq(desk.get_index(), main_ui.get_index() + 1, "directly after MainUI")
	assert_true(main_ui.visible, "MainUI stays visible so its _input keeps every key")
	for p in ["TopBar", "ContentArea", "InfoBar", "BottomBar"]:
		assert_false((main_ui.get_node(p) as CanvasItem).visible, "%s hidden under G" % p)
	assert_ne(desk.dateline.text, "", "the first game state reached the desk")
	assert_eq(desk.resource_values["money"].text, main_ui.money_label.text,
		"money prints exactly as the classic top bar")


func test_refusal_toast_for_an_early_ui_refusal() -> void:
	var main_ui: Node = await _boot(true)
	var desk = main_ui.get_g_desk()
	assert_false(desk.toast.visible, "no toast at rest")
	main_ui.report_rejection("Cannot afford action: Test")
	assert_true(desk.toast.visible, "a PLAN-time refusal shows the G toast")
	assert_eq(desk.toast.message_text(), "[!] Cannot afford action: Test")
	main_ui.report_rejection("Not enough Attention: need 2 planning hours, have 0")
	assert_eq(desk.toast.message_text(), "[!] Not enough Attention: need 2 planning hours, have 0",
		"a newer message replaces the older one")


func test_refusal_toast_for_a_backend_rejection() -> void:
	var main_ui: Node = await _boot(true)
	var desk = main_ui.get_g_desk()
	GameManager.error_occurred.emit("Backend says no")
	assert_true(desk.toast.visible, "GameManager.error_occurred reaches the G toast")
	assert_eq(desk.toast.message_text(), "[!] Backend says no")


func test_advisor_note_hand_off_and_clear() -> void:
	GameConfig.show_first_lever_hint = true
	GameConfig.first_lever_action_id = "scouting"
	GameConfig.first_lever_hint_text = "Advisor: you do not know anything yet. Go and find out -- scouting (the glowing button)."
	var prev_hints: bool = GameConfig.show_hints
	GameConfig.show_hints = true
	var main_ui: Node = await _boot(true)
	var desk = main_ui.get_g_desk()
	assert_true(desk.advisor_note.visible, "the cold open's hint shows as the advisor note")
	assert_eq(desk.advisor_note.body_text(), "You do not know anything yet. Go and find out -- scouting",
		"trimmed, first letter capitalised for display")
	assert_eq(desk.advisor_mode(), "lever")
	assert_true(desk.advisor_note.show_arrow, "the lever note has its arrow")
	var nm := String(GameActions.get_action_by_id("scouting").get("name", ""))
	assert_eq(desk.advisor_note.where_text(), "%s is in Actions, the glowing button." % nm)
	main_ui._clear_first_lever_nudge()
	assert_ne(desk.advisor_mode(), "lever", "first_lever_cleared removes the lever note")
	assert_eq(desk.plate_actions.modulate.a, 1.0, "the pulse stops at full alpha")
	assert_false(desk.actions_panel.hint_pulsing(), "and the row pulse")
	# Today's game: classic's first-turns label keeps the lever line after the clear until
	# turn 3, so the note carries what that label shows, without arrow or pulse.
	var gs: Label = main_ui.getting_started_hint
	assert_true(gs.visible, "turn 1, hints on: classic still shows its label")
	assert_eq(desk.advisor_mode(), "plain")
	assert_false(desk.advisor_note.show_arrow, "no arrow without the hand-off")
	assert_eq(desk.advisor_note.body_text(),
		GAdvisorNote.display_case(GAdvisorNote.trim_hint(gs.text)), "classic label's words")
	assert_eq(desk.advisor_note.where_text(), "", "the 'is in Actions, the glowing button' line goes")
	GameConfig.show_hints = prev_hints


func test_first_turns_hint_shows_in_the_note_without_the_hand_off() -> void:
	# Classic shows GettingStartedHint on the first turns when show_hints is on; G hides that
	# label with the classic chrome, so the advisor note carries it: same words, same source,
	# same condition, ADVISOR and x only.
	GameConfig.show_first_lever_hint = false
	var prev_hints: bool = GameConfig.show_hints
	GameConfig.show_hints = true
	var main_ui: Node = await _boot(true)
	var desk = main_ui.get_g_desk()
	var gs: Label = main_ui.getting_started_hint
	assert_true(gs.visible, "classic would show its first-turns line now")
	assert_false(gs.is_visible_in_tree(), "but G hides the classic label")
	assert_eq(desk.advisor_mode(), "plain")
	assert_true(desk.advisor_note.visible, "the note carries it instead")
	assert_eq(desk.advisor_note.body_text(), gs.text, "classic's own words, unchanged")
	assert_string_contains(desk.advisor_note.body_text(), "COMMIT THE MONTH")
	assert_false(desk.advisor_note.show_arrow, "no arrow")
	assert_eq(desk.advisor_note.where_text(), "", "no 'is in Actions' line")
	assert_false(desk.advisor_note._rule.visible, "and no rule above an empty line")
	assert_eq(desk.plate_actions.modulate.a, 1.0, "no plate pulse")
	assert_eq(desk.actions_panel.hint_id, "", "no row pulse")
	main_ui.screen_mode.toggle_mode()
	assert_false(desk.advisor_note.visible, "WATCH: hidden, as classic's PLAN-only label is")
	main_ui.screen_mode.toggle_mode()
	assert_true(desk.advisor_note.visible, "back in PLAN")
	desk.advisor_note.close_button.pressed.emit()
	assert_false(desk.advisor_note.visible, "the x hides it for the session")
	assert_true(GAdvisorNote.plain_dismissed_this_session)
	GAdvisorNote.plain_dismissed_this_session = false
	GameConfig.show_hints = false
	main_ui._on_game_state_updated(main_ui._last_state)
	desk._on_state(main_ui._last_state)
	assert_false(gs.visible, "hints off: classic hides it")
	assert_false(desk.advisor_note.visible, "and so does G")
	GameConfig.show_hints = prev_hints


func test_lever_note_wins_over_the_first_turns_hint() -> void:
	GameConfig.show_first_lever_hint = true
	GameConfig.first_lever_action_id = "scouting"
	var prev_hints: bool = GameConfig.show_hints
	GameConfig.show_hints = true
	var main_ui: Node = await _boot(true)
	var desk = main_ui.get_g_desk()
	assert_eq(desk.advisor_mode(), "lever", "the first-lever hand-off wins")
	assert_true(desk.advisor_note.show_arrow, "with its arrow")
	assert_ne(desk.advisor_note.where_text(), "", "and its 'is in Actions' line")
	assert_false(desk.advisor_note.body_text().contains("Each month"), "not the first-turns line")
	GameConfig.show_hints = prev_hints


func test_advisor_note_x_hides_without_touching_gameconfig() -> void:
	GameConfig.show_first_lever_hint = true
	var main_ui: Node = await _boot(true)
	var desk = main_ui.get_g_desk()
	assert_true(desk.advisor_note.visible)
	desk.advisor_note.close_button.pressed.emit()
	assert_false(desk.advisor_note.visible, "the x hides the note")
	assert_true(GameConfig.show_first_lever_hint, "the x does not change GameConfig")


func test_rail_statuses_mirror_the_game() -> void:
	var main_ui: Node = await _boot(true)
	var desk = main_ui.get_g_desk()
	assert_eq(desk.plate_staff.get_status(), str(int(main_ui._last_state.get("total_staff", 0))))
	assert_eq(desk.plate_ledger.get_status(), main_ui.ledger_screen.summary_word())
	assert_false(desk.plate_actions.disabled, "Actions opens its sheet in the plan (1b)")
	assert_false(desk.plate_upgrades.disabled, "Upgrades opens its sheet in the plan (1b)")


func test_ledger_plate_opens_todays_ledger() -> void:
	var main_ui: Node = await _boot(true)
	var desk = main_ui.get_g_desk()
	desk.plate_ledger.pressed.emit()
	await get_tree().process_frame
	assert_not_null(main_ui.active_dialog, "a modal is up")
	assert_true(main_ui.active_dialog.has_meta("is_ledger"), "it is today's ledger")
	assert_false(desk.plate_ledger.keycap_shown(), "keycaps hide while a modal is up")


func test_staff_plate_opens_employee_screen_and_desk_follows() -> void:
	var main_ui: Node = await _boot(true)
	var desk = main_ui.get_g_desk()
	desk.plate_staff.pressed.emit()
	await get_tree().process_frame
	assert_false(main_ui.visible, "TabManager hid MainUI for the Employee screen")
	assert_false(desk.visible, "the desk hides with MainUI")
	main_ui.tab_manager.show_main_screen()
	await get_tree().process_frame
	assert_true(desk.visible, "the desk returns with MainUI")


func test_embedded_guide_opens_over_the_run_and_esc_closes_it() -> void:
	var main_ui: Node = await _boot(true)
	var desk = main_ui.get_g_desk()
	var scene_before := get_tree().current_scene
	var state_before = GameManager.state
	desk.plate_guide.pressed.emit()
	await get_tree().process_frame
	assert_eq(main_ui.modal_stack.top_kind(), "g_guide", "the guide is registered in ModalStack")
	assert_true(desk.guide_open())
	var ev := InputEventKey.new()
	ev.keycode = KEY_ESCAPE
	ev.physical_keycode = KEY_ESCAPE
	ev.pressed = true
	get_viewport().push_input(ev)
	await get_tree().process_frame
	await get_tree().process_frame
	assert_false(desk.guide_open(), "Esc closed the guide through ModalStack")
	assert_eq(main_ui.modal_stack.top_kind(), "", "nothing left on the stack")
	assert_eq(get_tree().current_scene, scene_before, "no scene change")
	assert_eq(GameManager.state, state_before, "the run is untouched")


func test_embedded_guide_back_button_closes_without_scene_change() -> void:
	var main_ui: Node = await _boot(true)
	var desk = main_ui.get_g_desk()
	desk.toggle_guide()
	await get_tree().process_frame
	var guide: Node = main_ui.modal_stack.top_node()
	var back: Button = guide.get_node("Panel/VBox/ButtonRow/BackButton")
	assert_eq(back.text, "Back to Game")
	back.pressed.emit()
	await get_tree().process_frame
	assert_false(desk.guide_open())
	assert_true(GameManager.is_initialized and not GameManager.state.game_over, "run still live")


func test_view_switch_and_banner_follow_screen_mode() -> void:
	var main_ui: Node = await _boot(true)
	var desk = main_ui.get_g_desk()
	assert_eq(desk.mode_label.text, "## PLAN")
	desk.view_watch_button.pressed.emit()
	assert_eq(main_ui.screen_mode.current_mode, ScreenModeController.Mode.WATCH)
	assert_eq(desk.mode_label.text, "## WATCH")
	assert_false(main_ui.screen_mode.watch_bar.visible, "the classic WATCH strip stays hidden")
	desk.view_plan_button.pressed.emit()
	assert_eq(main_ui.screen_mode.current_mode, ScreenModeController.Mode.PLAN)


func test_desk_draws_no_number_from_the_global_rng() -> void:
	# Spec 7.4 rule: nothing in G draws from Godot's global generator. Refresh the desk many
	# times and check the global sequence is where it would be with no G activity.
	var main_ui: Node = await _boot(true)
	var desk = main_ui.get_g_desk()
	seed(12345)
	var expected := randi()
	seed(12345)
	for _i in range(20):
		desk._on_state(main_ui._last_state)
		desk._on_queue_view_changed()
		desk._on_mode_changed(0)
	assert_eq(randi(), expected, "the desk drew nothing from the global RNG")


# --- Settings: the G desk options row (spec 2.1) -------------------------------------------

const SETTINGS_SCENE := "res://scenes/settings_menu.tscn"
const G_ROW := "Board/BoardVBox/Columns/Col3/GDeskRow"


func test_settings_board_carries_the_g_row_inside_the_frame() -> void:
	var menu: Control = load(SETTINGS_SCENE).instantiate()
	add_child_autofree(menu)
	menu.call("_show_board")
	await get_tree().process_frame
	await get_tree().process_frame
	var row: Control = menu.get_node_or_null(G_ROW)
	assert_not_null(row, "the board shows the G desk options row (%s)" % G_ROW)
	var vp := menu.get_viewport_rect()
	if vp.size.x < 1280 or vp.size.y < 720:
		pass_test("viewport %s too small to judge the 1080p board layout" % vp.size)
		return
	var board: Control = menu.get_node("Board")
	assert_true(board.get_global_rect().encloses(row.get_global_rect()),
		"the G row sits inside the board frame (board=%s row=%s)" % [
			board.get_global_rect(), row.get_global_rect()])


func test_settings_g_row_opens_options_with_only_the_working_switches() -> void:
	var menu: Control = load(SETTINGS_SCENE).instantiate()
	add_child_autofree(menu)
	menu.call("_show_board")
	await get_tree().process_frame
	(menu.get_node(G_ROW + "/Button") as Button).pressed.emit()
	await get_tree().process_frame
	var modal: Control = menu.get("_g_options")
	assert_not_null(modal, "the row opens the G options modal")
	assert_true(modal.visible, "the modal is shown")
	var checks: Array = modal.find_children("*", "BaseButton", true, false).filter(
		func(b): return b is CheckButton or b is CheckBox)
	# The switches that work today: the G desk, the typewriter sound (phase 4) and reduced
	# motion (phase 7, every G motion follows it). Room effects is a picker, not a switch.
	assert_eq(checks.size(), 3, "only the switches that work today are shown")
	assert_eq(checks[0], modal.get("desk_toggle"), "the first is the G desk toggle")
	assert_eq(checks[1], modal.get("typewriter_toggle"), "the second is the typewriter sound")
	assert_eq(checks[2], modal.get("motion_toggle"), "the third is reduced motion")
	GPrefs.set_desk(true, false)
	GPrefs.set_reduced_motion(true, false)
	modal.call("show_panel")
	assert_true((checks[0] as CheckButton).button_pressed, "the switch reflects GPrefs")
	assert_true((checks[2] as CheckButton).button_pressed, "reduced motion reflects GPrefs")
	GPrefs.set_reduced_motion(false, false)
	modal.call("show_panel")
	assert_false((checks[2] as CheckButton).button_pressed, "and follows it back")

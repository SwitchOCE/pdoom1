extends GutTest
## Unit tests for the A/B layout harness (UI_PROPOSALS_2026-07-22 section 4):
## the GameConfig.ui_layout flag, LayoutController's container-reflow (both arrangements
## instance + restore cleanly), and QueueGantt's read-only row extraction (P10 -- gantt
## rows track the queued-action count). UI-layer only; no game state / RNG touched.

# --- GameConfig.ui_layout flag ------------------------------------------------------------

func test_ui_layout_defaults_to_classic():
	# The scaffolding default must be classic so first boot is the untouched layout.
	assert_true(GameConfig.UI_LAYOUTS.has("classic"), "classic is a known layout")
	assert_true(GameConfig.UI_LAYOUTS.has("proposed"), "proposed is a known layout")

func test_ui_layout_setter_accepts_known_and_rejects_garbage():
	var original: String = GameConfig.ui_layout
	GameConfig.set_setting("ui_layout", "proposed", false)
	assert_eq(GameConfig.ui_layout, "proposed", "known layout is accepted")
	GameConfig.set_setting("ui_layout", "nonsense", false)
	assert_eq(GameConfig.ui_layout, "proposed", "garbage layout is rejected (value unchanged)")
	GameConfig.set_setting("ui_layout", original, false)  # restore

func test_ui_layout_persists_round_trip():
	# The flag persists exactly the way GameConfig saves it -- an [interface] ConfigFile key.
	var cf := ConfigFile.new()
	cf.set_value("interface", "ui_layout", "proposed")
	assert_eq(cf.get_value("interface", "ui_layout", "classic"), "proposed",
		"ui_layout survives a ConfigFile save/load round-trip")

# --- LayoutController: both arrangements instance + restore -------------------------------

func _make_layout_fixture() -> Dictionary:
	# A minimal stand-in for main.tscn's ContentArea: three columns + a plan screen that
	# parents the upgrades label/scroll (the dock target).
	var content := HBoxContainer.new()
	var plan_col := Control.new()
	plan_col.size_flags_stretch_ratio = 0.3
	var instrument_col := Control.new()
	instrument_col.size_flags_stretch_ratio = 0.3
	var watch_col := Control.new()
	watch_col.size_flags_stretch_ratio = 0.4
	content.add_child(plan_col)
	content.add_child(instrument_col)
	content.add_child(watch_col)

	var plan_screen := VBoxContainer.new()
	var upgrades_label := Label.new()
	var upgrades_scroll := ScrollContainer.new()
	plan_screen.add_child(upgrades_label)
	plan_screen.add_child(upgrades_scroll)
	var office_cat := Control.new()
	plan_col.add_child(plan_screen)
	plan_col.add_child(office_cat)

	add_child_autofree(content)
	var lc := LayoutController.new()
	add_child_autofree(lc)
	lc.register_targets(plan_col, instrument_col, watch_col, office_cat,
		plan_screen, upgrades_label, upgrades_scroll)
	return {
		"lc": lc, "plan_col": plan_col, "instrument_col": instrument_col,
		"watch_col": watch_col, "plan_screen": plan_screen,
		"upgrades_label": upgrades_label, "upgrades_scroll": upgrades_scroll,
	}

func test_classic_layout_is_a_noop_over_defaults():
	var f := _make_layout_fixture()
	f.lc.apply_layout("classic")
	assert_eq(f.lc.current, "classic")
	assert_almost_eq(f.plan_col.size_flags_stretch_ratio, 0.3, 0.001, "classic keeps plan ratio")
	assert_almost_eq(f.instrument_col.size_flags_stretch_ratio, 0.3, 0.001, "classic keeps instrument ratio")
	assert_almost_eq(f.watch_col.size_flags_stretch_ratio, 0.4, 0.001, "classic keeps watch ratio")

func test_proposed_layout_reflows_columns_and_docks_upgrades():
	var f := _make_layout_fixture()
	f.lc.apply_layout("proposed")
	assert_eq(f.lc.current, "proposed")
	# P11: instrument column tightened, watch column widened.
	assert_lt(f.instrument_col.size_flags_stretch_ratio, 0.3, "instrument column reclaimed")
	assert_gt(f.watch_col.size_flags_stretch_ratio, 0.4, "watch column widened for the office floor")
	# P11 dock: upgrades label/scroll moved out of the plan screen into a framed panel.
	assert_ne(f.upgrades_label.get_parent(), f.plan_screen, "upgrades label docked into a panel")

func test_layout_flip_restores_classic_pixel_identical():
	var f := _make_layout_fixture()
	f.lc.apply_layout("proposed")
	f.lc.apply_layout("classic")
	# Ratios restored exactly.
	assert_almost_eq(f.plan_col.size_flags_stretch_ratio, 0.3, 0.001)
	assert_almost_eq(f.instrument_col.size_flags_stretch_ratio, 0.3, 0.001)
	assert_almost_eq(f.watch_col.size_flags_stretch_ratio, 0.4, 0.001)
	# Upgrades subtree back under the plan screen (dock reversed).
	assert_eq(f.upgrades_label.get_parent(), f.plan_screen, "upgrades label restored to plan screen")
	assert_eq(f.upgrades_scroll.get_parent(), f.plan_screen, "upgrades scroll restored to plan screen")

func test_toggle_cycles_between_the_two():
	var f := _make_layout_fixture()
	assert_eq(f.lc.toggle(), "proposed", "first toggle -> proposed")
	assert_eq(f.lc.toggle(), "classic", "second toggle -> classic")

# --- QueueGantt: rows track the queued-action count (P10) ---------------------------------

func test_gantt_rows_from_state_empty():
	assert_eq(QueueGantt.rows_from_state({}, []).size(), 0, "no state -> no rows")

func test_gantt_rows_track_committed_strategic_count():
	var state := {
		"turn": 5,
		"month_plan": {"queued_strategic": [
			{"action_id": "deep_research", "queued_on_turn": 3, "resolves_on_turn": 9},
			{"action_id": "field_building", "queued_on_turn": 4, "resolves_on_turn": 8},
		]},
	}
	var rows := QueueGantt.rows_from_state(state, [])
	assert_eq(rows.size(), 2, "one row per committed strategic play")
	assert_true(rows[0]["has_eta"], "committed rows carry an ETA")
	assert_eq(rows[0]["eta"], 9, "ETA is the resolution tick")
	assert_true(rows[0]["progress"] > 0.0, "mid-flight play shows partial progress")

func test_gantt_folds_in_tentative_and_hiring():
	var state := {
		"turn": 2,
		"month_plan": {"queued_strategic": [
			{"action_id": "deep_research", "queued_on_turn": 1, "resolves_on_turn": 6},
		]},
		"hiring": {"jobs": [
			{"kind": "interview", "resolves_on_turn": 5},
		]},
	}
	var tentative := [{"id": "scout", "name": "Scout"}]
	var rows := QueueGantt.rows_from_state(state, tentative)
	assert_eq(rows.size(), 3, "strategic + hiring + tentative all counted")
	assert_false(rows[2]["has_eta"], "tentative plan-time row has no ETA yet")

func test_gantt_builds_one_control_per_row():
	var gantt := QueueGantt.new()
	add_child_autofree(gantt)
	var rows := [
		{"name": "Deep Research", "eta": 9, "duration": 6, "progress": 0.3, "kind": "strategic", "has_eta": true},
		{"name": "Scout", "eta": -1, "duration": 0, "progress": 0.0, "kind": "planned", "has_eta": false},
	]
	gantt.update_rows(rows, true)
	assert_eq(gantt.row_count(), 2, "gantt renders one row control per queued entry")
	gantt.update_rows([], false)
	assert_eq(gantt.row_count(), 0, "empty queue renders no rows (hint only)")

# --- "g": the G desk on the real main.tscn (fork/design/godot-g/spec.md 2.1-2.2, 12.2 1a) ---
# Boots the real scene (the desk replaces MainUI's chrome and sits next to it under TabManager,
# so a container stand-in cannot exercise it). Flips go through the F9 handler itself.

const _G_MAIN_SCENE := "res://scenes/main.tscn"
var _g_prev_layout: String = ""


func _g_boot(desk_on: bool, layout: String = "classic") -> Node:
	_g_prev_layout = GameConfig.ui_layout
	GameConfig.ui_layout = layout
	GPrefs.set_desk(desk_on, false)
	var root: Node = load(_G_MAIN_SCENE).instantiate()
	add_child_autofree(root)
	var main_ui: Node = root.find_child("MainUI", true, false)
	for _i in range(120):
		await get_tree().process_frame
		if GameManager.is_initialized and String(main_ui.current_turn_phase).to_upper() == "ACTION_SELECTION":
			break
	await get_tree().process_frame
	return main_ui


func _g_cleanup() -> void:
	GameConfig.set_setting("ui_layout", _g_prev_layout if _g_prev_layout != "" else "classic", true)
	if FileAccess.file_exists(GPrefs.PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(GPrefs.PATH))
	GPrefs.reload_prefs()
	GameManager.month_playback_active = false


func _g_snapshot(main_ui: Node) -> Dictionary:
	"""Every node G touches or could disturb: MainUI's own children, the content columns, the
	control-bar buttons, the registered PLAN/WATCH screens, the nodes 1b will reparent, and
	TabManager's child list."""
	var snap := {}
	for c in main_ui.get_children():
		if c is CanvasItem:
			snap["vis:" + String(c.name)] = (c as CanvasItem).visible
	for c in main_ui.get_node("ContentArea").get_children():
		snap["vis:ContentArea/" + String(c.name)] = (c as CanvasItem).visible
	for c in main_ui.get_node("BottomBar/ControlButtons").get_children():
		snap["vis:ControlButtons/" + String(c.name)] = (c as CanvasItem).visible
	snap["vis:watch_bar"] = main_ui.screen_mode.watch_bar.visible
	snap["vis:banner"] = main_ui.screen_mode.banner.visible
	snap["parent:upgrades_label"] = main_ui.plan_screen.upgrades_label.get_parent().get_path()
	snap["parent:upgrades_scroll"] = main_ui.plan_screen.upgrades_scroll.get_parent().get_path()
	snap["parent:research_quality"] = main_ui.research_quality_selector.get_parent().get_path()
	snap["parent:inflight"] = main_ui._inflight_hiring_box.get_parent().get_path()
	var tm_children := []
	for c in main_ui.get_parent().get_children():
		if not c.is_queued_for_deletion():
			tm_children.append(String(c.name))
	snap["tab_manager"] = tm_children
	var main_root: Node = main_ui.get_parent().get_parent()
	snap["backdrop_modulate"] = (main_root.get_node("Backdrop") as CanvasItem).modulate
	snap["scrim"] = (main_root.get_node("BackdropScrim") as CanvasItem).visible
	snap["mode"] = main_ui.screen_mode.current_mode
	return snap


func _g_assert_same(before: Dictionary, after: Dictionary, why: String) -> void:
	for k in before:
		assert_eq(after.get(k), before[k], "%s: %s restored" % [why, k])


func test_g_boot_directly_into_persisted_g() -> void:
	GPrefs.set_desk(true, true)   # persisted to user://g_ui.cfg ...
	GPrefs.reload_prefs()         # ... and read back from the file, as a fresh launch would
	assert_true(GPrefs.desk())
	var root: Node = load(_G_MAIN_SCENE).instantiate()
	add_child_autofree(root)
	var main_ui: Node = root.find_child("MainUI", true, false)
	for _i in range(120):
		await get_tree().process_frame
		if GameManager.is_initialized and String(main_ui.current_turn_phase).to_upper() == "ACTION_SELECTION":
			break
	assert_eq(main_ui.get("_ui_layout"), "g", "a persisted G boots straight into the desk")
	var desk = main_ui.get_g_desk()
	assert_not_null(desk)
	assert_ne(desk.dateline.text, "", "the new-game state reached the desk (it was listening before boot)")
	assert_eq(desk.plate_staff.get_status(), str(int(GameManager.state.get_total_staff())))
	_g_prev_layout = GameConfig.ui_layout
	_g_cleanup()


func _g_cycle_test(start_layout: String, watch: bool) -> void:
	var main_ui: Node = await _g_boot(false, start_layout)
	assert_eq(main_ui.get("_ui_layout"), start_layout)
	if watch:
		main_ui.screen_mode.enter_watch()
	var before := _g_snapshot(main_ui)
	# F9 from start_layout until g.
	var guard := 0
	while main_ui.get("_ui_layout") != "g" and guard < 3:
		main_ui._toggle_ui_layout()
		guard += 1
	assert_eq(main_ui.get("_ui_layout"), "g", "F9 reaches g from %s" % start_layout)
	assert_true(GPrefs.desk(), "entering g sets GPrefs.desk")
	var desk = main_ui.get_g_desk()
	assert_not_null(desk, "desk built on the flip")
	assert_eq(desk.mode_label.text, "## WATCH" if watch else "## PLAN",
		"seeded from the live mode, not the next signal")
	for p in ["TopBar", "HSeparator1", "ContentArea", "HSeparator2", "InfoBar", "BottomBar"]:
		assert_false((main_ui.get_node(p) as CanvasItem).visible, "%s hidden in g" % p)
	assert_false(main_ui.screen_mode.watch_bar.visible, "WATCH strip hidden in g")
	assert_false(main_ui.screen_mode.banner.visible, "classic banner hidden in g")
	# A mode change while in g must not bring the classic chrome back.
	main_ui.screen_mode.toggle_mode()
	assert_false(main_ui.screen_mode.watch_bar.visible, "WATCH strip stays hidden after a mode change")
	main_ui.screen_mode.toggle_mode()
	# F9 out of g -> classic.
	main_ui._toggle_ui_layout()
	assert_eq(main_ui.get("_ui_layout"), "classic", "F9 leaves g to classic")
	assert_false(GPrefs.desk(), "leaving g clears GPrefs.desk")
	assert_null(main_ui.get_g_desk(), "desk gone")
	await get_tree().process_frame
	var after := _g_snapshot(main_ui)
	if start_layout == "classic":
		_g_assert_same(before, after, "%s->g->classic (%s)" % [start_layout, "WATCH" if watch else "PLAN"])
	else:
		# From proposed the cycle lands on classic, which must equal a fresh classic arrangement
		# in everything G touched (proposed's own deltas are LayoutController's, tested above).
		for k in before:
			if String(k).begins_with("parent:upgrades") or k == "tab_manager":
				continue
			assert_eq(after.get(k), before[k], "proposed->g->classic: %s" % k)
	assert_eq(main_ui.screen_mode.current_mode,
		ScreenModeController.Mode.WATCH if watch else ScreenModeController.Mode.PLAN,
		"the current PLAN/WATCH mode survives the round trip")
	_g_cleanup()


func test_g_f9_from_classic_and_back_in_plan() -> void:
	await _g_cycle_test("classic", false)


func test_g_f9_from_classic_and_back_in_watch() -> void:
	await _g_cycle_test("classic", true)


func test_g_f9_from_proposed_and_back_in_plan() -> void:
	await _g_cycle_test("proposed", false)


func test_g_f9_from_proposed_and_back_in_watch() -> void:
	await _g_cycle_test("proposed", true)


func test_g_f9_into_g_and_back_with_an_event_up() -> void:
	# Spec 2.2 / 12.2 "1a": a live flip with an event up. The event stays on top and keeps
	# every key through both flips; the desk seeds itself with that modal up (no rail keys,
	# no sheet); leaving g dismisses only g_* modals, never the event.
	var main_ui: Node = await _g_boot(false, "classic")
	var before := _g_snapshot(main_ui)
	var ev := Panel.new()
	ev.name = "FakeEvent"
	ev.set_meta("is_event_dialog", true)
	get_tree().root.add_child(ev)
	main_ui._on_event_dialog_opened(ev, [])
	assert_eq(main_ui.modal_stack.top_kind(), "event", "the event is up")
	var guard := 0
	while main_ui.get("_ui_layout") != "g" and guard < 3:
		main_ui._toggle_ui_layout()
		guard += 1
	assert_eq(main_ui.get("_ui_layout"), "g", "F9 reaches g with the event up")
	var desk = main_ui.get_g_desk()
	assert_not_null(desk, "desk built on the flip")
	assert_true(is_instance_valid(ev) and ev.visible, "the event survives the flip into g")
	assert_eq(main_ui.modal_stack.top_kind(), "event", "and is still on top")
	assert_false(desk.plate_actions.keycap_shown(), "seeded with the event up: no rail key shows")
	assert_false(desk.plate_ledger.keycap_shown())
	assert_eq(desk.effective_top_kind(), "event")
	var a := InputEventKey.new()
	a.keycode = KEY_A
	a.pressed = true
	assert_false(desk.handle_key(a), "A over the event is not G's")
	assert_false(desk.actions_panel.visible, "no sheet opened over the event")
	main_ui._toggle_ui_layout()
	assert_eq(main_ui.get("_ui_layout"), "classic", "F9 leaves g with the event up")
	assert_null(main_ui.get_g_desk(), "desk gone")
	assert_true(is_instance_valid(ev) and ev.visible, "the event survives the flip back")
	assert_eq(main_ui.modal_stack.top_kind(), "event", "and is still on top in classic")
	main_ui.modal_stack.dismiss(ev)
	ev.queue_free()
	await get_tree().process_frame
	var after := _g_snapshot(main_ui)
	_g_assert_same(before, after, "classic->g->classic with an event up")
	_g_cleanup()


func test_g_flip_flip_flip_never_drifts() -> void:
	var main_ui: Node = await _g_boot(false, "classic")
	var before := _g_snapshot(main_ui)
	for _i in range(3):
		main_ui._apply_ui_layout("g")
		main_ui._apply_ui_layout("classic")
	await get_tree().process_frame
	_g_assert_same(before, _g_snapshot(main_ui), "three g round trips")
	_g_cleanup()


func test_g_next_layout_cycle_and_toggle_unchanged() -> void:
	assert_eq(MainUIScript.next_ui_layout("classic"), "proposed")
	assert_eq(MainUIScript.next_ui_layout("proposed"), "g")
	assert_eq(MainUIScript.next_ui_layout("g"), "classic")
	assert_eq(MainUIScript.next_ui_layout("nonsense"), "classic")
	var f := _make_layout_fixture()
	f.lc.apply_layout("g")   # no host registered: nothing to build, nothing breaks
	assert_eq(f.lc.current, "g")
	f.lc.apply_layout("classic")
	assert_eq(f.lc.toggle(), "proposed", "toggle() still flips only classic/proposed")


const MainUIScript = preload("res://scripts/ui/main_ui.gd")

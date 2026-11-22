extends GutTest
## G phase 6, trace windows (fork/design/godot-g/spec.md 5.1.3-5.1.4, 2.3, 12.2 "Phase 6"):
##   * GResourceHistory: one sample per calendar month, at most 24, samples are shown amounts,
##     the window's points (earlier months, then the current amount), the caption;
##   * the drawing: auto-scale to the line's own min..max, a flat line when they are equal, the
##     zero line only when the line crosses 0, one point; window sizes; the take switch;
##   * GPrefs.resources: default "icons", round trip, unknown -> icons; the options row;
##   * on the real main.tscn: a new game and a load clear the history, a resume keeps it; the
##     tier icons stay the default; with traces on, the desk follows made-up months without
##     touching game state or the global RNG; classic is untouched.

const MAIN_SCENE := "res://scenes/main.tscn"
const KEYS := ["money", "compute", "research", "papers", "reputation"]
const SAVE := "user://g_traces_test.save"
const RNG_SEED := 20171101
const TW = GResourceCell.TraceWindow

var _prev_hint: bool
var _prev_baseline: int
var _prev_load: String
var _root: Node = null


func before_each() -> void:
	_prev_hint = GameConfig.show_first_lever_hint
	GameConfig.show_first_lever_hint = false
	# Blind baseline: no background baseline thread per boot (test_g_paper.gd says why).
	_prev_baseline = GameConfig.baseline_mode
	GameConfig.baseline_mode = 2
	_prev_load = GameConfig.pending_load_path
	GResourceHistory.clear()


func after_each() -> void:
	GameConfig.show_first_lever_hint = _prev_hint
	GameConfig.baseline_mode = _prev_baseline
	GameConfig.pending_load_path = _prev_load
	GameManager.pending_resume = false
	GameManager.month_playback_active = false
	GPrefs.reload_prefs()
	GResourceHistory.clear()
	if FileAccess.file_exists(SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SAVE))


func _st(y: int, m: int, money: float = 245000.0, compute: float = 100.0, research: float = 0.0,
		papers: float = 0.0, rep: float = 50.0) -> Dictionary:
	return {"calendar": {"year": y, "month": m, "day": 1}, "money": money, "compute": compute,
		"research": research, "papers": papers, "reputation": rep}


# --- GResourceHistory ---------------------------------------------------------------------------

func test_history_records_once_per_month() -> void:
	assert_true(GResourceHistory.note_state(_st(2017, 11)), "the first state is month 1's sample")
	assert_false(GResourceHistory.note_state(_st(2017, 11, 200000.0)), "same month: no sample")
	assert_false(GResourceHistory.note_state(_st(2017, 11, 150000.0)), "still the same month")
	assert_eq(GResourceHistory.samples.size(), 1)
	assert_eq(float(GResourceHistory.samples[0].money), 245000.0, "the month's FIRST state is kept")
	assert_true(GResourceHistory.note_state(_st(2017, 12, 120000.0)), "a new month appends")
	assert_true(GResourceHistory.note_state(_st(2018, 1, 90000.0)), "a new year's month appends")
	assert_eq(GResourceHistory.samples.size(), 3)
	assert_eq(int(GResourceHistory.samples[2].year), 2018)
	assert_eq(int(GResourceHistory.samples[2].month), 1)
	assert_false(GResourceHistory.note_state({"money": 5.0}), "no calendar: nothing recorded")
	assert_eq(GResourceHistory.samples.size(), 3)


func test_history_keeps_at_most_24() -> void:
	for i in range(30):
		GResourceHistory.note_state(_st(2017 + floori(i / 12.0), (i % 12) + 1, float(i)))
	assert_eq(GResourceHistory.samples.size(), GResourceHistory.CAP)
	assert_eq(GResourceHistory.CAP, 24)
	assert_eq(float(GResourceHistory.samples[0].money), 6.0, "the oldest six are dropped")
	assert_eq(float(GResourceHistory.samples[23].money), 29.0)


func test_samples_are_shown_amounts() -> void:
	GResourceHistory.note_state(_st(2017, 11, 19999.5, 60.25, -0.4, 2.5, 60.5))
	var s: Dictionary = GResourceHistory.samples[0]
	assert_eq(float(s.money), 20000.0, "19,999.5 prints $20,000")
	assert_eq(float(s.compute), 60.0, "60.25 prints 60")
	assert_eq(float(s.research), 0.0, "-0.4 prints -0, which is 0")
	assert_eq(float(s.papers), 3.0, "2.5 prints 3 (half away from zero)")
	assert_eq(float(s.reputation), 61.0, "60.5 prints 61")
	for key in KEYS:
		var printed := GameConfig.format_scalar(float(_st(2017, 11, 19999.5, 60.25, -0.4, 2.5, 60.5)[key]))
		assert_eq(absf(float(s[key])), float(printed.replace(",", "").trim_prefix("-")),
			"%s sample is the printed number" % key)


func test_points_are_earlier_months_then_the_current_amount() -> void:
	var nov := Vector2i(2017, 11)
	GResourceHistory.note_state(_st(2017, 11, 245000.0))
	assert_eq(GResourceHistory.points("money", 230000.4, nov), [230000.0],
		"month 1: one point, the current shown amount")
	GResourceHistory.note_state(_st(2017, 12, 180000.0))
	GResourceHistory.note_state(_st(2018, 1, 120000.0))
	assert_eq(GResourceHistory.points("money", 99999.6, Vector2i(2018, 1)),
		[245000.0, 180000.0, 100000.0], "earlier month-starts, then now (no forecast)")
	assert_eq(GResourceHistory.points("money", 1.0, Vector2i(2018, 2)).size(), 4,
		"a month not yet sampled keeps every sample and adds now")
	GResourceHistory.clear()
	assert_eq(GResourceHistory.points("money", 7.0, nov), [7.0], "no history: one point")


func test_caption() -> void:
	assert_eq(GResourceHistory.caption(), "no history yet")
	GResourceHistory.note_state(_st(2017, 7))
	assert_eq(GResourceHistory.caption(), "no history yet", "one point")
	GResourceHistory.note_state(_st(2017, 8))
	assert_eq(GResourceHistory.caption(), "since Jul 2017", "the first recorded month")


# --- the drawing ------------------------------------------------------------------------------

func test_auto_scale_fits_the_line_own_min_and_max() -> void:
	var lay: Dictionary = TW.layout([10.0, 30.0, 20.0], 40.0, 40.0)
	var line: PackedVector2Array = lay.line
	assert_eq(line.size(), 3)
	assert_false(bool(lay.one))
	assert_almost_eq(line[0].y, 40.0 - TW.PAD_Y, 0.001, "the min sits at the bottom pad")
	assert_almost_eq(line[1].y, TW.PAD_Y, 0.001, "the max sits at the top pad")
	assert_almost_eq(line[2].y, 20.0, 0.001, "the middle value in the middle")
	assert_almost_eq(line[0].x, TW.PAD_X, 0.001)
	assert_almost_eq(line[2].x, 40.0 - TW.PAD_X, 0.001, "the last point (now) at the right")
	# Same shape at a different size: the window shows shape, not size.
	var big: PackedVector2Array = TW.layout([1000.0, 3000.0, 2000.0], 40.0, 40.0).line
	for i in range(3):
		assert_almost_eq(big[i].y, line[i].y, 0.001, "point %d scales to the same place" % i)


func test_flat_line_when_equal() -> void:
	var lay: Dictionary = TW.layout([50.0, 50.0, 50.0, 50.0], 48.0, 46.0)
	for p in lay.line:
		assert_almost_eq((p as Vector2).y, 23.0, 0.001, "flat in the middle")
	assert_eq(float(lay.zero_y), -1.0)


func test_zero_line_only_when_the_line_crosses_0() -> void:
	var crossing: Dictionary = TW.layout([-10.0, 10.0], 40.0, 40.0)
	assert_almost_eq(float(crossing.zero_y), 20.0, 0.001, "zero sits where 0 falls")
	assert_eq(float(TW.layout([5.0, 10.0, 7.0], 40.0, 40.0).zero_y), -1.0, "all above 0")
	assert_eq(float(TW.layout([-5.0, -10.0], 40.0, 40.0).zero_y), -1.0, "all below 0")
	assert_eq(float(TW.layout([0.0, 10.0], 40.0, 40.0).zero_y), -1.0, "touching 0 is not crossing")
	assert_eq(float(TW.layout([-3.0, 0.0], 40.0, 40.0).zero_y), -1.0, "nor from below")


func test_one_point() -> void:
	var lay: Dictionary = TW.layout([245000.0], 48.0, 46.0)
	assert_true(bool(lay.one), "one point: the flat dashed line")
	assert_eq(lay.line.size(), 1)
	assert_eq(lay.line[0], Vector2(48.0 - TW.ONE_X, 23.0), "the dot, right, middle")
	assert_eq(float(lay.zero_y), -1.0)


func test_window_sizes_and_the_take_switch() -> void:
	GPrefs.set_resources("icons", false)
	var money := GResourceCell.new("money", "MONEY", false)
	var rep := GResourceCell.new("reputation", "REPUTATION", false)
	add_child_autofree(money)
	add_child_autofree(rep)
	assert_eq(money.monitor.custom_minimum_size, Vector2(48, 46))
	assert_eq(rep.monitor.custom_minimum_size, Vector2(40, 40))
	assert_eq(money.take, "icons", "icons by default")
	assert_true(money.plate.visible)
	assert_false(money.monitor.visible)
	money.set_take("traces")
	assert_false(money.plate.visible, "traces: the icon plate gives way")
	assert_true(money.monitor.visible, "to the window")
	money.set_take("sparkline")
	assert_eq(money.take, "icons", "an unknown take shows the icons")
	assert_true(money.plate.visible)
	money.set_take("traces")
	money.set_trace([1.0, 2.0])
	assert_eq(money.monitor.points, [1.0, 2.0])
	await get_tree().process_frame   # one draw, for errors
	assert_true(money.monitor.visible)


# --- the pref and the options row -----------------------------------------------------------------

func test_resources_pref_round_trips_and_falls_back_to_icons() -> void:
	const P := "user://g_ui_test_resources.cfg"
	GPrefs.reload_prefs("user://g_ui_does_not_exist.cfg")
	assert_eq(GPrefs.resources(), "icons", "default: tier icons (spec Q2)")
	GPrefs.set_resources("traces", false)
	assert_eq(GPrefs.save_prefs(P), OK)
	GPrefs.reload_prefs(P)
	assert_eq(GPrefs.resources(), "traces", "round trip")
	var cf := ConfigFile.new()
	cf.set_value("g", "resources", "sparkline")
	assert_eq(cf.save(P), OK)
	GPrefs.reload_prefs(P)
	assert_eq(GPrefs.resources(), "icons", "unknown value -> icons")
	GPrefs.set_resources("bogus", false)
	assert_eq(GPrefs.resources(), "icons", "the setter falls back too")
	DirAccess.remove_absolute(ProjectSettings.globalize_path(P))


func test_options_modal_has_the_resources_row() -> void:
	GPrefs.set_resources("icons", false)
	var m = load("res://scripts/ui/g/g_options_modal.gd").new()
	add_child_autofree(m)
	await get_tree().process_frame
	var p: OptionButton = m.resources_picker
	assert_not_null(p, "a Resources picker")
	assert_eq(p.item_count, 2)
	assert_eq(p.get_item_text(0), "Tier icons")
	assert_eq(p.get_item_text(1), "Traces")
	assert_eq(p.selected, 0, "shows Tier icons by default")
	var vb: Node = m.find_child("ResourcesRow", true, false).get_parent()
	var rows: Array = []
	for c in vb.get_children():
		if String(c.name).ends_with("Row"):
			rows.append(String(c.name))
	assert_eq(rows, ["DeskRow", "RoomRow", "TypewriterRow", "MotionRow", "ResourcesRow"],
		"Resources is the last row, after Typewriter sound and Reduced motion")
	p.select(1)
	p.item_selected.emit(1)
	assert_eq(GPrefs.resources(), "traces", "picking Traces sets the pref at once")
	GPrefs.set_resources("icons", false)
	m.show_panel()
	assert_eq(p.selected, 0, "the picker follows the pref when shown")
	p.select(0)
	p.item_selected.emit(0)   # the picker saves the prefs file; leave it as it was
	assert_eq(GPrefs.resources(), "icons")


# --- the live desk --------------------------------------------------------------------------------

func _boot(desk_on: bool) -> Node:
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


func _ym(main_ui: Node) -> Vector2i:
	return GResourceHistory.year_month(main_ui._last_state)


func _next_month(st: Dictionary, k: int) -> Dictionary:
	var s := st.duplicate(true)
	var cal: Dictionary = s.calendar.duplicate()
	var m0 := int(cal.month) - 1 + k
	cal["year"] = int(cal.year) + floori(m0 / 12.0)
	cal["month"] = (m0 % 12) + 1
	cal["day"] = 1
	s["calendar"] = cal
	return s


func _hash() -> String:
	return JSON.stringify(GameManager.state.to_dict()).sha256_text()


func test_new_game_clears_and_records_month_one_with_icons_the_default() -> void:
	GPrefs.set_resources("icons", false)
	GResourceHistory.note_state(_st(1999, 1, 1.0))
	GResourceHistory.note_state(_st(1999, 2, 2.0))
	var main_ui: Node = await _boot(true)
	var desk: GDesk = main_ui.get_g_desk()
	assert_eq(GResourceHistory.samples.size(), 1, "a new game starts the history afresh")
	var s: Dictionary = GResourceHistory.samples[0]
	assert_eq(Vector2i(int(s.year), int(s.month)), _ym(main_ui), "month 1's sample")
	assert_eq(float(s.money), GTiers.shown_amount(float(main_ui._last_state.money)))
	for key in KEYS:
		var cell: GResourceCell = desk.resource_cells[key]
		assert_eq(cell.take, "icons", "%s: tier icons stay the default" % key)
		assert_true(cell.plate.visible)
		assert_false(cell.monitor.visible)
	assert_false(desk.trace_caption.visible, "no trace caption with icons")


func test_traces_on_the_live_desk_follow_the_months_and_write_nothing() -> void:
	GPrefs.set_resources("traces", false)
	var main_ui: Node = await _boot(true)
	var desk: GDesk = main_ui.get_g_desk()
	assert_true(desk.trace_caption.visible, "the caption shows with traces")
	var since: Label = desk.trace_caption.get_meta("since")
	assert_eq(since.text, "no history yet", "month 1")
	for key in KEYS:
		var cell: GResourceCell = desk.resource_cells[key]
		assert_false(cell.plate.visible, "%s: no icon plate" % key)
		assert_true(cell.monitor.visible, "%s: the trace window" % key)
		assert_eq(cell.monitor.points.size(), 1, "%s: one point in month 1" % key)
		assert_eq(float(cell.monitor.points[0]), GTiers.shown_amount(float(main_ui._last_state[key])))
	assert_eq(desk.trace_caption.get_index(), 0, "the caption is the strip's first cell")
	var first_ym := _ym(main_ui)
	# Made-up months (display only): the windows grow, the game does not change.
	var before := _hash()
	var base: Dictionary = main_ui._last_state.duplicate(true)
	seed(RNG_SEED)
	var expected: Array = []
	for _i in range(5):
		expected.append(randi())
	seed(RNG_SEED)
	for k in range(1, 4):
		var st := _next_month(base, k)
		st["money"] = float(base.money) - 60000.0 * k
		st["research"] = -2.0 + 3.0 * k
		desk._on_state(st)
		desk._on_state(st)   # a second state in the same month adds nothing
	var drawn: Array = []
	for _i in range(5):
		drawn.append(randi())
	assert_eq(drawn, expected, "the desk drew nothing from the global RNG")
	assert_eq(GResourceHistory.samples.size(), 4)
	var money: GResourceCell = desk.resource_cells["money"]
	assert_eq(money.monitor.points.size(), 4, "four months, four points")
	assert_eq(float(money.monitor.points[3]), GTiers.shown_amount(float(base.money) - 180000.0),
		"the last point is the current shown amount")
	assert_eq(since.text, "since %s %d" % [Clock.MONTH_ABBR[first_ym.y - 1], first_ym.x])
	var research: GResourceCell = desk.resource_cells["research"]
	assert_eq(research.monitor.points, [GTiers.shown_amount(float(base.research)), 1.0, 4.0, 7.0])
	await get_tree().process_frame
	assert_eq(_hash(), before, "game state untouched (to_dict carries the RNG state)")
	# The take applies at once, on the next state.
	GPrefs.set_resources("icons", false)
	desk._on_state(main_ui._last_state)
	assert_true(money.plate.visible, "back to icons at once")
	assert_false(desk.trace_caption.visible)


func test_a_load_clears_the_history() -> void:
	var first: Node = await _boot(true)
	GResourceHistory.note_state(_next_month(first._last_state, 1))
	assert_eq(GResourceHistory.samples.size(), 2)
	assert_true(GameManager.save_game(SAVE), "saved the run")
	_root.queue_free()
	await get_tree().process_frame
	GResourceHistory.samples[0]["money"] = 1.0    # a marker: a cleared history loses it
	GameConfig.pending_load_path = SAVE
	var main_ui: Node = await _boot(true)
	assert_eq(GameConfig.pending_load_path, "", "the boot took the load branch")
	assert_eq(GResourceHistory.samples.size(), 1, "a loaded save starts with no history")
	assert_eq(float(GResourceHistory.samples[0].money), GTiers.shown_amount(float(main_ui._last_state.money)),
		"recorded afresh from the loaded state")
	assert_eq(GResourceHistory.caption(), "no history yet")


func test_a_resume_keeps_the_history() -> void:
	await _boot(true)
	assert_eq(GResourceHistory.samples.size(), 1)
	GResourceHistory.samples[0]["money"] = 1.0    # a marker: a kept history still has it
	_root.queue_free()
	await get_tree().process_frame
	GameManager.pending_resume = true
	await _boot(true)
	assert_false(GameManager.pending_resume, "the boot took the resume branch")
	assert_eq(GResourceHistory.samples.size(), 1, "same month: nothing added")
	assert_eq(float(GResourceHistory.samples[0].money), 1.0, "the history survived the resume")


func test_classic_is_untouched() -> void:
	GPrefs.set_resources("traces", false)
	var main_ui: Node = await _boot(false)
	assert_eq(main_ui.get("_ui_layout"), "classic")
	assert_null(main_ui.get_g_desk(), "no desk in classic")
	assert_true(GResourceHistory.samples.is_empty(), "classic records nothing")
	for n in main_ui.get_tree().root.find_children("Trace*", "", true, false):
		assert_false(n is GResourceCell.TraceWindow, "no trace window in classic (%s)" % n.get_path())
	assert_true((main_ui.get_node("TopBar") as CanvasItem).visible, "classic top bar shows")
	assert_string_contains(main_ui.money_label.text, "$", "classic money label as today")

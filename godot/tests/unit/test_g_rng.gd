extends GutTest
## Spec 7.4, phase 4: nothing in G draws from Godot's global random generator. Seed the global
## generator, type a full date (schedule, strikes, pitch, level, the carriage return, the end)
## and check that the next global numbers are the ones they would have been with no G activity.
## (The room's own check is in test_g_room.gd.)

const MAIN_SCENE := "res://scenes/main.tscn"
const DATE := "NOVEMBER 1, 2017"
const SEED := 20171101


func _expected(n: int) -> Array:
	seed(SEED)
	var out: Array = []
	for _i in range(n):
		out.append(randi())
	return out


func _drawn(n: int) -> Array:
	var out: Array = []
	for _i in range(n):
		out.append(randi())
	return out


func _type_through(d: GDateline, t: String) -> void:
	d.type_text(t)
	var tw: Tween = d.get("_tween")
	assert_not_null(tw, "a type-on started")
	tw.pause()
	var left := 4.0
	while left > 0.0 and tw.is_valid():
		tw.custom_step(1.0 / 60.0)
		left -= 1.0 / 60.0


func test_a_full_type_on_draws_nothing_from_the_global_rng() -> void:
	var expected := _expected(5)
	var s := GTypeSound.new()
	add_child_autofree(s)
	var d := GDateline.new()
	d.sound = s
	add_child_autofree(d)
	seed(SEED)
	_type_through(d, DATE)
	assert_false(d.busy, "the type-on ran to its end")
	assert_eq(d.type_log.size(), DATE.length() + 2, "every letter, the carriage and the end fired")
	GDateline.schedule("DECEMBER 1, 2017", d.rng)
	d.type_text("JANUARY 1, 2018")
	d.set_text("JANUARY 2, 2018")          # the busy rule's cut
	assert_eq(_drawn(5), expected, "the global sequence is where it would be with no G activity")


func test_the_live_desk_typing_a_new_month_draws_nothing_from_the_global_rng() -> void:
	var prev_baseline := GameConfig.baseline_mode
	GameConfig.baseline_mode = 2
	GPrefs.set_desk(true, false)
	var root: Node = load(MAIN_SCENE).instantiate()
	add_child_autofree(root)
	var main_ui: Node = root.find_child("MainUI", true, false)
	for _i in range(120):
		await get_tree().process_frame
		if GameManager.is_initialized and String(main_ui.current_turn_phase).to_upper() == "ACTION_SELECTION":
			break
	var desk: GDesk = main_ui.get_g_desk()
	assert_not_null(desk)
	# Let the new game's own type-on finish first (a new month while it runs is cut to set).
	var first: Tween = desk.dateline.get("_tween")
	if first != null and first.is_valid():
		first.pause()
		for _i in range(240):
			if first.is_valid():
				first.custom_step(1.0 / 60.0)
	assert_false(desk.dateline.busy, "the new game's type-on is over")
	var st: Dictionary = main_ui._last_state.duplicate(true)
	var cal: Dictionary = st.calendar.duplicate()
	cal["month"] = 1 if int(cal.month) == 12 else int(cal.month) + 1
	cal["day"] = 1
	st["calendar"] = cal
	var expected := _expected(5)
	seed(SEED)
	desk._refresh_dateline(st)
	assert_true(desk.dateline.busy, "the new month types")
	var tw: Tween = desk.dateline.get("_tween")
	tw.pause()
	for _i in range(240):
		if tw.is_valid():
			tw.custom_step(1.0 / 60.0)
	assert_false(desk.dateline.busy, "and ends")
	assert_eq(_drawn(5), expected, "the desk's dateline drew nothing from the global RNG")
	GameConfig.baseline_mode = prev_baseline
	GPrefs.reload_prefs()

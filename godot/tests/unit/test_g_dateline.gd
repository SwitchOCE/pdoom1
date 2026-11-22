extends GutTest
## G phase 4, the dateline and its sound (fork/design/godot-g/spec.md 5.1.1, 7, 12.2 "Phase 4"):
##   * the date text and the worn ribbon;
##   * schedule() for "NOVEMBER 1, 2017" with its fixed seed (hash of the text): timings, the
##     strike picks, pitch and level ranges, the carriage return and the end;
##   * a type-on driven through its tween: one strike per letter, spaces silent, the carriage
##     return, busy until the end, on the SFX bus from a pool of 12;
##   * the busy rule: the same text is ignored, a different one cuts to set and stops the sound;
##   * reduced motion: shown set, no sound;
##   * the triggers on the real main.tscn: a new game types, a new month types, a day change
##     inside the month does not, a load does not, a resume does not, an F9 flip does not.
## The global-RNG check is in test_g_rng.gd.

const MAIN_SCENE := "res://scenes/main.tscn"
const DATE := "NOVEMBER 1, 2017"
const SAVE := "user://g_dateline_test.save"

var _prev_baseline: int
var _prev_load: String
var _root: Node = null


func before_each() -> void:
	# Blind baseline: no background baseline thread per boot (test_g_paper.gd says why).
	_prev_baseline = GameConfig.baseline_mode
	GameConfig.baseline_mode = 2
	_prev_load = GameConfig.pending_load_path
	GPrefs.set_reduced_motion(false, false)
	GPrefs.set_typewriter_sound(true, false)


func after_each() -> void:
	GameConfig.baseline_mode = _prev_baseline
	GameConfig.pending_load_path = _prev_load
	GameManager.pending_resume = false
	GameManager.month_playback_active = false
	GPrefs.reload_prefs()
	if FileAccess.file_exists(SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SAVE))


func _seeded(t: String) -> RandomNumberGenerator:
	var r := RandomNumberGenerator.new()
	r.seed = hash(t)
	return r


func _standalone(with_sound: bool = true) -> GDateline:
	var d := GDateline.new()
	if with_sound:
		var s := GTypeSound.new()
		add_child_autofree(s)
		d.sound = s
	add_child_autofree(d)
	return d


func _step(d: GDateline, seconds: float, dt: float = 1.0 / 60.0) -> void:
	"""Drive the type-on's tween by hand (paused, so frames do not also advance it)."""
	var t: Tween = d.get("_tween")
	if t == null or not t.is_valid():
		return
	t.pause()
	var left := seconds
	while left > 0.0 and t.is_valid():
		t.custom_step(minf(dt, left))
		left -= dt


# --- text and ribbon ------------------------------------------------------------------------

func test_date_text_is_month_day_year_upper_case() -> void:
	assert_eq(GDateline.date_text({"year": 2017, "month": 11, "day": 1}), DATE)
	assert_eq(GDateline.date_text({"year": 2018, "month": 2, "day": 28}), "FEBRUARY 28, 2018")
	assert_eq(GDateline.date_text({}), "", "no calendar -> no date")


func test_ribbon_is_hs_fixed_pattern() -> void:
	assert_eq(GDateline.RIB_OP, [1.0, 0.86, 0.97, 0.9, 1.0, 0.82, 0.95, 1.0, 0.88],
		"RIB_OP as in hifi3/H/concept.html")
	assert_eq(GDateline.RIB_DY, [0, 1, 0, 0, -1, 0, 1, 0, 0], "RIB_DY as in hifi3/H/concept.html")


# --- the schedule (spec 7.2) ----------------------------------------------------------------

func test_schedule_for_november_1_2017_with_its_fixed_seed() -> void:
	var s := GDateline.schedule(DATE, _seeded(DATE))
	var times: Array = s.letter_times
	assert_eq(times.size(), DATE.length(), "one time per character")
	assert_almost_eq(float(times[0]), 0.06, 0.000001, "first letter at 0.06 s")
	for i in range(1, times.size()):
		var gap := float(times[i]) - float(times[i - 1])
		var extra := 0.0
		if DATE[i] == " ":
			extra += 0.06
		if DATE[i - 1] == ",":
			extra += 0.04
		assert_between(gap - extra, 0.095 - 0.022 - 0.000001, 0.095 + 0.022 + 0.000001,
			"gap %d is 95 +- 22 ms plus its space / comma beat" % i)
	# Pinned for this seed (the same date always types the same way, spec 7.4).
	assert_almost_eq(float(times[15]), 1.569800, 0.00001, "last letter near 1.6 s")
	assert_almost_eq(float(times[8]), 0.812470, 0.00001, "the space after NOVEMBER")
	assert_almost_eq(float(s.cr_time), float(times[15]) + 0.32, 0.000001, "carriage 0.32 after")
	assert_almost_eq(float(s.end_time), float(s.cr_time) + 0.24 + 0.35 + 0.7, 0.000001,
		"end: slide, stop and the room tail")
	assert_eq(s.picks, [5, 3, 2, 3, 2, 1, 5, 3, -1, 1, 0, -1, 3, 0, 2, 1], "pinned picks")
	assert_eq(int(s.strikes), 14, "14 strikes: the two spaces are silent")


func test_schedule_picks_pitch_and_level_stay_in_range() -> void:
	for t in [DATE, "SEPTEMBER 30, 2019", "MAY 9, 2017"]:
		var s := GDateline.schedule(t, _seeded(t))
		var prev := -1
		for i in range(t.length()):
			var pick := int(s.picks[i])
			if t[i] == " ":
				assert_eq(pick, -1, "a space has no strike")
				continue
			assert_between(pick, 0, 5, "a strike is one of six")
			assert_ne(pick, prev, "never the previous strike (%s, %d)" % [t, i])
			prev = pick
			assert_between(float(s.pitches[i]), 0.975, 1.025, "pitch_scale 0.975..1.025")
			assert_between(float(s.volumes[i]), -1.0, 1.0, "volume_db -1..+1")


func test_schedule_repeats_exactly_for_the_same_seed() -> void:
	var a := GDateline.schedule(DATE, _seeded(DATE))
	var b := GDateline.schedule(DATE, _seeded(DATE))
	assert_eq(a, b, "same text, same seed -> same schedule")
	var c := GDateline.schedule("DECEMBER 1, 2017", _seeded("DECEMBER 1, 2017"))
	assert_ne(a.picks, c.picks, "another date types differently")


# --- a type-on ----------------------------------------------------------------------------

func test_type_on_strikes_each_letter_then_the_carriage_and_ends() -> void:
	var d := _standalone()
	d.type_text(DATE)
	assert_true(d.busy, "busy from the start")
	assert_true(d.typing(), "typing")
	assert_eq(d.visible_count, 0, "no glyph yet")
	assert_eq(d.type_count, 1)
	_step(d, 0.07)
	assert_eq(d.visible_count, 1, "the first letter lands at 0.06 s")
	assert_eq(d.sound.ringing(), 1, "with its strike")
	_step(d, 1.0)
	assert_true(d.typing(), "still typing at 1.07 s")
	_step(d, 0.6)
	assert_false(d.typing(), "every letter shown by 1.67 s")
	assert_true(d.busy, "busy-tail: the carriage and the room tail still ring")
	var strikes := 0
	for e in d.type_log:
		if int(e.i) >= 0 and int(e.pick) >= 0:
			strikes += 1
	assert_eq(strikes, 14, "14 strikes, spaces silent")
	_step(d, 0.4)
	assert_eq(String(d.type_log[d.type_log.size() - 1].ch), "CR", "then the carriage return")
	_step(d, 1.4)
	assert_false(d.busy, "not busy after end_time")
	assert_eq(String(d.type_log[d.type_log.size() - 1].ch), "END")
	assert_eq(d.visible_count, -1, "the date is set")


func test_strikes_use_the_sfx_bus_from_a_pool_of_twelve() -> void:
	var d := _standalone()
	assert_eq(d.sound.players.size(), 12, "pool of 12 (spec 7.2, N2)")
	for p in d.sound.players:
		assert_eq(p.bus, &"SFX", "every player on the SFX bus")
	assert_eq(AudioServer.get_bus_index(&"SFX"), 1, "SFX is bus 1, GameConfig.sfx_volume's bus")
	assert_eq(d.sound.strikes.size(), 6, "six strikes")
	for st in d.sound.strikes:
		assert_true(st is AudioStreamWAV, "plain WAV streams, no AudioStreamRandomizer")
		assert_eq((st as AudioStreamWAV).format, AudioStreamWAV.FORMAT_16_BITS, "PCM, not QOA")
		assert_false((st as AudioStreamWAV).stereo, "mono")
	d.type_text(DATE)
	_step(d, 1.0)
	assert_gt(d.sound.ringing(), 6, "tails overlap: more than six ring at once")


func test_pool_reuses_the_oldest_player_when_all_ring() -> void:
	var s := GTypeSound.new()
	add_child_autofree(s)
	var first := s.play_strike(0, 1.0, 0.0)
	for i in range(11):
		s.play_strike(i % 6, 1.0, 0.0)
	assert_eq(s.ringing(), 12)
	var again := s.play_strike(1, 1.0, 0.0)
	assert_eq(again, first, "the 13th strike takes the oldest player")


# --- the busy rule (spec 7.3) -----------------------------------------------------------------

func test_busy_same_text_is_ignored() -> void:
	var d := _standalone()
	d.type_text(DATE)
	_step(d, 0.5)
	var shown := d.visible_count
	d.type_text(DATE)
	d.set_text(DATE)
	assert_true(d.typing(), "the same text lets the type-on run on")
	assert_eq(d.visible_count, shown)
	assert_eq(d.type_count, 1, "no second type-on")


func test_busy_new_text_cuts_to_set_and_stops_every_strike() -> void:
	for how in ["type", "set"]:
		var d := _standalone()
		d.type_text(DATE)
		_step(d, 0.5)
		assert_gt(d.sound.ringing(), 0)
		var logged := d.type_log.size()
		if how == "type":
			d.type_text("DECEMBER 1, 2017")
		else:
			d.set_text("NOVEMBER 2, 2017")
		assert_false(d.busy, "%s: not busy" % how)
		assert_eq(d.visible_count, -1, "%s: shown set" % how)
		assert_eq(d.text, "DECEMBER 1, 2017" if how == "type" else "NOVEMBER 2, 2017")
		assert_eq(d.sound.ringing(), 0, "%s: every player stopped" % how)
		assert_eq(d.type_count, 1, "%s: never two datelines" % how)
		await get_tree().process_frame
		await get_tree().process_frame
		assert_eq(d.type_log.size(), logged, "%s: no later strike" % how)


func test_reduced_motion_shows_it_set_with_no_sound() -> void:
	var d := _standalone()
	d.reduced_motion = true
	d.type_text(DATE)
	assert_false(d.busy)
	assert_eq(d.visible_count, -1)
	assert_eq(d.text, DATE)
	assert_eq(d.sound.ringing(), 0, "no sound")
	assert_eq(d.type_count, 0)


func test_reduced_motion_pref_round_trips() -> void:
	const P := "user://g_ui_test_dateline.cfg"
	GPrefs.reload_prefs("user://g_ui_does_not_exist.cfg")
	assert_false(GPrefs.reduced_motion(), "default off")
	GPrefs.set_reduced_motion(true, false)
	assert_eq(GPrefs.save_prefs(P), OK)
	GPrefs.reload_prefs(P)
	assert_true(GPrefs.reduced_motion())
	DirAccess.remove_absolute(ProjectSettings.globalize_path(P))


func test_typewriter_sound_off_types_the_date_silently() -> void:
	# Alex, 2026-11-23: "include a mute option for it". Off: the date still types, no strikes.
	GPrefs.set_typewriter_sound(false, false)
	var d := _standalone()
	d.type_text(DATE)
	_step(d, 0.07)
	assert_eq(d.visible_count, 1, "the letters still type in")
	assert_eq(d.sound.ringing(), 0, "no strike")
	_step(d, 3.0)
	assert_eq(d.sound.ringing(), 0, "no carriage return either")
	assert_eq(d.visible_count, -1, "the date is set")
	assert_null(d.sound.play_strike(0, 1.0, 0.0), "a direct strike is silent too")


func test_typewriter_sound_pref_round_trips_and_defaults_on() -> void:
	const P := "user://g_ui_test_typewriter.cfg"
	GPrefs.reload_prefs("user://g_ui_does_not_exist.cfg")
	assert_true(GPrefs.typewriter_sound(), "default on")
	GPrefs.set_typewriter_sound(false, false)
	assert_eq(GPrefs.save_prefs(P), OK)
	GPrefs.reload_prefs(P)
	assert_false(GPrefs.typewriter_sound())
	DirAccess.remove_absolute(ProjectSettings.globalize_path(P))


func test_options_modal_has_the_typewriter_switch() -> void:
	var m = load("res://scripts/ui/g/g_options_modal.gd").new()
	add_child_autofree(m)
	await get_tree().process_frame
	var t: CheckButton = m.typewriter_toggle
	assert_not_null(t, "a Typewriter sound switch")
	assert_true(t.button_pressed, "shows on by default")
	t.button_pressed = false
	assert_false(GPrefs.typewriter_sound(), "turning it off mutes the strikes at once")
	t.button_pressed = true  # the switch saves the prefs file; leave it as it was
	assert_true(GPrefs.typewriter_sound())


# --- the triggers (spec 5.1.1) ------------------------------------------------------------------

func test_trigger_rules() -> void:
	var none := Vector2i(-1, -1)
	var nov := Vector2i(2017, 11)
	assert_eq(GDesk.dateline_action(none, nov, "new"), "type", "a new game types")
	for boot in ["load", "resume", "live"]:
		assert_eq(GDesk.dateline_action(none, nov, boot), "set", "%s shows it set" % boot)
	assert_eq(GDesk.dateline_action(nov, nov, "new"), "set", "a day change inside the month")
	assert_eq(GDesk.dateline_action(nov, Vector2i(2017, 12), "load"), "type", "a new month")
	assert_eq(GDesk.dateline_action(Vector2i(2017, 12), Vector2i(2018, 1), "resume"), "type",
		"a new year's month")
	assert_eq(GDesk.dateline_boot_kind(true, true, "x"), "live", "an F9 flip over a live run")
	assert_eq(GDesk.dateline_boot_kind(false, true, ""), "resume")
	assert_eq(GDesk.dateline_boot_kind(false, false, "user://a.save"), "load")
	assert_eq(GDesk.dateline_boot_kind(false, false, ""), "new")


func _boot() -> Node:
	GPrefs.set_desk(true, false)
	var root: Node = load(MAIN_SCENE).instantiate()
	add_child_autofree(root)
	_root = root
	var main_ui: Node = root.find_child("MainUI", true, false)
	for _i in range(120):
		await get_tree().process_frame
		if GameManager.is_initialized and String(main_ui.current_turn_phase).to_upper() == "ACTION_SELECTION":
			break
	await get_tree().process_frame
	return main_ui


func _state_on(main_ui: Node, y: int, m: int, day: int) -> Dictionary:
	var s: Dictionary = main_ui._last_state.duplicate(true)
	var cal: Dictionary = s.get("calendar", {}).duplicate()
	cal["year"] = y
	cal["month"] = m
	cal["day"] = day
	s["calendar"] = cal
	return s


func test_new_game_types_and_the_month_rules_on_the_live_desk() -> void:
	var main_ui: Node = await _boot()
	var desk: GDesk = main_ui.get_g_desk()
	var dl: GDateline = desk.dateline
	assert_eq(desk.dateline_boot, "new")
	assert_eq(dl.type_count, 1, "the new game's first state typed the date")
	assert_eq(dl.text, GDateline.date_text(main_ui._last_state.calendar), "the run's date")
	assert_eq(dl.sound, desk.type_sound, "strikes play on the desk's TypeSound")
	_step(dl, 4.0)
	assert_false(dl.busy)
	var cal: Dictionary = main_ui._last_state.calendar
	var y := int(cal.year)
	var m := int(cal.month)
	# A day change inside the month (WATCH): set in place, no type-on.
	desk._refresh_dateline(_state_on(main_ui, y, m, int(cal.day) + 1))
	assert_eq(dl.type_count, 1, "a day change inside the month does not type")
	assert_false(dl.busy)
	assert_eq(dl.text, GDateline.date_text({"year": y, "month": m, "day": int(cal.day) + 1}))
	# A new month types.
	var ny := y + (1 if m == 12 else 0)
	var nm := 1 if m == 12 else m + 1
	desk._refresh_dateline(_state_on(main_ui, ny, nm, 1))
	assert_eq(dl.type_count, 2, "a new month types")
	assert_true(dl.typing())
	# The next plan-phase state carries the same date: the type-on runs on.
	desk._refresh_dateline(_state_on(main_ui, ny, nm, 1))
	assert_true(dl.typing(), "the same date lets it finish")
	# Playback starts within 1.6 s: the next state with a new day cuts it to set.
	desk._refresh_dateline(_state_on(main_ui, ny, nm, 2))
	assert_false(dl.busy, "a new day mid-type cuts the dateline to set")
	assert_eq(desk.type_sound.ringing(), 0, "and stops the strikes")
	assert_eq(dl.type_count, 2)


func test_f9_flip_over_a_live_run_shows_the_date_set() -> void:
	var main_ui: Node = await _boot()
	main_ui._apply_ui_layout("classic")
	await get_tree().process_frame
	main_ui._apply_ui_layout("g")
	await get_tree().process_frame
	var desk: GDesk = main_ui.get_g_desk()
	assert_eq(desk.dateline_boot, "live")
	assert_eq(desk.dateline.type_count, 0, "a flip does not type")
	assert_eq(desk.dateline.text, GDateline.date_text(main_ui._last_state.calendar))


func test_resume_after_a_conference_shows_the_date_set() -> void:
	var first: Node = await _boot()
	var date := GDateline.date_text(first._last_state.calendar)
	_root.queue_free()
	await get_tree().process_frame
	# main.tscn re-entered with the run still live (ADR-0014): _boot_game resumes in place.
	GameManager.pending_resume = true
	var main_ui: Node = await _boot()
	var desk: GDesk = main_ui.get_g_desk()
	assert_false(GameManager.pending_resume, "the boot took the resume branch")
	assert_eq(desk.dateline_boot, "resume")
	assert_eq(desk.dateline.type_count, 0, "a resume does not type")
	assert_eq(desk.dateline.text, date, "the same run's date, set")


func test_load_shows_the_date_set() -> void:
	await _boot()
	assert_true(GameManager.save_game(SAVE), "saved the run")
	_root.queue_free()
	await get_tree().process_frame
	GameConfig.pending_load_path = SAVE
	var main_ui: Node = await _boot()
	var desk: GDesk = main_ui.get_g_desk()
	assert_eq(GameConfig.pending_load_path, "", "the boot took the load branch")
	assert_eq(desk.dateline_boot, "load")
	assert_eq(desk.dateline.type_count, 0, "a load does not type")
	assert_ne(desk.dateline.text, "", "the loaded run's date is shown")
	assert_eq(desk.dateline.text, GDateline.date_text(main_ui._last_state.calendar))


func test_dateline_draws_in_the_theme_face_at_header_size() -> void:
	var main_ui: Node = await _boot()
	var dl: GDateline = main_ui.get_g_desk().dateline
	assert_eq(dl.get_theme_font_size("font_size"), ThemeManager.get_font_size("header"))
	assert_eq(GDesk.ink_of(dl), GDesk.C.dateline, "#d9d1bf")
	assert_gte(dl.size.x, 420.0, "420 wide")
	assert_lt(dl.text_width(), 420.0, "the date fits its slot")
	var long := GDateline.new()
	GDesk.set_step(long, "header")
	dl.add_child(long)
	long.text = "SEPTEMBER 30, 2017"
	assert_lte(long.text_width(), 420.0, "the longest month's date fits too")
	long.queue_free()

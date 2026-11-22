extends GutTest
## G desk, phases 3a and 3b (fork/design/godot-g/spec.md 12.2, 5.14): the room by doom band. The
## band comes from doom, never the month; the band tween reaches the new band and is instant
## with reduced motion; grain freezes in pause and is static with reduced motion; `simple` and
## `off` set what 5.14 says; the band override is debug-only; no global RNG draw; classic keeps
## today's room, and leaving G puts it back. 3b: the floor smoke shows at bands 5-6 (blended by
## the shown band), hides in simple and off, drifts on a pausable looping tween, is static with
## reduced motion, and sits under every panel.

const MAIN_SCENE := "res://scenes/main.tscn"
const TEST_PREFS := "user://g_ui_room_test.cfg"


func after_each() -> void:
	get_tree().paused = false
	if FileAccess.file_exists(TEST_PREFS):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(TEST_PREFS))
	GPrefs.reload_prefs()
	GameManager.month_playback_active = false


## A room on its own, driving a stand-in Backdrop and scrim the way it drives main.tscn's.
func _room(mode: String = "full", reduced: bool = false) -> GRoom:
	var holder := Control.new()
	holder.size = Vector2(1920, 1080)
	add_child_autofree(holder)
	var bd := TextureRect.new()
	bd.name = "Backdrop"
	bd.texture = load("res://assets/images/backgrounds/office_wide_day.webp")
	bd.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bd.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	bd.modulate = GRoom.OFF_MODULATE
	holder.add_child(bd)
	bd.position = Vector2.ZERO
	bd.size = Vector2(1920, 1080)
	var scrim := ColorRect.new()
	scrim.name = "BackdropScrim"
	holder.add_child(scrim)
	var room := GRoom.new()
	holder.add_child(room)
	room.attach(bd, scrim, mode, reduced)
	return room


# --- band from doom -------------------------------------------------------------------------

func test_band_comes_from_doom_through_theme_manager() -> void:
	for doom in [0.0, 14.9, 15.0, 36.9, 37.0, 51.9, 52.0, 66.9, 67.0, 79.9, 80.0, 91.9, 92.0, 100.0]:
		assert_eq(GRoom.band_for_doom(doom), ThemeManager.get_doom_band_index(doom), "doom %.1f" % doom)


func test_band_ignores_the_month() -> void:
	var room := _room("full", true)
	room.update_from_state({"doom": 55.0, "turn": 1, "month": 7, "calendar_month": 7})
	assert_eq(room.target_band, 3, "SEVERE")
	room.update_from_state({"doom": 55.0, "turn": 30, "month": 1, "calendar_month": 1})
	assert_eq(room.target_band, 3, "same doom, another month: same band")
	room.update_from_state({"turn": 31, "month": 2})
	assert_eq(room.target_band, 3, "a state without doom leaves the room alone")
	room.update_from_state({"doom": 10.0, "turn": 31, "month": 2})
	assert_eq(room.target_band, 0, "doom falls, the room lightens")


func test_first_state_lands_instantly() -> void:
	# A freshly built room at high doom (a load, a resume, an F9 flip) starts at the run's band;
	# it does not fade down from band 0 as if doom were rising.
	var room := _room("full", false)
	room.update_from_state({"doom": 95.0})
	assert_almost_eq(room.shown_band, 6.0, 0.001, "the first state is instant")
	room.update_from_state({"doom": 5.0})
	assert_true(room._tween != null and room._tween.is_valid(), "later band changes still tween")


# --- the band tween (spec 6.2) ----------------------------------------------------------------

func test_band_tween_reaches_the_new_band() -> void:
	var room := _room("full", false)
	room.set_band(0, true)
	room.set_band(3)
	assert_almost_eq(room.shown_band, 0.0, 0.001, "starts where it was")
	assert_not_null(room._tween, "a tween runs")
	room._tween.custom_step(0.6)
	assert_between(room.shown_band, 0.5, 2.5, "half way through 1.2 s, between the two bands")
	# A further change mid-tween starts from the current value.
	var mid := room.shown_band
	room.set_band(5)
	assert_almost_eq(room.shown_band, mid, 0.001, "the new tween starts from the current value")
	room._tween.custom_step(GRoom.TWEEN_S + 0.1)
	assert_almost_eq(room.shown_band, 5.0, 0.001, "reaches the new band")
	assert_almost_eq(float(room.material_room.get_shader_parameter("band")), 5.0, 0.001, "the uniform follows")
	assert_eq(room.glows[0].self_modulate, GRoom.glow_color(5.0), "the glows follow")


func test_band_change_is_instant_with_reduced_motion() -> void:
	var room := _room("full", true)
	room.set_band(0, true)
	room.set_band(6)
	assert_almost_eq(room.shown_band, 6.0, 0.001, "instant")
	assert_true(room._tween == null, "no tween")


# --- grain (spec 5.14, 6.3) ---------------------------------------------------------------------

func test_grain_moves_twelve_steps_a_second_and_freezes_in_pause() -> void:
	var room := _room("full", false)
	assert_eq(room.process_mode, Node.PROCESS_MODE_INHERIT, "pausable: inherits the tree's pause")
	assert_true(room.is_processing(), "full mode moves the grain")
	for _i in range(30):
		await get_tree().process_frame
	assert_gt(room.grain_step, 0, "grain stepped while running")
	get_tree().paused = true
	await get_tree().process_frame
	var step := room.grain_step
	var offset := room.grain_offset
	for _i in range(30):
		await get_tree().process_frame
	assert_false(room.can_process(), "the room does not process in pause")
	assert_eq(room.grain_step, step, "grain frozen in pause")
	assert_eq(room.grain_offset, offset, "offset frozen in pause")
	get_tree().paused = false
	for _i in range(30):
		await get_tree().process_frame
	assert_gt(room.grain_step, step, "grain goes on after pause")


func test_grain_offset_is_a_function_of_the_step() -> void:
	var room := _room("full", true)
	room.set_grain_step(7)
	var a := room.grain_offset
	room.set_grain_step(8)
	room.set_grain_step(7)
	assert_eq(room.grain_offset, a, "same step, same offset")
	assert_eq(room.material_room.get_shader_parameter("grain_offset"), a, "the uniform follows")


func test_grain_is_static_with_reduced_motion() -> void:
	var room := _room("full", true)
	for _i in range(30):
		await get_tree().process_frame
	assert_eq(room.grain_step, 0, "no grain steps")


# --- modes (spec 5.14) ---------------------------------------------------------------------------

func test_full_mode_puts_the_shader_on_the_backdrop() -> void:
	var room := _room("full", true)
	room.set_band(2, true)
	assert_eq(room.backdrop.material, room.material_room, "the room material")
	assert_eq(room.material_room.shader.resource_path, GRoom.SHADER_PATH)
	for p in ["window_mask", "noise_lo", "noise_hi"]:
		assert_not_null(room.material_room.get_shader_parameter(p), "%s set" % p)
	assert_eq(room.backdrop.modulate, Color.WHITE, "modulate white")
	assert_false(room.scrim.visible, "scrim hidden")
	for g in room.glows:
		assert_true(g.visible, "glows on")
		assert_eq((g.material as CanvasItemMaterial).blend_mode, CanvasItemMaterial.BLEND_MODE_ADD)


func test_simple_mode_is_brightness_times_tint_without_shader() -> void:
	var room := _room("simple", false)
	room.set_band(4, true)
	assert_null(room.backdrop.material, "no shader")
	assert_eq(room.backdrop.modulate, GRoom.simple_modulate(4.0), "brightness x grade tint")
	var expect := Color(1, 1, 1).lerp(Color(62.0 / 255.0, 16.0 / 255.0, 24.0 / 255.0), 0.40) * 0.44
	assert_almost_eq(room.backdrop.modulate.r, expect.r, 0.001)
	assert_almost_eq(room.backdrop.modulate.g, expect.g, 0.001)
	assert_false(room.scrim.visible, "scrim hidden")
	assert_true(room.glows[0].visible, "glows kept")
	assert_false(room.is_processing(), "no grain")


func test_off_mode_is_todays_room() -> void:
	var room := _room("off", false)
	room.set_band(5, true)
	assert_null(room.backdrop.material, "no shader")
	assert_eq(room.backdrop.modulate, GRoom.OFF_MODULATE, "today's 0.35")
	assert_true(room.scrim.visible, "today's scrim")
	for g in room.glows:
		assert_false(g.visible, "no glows")
	assert_false(room.is_processing(), "no grain")


func test_unknown_mode_falls_back_to_full_and_prefs_round_trip() -> void:
	assert_eq(GRoom._valid_mode("fancy"), "full")
	GPrefs.reload_prefs("user://g_ui_does_not_exist.cfg")
	assert_eq(GPrefs.room_effects(), "full", "default full")
	assert_false(GPrefs.reduced_motion(), "default off")
	GPrefs.set_room_effects("simple", false)
	GPrefs.set_reduced_motion(true, false)
	assert_eq(GPrefs.save_prefs(TEST_PREFS), OK)
	GPrefs.reload_prefs("user://g_ui_does_not_exist.cfg")
	GPrefs.reload_prefs(TEST_PREFS)
	assert_eq(GPrefs.room_effects(), "simple", "room_effects survives")
	assert_true(GPrefs.reduced_motion(), "reduced_motion survives")
	GPrefs.set_room_effects("bogus", false)
	assert_eq(GPrefs.room_effects(), "full", "an unknown value falls back to full")


func test_glows_sit_on_the_lit_crts_at_1080() -> void:
	var room := _room("full", true)
	room._layout_glows()
	# office_wide_day at 1920x1080, covered: scale 1.25, 100 px cropped off the top.
	var cr := room.covered_rect()
	assert_almost_eq(cr.position.y, -100.0, 0.5)
	assert_almost_eq(cr.size.x, 1920.0, 0.5)
	var left: TextureRect = room.glows[0]
	var c := left.position + left.size * 0.5
	assert_almost_eq(c.x, 205.0 * 1.25, 0.5)
	assert_almost_eq(c.y, 606.0 * 1.25 - 100.0, 0.5)


# --- floor smoke (phase 3b, spec 5.14) ----------------------------------------------------------

func test_smoke_amount_is_zero_to_band_four_and_042_at_five_and_six() -> void:
	for b in range(5):
		assert_eq(GRoom.smoke_amount(float(b)), 0.0, "band %d: no smoke" % b)
	assert_almost_eq(GRoom.smoke_amount(5.0), 0.42, 0.0001, "band 5")
	assert_almost_eq(GRoom.smoke_amount(6.0), 0.42, 0.0001, "band 6")
	assert_almost_eq(GRoom.smoke_amount(4.5), 0.21, 0.0001, "between 4 and 5: blended")
	assert_almost_eq(GRoom.smoke_amount(4.25), 0.105, 0.0001, "a quarter of the way")


func test_smoke_follows_the_shown_band_and_fades_in_with_the_band_tween() -> void:
	var room := _room("full", false)
	assert_not_null(room.smoke, "the smoke layer exists")
	assert_eq(room.smoke.texture.resource_path, GRoom.SMOKE_PATH)
	room.set_band(4, true)
	assert_false(room.smoke.visible, "band 4: no smoke shown")
	assert_eq(room.smoke.self_modulate.a, 0.0, "band 4: amount 0")
	room.set_band(5)
	room._tween.custom_step(GRoom.TWEEN_S * 0.5)
	assert_almost_eq(room.smoke.self_modulate.a, GRoom.smoke_amount(room.shown_band), 0.0001,
		"mid-tween the smoke uses the same float band as the shader")
	assert_between(room.smoke.self_modulate.a, 0.01, 0.41, "half way in")
	assert_true(room.smoke.visible, "shown as soon as it has any amount")
	room._tween.custom_step(GRoom.TWEEN_S)
	assert_almost_eq(room.smoke.self_modulate.a, 0.42, 0.0001, "band 5: .42")
	var c: Color = room.smoke.self_modulate
	assert_eq(Color(c.r, c.g, c.b), Color(GRoom.SMOKE_TINT.r, GRoom.SMOKE_TINT.g, GRoom.SMOKE_TINT.b), "violet")
	assert_null(room.smoke.material, "normal blend (no additive material)")
	room.set_band(6, true)
	assert_almost_eq(room.smoke.self_modulate.a, 0.42, 0.0001, "band 6: .42")


func test_smoke_is_bottom_anchored_over_the_room() -> void:
	var room := _room("full", true)
	room.set_band(6, true)
	room._layout_smoke()
	var r: TextureRect = room.smoke
	assert_almost_eq(r.position.y + r.size.y, 1080.0, 0.5, "sits on the bottom edge")
	assert_almost_eq(r.size.y, 520.0, 0.5, "the mock-up's 520 of 1080")
	assert_almost_eq(r.size.x, 1920.0 + GRoom.SMOKE_DRIFT_PX, 0.5, "the room's width plus the drift")
	assert_true(r.position.x <= 0.0 and r.position.x + r.size.x >= 1920.0, "covers the room at any drift")
	assert_eq(r.mouse_filter, Control.MOUSE_FILTER_IGNORE, "takes no clicks")


func test_smoke_hidden_in_simple_and_off() -> void:
	for m in ["simple", "off"]:
		var room := _room(m, false)
		room.set_band(6, true)
		assert_false(room.smoke.visible, "%s: no smoke at band 6" % m)
		assert_true(room._drift_tween == null, "%s: no drift" % m)
	var full := _room("full", false)
	full.set_band(6, true)
	assert_true(full.smoke.visible, "full: smoke at band 6")
	full.set_mode("simple")
	assert_false(full.smoke.visible, "flip to simple hides it")
	full.set_mode("full")
	assert_true(full.smoke.visible, "back to full shows it")


func test_smoke_drifts_freezes_in_a_real_pause_and_goes_on() -> void:
	var room := _room("full", false)
	room.set_band(6, true)
	assert_true(room._drift_tween != null and room._drift_tween.is_valid(), "full: the drift tween runs")
	assert_eq(room._drift_tween.get_loops_left(), -1, "it loops for ever")
	# Into the steep middle of the 20 s leg, so real frames move it measurably.
	room._drift_tween.custom_step(GRoom.SMOKE_DRIFT_S * 0.5)
	assert_almost_eq(room.smoke_drift, GRoom.SMOKE_DRIFT_PX * 0.5, 0.01, "half way at 10 s")
	assert_almost_eq(room.smoke.position.x, -GRoom.SMOKE_DRIFT_PX + room.smoke_drift, 0.001, "the layer moves")
	var before := room.smoke_drift
	for _i in range(30):
		await get_tree().process_frame
	assert_gt(room.smoke_drift, before, "drifts while running")
	get_tree().paused = true
	await get_tree().process_frame
	var held := room.smoke_drift
	for _i in range(30):
		await get_tree().process_frame
	assert_eq(room.smoke_drift, held, "frozen in pause")
	get_tree().paused = false
	for _i in range(30):
		await get_tree().process_frame
	assert_gt(room.smoke_drift, held, "goes on after pause")


func test_smoke_drift_turns_back_after_twenty_seconds() -> void:
	var room := _room("full", false)
	room.set_band(5, true)
	room._drift_tween.custom_step(GRoom.SMOKE_DRIFT_S)
	assert_almost_eq(room.smoke_drift, GRoom.SMOKE_DRIFT_PX, 0.01, "40 px out at 20 s")
	room._drift_tween.custom_step(GRoom.SMOKE_DRIFT_S)
	assert_almost_eq(room.smoke_drift, 0.0, 0.01, "back at 40 s")
	room._drift_tween.custom_step(GRoom.SMOKE_DRIFT_S * 0.5)
	assert_almost_eq(room.smoke_drift, GRoom.SMOKE_DRIFT_PX * 0.5, 0.01, "and round again")


func test_smoke_is_static_with_reduced_motion() -> void:
	var room := _room("full", true)
	room.set_band(6, true)
	assert_true(room.smoke.visible, "the smoke still shows")
	assert_true(room._drift_tween == null, "no drift tween")
	var x := room.smoke.position.x
	for _i in range(30):
		await get_tree().process_frame
	assert_eq(room.smoke_drift, 0.0, "no drift")
	assert_eq(room.smoke.position.x, x, "static")


func test_smoke_sits_under_every_panel() -> void:
	var room := _room("full", true)
	assert_eq(room.smoke.get_parent(), room.smoke_slot, "in SmokeSlot")
	assert_eq(room.smoke_slot.get_parent(), room, "SmokeSlot in RoomLayers")
	for n in [room.smoke, room.smoke_slot]:
		assert_eq((n as CanvasItem).z_index, 0, "%s: no z lift" % n.name)
		assert_false((n as CanvasItem).top_level, "%s: not top level" % n.name)
	assert_eq(room.smoke_slot.mouse_filter, Control.MOUSE_FILTER_IGNORE)


# --- debug-only override ---------------------------------------------------------------------------

func test_override_holds_the_band_in_debug_builds_only() -> void:
	var room := _room("full", false)
	assert_true(OS.is_debug_build(), "tests run in a debug build")
	assert_true(room.debug_force_band(6), "taken in a debug build")
	assert_almost_eq(room.shown_band, 6.0, 0.001, "instant")
	room.update_from_state({"doom": 5.0})
	assert_eq(room.target_band, 6, "doom does not move a forced room")
	room.debug_force_band(-1)
	room.update_from_state({"doom": 5.0})
	assert_eq(room.target_band, 0, "released: doom drives it again")
	var src := FileAccess.get_file_as_string("res://scripts/ui/g/g_room.gd")
	var body := src.substr(src.find("func debug_force_band"))
	assert_string_contains(body.substr(0, 600), "if not OS.is_debug_build():\n\t\treturn false",
		"a release build returns before touching the room")


func test_nothing_in_the_game_calls_the_override() -> void:
	var hits: Array = []
	_scan("res://scripts", hits)
	_scan("res://autoload", hits)
	assert_eq(hits, ["res://scripts/ui/g/g_room.gd"], "only its own file names it")


func _scan(dir: String, hits: Array) -> void:
	var d := DirAccess.open(dir)
	if d == null:
		return
	for f in d.get_files():
		if f.ends_with(".gd"):
			var p := dir.path_join(f)
			if FileAccess.get_file_as_string(p).contains("debug_force_band"):
				hits.append(p)
	for sub in d.get_directories():
		_scan(dir.path_join(sub), hits)


# --- no RNG (spec 7.4) ---------------------------------------------------------------------------------

func test_the_room_draws_no_global_random_number() -> void:
	seed(424242)
	var expect := [randi(), randi(), randi()]
	seed(424242)
	var room := _room("full", false)
	room.update_from_state({"doom": 5.0})  # the first state lands instantly
	room.update_from_state({"doom": 60.0})
	room._tween.custom_step(0.5)
	room.update_from_state({"doom": 95.0})
	room._tween.custom_step(2.0)
	for i in range(40):
		room._process(1.0 / 12.0)
	room.set_mode("simple")
	room.set_band(2)
	room.set_mode("off")
	room.set_mode("full")
	room.debug_force_band(6)
	room._drift_tween.custom_step(27.0)
	room.debug_force_band(4)
	room._layout_glows()
	room._layout_smoke()
	assert_gt(room.grain_step, 0, "grain did step")
	assert_gt(room.smoke_drift, 0.0, "the smoke did drift")
	assert_eq([randi(), randi(), randi()], expect, "the global sequence is unchanged")


# --- live: G and classic on main.tscn ----------------------------------------------------------------

func _boot(desk_on: bool) -> Node:
	GPrefs.set_desk(desk_on, false)
	GPrefs.set_room_effects("full", false)
	var root: Node = load(MAIN_SCENE).instantiate()
	add_child_autofree(root)
	var main_ui: Node = root.find_child("MainUI", true, false)
	for _i in range(120):
		await get_tree().process_frame
		if GameManager.is_initialized and String(main_ui.current_turn_phase).to_upper() == "ACTION_SELECTION":
			break
	await get_tree().process_frame
	return main_ui


func test_live_g_desk_grades_the_backdrop_and_classic_comes_back() -> void:
	var main_ui: Node = await _boot(true)
	var root: Node = main_ui.get_parent().get_parent()
	var bd: TextureRect = root.get_node("Backdrop")
	var scrim: CanvasItem = root.get_node("BackdropScrim")
	var desk = main_ui.get_g_desk()
	assert_not_null(desk, "G is up")
	var room: GRoom = desk.room
	assert_eq(desk.get_child(0), room, "RoomLayers is the desk's first child, under every panel")
	assert_true(room.is_ancestor_of(room.smoke), "the floor smoke is inside RoomLayers, so under every panel")
	assert_eq(room.z_index, 0, "RoomLayers has no z lift")
	for i in range(1, desk.get_child_count()):
		var c: Node = desk.get_child(i)
		if c is CanvasItem:
			assert_true((c as CanvasItem).z_index >= room.z_index, "%s draws over the room" % c.name)
	assert_eq(room.mouse_filter, Control.MOUSE_FILTER_IGNORE)
	assert_eq(bd.material, room.material_room, "the Backdrop carries the room shader")
	assert_eq(bd.modulate, Color.WHITE)
	assert_false(scrim.visible)
	var doom := float(GameManager.state.doom)
	assert_eq(room.target_band, ThemeManager.get_doom_band_index(doom), "band from the run's doom")
	main_ui._apply_ui_layout("classic")
	await get_tree().process_frame
	assert_null(main_ui.get_g_desk(), "desk gone")
	assert_null(bd.material, "today's Backdrop: no material")
	assert_eq(bd.modulate, GRoom.OFF_MODULATE, "today's 0.35")
	assert_true(scrim.visible, "today's scrim")


func test_classic_keeps_todays_room() -> void:
	var main_ui: Node = await _boot(false)
	var root: Node = main_ui.get_parent().get_parent()
	var bd: TextureRect = root.get_node("Backdrop")
	assert_null(main_ui.get_g_desk(), "classic")
	assert_null(bd.material, "no material")
	assert_eq(bd.modulate, GRoom.OFF_MODULATE, "0.35 as main.tscn sets it")
	assert_true(root.get_node("BackdropScrim").visible, "scrim shown")
	assert_null(root.find_child("RoomLayers", true, false), "no room layer")
	assert_null(root.find_child("FloorSmoke", true, false), "no floor smoke")

extends GutTest
## G phase 5, tier icons (fork/design/godot-g/spec.md 5.1.2 take a, 6.2, 11.2, 12.2 "Phase 5"):
##   * GTiers: the shown amount and tier boundaries on shown amounts (60, 60.25, 60.5, 0.25,
##     -0.4 from the H council), every resource's table lines, the tags;
##   * the 25 shipped icons: names, size, import settings (lossless, mipmaps, fix alpha
##     border, premult off) and the mipmapped texture filter on the cell;
##   * a GResourceCell shows the right tier icon, text, colour and tag for a range of amounts,
##     crossfades on a tier change (instant with reduced motion);
##   * reputation's "0 ends the run" note: the 0 in blood_text at 4.5:1 or more on the panel;
##   * on the real main.tscn: each cell follows the state, the desk stays a pure view, and
##     classic is untouched.

const MAIN_SCENE := "res://scenes/main.tscn"
const KEYS := ["money", "compute", "research", "papers", "reputation"]

var _prev_hint: bool
var _prev_baseline: int


func before_each() -> void:
	_prev_hint = GameConfig.show_first_lever_hint
	GameConfig.show_first_lever_hint = false
	# Blind baseline: no background baseline thread per boot (the unjoined-thread flake noted
	# in test_g_paper.gd).
	_prev_baseline = GameConfig.baseline_mode
	GameConfig.baseline_mode = 2
	GResourceCell.reduced_motion = false


func after_each() -> void:
	GameConfig.show_first_lever_hint = _prev_hint
	GameConfig.baseline_mode = _prev_baseline
	GResourceCell.reduced_motion = false
	GPrefs.reload_prefs()
	GameManager.month_playback_active = false


# --- GTiers --------------------------------------------------------------------------------

func test_shown_amount_rounds_half_away_and_keeps_the_sign() -> void:
	assert_eq(GTiers.shown_amount(60.0), 60.0)
	assert_eq(GTiers.shown_amount(60.25), 60.0)
	assert_eq(GTiers.shown_amount(60.5), 61.0)
	assert_eq(GTiers.shown_amount(0.25), 0.0)
	assert_eq(GTiers.shown_amount(-0.4), 0.0, "-0.4 shows as -0, which equals 0")
	assert_eq(GTiers.shown_amount(-0.5), -1.0, "half away from zero on the negative side")
	assert_eq(GTiers.shown_amount(-12.0), -12.0)


func test_shown_amount_is_the_number_the_game_prints() -> void:
	for raw in [60.0, 60.25, 60.5, 0.25, -0.4, -0.5, 1.5, 2.5, 19999.5, 245000.49, -7.6]:
		var shown := GTiers.shown_amount(raw)
		var printed := GameConfig.format_scalar(raw).replace(",", "")
		assert_eq(absf(shown), float(printed.trim_prefix("-")),
			"%s: the shown amount is the printed digits (%s)" % [raw, printed])


func test_h_council_boundaries_on_shown_amounts() -> void:
	assert_eq(GTiers.tier_of_raw("reputation", 60.0), 3, "60 prints 60: tier 3")
	assert_eq(GTiers.tier_of_raw("reputation", 60.25), 3, "60.25 prints 60: tier 3")
	assert_eq(GTiers.tier_of_raw("reputation", 60.5), 4, "60.5 prints 61: tier 4")
	assert_eq(GTiers.tier_of_raw("reputation", 0.25), 0, "0.25 prints 0: tier 0")
	assert_eq(GTiers.tier_of_raw("reputation", -0.4), 0, "-0.4 prints -0: tier 0")
	assert_eq(GameConfig.format_scalar(-0.4), "-0", "-0 still prints as today")


func test_every_resource_table_line() -> void:
	# [amount, tier] pairs on both sides of every line of spec 5.1.2's table.
	var cases := {
		"money": [[-5000, 0], [0, 0], [1, 1], [20000, 1], [20001, 2], [99999, 2], [100000, 3],
			[245000, 3], [249999, 3], [250000, 4], [1000000, 4]],
		"compute": [[-1, 0], [0, 0], [1, 1], [49, 1], [50, 2], [99, 2], [100, 3], [199, 3], [200, 4]],
		"research": [[-12, 0], [0, 0], [1, 1], [9, 1], [10, 2], [19, 2], [20, 3], [49, 3], [50, 4]],
		"papers": [[0, 0], [1, 1], [2, 2], [4, 2], [5, 3], [9, 3], [10, 4]],
		"reputation": [[-3, 0], [0, 0], [1, 1], [20, 1], [21, 2], [30, 2], [31, 3], [60, 3], [61, 4]],
	}
	for key in cases:
		for pair in cases[key]:
			assert_eq(GTiers.tier(key, float(pair[0])), int(pair[1]), "%s %s" % [key, pair[0]])
	# Raw floats near a line follow the number on screen, not the raw value.
	assert_eq(GTiers.tier_of_raw("money", 20000.4), 1, "$20,000.4 prints $20,000: tier 1")
	assert_eq(GTiers.tier_of_raw("money", 20000.5), 2, "$20,000.5 prints $20,001: tier 2")
	assert_eq(GTiers.tier_of_raw("compute", 49.5), 2, "49.5 prints 50: tier 2")
	assert_eq(GTiers.tier_of_raw("papers", 1.49), 1, "1.49 prints 1: tier 1")


func test_tags() -> void:
	assert_eq(GTiers.tag("money", 20000.0), {"text": "LOW", "tone": "warn"}, "money at the low-funds line")
	assert_eq(GTiers.tag("money", -100.0), {"text": "LOW", "tone": "warn"}, "money below zero is low")
	assert_eq(GTiers.tag("money", 20001.0), {}, "money above the line: no tag")
	assert_eq(GTiers.tag("money", GTiers.shown_amount(20000.4)), {"text": "LOW", "tone": "warn"},
		"$20,000.4 prints $20,000: LOW")
	assert_eq(GTiers.tag("reputation", 31.0), {}, "reputation 31: no tag")
	assert_eq(GTiers.tag("reputation", 30.0), {"text": "LOW", "tone": "amber"}, "reputation 30: amber")
	assert_eq(GTiers.tag("reputation", 21.0), {"text": "LOW", "tone": "amber"}, "reputation 21: amber")
	assert_eq(GTiers.tag("reputation", 20.0), {"text": "LOW", "tone": "warn"}, "reputation 20: warn")
	assert_eq(GTiers.tag("reputation", 0.0), {"text": "LOW", "tone": "warn"})
	assert_eq(GTiers.tag("research", -1.0), {"text": "BELOW ZERO", "tone": "warn"})
	assert_eq(GTiers.tag("research", GTiers.shown_amount(-0.4)), {}, "-0 is not below zero")
	assert_eq(GTiers.tag("research", 0.0), {})
	assert_eq(GTiers.tag("compute", -5.0), {}, "compute has no tag")
	assert_eq(GTiers.tag("papers", 0.0), {}, "papers has no tag")


# --- the icons ------------------------------------------------------------------------------

func test_the_25_icons_ship_with_the_spec_import_settings() -> void:
	for key in KEYS:
		for t in range(5):
			var path := GTiers.icon_path(key, t)
			var tex := load(path) as Texture2D
			assert_not_null(tex, "%s loads" % path)
			if tex == null:
				continue
			assert_eq(Vector2i(tex.get_size()), Vector2i(128, 128), "%s is 128x128" % path)
			assert_true(tex.get_image().has_mipmaps(), "%s has mipmaps" % path)
			var cf := ConfigFile.new()
			assert_eq(cf.load(path + ".import"), OK, "%s.import reads" % path)
			assert_eq(int(cf.get_value("params", "compress/mode", -1)), 0, "%s lossless" % path)
			assert_true(bool(cf.get_value("params", "mipmaps/generate", false)), "%s mipmaps on" % path)
			assert_true(bool(cf.get_value("params", "process/fix_alpha_border", false)),
				"%s fix alpha border on" % path)
			assert_false(bool(cf.get_value("params", "process/premult_alpha", true)), "%s premult off" % path)
	assert_eq(GTiers.icon_path("reputation", 2), "res://assets/icons/g_tiers/rep-2.png",
		"reputation's files are rep-N (spec 11.2)")


# --- one cell -------------------------------------------------------------------------------

func _cell(key: String) -> GResourceCell:
	var c := GResourceCell.new(key, key.to_upper(), false)
	add_child_autofree(c)
	return c


func _settled_path(c: GResourceCell) -> String:
	var t := c.icon_texture()
	return t.resource_path if t != null else ""


func test_each_cell_shows_the_right_tier_icon_for_a_range_of_amounts() -> void:
	GResourceCell.reduced_motion = true   # instant swaps: the icon is the final one at once
	var amounts := {
		"money": [245000.0, 12400.0, -3000.0, 99999.4, 250000.0, 60000.0],
		"compute": [100.0, 0.0, 49.5, 250.0, 12.0],
		"research": [0.0, -12.0, 9.0, 19.6, 33.0, 75.0],
		"papers": [0.0, 1.0, 3.0, 7.0, 12.0],
		"reputation": [50.0, 34.0, 21.0, 60.25, 60.5, 0.25, -0.4, 15.0],
	}
	for key in amounts:
		var c := _cell(key)
		for raw in amounts[key]:
			c.set_amount(raw)
			var want := GTiers.tier_of_raw(key, raw)
			assert_eq(c.tier, want, "%s %s -> tier %d" % [key, raw, want])
			assert_eq(_settled_path(c), GTiers.icon_path(key, want), "%s %s shows its tier icon" % [key, raw])
			var text: String = GameConfig.format_money(raw) if key == "money" else GameConfig.format_scalar(raw)
			assert_eq(c.value.text, text, "%s %s prints exactly as the classic top bar" % [key, raw])
			var warn: bool = GTiers.shown_amount(raw) < 0.0
			assert_eq(GDesk.ink_of(c.value), GDesk.C.warn if warn else GDesk.C.bone,
				"%s %s: warn colour only when the shown amount is negative" % [key, raw])
			var tag := GTiers.tag(key, GTiers.shown_amount(raw))
			assert_eq(c.tag_box.visible, not tag.is_empty(), "%s %s: tag shown iff GTiers has one" % [key, raw])
			if not tag.is_empty():
				assert_eq(c.tag_label.text, String(tag.text))


func test_icon_plates_are_40_for_money_and_32_for_the_rest_with_mipmapped_filter() -> void:
	for key in KEYS:
		var c := _cell(key)
		var px := 40 if key == "money" else 32
		assert_eq(c.plate.custom_minimum_size, Vector2(px, px), "%s plate" % key)
		for r in c.icon_rects():
			assert_eq((r as TextureRect).texture_filter, CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS,
				"%s icon filter (spec 11.2)" % key)


func test_tier_change_crossfades_then_settles() -> void:
	var c := _cell("compute")
	c.set_amount(100.0)
	assert_false(c.is_fading(), "the first amount shows at once")
	assert_eq(_settled_path(c), GTiers.icon_path("compute", 3))
	c.set_amount(101.0)
	assert_false(c.is_fading(), "same tier: no fade")
	c.set_amount(60.0)
	assert_true(c.is_fading(), "a tier change crossfades")
	var rects: Array = c.icon_rects()
	assert_true((rects[1] as TextureRect).visible, "the incoming icon is drawn during the fade")
	assert_eq(_settled_path(c), GTiers.icon_path("compute", 2), "the target is the new tier")
	await get_tree().create_timer(GResourceCell.CROSSFADE_S + 0.15, false).timeout
	assert_false(c.is_fading(), "the fade ends")
	assert_false((rects[1] as TextureRect).visible, "one icon after the fade")
	assert_eq((rects[0] as TextureRect).texture.resource_path, GTiers.icon_path("compute", 2))
	assert_almost_eq((rects[0] as TextureRect).modulate.a, 1.0, 0.001)


func test_a_change_mid_fade_lands_on_the_latest_tier() -> void:
	var c := _cell("research")
	c.set_amount(5.0)
	c.set_amount(15.0)
	assert_true(c.is_fading())
	c.set_amount(40.0)
	await get_tree().create_timer(GResourceCell.CROSSFADE_S + 0.15, false).timeout
	assert_false(c.is_fading())
	assert_eq((c.icon_rects()[0] as TextureRect).texture.resource_path, GTiers.icon_path("research", 3))


func test_reduced_motion_swaps_at_once() -> void:
	GResourceCell.reduced_motion = true
	var c := _cell("papers")
	c.set_amount(0.0)
	c.set_amount(6.0)
	assert_false(c.is_fading(), "no fade with reduced motion")
	assert_false((c.icon_rects()[1] as TextureRect).visible)
	assert_eq((c.icon_rects()[0] as TextureRect).texture.resource_path, GTiers.icon_path("papers", 3))


func test_reputation_note_reads_0_ends_the_run_in_lifted_red() -> void:
	var c := _cell("reputation")
	assert_not_null(c.note, "reputation carries the note")
	assert_eq(c.note_zero.text, "0")
	assert_eq(c.note_text.text, "ends the run")
	assert_eq(GDesk.ink_of(c.note_zero), GDesk.C.blood_text, "the 0 is blood_text, not blood (A10)")
	assert_gte(GDesk.contrast_ratio(GDesk.C.blood_text, GDesk.C.panel_solid), 4.5,
		"blood_text on the panel reaches 4.5:1")
	assert_eq(GDesk.ink_of(c.note_text), GDesk.C.muted)
	for key in ["money", "compute", "research", "papers"]:
		assert_null(_cell(key).note, "%s has no note" % key)


func test_tag_tones() -> void:
	var c := _cell("reputation")
	c.set_amount(25.0)
	assert_true(c.tag_box.visible)
	assert_eq(GDesk.ink_of(c.tag_label), GDesk.C.amber, "reputation 25: amber LOW")
	var sb := c.tag_box.get_theme_stylebox("panel") as StyleBoxFlat
	assert_eq(sb.border_color, GDesk.C.amber, "amber hairline")
	assert_eq(sb.bg_color.a, 0.0, "hairline, not filled")
	c.set_amount(12.0)
	assert_eq(GDesk.ink_of(c.tag_label), GDesk.C.warn, "reputation 12: warn LOW")
	assert_false(c.tag_box.has_theme_stylebox_override("panel"), "warn takes the theme's GTag hairline")
	c.set_amount(40.0)
	assert_false(c.tag_box.visible, "reputation 40: no tag")


# --- live desk -------------------------------------------------------------------------------

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
	await get_tree().process_frame
	return main_ui


func test_live_cells_follow_the_state_and_write_nothing() -> void:
	var main_ui: Node = await _boot(true)
	var desk = main_ui.get_g_desk()
	assert_not_null(desk)
	for key in KEYS:
		var cell = desk.resource_cells[key]
		assert_true(cell is GResourceCell, "%s is a GResourceCell" % key)
		var raw := float(main_ui._last_state.get(key, 0))
		assert_eq(cell.tier, GTiers.tier_of_raw(key, raw), "%s cell tier follows the state" % key)
		assert_eq(desk.resource_values[key], cell.value, "resource_values points at the cell's value")
	assert_eq(desk.resource_values["money"].text, main_ui.money_label.text, "money prints as classic")
	# A made-up state (display only): the cells change, the game does not.
	var before: String = JSON.stringify(GameManager.state.to_dict()).sha256_text()
	var st: Dictionary = main_ui._last_state.duplicate(true)
	st["money"] = 12400.0
	st["research"] = -12.0
	st["papers"] = 7.0
	st["reputation"] = 21.0
	desk._on_state(st)
	assert_eq(desk.resource_cells["money"].tier, 1)
	assert_eq(desk.resource_cells["money"].tag_label.text, "LOW")
	assert_eq(desk.resource_cells["research"].tier, 0)
	assert_eq(desk.resource_cells["research"].tag_label.text, "BELOW ZERO")
	assert_eq(desk.resource_cells["papers"].tier, 3)
	assert_eq(desk.resource_cells["reputation"].tier, 2)
	assert_eq(GDesk.ink_of(desk.resource_cells["reputation"].tag_label), GDesk.C.amber)
	await get_tree().create_timer(GResourceCell.CROSSFADE_S + 0.15, false).timeout
	assert_eq(JSON.stringify(GameManager.state.to_dict()).sha256_text(), before,
		"game state untouched (to_dict carries the RNG state, so a draw would show)")


func test_crowded_strip_shrinks_the_separation_first() -> void:
	var main_ui: Node = await _boot(true)
	var desk = main_ui.get_g_desk()
	var st: Dictionary = main_ui._last_state.duplicate(true)
	# Wide numbers and every tag at once.
	st["money"] = -1234567.0
	st["compute"] = 123456.0
	st["research"] = -123456.0
	st["papers"] = 123456.0
	st["reputation"] = 12.0
	desk._on_state(st)
	await get_tree().process_frame
	await get_tree().process_frame
	var sep: int = desk.resource_strip.get_theme_constant("separation")
	assert_between(sep, GDesk.RESOURCE_SEP_MIN, GDesk.RESOURCE_SEP, "separation stays in its range")
	assert_lt(sep, GDesk.RESOURCE_SEP, "a crowded strip gives up separation first (got %d)" % sep)
	desk._on_state(main_ui._last_state)
	await get_tree().process_frame
	await get_tree().process_frame
	assert_eq(desk.resource_strip.get_theme_constant("separation"), GDesk.RESOURCE_SEP,
		"month 1 at 1920 wide keeps the full 24 px")


func test_classic_is_untouched() -> void:
	var main_ui: Node = await _boot(false)
	assert_eq(main_ui.get("_ui_layout"), "classic")
	assert_null(main_ui.get_g_desk(), "no desk in classic")
	var found := main_ui.get_tree().root.find_children("Cell_*", "", true, false)
	for n in found:
		assert_false(n is GResourceCell, "no G resource cell in classic (%s)" % n.get_path())
	assert_true((main_ui.get_node("TopBar") as CanvasItem).visible, "classic top bar shows")
	assert_string_contains(main_ui.money_label.text, "$", "classic money label as today")

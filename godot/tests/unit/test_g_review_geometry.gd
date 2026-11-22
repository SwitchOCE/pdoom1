extends GutTest
## G desk phase 2b (fork/design/godot-g/spec.md 5.12, A7): the month review on G's paper is a
## separate, G-only entry -- apply_geometry_g and build(..., use_g = true) -- so the classic
## clipboard, its constants and test_month_review_panel.gd are untouched. This pins G's
## geometry (700 wide, top 132), its sizes (ThemeManager, never a literal), the paper, and that
## every word of the payload reaches the sheet.

const GameManagerScript := preload("res://scripts/game_manager.gd")


func _gm() -> Node:
	var gm: Node = GameManagerScript.new()
	autofree(gm)
	return gm


func _payload(with_rivals: bool = true) -> Dictionary:
	var p := {
		"heading": "Month Review",
		"period": "October 2017",
		"lede": "October 2017 begins.",
		"attention": "Attention: 20 fresh decisions this month (last month's unspent reserve evaporated -- no banking).",
		"movement_title": "Last month's movement",
		"movement": _gm()._collect_month_movement_rows(
			{"money": 1119896.0, "doom": 25.3, "staff": 3}, {"money": 1083712.0, "doom": 25.3, "staff": 2}),
		"rivals_title": "Rivals this month",
		"rivals": [],
		"closing": "Queue this month's actions, then press COMMIT THE MONTH to play the month out.",
	}
	if with_rivals:
		p["rivals"] = [
			{"name": "DeepSafety", "focus": "safety", "drift": "capabilities flat", "heat": 0},
			{"name": "CapabiliCorp", "focus": "capabilities", "drift": "capabilities climbing fast", "heat": 3},
		]
	return p


func _texts(node: Node, out: Array[String] = []) -> Array[String]:
	if node is Label:
		out.append((node as Label).text)
	for child in node.get_children():
		_texts(child, out)
	return out


func _labels(node: Node, out: Array = []) -> Array:
	if node is Label:
		out.append(node)
	for child in node.get_children():
		_labels(child, out)
	return out


func _build_g(payload: Dictionary, vp := Vector2(1920, 1080)) -> Panel:
	var dialog := Panel.new()
	add_child_autofree(dialog)
	MonthReviewPanel.apply_geometry_g(dialog, vp)
	MonthReviewPanel.build(dialog, {"review": payload}, true)
	return dialog


func test_g_geometry_is_700_wide_at_top_132() -> void:
	for vp in [Vector2(1920, 1080), Vector2(1600, 900), Vector2(2560, 1080)]:
		var dialog := Panel.new()
		autofree(dialog)
		MonthReviewPanel.apply_geometry_g(dialog, vp)
		assert_eq(dialog.size.x, 700.0, "700 wide at %s" % vp)
		assert_eq(dialog.position.y, 132.0, "top 132 at %s" % vp)
		assert_eq(dialog.position.x, roundf((vp.x - 700.0) / 2.0), "centred across at %s" % vp)
	assert_eq(MonthReviewPanel.G_WIDTH, 700.0)
	assert_eq(MonthReviewPanel.G_TOP, 132.0)


func test_g_sheet_keeps_its_geometry_once_built() -> void:
	var dialog := _build_g(_payload())
	await get_tree().process_frame
	await get_tree().process_frame
	assert_eq(dialog.size.x, 700.0, "still 700 wide with its content")
	assert_eq(dialog.position.y, 132.0, "still at top 132")
	var content: Control = dialog.get_node("PaperMargin")
	assert_almost_eq(dialog.size.y, content.get_combined_minimum_size().y, 1.0,
		"the paper is as tall as its words")
	assert_lt(dialog.position.y + dialog.size.y, 1080.0 - GPaper.BOTTOM_GAP + 1.0,
		"and stays clear of the bottom strip")


func test_g_sizes_come_from_theme_manager() -> void:
	var dialog := _build_g(_payload())
	var sheet: Node = dialog.get_node("PaperMargin/Paper")
	var want := {
		"Heading": "small", "Period": "small", "Lede": "label", "Attention": "body", "Closing": "body",
	}
	for n in want:
		var l: Label = sheet.find_child(n, true, false)
		assert_not_null(l, "%s is on the sheet" % n)
		assert_eq(l.get_theme_font_size("font_size"), ThemeManager.get_font_size(want[n]),
			"%s at ThemeManager's %s" % [n, want[n]])
	var allowed := []
	for step in ["small", "body", "label"]:
		allowed.append(ThemeManager.get_font_size(step))
	for l in _labels(dialog):
		assert_true(allowed.has((l as Label).get_theme_font_size("font_size")),
			"'%s' uses a ThemeManager size" % (l as Label).text)


func test_g_sheet_is_paper_with_g_theme() -> void:
	var dialog := _build_g(_payload())
	assert_eq(dialog.theme, load(GDesk.THEME_PATH), "the panel carries g_theme.tres itself (A7)")
	var sb := dialog.get_theme_stylebox("panel")
	assert_true(sb is StyleBoxTexture, "the paper 9-slice")
	assert_eq((sb as StyleBoxTexture).texture.resource_path, GPaper.PAPER_PATH)
	assert_eq((sb as StyleBoxTexture).texture_margin_left, 64.0, "9-slice margins 64")
	assert_eq((sb as StyleBoxTexture).texture_margin_bottom, 64.0)
	for l in _labels(dialog):
		assert_eq((l as Label).get_theme_color("font_color"), GDesk.C.ink, "'%s' in ink" % (l as Label).text)
	# Small paper labels are bold (spec 4.5).
	var heading: Label = dialog.find_child("Heading", true, false)
	assert_eq(heading.theme_type_variation, &"GCapsBold")


func test_every_word_of_the_payload_reaches_the_g_sheet() -> void:
	var p := _payload()
	var said := _texts(_build_g(p))
	assert_has(said, "MONTH REVIEW")
	for key in ["period", "lede", "attention", "closing"]:
		assert_has(said, String(p[key]), "%s reaches the sheet" % key)
	assert_has(said, "LAST MONTH'S MOVEMENT")
	assert_has(said, "RIVALS THIS MONTH")
	for row in p["movement"]:
		assert_has(said, String(row["stat"]).to_upper())
		assert_has(said, "%s -> %s" % [row["from"], row["to"]])
		assert_has(said, String(row["delta"]))
	for r in p["rivals"]:
		for k in ["name", "focus", "drift"]:
			assert_has(said, String(r[k]))


func test_rivals_only_when_the_payload_has_them() -> void:
	var said := _texts(_build_g(_payload(false)))
	assert_false(said.has("RIVALS THIS MONTH"), "no rivals section without rivals")
	var first := _payload(false)
	first["movement"] = []
	var dialog := _build_g(first)
	assert_null(dialog.find_child("Lists", true, false), "month 1: no lists at all")
	assert_has(_texts(dialog), String(first["closing"]))


func test_g_sheet_prints_no_doom_percentage() -> void:
	for t in _texts(_build_g(_payload())):
		assert_false(t.contains("%"), "no percentage on the G review: '%s'" % t)


func test_classic_geometry_and_sizes_are_untouched() -> void:
	assert_eq(MonthReviewPanel.SIZE_BODY, 19)
	assert_eq(MonthReviewPanel.SIZE_SMALL, 17)
	assert_eq(MonthReviewPanel.SIZE_BUTTON, 20)
	assert_eq(MonthReviewPanel.MAX_SIZE, Vector2(1120.0, 760.0))
	var dialog := Panel.new()
	autofree(dialog)
	MonthReviewPanel.apply_geometry(dialog, Vector2(1920, 1080))
	assert_eq(dialog.size, Vector2(1120, 760), "classic is still the clipboard's size")
	MonthReviewPanel.build(dialog, {"review": _payload()})
	assert_null(dialog.theme, "classic sets no G theme")
	assert_false(dialog.get_theme_stylebox("panel") is StyleBoxTexture, "classic is not on G paper")

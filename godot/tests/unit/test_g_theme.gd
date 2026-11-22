extends GutTest
## G desk, phase 2a (fork/design/godot-g/spec.md 12.2 "2a", 4.1-4.4): the theme, its faces and
## the font fallback, the colour tokens, the script-made textures, the `label` size step, and on
## the real main.tscn that the desk takes the theme and sets its sizes by rank.

const MAIN_SCENE := "res://scenes/main.tscn"
const THEME := "res://theme/g_theme.tres"

## Every theme type variation G code names (a typo would silently fall back to the default
## look, so the list is checked against the theme).
const VARIATIONS := [
	"GSans", "GSansMed", "GMono", "GMonoReg", "GMonoSemi", "GCaps", "GCapsMed", "GCapsBold",
	"GType", "GTypeBold", "GDateline",
	"GPanel", "GSheetPanel", "GCardPanel", "GStripTop", "GBanner", "GStripBottom",
	"GKeycap", "GKeycapAmber", "GTile", "GRaised", "GHeld", "GTag", "GToast",
	"GPlate", "GPlateLit", "GPlateHint", "GButton", "GButtonAmber", "GClose",
	"GSegment", "GSegmentOn", "GQualityButton", "GRow", "GRowBlocked", "GUpgradeRow",
	"GCommitReady", "GCommitHold",
]

## The faces of spec 4.2: variation -> the family the FontFile names.
const FACES := {
	"GSans": "IBM Plex Sans", "GSansMed": "IBM Plex Sans",
	"GMono": "IBM Plex Mono", "GMonoReg": "IBM Plex Mono", "GMonoSemi": "IBM Plex Mono",
	"GCaps": "Barlow Condensed", "GCapsMed": "Barlow Condensed", "GCapsBold": "Barlow Condensed",
	"GType": "Courier Prime", "GTypeBold": "Courier Prime", "GDateline": "Courier Prime",
}


func _theme() -> Theme:
	return load(THEME) as Theme


func after_each() -> void:
	GDesk.compact = false
	GPrefs.reload_prefs()
	GameManager.month_playback_active = false


# --- the theme resource -------------------------------------------------------------------

func test_theme_sets_no_font_sizes() -> void:
	var t := _theme()
	assert_not_null(t, "g_theme.tres loads")
	assert_false(t.has_default_font_size(), "no default size: base_theme.tres is the one size lever")
	assert_eq(t.get_font_size_type_list().size(), 0, "no font size item on any type")


func test_default_face_is_plex_sans() -> void:
	var t := _theme()
	assert_true(t.has_default_font(), "a default face")
	var fv := t.default_font as FontVariation
	assert_not_null(fv, "every face is a FontVariation (missing file -> Godot's default font)")
	assert_not_null(fv.base_font, "the bundled file loads")
	assert_eq(fv.base_font.get_font_name(), "IBM Plex Sans")


func test_each_face_is_its_bundled_family() -> void:
	var t := _theme()
	for v in FACES:
		assert_true(t.has_font("font", v), "%s has a face" % v)
		var fv := t.get_font("font", v) as FontVariation
		assert_not_null(fv, "%s is a FontVariation" % v)
		if fv == null:
			continue
		assert_not_null(fv.base_font, "%s: its file loads" % v)
		if fv.base_font != null:
			# Static weights name themselves "<family> <style>" (e.g. "Barlow Condensed SemiBold").
			assert_true(fv.base_font.get_font_name().begins_with(FACES[v]),
				"%s is %s (%s)" % [v, FACES[v], fv.base_font.get_font_name()])
	# Tracked caps (spec 4.2): spacing_glyph 2 on the Barlow styles.
	assert_eq((t.get_font("font", "GCaps") as FontVariation).spacing_glyph, 2)


func test_weights_are_the_spec_table() -> void:
	var t := _theme()
	var weights := {}
	for v in FACES:
		var fv := t.get_font("font", v) as FontVariation
		weights[v] = fv.base_font.get_font_weight()
	assert_eq(weights["GCapsMed"], 500)
	assert_eq(weights["GCaps"], 600)
	assert_eq(weights["GCapsBold"], 700)
	assert_eq(weights["GMonoReg"], 400)
	assert_eq(weights["GMono"], 500)
	assert_eq(weights["GMonoSemi"], 600)
	assert_eq(weights["GSans"], 400)
	assert_eq(weights["GSansMed"], 500)
	assert_eq(weights["GType"], 400)
	assert_eq(weights["GTypeBold"], 700)


func test_a_face_with_a_missing_file_falls_back_to_the_default_font() -> void:
	# What a FontVariation does when its FontFile is gone: it draws with Godot's default font
	# (today's look), never with boxes.
	var fv := FontVariation.new()
	assert_null(fv.base_font)
	assert_gt(fv.get_height(19), 0.0, "still has metrics")
	assert_gt(fv.get_string_size("ACTIONS", HORIZONTAL_ALIGNMENT_LEFT, -1, 19).x, 0.0,
		"still measures text")


func test_every_variation_g_names_exists() -> void:
	var t := _theme()
	for v in VARIATIONS:
		assert_ne(String(t.get_type_variation_base(StringName(v))), "",
			"%s is a type variation in the theme" % v)


func test_colour_tokens_match_the_desk_table() -> void:
	var t := _theme()
	for k in GDesk.C:
		assert_true(t.has_color(k, "GColors"), "GColors/%s" % k)
		assert_eq(t.get_color(k, "GColors"), GDesk.C[k], "GColors/%s equals GDesk.C" % k)


func test_panels_use_the_script_textures() -> void:
	var t := _theme()
	var sb := t.get_stylebox("panel", "GPanel") as StyleBoxTexture
	assert_not_null(sb, "the panel is a StyleBoxTexture")
	assert_eq(sb.texture.resource_path, "res://assets/textures/g/panel_grime_9.png")
	assert_eq(sb.texture.get_size(), Vector2(256, 256))
	for side in [SIDE_LEFT, SIDE_TOP, SIDE_RIGHT, SIDE_BOTTOM]:
		assert_eq(sb.get_texture_margin(side), 24.0, "9-slice margins 24")
	var fr := t.get_stylebox("frame", "GPanel") as StyleBoxFlat
	assert_not_null(fr, "the frame hairline is a second stylebox")
	assert_false(fr.draw_center, "the frame draws no fill")
	assert_eq(fr.border_color, GDesk.C.frame)
	var off := t.get_stylebox("disabled", "GPlate") as StyleBoxTexture
	assert_not_null(off, "disabled = the hatch")
	assert_eq(off.texture.resource_path, "res://assets/textures/g/hatch_16.png")
	assert_eq(off.texture.get_size(), Vector2(16, 16))
	assert_eq(off.axis_stretch_horizontal, StyleBoxTexture.AXIS_STRETCH_MODE_TILE, "tiled")


# --- the label step (spec 4.2) ------------------------------------------------------------

func test_label_step_is_body_plus_three() -> void:
	assert_eq(ThemeManager.get_font_size("label"), ThemeManager.get_font_size("body") + 3)
	assert_eq(ThemeManager.get_font_size("label"), 22, "22 at today's base of 19")


# --- the live desk ------------------------------------------------------------------------

func _boot() -> Node:
	GPrefs.set_desk(true, false)
	var root: Node = load(MAIN_SCENE).instantiate()
	add_child_autofree(root)
	var main_ui: Node = root.find_child("MainUI", true, false)
	for _i in range(120):
		await get_tree().process_frame
		if GameManager.is_initialized and String(main_ui.current_turn_phase).to_upper() == "ACTION_SELECTION":
			break
	await get_tree().process_frame
	return main_ui


func _size(c: Control) -> int:
	return c.get_theme_font_size("font_size")


func _family(c: Control) -> String:
	var f := c.get_theme_font("font")
	if f is FontVariation and (f as FontVariation).base_font != null:
		return (f as FontVariation).base_font.get_font_name()
	return f.get_font_name() if f != null else ""


func test_desk_root_carries_the_theme_and_classic_does_not() -> void:
	var main_ui: Node = await _boot()
	var desk: Control = main_ui.get_g_desk()
	assert_not_null(desk.theme, "GDesk's root has a theme")
	assert_eq(desk.theme.resource_path, THEME)
	assert_null(main_ui.theme, "MainUI keeps today's theme chain")
	assert_string_starts_with(_family(desk.mode_label), "Barlow Condensed", "a G caps label takes Barlow")
	assert_string_starts_with(_family(desk.resource_values["money"]), "IBM Plex Mono", "numbers take Plex Mono")
	assert_string_starts_with(_family(desk.dateline), "Courier Prime", "the dateline takes Courier Prime")
	assert_string_starts_with(_family(desk.attention_card.choose_button), "Barlow Condensed",
		"a G button takes Barlow")
	assert_string_starts_with(_family(desk.attention_card._header_total), "IBM Plex Sans",
		"plain G text takes the theme's default face")


func test_hierarchy_sizes_by_rank() -> void:
	# Spec 4.4: P(Doom) percent at title; band name, hours left and level-3 values at label;
	# money at header; rail plate names at small.
	var main_ui: Node = await _boot()
	var desk: Control = main_ui.get_g_desk()
	var title := ThemeManager.get_font_size("title")
	var label := ThemeManager.get_font_size("label")
	assert_eq(_size(desk.doom_card._pct), title, "P(Doom) percent at title")
	assert_eq(_size(desk.doom_card._band_name), label, "band name at label")
	assert_eq(_size(desk.resource_values["money"]), ThemeManager.get_font_size("header"), "money at header")
	for k in ["compute", "research", "papers", "reputation"]:
		assert_eq(_size(desk.resource_values[k]), label, "%s at label" % k)
	assert_eq(_size(desk.attention_card._left), label, "the total hours left at label")
	assert_eq(_size(desk.plate_actions._name_label), ThemeManager.get_font_size("small"),
		"rail plate names at small")
	assert_eq(desk.plate_actions._name_label.get_theme_color("font_color"), GDesk.C.muted,
		"rail plate names in muted")


func test_doom_card_is_framed_in_its_band_colour() -> void:
	var main_ui: Node = await _boot()
	var desk: Control = main_ui.get_g_desk()
	var card: GDoomCard = desk.doom_card
	var stroke: Color = ThemeManager.get_doom_stroke_color(float(main_ui._last_state.get("doom", 0.0)))
	assert_eq(card.band_stroke(), stroke, "the top edge is the band's full colour")
	var fr := card.frame_override as StyleBoxFlat
	assert_not_null(fr, "its own frame")
	assert_almost_eq(fr.border_color.a, 0.55, 0.001, "hairline at 55%")
	assert_eq(Color(fr.border_color, 1.0), Color(stroke, 1.0))
	assert_eq(fr.shadow_size, 8, "outer glow size 8")
	assert_almost_eq(fr.shadow_color.a, 0.30, 0.001, "glow at 30%")
	assert_false(fr.draw_center, "drawn over the grime, no fill")
	# Only the P(Doom) card is framed in its own colour (spec 4.4 rank 1).
	assert_null(desk.attention_card.frame_override, "the Attention card keeps the theme's hairline")


func test_commit_is_muted_until_something_is_queued() -> void:
	var main_ui: Node = await _boot()
	var desk: Control = main_ui.get_g_desk()
	main_ui._on_clear_queue_button_pressed()
	await get_tree().process_frame
	assert_eq(String(desk.commit_plate.theme_type_variation), "GCommitHold", "empty queue: muted plate")
	assert_eq(desk.commit_caption.get_theme_color("font_color"), GDesk.C.muted)
	main_ui._on_dynamic_action_pressed("scout_read", "Read the Literature")
	await get_tree().process_frame
	assert_eq(String(desk.commit_plate.theme_type_variation), "GCommitReady", "a play queued: amber")
	assert_eq(desk.commit_caption.get_theme_color("font_color"), GDesk.C.amber)
	main_ui._on_clear_queue_button_pressed()
	await get_tree().process_frame


func test_disabled_plates_keep_dim_text_on_the_hatch() -> void:
	var main_ui: Node = await _boot()
	var desk: Control = main_ui.get_g_desk()
	var plate: GPlate = desk.plate_actions
	plate.disabled = true
	plate.set_lit(false)
	assert_eq(plate._name_label.get_theme_color("font_color"), GDesk.C.dim, "dim, never faded")
	assert_eq(plate._name_label.modulate.a, 1.0, "no fade on the text")
	assert_true(plate.get_theme_stylebox("disabled") is StyleBoxTexture, "the hatch")
	plate.disabled = false
	plate.set_lit(false)


func test_cards_and_sheets_are_ticked_g_panels() -> void:
	var main_ui: Node = await _boot()
	var desk: Control = main_ui.get_g_desk()
	assert_true(desk.doom_card is GPanel and desk.attention_card is GPanel, "the cards are GPanels")
	assert_true(desk.feed_panel is GPanel, "the feed is a GPanel")
	assert_true(desk.actions_panel.panel is GPanel, "the sheets' panels are GPanels")
	assert_eq(String(desk.actions_panel.panel.theme_type_variation), "GSheetPanel")
	assert_true(desk.doom_card.ticks and desk.attention_card.ticks, "with corner ticks")


# --- the compact view (2a addendum): G lifts its own small text below 0.8 of 1080 ----------

func test_compact_threshold() -> void:
	assert_true(GDesk.is_compact_scale(1280.0 / 1920.0), "1280x720 is compact")
	assert_false(GDesk.is_compact_scale(1.0), "1920x1080 is not")
	assert_false(GDesk.is_compact_scale(0.85), "1600x900 (0.833) is not")
	assert_false(GDesk.is_compact_scale(0.0), "no viewport yet is not")


func test_compact_ink_lifts_toward_bone_and_never_darkens() -> void:
	for c in [GDesk.C.muted, GDesk.C.dim, GDesk.C.plan, GDesk.C.amber]:
		var lifted := GDesk.compact_ink(c)
		assert_true(GDesk.contrast_ratio(lifted, GDesk.C.panel_solid) >= GDesk.contrast_ratio(c, GDesk.C.panel_solid),
			"never darker")
		assert_true(GDesk.contrast_ratio(lifted, GDesk.C.panel_solid) >= GDesk.COMPACT_TARGET - 0.01
				or lifted.is_equal_approx(GDesk.C.bone), "reaches the target or bone")
	assert_eq(GDesk.compact_ink(GDesk.C.bone), GDesk.C.bone, "bone stays bone")


func test_compact_view_lifts_small_text_below_the_threshold_only() -> void:
	var main_ui: Node = await _boot()
	var desk: Control = main_ui.get_g_desk()
	var name_l: Label = desk.plate_actions._name_label      # small, muted (or lit)
	var money: Label = desk.resource_values["money"]         # header, bone: never lifted
	var small := ThemeManager.get_font_size("small")
	var base_name: Color = GDesk.ink_of(name_l)
	assert_true(desk.get_viewport().size_changed.is_connected(desk._on_view_resized),
		"the desk follows window resizes")
	desk._update_compact(false, 1.0)
	assert_false(GDesk.compact, "1080: not compact")
	assert_eq(name_l.get_theme_color("font_color"), base_name, "1080: small text keeps its colour")
	assert_eq(_size(name_l), small, "1080: small text at small")
	desk._update_compact(false, 1280.0 / 1920.0)
	assert_true(GDesk.compact, "720: compact")
	var lifted: Color = name_l.get_theme_color("font_color")
	assert_eq(lifted, GDesk.compact_ink(base_name), "720: small text lifted toward bone")
	assert_true(GDesk.contrast_ratio(lifted, GDesk.C.panel_solid) > GDesk.contrast_ratio(base_name, GDesk.C.panel_solid),
		"720: lighter than at 1080")
	assert_eq(_size(name_l), small, "720: a lifted-only class keeps small")
	assert_eq(_size(money), ThemeManager.get_font_size("header"), "720: header text keeps its size")
	assert_eq(money.get_theme_color("font_color"), GDesk.ink_of(money), "720: header text keeps its colour")
	assert_true(desk.actions_panel.close_button.has_theme_color_override("font_color"),
		"720: the close x (a thin glyph) is lifted")
	var status: Label = desk.plate_staff._status_label
	assert_eq(_size(status), ThemeManager.get_font_size("body"),
		"720: a stepped-up class (rail status) takes the next step")
	# A colour set while compact is lifted at once; back at 1080 it is the colour it was given.
	GDesk.set_ink(name_l, GDesk.C.dim)
	assert_eq(name_l.get_theme_color("font_color"), GDesk.compact_ink(GDesk.C.dim))
	desk._update_compact(false, 1.0)
	assert_false(GDesk.compact, "back to 1080")
	assert_eq(name_l.get_theme_color("font_color"), GDesk.C.dim, "1080: the colour it was given")
	assert_eq(_size(name_l), small, "1080: back at small")
	assert_eq(_size(status), small, "1080: the rail status back at small")
	var close: Button = desk.actions_panel.close_button
	assert_false(close.has_theme_color_override("font_color"), "1080: the close x takes the theme's colour")
	desk.plate_actions.set_lit(false)

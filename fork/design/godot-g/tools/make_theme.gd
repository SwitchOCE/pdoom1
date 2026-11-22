extends SceneTree
## Writes godot/theme/g_theme.tres (fork/design/godot-g/spec.md 4.1-4.3). Fork tool, kept with
## make_textures.py; never on a ui/g-* branch. Run from the worktree:
##   godot --headless --path godot -s <path to this file>
## It sets NO font sizes (base_theme.tres stays the one size lever; G sets sizes in code with
## ThemeManager.get_font_size). Every face is a FontVariation over the bundled FontFile, so a
## missing file falls back to Godot's default font instead of failing.

const OUT := "res://theme/g_theme.tres"
const FONTS := "res://assets/fonts/"
const TEX := "res://assets/textures/g/"
const HEADER := """; The G desk's look (fork/design/godot-g/spec.md 4.1-4.3), set on GDesk's root
; (scenes/ui/g/g_desk.tscn), so it reaches only G's own controls and the classic nodes G
; moves into its sheets.
;
; Faces (OFL, assets/fonts/*/), the colour tokens as type GColors, styleboxes as type
; variations (GPanel, GPlate, GKeycap, GRow, GCommitReady, ...) and Label variations per face
; (GCaps, GMono, GType, ...). NO FONT SIZES: base_theme.tres stays the one size lever and G
; sets every size in code with ThemeManager.get_font_size().
;
; Every face is a FontVariation over the bundled FontFile, so a missing file falls back to
; Godot's default font, never to boxes. Textures: assets/textures/g/ (script-made).
; Written by a fork tool (fork/design/godot-g/tools/make_theme.gd); the Godot editor strips
; these comments if it re-saves the file.

"""

# The colour tokens (spec 4.1). Must equal GDesk.C (tests/unit/test_g_theme.gd checks it).
var C := {
	"void": Color("#090807"),
	"panel": Color(16.0 / 255.0, 14.0 / 255.0, 12.0 / 255.0, 0.95),
	"panel_solid": Color("#100e0c"),
	"panel2": Color("#1a1612"),
	"well": Color("#0d0b0a"),
	"frame": Color(196.0 / 255.0, 176.0 / 255.0, 138.0 / 255.0, 0.16),
	"frame_hi": Color(196.0 / 255.0, 176.0 / 255.0, 138.0 / 255.0, 0.28),
	"tick": Color("#6a573a"),
	"bone": Color("#d6cebd"),
	"muted": Color("#aaa08e"),
	"dim": Color("#968d7c"),
	"plan": Color("#c9a465"),
	"plan_fill": Color("#a8854b"),
	"op": Color("#93b3a9"),
	"op_fill": Color("#6c8f86"),
	"amber": Color("#d9a03a"),
	"amber_line": Color(217.0 / 255.0, 160.0 / 255.0, 58.0 / 255.0, 0.62),
	"warn": Color("#d58a52"),
	"blood": Color("#9b3328"),
	"blood_text": Color("#d25a49"),
	"held": Color("#c9d2d8"),
	"paper": Color("#c3b79c"),
	"paper_dark": Color("#afa286"),
	"ink": Color("#1a140d"),
	"ink_soft": Color("#221b13"),
	"rail_edge": Color("#3a1d33"),
	"dateline": Color("#d9d1bf"),
}

var t := Theme.new()


func _init() -> void:
	_build()
	var err := ResourceSaver.save(t, OUT)
	if err == OK:
		var f := FileAccess.open(OUT, FileAccess.READ)
		var body := f.get_as_text()
		f.close()
		f = FileAccess.open(OUT, FileAccess.WRITE)
		f.store_string(HEADER + body)
		f.close()
	print("g_theme saved: ", err)
	quit(0 if err == OK else 1)


func face(file: String, spacing: int = 0) -> FontVariation:
	var fv := FontVariation.new()
	var path := FONTS + file
	if ResourceLoader.exists(path):
		fv.base_font = load(path)
	if spacing != 0:
		fv.spacing_glyph = spacing
	return fv


func box(bg: Color, border: Color = Color(0, 0, 0, 0), width: int = 1, radius: int = 2,
		margins: Array = [12, 12, 4, 4]) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = bg
	if border.a > 0.0:
		sb.border_color = border
		sb.set_border_width_all(width)
	sb.set_corner_radius_all(radius)
	sb.content_margin_left = margins[0]
	sb.content_margin_right = margins[1]
	sb.content_margin_top = margins[2]
	sb.content_margin_bottom = margins[3]
	sb.anti_aliasing = false
	return sb


func outline(c: Color, width: int = 1, radius: int = 2) -> StyleBoxFlat:
	var sb := box(Color(0, 0, 0, 0), c, width, radius)
	sb.draw_center = false
	return sb


func hatch(margins: Array = [12, 12, 4, 4]) -> StyleBoxTexture:
	"""Disabled ground: the 16 px hatch, tiled (spec 4.3). The dashed edge is drawn by the
	control (GDesk.draw_dashed_rect), as StyleBox borders are solid only."""
	var sb := StyleBoxTexture.new()
	sb.texture = load(TEX + "hatch_16.png")
	sb.axis_stretch_horizontal = StyleBoxTexture.AXIS_STRETCH_MODE_TILE
	sb.axis_stretch_vertical = StyleBoxTexture.AXIS_STRETCH_MODE_TILE
	sb.content_margin_left = margins[0]
	sb.content_margin_right = margins[1]
	sb.content_margin_top = margins[2]
	sb.content_margin_bottom = margins[3]
	return sb


func grime(margins: Array, alpha: float = 1.0) -> StyleBoxTexture:
	"""The panel: a 9-slice (margins 24) with the soot baked in; the middle and the edges
	tile-fit, the texture's noise is periodic over them (make_textures.py). The texture is
	opaque; `alpha` is the panel token's .95 for the cards, 1 for the sheets."""
	var sb := StyleBoxTexture.new()
	sb.modulate_color = Color(1, 1, 1, alpha)
	sb.texture = load(TEX + "panel_grime_9.png")
	sb.texture_margin_left = 24
	sb.texture_margin_right = 24
	sb.texture_margin_top = 24
	sb.texture_margin_bottom = 24
	sb.axis_stretch_horizontal = StyleBoxTexture.AXIS_STRETCH_MODE_TILE_FIT
	sb.axis_stretch_vertical = StyleBoxTexture.AXIS_STRETCH_MODE_TILE_FIT
	sb.content_margin_left = margins[0]
	sb.content_margin_right = margins[1]
	sb.content_margin_top = margins[2]
	sb.content_margin_bottom = margins[3]
	return sb


func variation(name: String, base: String) -> void:
	t.set_type_variation(name, base)


func button_colors(type: String, normal: Color, hover: Color, disabled: Color) -> void:
	t.set_color("font_color", type, normal)
	t.set_color("font_hover_color", type, hover)
	t.set_color("font_pressed_color", type, hover)
	t.set_color("font_focus_color", type, normal)
	t.set_color("font_hover_pressed_color", type, hover)
	t.set_color("font_disabled_color", type, disabled)


func button_boxes(type: String, normal: StyleBox, hover: StyleBox, disabled: StyleBox,
		focus: StyleBox = null) -> void:
	t.set_stylebox("normal", type, normal)
	t.set_stylebox("hover", type, hover)
	t.set_stylebox("pressed", type, hover)
	t.set_stylebox("hover_pressed", type, hover)
	t.set_stylebox("disabled", type, disabled)
	t.set_stylebox("focus", type, focus if focus != null else StyleBoxEmpty.new())


func _build() -> void:
	# --- faces (spec 4.2) -------------------------------------------------------------------
	var sans := face("ibm_plex_sans/IBMPlexSans-Regular.ttf")
	var sans_med := face("ibm_plex_sans/IBMPlexSans-Medium.ttf")
	var mono := face("ibm_plex_mono/IBMPlexMono-Regular.ttf")
	var mono_med := face("ibm_plex_mono/IBMPlexMono-Medium.ttf")
	var mono_semi := face("ibm_plex_mono/IBMPlexMono-SemiBold.ttf")
	var caps_med := face("barlow_condensed/BarlowCondensed-Medium.ttf", 2)
	var caps := face("barlow_condensed/BarlowCondensed-SemiBold.ttf", 2)
	var caps_bold := face("barlow_condensed/BarlowCondensed-Bold.ttf", 2)
	var type_reg := face("courier_prime/CourierPrime-Regular.ttf")
	var type_bold := face("courier_prime/CourierPrime-Bold.ttf")
	var dateline := face("courier_prime/CourierPrime-Bold.ttf", 2)
	t.default_font = sans

	# --- colour tokens (spec 4.1) -------------------------------------------------------------
	for k in C:
		t.set_color(k, "GColors", C[k])

	# --- text styles: Label variations (no sizes) ------------------------------------------
	var label_faces := {
		"GSans": sans, "GSansMed": sans_med,
		"GMono": mono_med, "GMonoReg": mono, "GMonoSemi": mono_semi,
		"GCaps": caps, "GCapsMed": caps_med, "GCapsBold": caps_bold,
		"GType": type_reg, "GTypeBold": type_bold, "GDateline": dateline,
	}
	for v in label_faces:
		variation(v, "Label")
		t.set_font("font", v, label_faces[v])
		t.set_color("font_color", v, C.bone)

	# --- panels (spec 4.3) ----------------------------------------------------------------
	variation("GPanel", "PanelContainer")
	t.set_stylebox("panel", "GPanel", grime([1, 1, 1, 1], C.panel.a))
	t.set_stylebox("frame", "GPanel", outline(C.frame, 1, 2))
	variation("GSheetPanel", "GPanel")
	t.set_stylebox("panel", "GSheetPanel", grime([20, 20, 14, 16]))
	variation("GCardPanel", "GPanel")
	t.set_stylebox("panel", "GCardPanel", grime([18, 18, 14, 14]))

	var strip_top := box(Color("#120f0d"), Color(0, 0, 0, 0), 0, 0, [0, 0, 0, 0])
	strip_top.border_color = C.frame_hi
	strip_top.border_width_bottom = 1
	strip_top.shadow_color = Color(0, 0, 0, 0.45)
	strip_top.shadow_size = 5
	strip_top.shadow_offset = Vector2(0, 2)
	variation("GStripTop", "PanelContainer")
	t.set_stylebox("panel", "GStripTop", strip_top)
	var banner := box(Color("#0f0c0a"), Color(0, 0, 0, 0), 0, 0, [0, 0, 0, 0])
	banner.border_color = Color(C.amber, 0.22)
	banner.border_width_bottom = 1
	variation("GBanner", "PanelContainer")
	t.set_stylebox("panel", "GBanner", banner)
	var strip_bottom := box(Color("#110e0c"), Color(0, 0, 0, 0), 0, 0, [0, 0, 0, 0])
	strip_bottom.border_color = C.frame_hi
	strip_bottom.border_width_top = 1
	variation("GStripBottom", "PanelContainer")
	t.set_stylebox("panel", "GStripBottom", strip_bottom)

	# Keycaps (spec 4.3): 1 px frame-hi (or amber-line) hairline, 2 px radius; mono small text.
	variation("GKeycap", "PanelContainer")
	t.set_stylebox("panel", "GKeycap", box(Color(0, 0, 0, 0), Color(C.bone, 0.34), 1, 2, [6, 6, 1, 1]))
	variation("GKeycapAmber", "PanelContainer")
	t.set_stylebox("panel", "GKeycapAmber", box(Color(0, 0, 0, 0), C.amber_line, 1, 2, [6, 6, 1, 1]))
	# Icon plates: the dark square under Pip's icons.
	variation("GTile", "PanelContainer")
	t.set_stylebox("panel", "GTile", box(Color("#0b0a09"), Color(C.frame.r, C.frame.g, C.frame.b, 0.14), 1, 0, [0, 0, 0, 0]))
	# Raised rows and selected cells: panel-2, 2 px radius.
	variation("GRaised", "PanelContainer")
	t.set_stylebox("panel", "GRaised", box(C.panel2, C.frame, 1, 2, [4, 4, 2, 2]))
	# The held plate.
	variation("GHeld", "PanelContainer")
	t.set_stylebox("panel", "GHeld", box(Color("#100d0b"), C.frame, 1, 2, [0, 0, 0, 0]))
	# Hairline tags (RISING), warn.
	variation("GTag", "PanelContainer")
	t.set_stylebox("panel", "GTag", box(Color(0, 0, 0, 0), C.warn, 1, 2, [6, 6, 1, 1]))
	# The refusal toast: warn on panel-2.
	variation("GToast", "PanelContainer")
	var toast := box(C.panel2, C.warn, 1, 2, [14, 14, 6, 6])
	toast.shadow_color = Color(0, 0, 0, 0.55)
	toast.shadow_size = 10
	t.set_stylebox("panel", "GToast", toast)

	# --- rail plates (spec 5.3): rest, lit, hint, disabled -----------------------------------
	var plate_rest := box(Color("#14110f"), Color(C.frame.r, C.frame.g, C.frame.b, 0.12), 1, 0, [0, 0, 0, 0])
	plate_rest.shadow_color = Color(0, 0, 0, 0.45)
	plate_rest.shadow_size = 7
	plate_rest.shadow_offset = Vector2(0, 6)
	var plate_hover := plate_rest.duplicate() as StyleBoxFlat
	plate_hover.bg_color = Color("#1f1913")
	plate_hover.border_color = C.frame_hi
	var plate_lit := plate_rest.duplicate() as StyleBoxFlat
	plate_lit.bg_color = Color("#1f1913")
	plate_lit.border_color = Color(C.amber, 0.35)
	var plate_hint := plate_lit.duplicate() as StyleBoxFlat
	plate_hint.border_color = Color(C.amber, 0.5)
	plate_hint.set_border_width_all(2)
	plate_hint.shadow_color = Color(C.amber, 0.26)
	plate_hint.shadow_size = 12
	plate_hint.shadow_offset = Vector2.ZERO
	var plate_off := hatch([0, 0, 0, 0])
	for v in ["GPlate", "GPlateLit", "GPlateHint"]:
		variation(v, "Button")
		t.set_font("font", v, caps)
		button_colors(v, C.muted, C.bone, C.dim)
	button_boxes("GPlate", plate_rest, plate_hover, plate_off)
	button_boxes("GPlateLit", plate_lit, plate_lit, plate_off)
	button_boxes("GPlateHint", plate_hint, plate_hint, plate_off)

	# --- text buttons (CHOOSE ACTIONS, UNDO, BACK, ...) and the primary (ADD TO PLAN) --------
	var focus := outline(C.amber, 1, 2)
	variation("GButton", "Button")
	t.set_font("font", "GButton", caps)
	button_colors("GButton", C.bone, Color("#e8dcc2"), C.dim)
	button_boxes("GButton", box(Color("#14110f"), C.frame_hi), box(Color("#1f1913"), Color(C.bone, 0.5)),
		hatch(), focus)
	variation("GButtonAmber", "Button")
	t.set_font("font", "GButtonAmber", caps)
	button_colors("GButtonAmber", C.amber, Color("#e8b85a"), C.dim)
	button_boxes("GButtonAmber", box(Color("#1b1612"), C.amber_line), box(Color("#231c14"), C.amber),
		hatch(), focus)
	# The x of a sheet (and other small mono buttons).
	variation("GClose", "Button")
	t.set_font("font", "GClose", mono_med)
	button_colors("GClose", C.muted, C.bone, C.dim)
	button_boxes("GClose", box(Color(0, 0, 0, 0), C.frame_hi, 1, 2, [8, 8, 0, 0]),
		box(C.panel2, Color(C.bone, 0.5), 1, 2, [8, 8, 0, 0]), hatch([8, 8, 0, 0]), focus)

	# --- the view switch segments (spec 5.2): the current one has an amber underline ----------
	var seg := box(Color("#0d0b0a"), C.frame_hi, 1, 0, [14, 14, 0, 0])
	var seg_on := box(Color("#2a2119"), C.frame_hi, 1, 0, [14, 14, 0, 0])
	seg_on.border_color = C.amber
	seg_on.border_width_left = 0
	seg_on.border_width_right = 0
	seg_on.border_width_top = 0
	seg_on.border_width_bottom = 2
	var seg_hover := seg.duplicate() as StyleBoxFlat
	seg_hover.bg_color = C.panel2
	variation("GSegment", "Button")
	t.set_font("font", "GSegment", mono_med)
	button_colors("GSegment", C.muted, C.bone, C.dim)
	button_boxes("GSegment", seg, seg_hover, hatch([14, 14, 0, 0]))
	variation("GSegmentOn", "Button")
	t.set_font("font", "GSegmentOn", mono_med)
	button_colors("GSegmentOn", Color("#e6d9bd"), Color("#e6d9bd"), C.dim)
	button_boxes("GSegmentOn", seg_on, seg_on, hatch([14, 14, 0, 0]))

	# The research-quality switch in the Plan drawer (spec 5.8, A4): toggle buttons, the chosen
	# one pressed (panel-2 ground, plan-fill underline), the others muted.
	var rq := box(Color("#0d0b0a"), C.frame_hi, 1, 0, [14, 14, 6, 6])
	var rq_hover := rq.duplicate() as StyleBoxFlat
	rq_hover.bg_color = C.panel2
	var rq_on := box(Color("#2a2119"), C.frame_hi, 1, 0, [14, 14, 6, 6])
	rq_on.border_color = C.plan_fill
	rq_on.border_width_left = 0
	rq_on.border_width_right = 0
	rq_on.border_width_top = 0
	rq_on.border_width_bottom = 2
	variation("GQualityButton", "Button")
	t.set_font("font", "GQualityButton", sans)
	t.set_color("font_color", "GQualityButton", C.muted)
	t.set_color("font_hover_color", "GQualityButton", C.bone)
	t.set_color("font_focus_color", "GQualityButton", C.muted)
	t.set_color("font_pressed_color", "GQualityButton", Color("#e6d9bd"))
	t.set_color("font_hover_pressed_color", "GQualityButton", Color("#e6d9bd"))
	t.set_color("font_disabled_color", "GQualityButton", C.dim)
	t.set_stylebox("normal", "GQualityButton", rq)
	t.set_stylebox("hover", "GQualityButton", rq_hover)
	t.set_stylebox("pressed", "GQualityButton", rq_on)
	t.set_stylebox("hover_pressed", "GQualityButton", rq_on)
	t.set_stylebox("disabled", "GQualityButton", hatch([14, 14, 6, 6]))
	t.set_stylebox("focus", "GQualityButton", outline(C.amber, 1, 0))

	# --- sheet rows (spec 5.7.1): rest, hover/focus (amber hairline), blocked (hatch) -------
	var row_rest := box(Color(0, 0, 0, 0), Color(0, 0, 0, 0), 1, 2, [0, 0, 0, 0])
	row_rest.border_color = Color(0, 0, 0, 0)
	row_rest.set_border_width_all(1)
	var row_hover := box(Color("#1f1913"), C.amber_line, 1, 2, [0, 0, 0, 0])
	var row_blocked_hover := box(Color("#14110f"), C.frame_hi, 1, 2, [0, 0, 0, 0])
	variation("GRow", "Button")
	button_colors("GRow", C.bone, C.bone, C.dim)
	button_boxes("GRow", row_rest, row_hover, hatch([0, 0, 0, 0]), outline(C.amber, 1, 2))
	variation("GRowBlocked", "Button")
	button_colors("GRowBlocked", C.muted, C.bone, C.dim)
	button_boxes("GRowBlocked", hatch([0, 0, 0, 0]), row_blocked_hover, hatch([0, 0, 0, 0]),
		outline(C.amber, 1, 2))
	# The Upgrades list rows (A4): raised panel-2 rows; bought and unaffordable = hatch.
	variation("GUpgradeRow", "Button")
	t.set_font("font", "GUpgradeRow", sans)
	button_colors("GUpgradeRow", C.bone, C.bone, C.dim)
	button_boxes("GUpgradeRow", box(C.panel2, C.frame, 1, 2, [14, 14, 4, 4]),
		box(Color("#1f1913"), C.amber_line, 1, 2, [14, 14, 4, 4]), hatch([14, 14, 4, 4]),
		outline(C.amber, 1, 2))

	# --- Commit (spec 5.6): ready (amber), hold (muted, live), inert (hatch + dashed) -------
	var cmt := box(Color("#1a1510"), C.amber_line, 1, 2, [0, 0, 0, 0])
	cmt.shadow_color = Color(0, 0, 0, 0.55)
	cmt.shadow_size = 12
	cmt.shadow_offset = Vector2(0, 6)
	var cmt_hover := cmt.duplicate() as StyleBoxFlat
	cmt_hover.bg_color = Color("#241c14")
	cmt_hover.border_color = C.amber
	variation("GCommitReady", "Button")
	button_boxes("GCommitReady", cmt, cmt_hover, hatch([0, 0, 0, 0]))
	var hold := box(Color("#110f0d"), C.frame_hi, 1, 2, [0, 0, 0, 0])
	var hold_hover := hold.duplicate() as StyleBoxFlat
	hold_hover.bg_color = C.panel2
	hold_hover.border_color = Color(C.bone, 0.5)
	variation("GCommitHold", "Button")
	button_boxes("GCommitHold", hold, hold_hover, hatch([0, 0, 0, 0]))

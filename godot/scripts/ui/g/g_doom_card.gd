class_name GDoomCard
extends GPanel
## P(Doom) card (spec 5.4). A 270-degree ring in the game's doom stroke colour,
## the percentage exactly as today's readout prints it ("%.1f%%"), the band name, a RISING
## tag from the doom system's own trend word, a seven-chip band ladder and "band N of 7".
## No delta chip and no momentum number (spec 10.9, ADR-0015 reading). Click: today's
## expanded trend dialog. Doom colours and bands come from ThemeManager only.
##
## The look (phase 2a, spec 4.4 rank 1): the only panel framed in its own colour -- the band's
## stroke at 55% for the hairline, a 3 px top edge in the full colour, an outer glow of the
## stroke at 30% (StyleBoxFlat shadow, size 8; drawn with draw_center off, so it is a ring
## outside the card). The percentage at `title` and the band name at `label`, mono, in the
## stroke colour lifted to 5:1 on the card (spec 4.1).

signal pressed

const RING_SIZE := 172.0
const STROKE := 16.0
const START_DEG := 135.0
const SWEEP_DEG := 270.0

var doom: float = 0.0
var band_index: int = 0
var trend: String = ""

var _ring: Control
var _pct: Label
var _band_name: Label
var _rising: PanelContainer
var _band_n: Label
var _warn_label: Label
var _ladder: Control
## Today's lose-condition line ("Buy time -- survival is the score | Lose: ..."), read from
## the classic ExplanationLabel by GDesk (set_lose_line), never retyped here.
var lose_label: Label


const TOP_EDGE := 3.0

var _stroke: Color = Color(0, 0, 0, 0)


func _init() -> void:
	name = "DoomCard"
	mouse_filter = Control.MOUSE_FILTER_STOP
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	tooltip_text = "P(Doom): click for the full trend and what moved it"
	_build()


func _build() -> void:
	var m := MarginContainer.new()
	m.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for side in ["left", "right"]:
		m.add_theme_constant_override("margin_" + side, 16)
	m.add_theme_constant_override("margin_top", 10)
	m.add_theme_constant_override("margin_bottom", 12)
	add_child(m)
	var vb := VBoxContainer.new()
	vb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vb.add_theme_constant_override("separation", 8)
	m.add_child(vb)
	var head := HBoxContainer.new()
	head.mouse_filter = Control.MOUSE_FILTER_IGNORE
	head.add_theme_constant_override("separation", 8)
	vb.add_child(head)
	var icon_path := "res://assets/icons/doom.png"
	if ResourceLoader.exists(icon_path):
		var ic := TextureRect.new()
		ic.texture = load(icon_path)
		ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		ic.custom_minimum_size = Vector2(24, 24)
		ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
		head.add_child(ic)
	var title := GDesk.make_label("P(DOOM)", "body", GDesk.C.muted, "GCaps")
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_child(title)
	# From band index 5 the header carries the game's own words (main_ui commit warning).
	_warn_label = GDesk.make_label("Very close to game over", "small", GDesk.C.warn, "GSansMed")
	_warn_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_warn_label.visible = false
	head.add_child(_warn_label)

	var body := HBoxContainer.new()
	body.mouse_filter = Control.MOUSE_FILTER_IGNORE
	body.add_theme_constant_override("separation", 16)
	vb.add_child(body)
	_ring = Control.new()
	_ring.name = "Ring"
	_ring.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_ring.custom_minimum_size = Vector2(RING_SIZE, RING_SIZE)
	_ring.draw.connect(_draw_ring)
	body.add_child(_ring)
	_pct = GDesk.make_label("--", "title", GDesk.C.bone, "GMonoSemi")
	_pct.name = "Percent"
	_pct.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_pct.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_pct.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_ring.add_child(_pct)

	var right := VBoxContainer.new()
	right.mouse_filter = Control.MOUSE_FILTER_IGNORE
	right.add_theme_constant_override("separation", 8)
	right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right.alignment = BoxContainer.ALIGNMENT_CENTER
	body.add_child(right)
	_band_name = GDesk.make_label("--", "label", GDesk.C.bone, "GMonoSemi")
	_band_name.name = "BandName"
	right.add_child(_band_name)
	_rising = GDesk.make_keycap("RISING")
	_rising.theme_type_variation = &"GTag"
	GDesk.set_ink(_rising.get_meta("label") as Label, GDesk.C.warn)
	_rising.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	_rising.visible = false
	right.add_child(_rising)
	_ladder = Control.new()
	_ladder.name = "Ladder"
	_ladder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_ladder.custom_minimum_size = Vector2(170, 14)
	_ladder.draw.connect(_draw_ladder)
	right.add_child(_ladder)
	_band_n = GDesk.make_label("band -- of 7", "small", GDesk.C.muted, "GMono")
	right.add_child(_band_n)
	lose_label = GDesk.make_label("", "small", GDesk.C.muted)
	lose_label.name = "LoseLine"
	lose_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	lose_label.visible = false
	right.add_child(lose_label)


func set_lose_line(text: String) -> void:
	"""Today's lose-condition line, shown as the classic layout shows it (G hides the classic
	label with the rest of the classic chrome)."""
	lose_label.text = text
	lose_label.visible = text != ""


func update_from_state(state: Dictionary) -> void:
	doom = float(state.get("doom", 0.0))
	band_index = ThemeManager.get_doom_band_index(doom)
	var ds = state.get("doom_system", {})
	trend = String(ds.get("doom_trend", "")) if ds is Dictionary else ""
	var stroke: Color = ThemeManager.get_doom_stroke_color(doom)
	var bg: Color = GDesk.C.panel_solid
	# Exactly today's readout format (main_ui numeric doom label).
	_pct.text = "%.1f%%" % doom
	GDesk.set_ink(_pct, GDesk.lift_to(stroke, bg, 5.0))
	_band_name.text = ThemeManager.get_doom_status_label(doom)
	GDesk.set_ink(_band_name, GDesk.lift_to(stroke, bg, 5.0))
	_rising.visible = trend == "increasing" or trend == "strongly_increasing"
	_band_n.text = "band %d of %d" % [band_index + 1, ThemeManager.DOOM_STATUS_BANDS.size()]
	_warn_label.visible = band_index >= 5
	if stroke != _stroke:
		_stroke = stroke
		frame_override = band_frame(stroke)
		queue_redraw()
	_ring.queue_redraw()
	_ladder.queue_redraw()


static func band_frame(stroke: Color) -> StyleBoxFlat:
	"""The card's own frame (spec 4.4): a 1 px hairline of the band stroke at 55% and the outer
	glow, the stroke at 30% (shadow size 8). No fill: it is drawn over the grime ground."""
	var sb := StyleBoxFlat.new()
	sb.draw_center = false
	sb.border_color = Color(stroke, 0.55)
	sb.set_border_width_all(1)
	sb.shadow_color = Color(stroke, 0.30)
	sb.shadow_size = 8
	return sb


func _draw() -> void:
	super._draw()
	# The 3 px top edge in the band's full colour, over the hairline.
	draw_rect(Rect2(0, 0, size.x, TOP_EDGE), _stroke)


func band_stroke() -> Color:
	return _stroke


func _draw_ring() -> void:
	var center := _ring.size / 2.0
	var r := minf(_ring.size.x, _ring.size.y) / 2.0 - STROKE / 2.0 - 2.0
	var a0 := deg_to_rad(START_DEG)
	var a1 := deg_to_rad(START_DEG + SWEEP_DEG)
	_ring.draw_arc(center, r, a0, a1, 64, Color(1, 1, 1, 0.07), STROKE, true)
	var frac := clampf(doom / 100.0, 0.0, 1.0)
	if frac > 0.0:
		_ring.draw_arc(center, r, a0, a0 + (a1 - a0) * frac, 64,
			ThemeManager.get_doom_stroke_color(doom), STROKE, true)
	# A fine tick at each band edge.
	for band in ThemeManager.DOOM_STATUS_BANDS:
		var at := float(band.below)
		if at >= 100.0:
			continue
		var ang := a0 + (a1 - a0) * (at / 100.0)
		var dir := Vector2(cos(ang), sin(ang))
		_ring.draw_line(center + dir * (r - STROKE / 2.0 - 2.0), center + dir * (r + STROKE / 2.0 + 2.0),
			GDesk.C.tick, 1.0, true)


func _draw_ladder() -> void:
	var bands: Array = ThemeManager.DOOM_STATUS_BANDS
	var n := bands.size()
	var gap := 4.0
	var w := (_ladder.size.x - gap * (n - 1)) / float(n)
	var lo := 0.0
	for i in range(n):
		var hi := minf(float(bands[i].below), 100.0)
		var mid := (lo + hi) / 2.0
		lo = hi
		var col: Color = ThemeManager.get_doom_stroke_color(mid)
		var rect := Rect2(i * (w + gap), 4, w, 6)
		if i == band_index:
			rect = Rect2(i * (w + gap), 0, w, 14)
		else:
			col.a = 0.38
		_ladder.draw_rect(rect, col)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT \
			and event.pressed:
		pressed.emit()
		accept_event()


func get_text_boxes() -> Array:
	return []

class_name GPlate
extends Button
## One rail plate (spec 5.3): icon tile, caps name, an optional status at the right, keycap.
## States: rest, lit (its sheet is open), hint (advisor pulse), disabled, keys hidden.
## The look (phase 2a) is the theme's: GPlate / GPlateLit / GPlateHint (theme/g_theme.tres)
## give the ground, hairline and shadow per state, and the hatch when disabled. This plate's
## _draw adds what a StyleBoxFlat cannot: the 3 px left edge in the state colour (Pip's
## aubergine at rest, amber lit or hinted, spec 5.3 and Q13) and, when disabled, the dashed
## edge (spec 4.3). Hierarchy rank 4 (spec 4.4): the name `small` in `muted`, icon at 82%.

var _icon: TextureRect
var _name_label: Label
var _status_label: Label
var _keycap: PanelContainer
var _key_text := ""
var _keycap_allowed := true
var _lit := false
var _hint := false

const EDGE_W := 3.0
const EDGE_OFF := Color("#2a241e")          # a disabled plate's edge (the mock-up's .rb.off)
const LIT_TEXT := Color("#e8dcc2")          # the name on a lit or hinted plate


func _init() -> void:
	focus_mode = Control.FOCUS_NONE
	custom_minimum_size = Vector2(232, 52)
	clip_contents = false


func setup(icon_path: String, title: String, key_text: String, status: String = "") -> void:
	var hb := HBoxContainer.new()
	hb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hb.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	hb.offset_left = 11
	hb.offset_right = -10
	hb.add_theme_constant_override("separation", 10)
	add_child(hb)
	var tile := PanelContainer.new()
	tile.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tile.custom_minimum_size = Vector2(36, 36)
	tile.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	tile.theme_type_variation = &"GTile"
	hb.add_child(tile)
	_icon = TextureRect.new()
	_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_icon.custom_minimum_size = Vector2(28, 28)
	_icon.self_modulate = Color(1, 1, 1, 0.82)
	if ResourceLoader.exists(icon_path):
		_icon.texture = load(icon_path)
	tile.add_child(_icon)
	_name_label = GDesk.make_label(title, "small", GDesk.C.muted, "GCaps")
	_name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hb.add_child(_name_label)
	_status_label = GDesk.make_label(status, "small", GDesk.C.muted, "GMono")
	GDesk.compact_step_up(_status_label)
	_status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hb.add_child(_status_label)
	_keycap = GDesk.make_keycap(key_text)
	_keycap.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	hb.add_child(_keycap)
	_key_text = key_text
	_refresh()


func set_status(text: String) -> void:
	if _status_label != null:
		_status_label.text = text


func set_status_warn(on: bool) -> void:
	"""Warn colour for a status that is a warning (the Ledger's due-soon [!])."""
	if _status_label != null:
		GDesk.set_ink(_status_label, GDesk.C.warn if on else GDesk.C.muted)


func get_status() -> String:
	return _status_label.text if _status_label != null else ""


func set_keycap_visible(on: bool) -> void:
	_keycap_allowed = on
	_refresh()


func keycap_shown() -> bool:
	return _keycap != null and _keycap.visible


func set_lit(on: bool) -> void:
	_lit = on
	_refresh()


func set_hint(on: bool) -> void:
	_hint = on
	_refresh()


func _notification(what: int) -> void:
	if what == NOTIFICATION_ENABLED or what == NOTIFICATION_DISABLED:
		_refresh()


func _refresh() -> void:
	if _keycap != null:
		_keycap.visible = _key_text != "" and _keycap_allowed and not disabled
		GDesk.set_keycap_amber(_keycap, (_lit or _hint) and not disabled)
	if _hint and not disabled:
		theme_type_variation = &"GPlateHint"
	elif _lit and not disabled:
		theme_type_variation = &"GPlateLit"
	else:
		theme_type_variation = &"GPlate"
	if _name_label != null:
		# Disabled keeps `dim`, never faded text (spec 4.3).
		GDesk.set_ink(_name_label,
			GDesk.C.dim if disabled else (LIT_TEXT if (_lit or _hint) else GDesk.C.muted))
	if _icon != null:
		_icon.self_modulate = Color(1, 1, 1, 0.45 if disabled else 0.82)
	queue_redraw()


func edge_colour() -> Color:
	if disabled:
		return EDGE_OFF
	return GDesk.C.amber if (_lit or _hint) else GDesk.C.rail_edge


func _draw() -> void:
	# Over the theme's stylebox, under the children: the state edge, then the dashed edge
	# of a disabled plate.
	if disabled:
		GDesk.draw_dashed_rect(self, Rect2(Vector2.ZERO, size), GDesk.C.frame_hi)
	draw_rect(Rect2(0, 0, EDGE_W, size.y), edge_colour())

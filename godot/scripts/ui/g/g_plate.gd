class_name GPlate
extends Button
## One rail plate (spec 5.3): icon tile, caps name, an optional status at the right, keycap.
## States: rest, lit (its sheet is open), hint (advisor pulse), disabled, keys hidden.
## Plain look for phase 1a; 2a swaps the styleboxes for g_theme.tres.

var _icon: TextureRect
var _name_label: Label
var _status_label: Label
var _keycap: PanelContainer
var _key_text := ""
var _keycap_allowed := true
var _lit := false
var _hint := false


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
	tile.add_theme_stylebox_override("panel", GDesk.make_box(GDesk.C.well, GDesk.C.frame, 1, 2))
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
	_name_label = GDesk.make_label(title, "small", GDesk.C.muted)
	_name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hb.add_child(_name_label)
	_status_label = GDesk.make_label(status, "small", GDesk.C.muted)
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
		_status_label.add_theme_color_override("font_color", GDesk.C.warn if on else GDesk.C.muted)


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
	var edge: Color = GDesk.C.amber if (_lit or _hint) else GDesk.C.rail_edge
	var border: Color = GDesk.C.frame_hi
	var normal := _box(GDesk.C.panel, border, edge)
	var hover := _box(GDesk.C.panel2, GDesk.C.frame_hi, edge)
	var dis := _box(GDesk.C.well, GDesk.C.frame, GDesk.C.rail_edge)
	add_theme_stylebox_override("normal", normal)
	add_theme_stylebox_override("hover", hover)
	add_theme_stylebox_override("pressed", hover)
	add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	add_theme_stylebox_override("disabled", dis)
	if _name_label != null:
		# Disabled keeps `dim`, never faded text (spec 4.3).
		_name_label.add_theme_color_override("font_color",
			GDesk.C.dim if disabled else (GDesk.C.bone if _lit else GDesk.C.muted))


static func _box(bg: Color, border: Color, edge: Color) -> StyleBoxFlat:
	"""Plain look: one flat box. The 3 px left edge carries the plate's state colour (amber when
	lit or hinted, Pip's aubergine at rest); the other sides are a 1 px hairline. StyleBoxFlat
	has a single border colour, so at rest the hairline takes the edge colour too; 2a replaces
	this with the textured stylebox."""
	var sb := StyleBoxFlat.new()
	sb.bg_color = bg
	sb.border_color = edge if edge == GDesk.C.amber else border
	sb.border_width_top = 1
	sb.border_width_right = 1
	sb.border_width_bottom = 1
	sb.border_width_left = 3
	sb.set_corner_radius_all(2)
	return sb

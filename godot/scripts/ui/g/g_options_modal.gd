extends Control
## G desk options (fork/design/godot-g/spec.md 2.1), opened from the Settings board's
## "G desk options" row. It shows only the switches that do something today: in phase 1 that
## is the G desk on/off switch. Reduced motion, room effects and the resources take join it in
## the phases that make them work (GPrefs gains each setting then). Applies on next game load,
## like today's layout checkbox.
##
## Escape contract (docs/game-design/UI_ESCAPE_CONTRACT.md): Esc, the x and Close all close it,
## standalone-safe (tests/unit/test_ui_no_dead_ends.gd opens it with no host).

signal closed

var desk_toggle: CheckButton
var _panel: PanelContainer
var _barrier: ColorRect


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_build()
	visible = false
	EscToClose.attach(self, _request_close)


func _build() -> void:
	_barrier = ColorRect.new()
	_barrier.name = "Barrier"
	_barrier.color = Color(0, 0, 0, 0.55)
	_barrier.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(_barrier)
	_barrier.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	_panel = PanelContainer.new()
	_panel.name = "Panel"
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color("#1a1612")
	sb.border_color = Color(196.0 / 255.0, 176.0 / 255.0, 138.0 / 255.0, 0.28)
	sb.set_border_width_all(1)
	sb.set_corner_radius_all(2)
	sb.content_margin_left = 24
	sb.content_margin_right = 24
	sb.content_margin_top = 16
	sb.content_margin_bottom = 20
	_panel.add_theme_stylebox_override("panel", sb)
	add_child(_panel)
	_panel.custom_minimum_size = Vector2(560, 0)
	_panel.set_anchors_preset(Control.PRESET_CENTER)
	_panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	_panel.grow_vertical = Control.GROW_DIRECTION_BOTH

	var vb := VBoxContainer.new()
	vb.add_theme_constant_override("separation", 14)
	_panel.add_child(vb)
	var head := HBoxContainer.new()
	vb.add_child(head)
	var title := _label("G DESK OPTIONS", "header", Color("#d9a03a"))
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_child(title)
	var x := Button.new()
	x.name = "CloseX"
	x.text = "x"
	x.tooltip_text = "Close (Esc)"
	x.custom_minimum_size = Vector2(36, 32)
	x.add_theme_font_size_override("font_size", ThemeManager.get_font_size("body"))
	x.pressed.connect(_request_close)
	head.add_child(x)

	var row := HBoxContainer.new()
	row.name = "DeskRow"
	row.add_theme_constant_override("separation", 16)
	vb.add_child(row)
	var l := _label("G desk (the new main screen)", "body", Color("#d6cebd"))
	l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(l)
	desk_toggle = CheckButton.new()
	desk_toggle.name = "DeskToggle"
	desk_toggle.tooltip_text = "On: the G desk. Off: the classic main screen."
	desk_toggle.set_pressed_no_signal(GPrefs.desk())
	desk_toggle.toggled.connect(_on_desk_toggled)
	row.add_child(desk_toggle)
	var cap := _label("Off brings back the classic main screen. Applies on next game load.",
		"small", Color("#aaa08e"))
	cap.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	cap.custom_minimum_size = Vector2(500, 0)
	vb.add_child(cap)

	var foot := HBoxContainer.new()
	foot.alignment = BoxContainer.ALIGNMENT_END
	vb.add_child(foot)
	var close := Button.new()
	close.name = "CloseButton"
	close.text = "Close"
	close.custom_minimum_size = Vector2(140, 40)
	close.add_theme_font_size_override("font_size", ThemeManager.get_font_size("body"))
	close.pressed.connect(_request_close)
	foot.add_child(close)


func _label(text: String, size_name: String, color: Color) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", ThemeManager.get_font_size(size_name))
	l.add_theme_color_override("font_color", color)
	return l


func show_panel() -> void:
	if desk_toggle != null:
		desk_toggle.set_pressed_no_signal(GPrefs.desk())
	visible = true
	_barrier.mouse_filter = Control.MOUSE_FILTER_STOP


func hide_panel() -> void:
	visible = false
	_barrier.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var vp := get_viewport()
	if vp != null:
		var f := vp.gui_get_focus_owner()
		if f != null and is_ancestor_of(f):
			vp.gui_release_focus()


func _request_close() -> void:
	if not visible:
		return
	hide_panel()
	closed.emit()


func _input(event: InputEvent) -> void:
	# The Settings screen's own _input turns Esc into "back"; this modal sits over it, so it
	# takes Esc first while it is open (children receive _input before their parent).
	if visible and event.is_action_pressed("ui_cancel"):
		_request_close()
		get_viewport().set_input_as_handled()


func _on_desk_toggled(on: bool) -> void:
	GPrefs.set_desk(on)

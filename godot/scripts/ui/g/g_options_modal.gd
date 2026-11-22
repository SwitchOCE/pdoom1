extends Control
## G desk options (fork/design/godot-g/spec.md 2.1), opened from the Settings board's
## "G desk options" row. It shows only the switches that do something today: the G desk on/off
## switch, room effects (full / simple / off, spec 5.14, phase 3a), the typewriter sound
## on/off (phase 4; Alex: "include a mute option for it") and, since phase 7, reduced
## motion (spec 6.5: every motion of the 6.2 table takes its "Reduced motion" column), and the
## resources take (tier icons / traces, phase 6). Each row's caption says when it applies.
##
## Escape contract (docs/game-design/UI_ESCAPE_CONTRACT.md): Esc, the x and Close all close it,
## standalone-safe (tests/unit/test_ui_no_dead_ends.gd opens it with no host).

signal closed

var desk_toggle: CheckButton
var typewriter_toggle: CheckButton
var room_picker: OptionButton
var motion_toggle: CheckButton
var resources_picker: OptionButton
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

	var room_row := HBoxContainer.new()
	room_row.name = "RoomRow"
	room_row.add_theme_constant_override("separation", 16)
	vb.add_child(room_row)
	var rl := _label("Room effects", "body", Color("#d6cebd"))
	rl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	room_row.add_child(rl)
	room_picker = OptionButton.new()
	room_picker.name = "RoomPicker"
	room_picker.add_theme_font_size_override("font_size", ThemeManager.get_font_size("body"))
	for i in range(ROOM_CHOICES.size()):
		room_picker.add_item(String(ROOM_CHOICES[i][1]), i)
	room_picker.tooltip_text = "How the office behind the desk shows the doom level."
	room_picker.custom_minimum_size = Vector2(140, 0)
	room_picker.select(_room_index(GPrefs.room_effects()))
	room_picker.item_selected.connect(_on_room_selected)
	room_row.add_child(room_picker)
	var rcap := _label("Full: the office darkens as doom rises, with film grain. Simple: the colour change only, for slow graphics. Off: the classic dim office. Applies on next game load.",
		"small", Color("#aaa08e"))
	rcap.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	rcap.custom_minimum_size = Vector2(500, 0)
	vb.add_child(rcap)

	var tw_row := HBoxContainer.new()
	tw_row.name = "TypewriterRow"
	tw_row.add_theme_constant_override("separation", 16)
	vb.add_child(tw_row)
	var tl := _label("Typewriter sound", "body", Color("#d6cebd"))
	tl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tw_row.add_child(tl)
	typewriter_toggle = CheckButton.new()
	typewriter_toggle.name = "TypewriterToggle"
	typewriter_toggle.tooltip_text = "On: the date types in with typewriter strikes. Off: it types in silently."
	typewriter_toggle.set_pressed_no_signal(GPrefs.typewriter_sound())
	typewriter_toggle.toggled.connect(_on_typewriter_toggled)
	tw_row.add_child(typewriter_toggle)
	var tcap := _label("The strikes as each new month's date types in. Applies at once.",
		"small", Color("#aaa08e"))
	tcap.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	tcap.custom_minimum_size = Vector2(500, 0)
	vb.add_child(tcap)
	var motion_row := HBoxContainer.new()
	motion_row.name = "MotionRow"
	motion_row.add_theme_constant_override("separation", 16)
	vb.add_child(motion_row)
	var ml := _label("Reduced motion", "body", Color("#d6cebd"))
	ml.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	motion_row.add_child(ml)
	motion_toggle = CheckButton.new()
	motion_toggle.name = "MotionToggle"
	motion_toggle.tooltip_text = "On: no fades, slides or pulses on the G desk."
	motion_toggle.set_pressed_no_signal(GPrefs.reduced_motion())
	motion_toggle.toggled.connect(_on_motion_toggled)
	motion_row.add_child(motion_toggle)
	var mcap := _label("On: sheets, papers and the P(Doom) ring change at once, the office changes with doom at once with still grain, the advisor's button glows without pulsing, and the date shows without typing or its sound. Applies at once; the office on next game load.",
		"small", Color("#aaa08e"))
	mcap.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	mcap.custom_minimum_size = Vector2(500, 0)
	vb.add_child(mcap)

	# Phase 6 (spec 5.1.3, Q2): the top strip's resources as tier icons (default) or traces.
	var res_row := HBoxContainer.new()
	res_row.name = "ResourcesRow"
	res_row.add_theme_constant_override("separation", 16)
	vb.add_child(res_row)
	var rsl := _label("Resources", "body", Color("#d6cebd"))
	rsl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	res_row.add_child(rsl)
	resources_picker = OptionButton.new()
	resources_picker.name = "ResourcesPicker"
	resources_picker.add_theme_font_size_override("font_size", ThemeManager.get_font_size("body"))
	for i in range(RESOURCE_CHOICES.size()):
		resources_picker.add_item(String(RESOURCE_CHOICES[i][1]), i)
	resources_picker.tooltip_text = "How the top strip shows money, compute, research, papers and reputation."
	resources_picker.custom_minimum_size = Vector2(140, 0)
	resources_picker.select(_resources_index(GPrefs.resources()))
	resources_picker.item_selected.connect(_on_resources_selected)
	res_row.add_child(resources_picker)
	var rscap := _label("Tier icons: a picture beside each amount that changes as it rises or falls. Traces: a small line of each amount at the start of each month since the run began or was loaded (up to the last 24). Applies at once.",
		"small", Color("#aaa08e"))
	rscap.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	rscap.custom_minimum_size = Vector2(500, 0)
	vb.add_child(rscap)

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
	_center_panel()


## Room effects choices: GPrefs value, shown name.
const ROOM_CHOICES := [["full", "Full"], ["simple", "Simple"], ["off", "Off"]]


static func _room_index(value: String) -> int:
	for i in range(ROOM_CHOICES.size()):
		if String(ROOM_CHOICES[i][0]) == value:
			return i
	return 0


## Resources choices (spec 5.1.2-5.1.3): GPrefs value, shown name.
const RESOURCE_CHOICES := [["icons", "Tier icons"], ["traces", "Traces"]]


static func _resources_index(value: String) -> int:
	for i in range(RESOURCE_CHOICES.size()):
		if String(RESOURCE_CHOICES[i][0]) == value:
			return i
	return 0


func _on_resources_selected(i: int) -> void:
	if i >= 0 and i < RESOURCE_CHOICES.size():
		GPrefs.set_resources(String(RESOURCE_CHOICES[i][0]))


func _on_room_selected(i: int) -> void:
	if i >= 0 and i < ROOM_CHOICES.size():
		GPrefs.set_room_effects(String(ROOM_CHOICES[i][0]))


func _center_panel() -> void:
	"""Centre the panel on screen at its content size. set_anchors_preset() alone keeps the
	panel's old position as offsets, which left its top-left quarter (title, x and the G desk
	switch) off screen."""
	_panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER, Control.PRESET_MODE_MINSIZE)


func _label(text: String, size_name: String, color: Color) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", ThemeManager.get_font_size(size_name))
	l.add_theme_color_override("font_color", color)
	return l


func show_panel() -> void:
	if desk_toggle != null:
		desk_toggle.set_pressed_no_signal(GPrefs.desk())
	if room_picker != null:
		room_picker.select(_room_index(GPrefs.room_effects()))
	if typewriter_toggle != null:
		typewriter_toggle.set_pressed_no_signal(GPrefs.typewriter_sound())
	if motion_toggle != null:
		motion_toggle.set_pressed_no_signal(GPrefs.reduced_motion())
	if resources_picker != null:
		resources_picker.select(_resources_index(GPrefs.resources()))
	visible = true
	_center_panel()
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


func _on_typewriter_toggled(on: bool) -> void:
	GPrefs.set_typewriter_sound(on)


func _on_motion_toggled(on: bool) -> void:
	GPrefs.set_reduced_motion(on)

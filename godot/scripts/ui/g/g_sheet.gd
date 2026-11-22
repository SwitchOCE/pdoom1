class_name GSheet
extends Control
## Shared base for the three G sheets (fork/design/godot-g/spec.md 2.3-2.4, 6.2-6.4): Actions,
## the Plan drawer and Upgrades. The look is the theme's (phase 2a): the panel is a GPanel with
## the GSheetPanel ground (grime, hairline, corner ticks), the head is caps over a hairline.
##
## Each sheet is a full-rect Control that stays a child of GDesk/Sheets for its whole life
## (never freed while G is on, so the live nodes reparented into it are never freed with it).
## It holds its own input barrier under the panel, so it needs no _present_modal_dialog.
##
## ModalStack: the desk presents it with {"kind": <kind>, "close_mode": HIDE} and then calls
## show_panel(); closing is modal_stack.dismiss(self), which calls hide_panel() (spec 2.4).
## Standalone-safe Esc (A3): EscToClose and the x share one callback, _request_close(). The
## Esc helper listens only while the sheet is shown, so a closed sheet never takes Esc from
## anyone else.
##
## VIEW-ONLY: every button in a sheet runs today's handler; a sheet writes no game state and
## draws no random number (spec 7.4).

signal closed

const OPEN_SECONDS := 0.12
const OPEN_SHIFT := 8.0

## "g_actions" | "g_plan" | "g_upgrades" (ModalStack kind).
var kind: String = "g_sheet"
var host: Node = null           # MainUI, set by GDesk.setup (null standalone)
var desk: Node = null           # GDesk (null standalone)
var modal_stack = null          # host.modal_stack (null standalone)

var barrier: ColorRect
var panel: GPanel
var body: VBoxContainer
var header: HBoxContainer
var title_label: Label
var header_right: Label
var close_button: Button

var _tween: Tween
var _esc: EscToClose
var _panel_base_x := 0.0


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_build_base()
	_build()
	visible = false
	_esc = EscToClose.attach(self, _request_close)
	_esc.set_process_unhandled_input(false)


func setup(main_ui: Node, g_desk: Node) -> void:
	host = main_ui
	desk = g_desk
	modal_stack = main_ui.get("modal_stack") if main_ui != null else null


## Subclasses: the panel rect on the 1920x1080 canvas and its anchors (spec 3.2).
func _panel_layout() -> void:
	pass


## Subclasses: build the body.
func _build() -> void:
	pass


## Subclasses: redraw from the live UI (called on show and by the desk on updates).
func refresh() -> void:
	pass


func _build_base() -> void:
	barrier = ColorRect.new()
	barrier.name = "Barrier"
	barrier.color = Color(0.035, 0.031, 0.027, 0.5)   # `void` token at 50%
	barrier.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(barrier)
	barrier.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	barrier.gui_input.connect(_on_barrier_input)

	panel = GPanel.new()
	panel.name = "Panel"
	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	panel.theme_type_variation = &"GSheetPanel"
	add_child(panel)
	_panel_layout()
	var vb := VBoxContainer.new()
	vb.name = "VBox"
	vb.add_theme_constant_override("separation", 12)
	panel.add_child(vb)
	header = HBoxContainer.new()
	header.name = "Header"
	header.add_theme_constant_override("separation", 10)
	vb.add_child(header)
	title_label = GDesk.make_label("", "body", GDesk.C.muted, "GCaps")
	title_label.name = "Title"
	title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(title_label)
	header_right = GDesk.make_label("", "small", GDesk.C.muted)
	header_right.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	header.add_child(header_right)
	close_button = Button.new()
	close_button.name = "CloseX"
	close_button.text = "x"
	close_button.tooltip_text = "Close (Esc)"
	close_button.focus_mode = Control.FOCUS_NONE
	close_button.custom_minimum_size = Vector2(36, 32)
	GDesk.set_step(close_button, "body")
	close_button.theme_type_variation = &"GClose"
	GDesk.track_theme_ink(close_button)  # a thin glyph: lifted in the compact view
	close_button.pressed.connect(_request_close)
	header.add_child(close_button)
	var rule := ColorRect.new()
	rule.name = "HeadRule"
	rule.color = GDesk.C.frame
	rule.custom_minimum_size = Vector2(0, 1)
	rule.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vb.add_child(rule)
	body = VBoxContainer.new()
	body.name = "Body"
	body.add_theme_constant_override("separation", 10)
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vb.add_child(body)


func _anchor_left_column(x: float, w: float) -> void:
	"""L, T and B (spec 3.2): x..x+w, top 132, bottom 1004 on the 1920x1080 canvas."""
	panel.anchor_left = 0.0
	panel.anchor_right = 0.0
	panel.anchor_top = 0.0
	panel.anchor_bottom = 1.0
	panel.offset_left = x
	panel.offset_right = x + w
	panel.offset_top = 132
	panel.offset_bottom = -76


func _anchor_right_column(right_gap: float, w: float) -> void:
	"""R (offset from the right column), T and B: right edge at 1920 - right_gap."""
	panel.anchor_left = 1.0
	panel.anchor_right = 1.0
	panel.anchor_top = 0.0
	panel.anchor_bottom = 1.0
	panel.offset_right = -right_gap
	panel.offset_left = -right_gap - w
	panel.offset_top = 132
	panel.offset_bottom = -76


# --- show / hide (spec 2.4, 6.2) ----------------------------------------------------------

func is_open() -> bool:
	return visible


func show_panel() -> void:
	"""Shown at once and top from the first frame (it takes keys and clicks at once); the
	0.12 s fade and slide is display only, and Esc or its letter mid-open kills it. With
	reduced motion (spec 6.5) there is no fade: the sheet is there at once."""
	_kill_tween()
	visible = true
	barrier.mouse_filter = Control.MOUSE_FILTER_STOP
	if _esc != null:
		_esc.set_process_unhandled_input(true)
	refresh()
	_panel_base_x = panel.position.x
	focus_first()
	if GPrefs.reduced_motion():
		return   # spec 6.5: the sheet is simply there
	modulate.a = 0.0
	panel.position.x = _panel_base_x - OPEN_SHIFT
	_tween = create_tween()
	_tween.set_parallel(true)
	# Ease out (spec 6.2): a linear transition would ignore the ease.
	_tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	_tween.tween_property(self, "modulate:a", 1.0, OPEN_SECONDS)
	_tween.tween_property(panel, "position:x", _panel_base_x, OPEN_SECONDS)


func hide_panel() -> void:
	"""Immediate (V6): hidden, barrier off and keyboard focus released in the same call. No
	fade keeps a closed sheet visible, focusable or taking input."""
	var was_open := visible
	_kill_tween()
	visible = false
	barrier.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if _esc != null:
		_esc.set_process_unhandled_input(false)
	if is_inside_tree():
		var f := get_viewport().gui_get_focus_owner()
		if f != null and is_ancestor_of(f):
			get_viewport().gui_release_focus()
	if was_open:
		closed.emit()


func opening() -> bool:
	"""True while the open fade runs (tests: Esc mid-open)."""
	return _tween != null and _tween.is_valid() and _tween.is_running()


func _kill_tween() -> void:
	if _tween != null and _tween.is_valid():
		_tween.kill()
		panel.position.x = _panel_base_x
	_tween = null
	modulate.a = 1.0


func _request_close() -> void:
	if not visible:
		return
	if modal_stack != null and modal_stack.dismiss(self):
		return
	hide_panel()


func _on_barrier_input(ev: InputEvent) -> void:
	# A click on the dimmed desk behind the sheet closes the sheet, like its x.
	if ev is InputEventMouseButton and ev.pressed and ev.button_index == MOUSE_BUTTON_LEFT:
		_request_close()
		accept_event()


# --- focus (spec 2.4, V3) -------------------------------------------------------------------

func focusables() -> Array:
	var out: Array = []
	_gather_focus(panel, out)
	return out


func _gather_focus(n: Node, out: Array) -> void:
	for c in n.get_children():
		if c is Control:
			var cc := c as Control
			if not cc.visible:
				continue
			if cc.focus_mode != Control.FOCUS_NONE and cc is BaseButton:
				out.append(cc)
		_gather_focus(c, out)


func relink_focus() -> void:
	"""Tab stays inside the sheet: its first and last focusable controls point at each other."""
	var f := focusables()
	if f.size() < 2:
		if f.size() == 1:
			var only: Control = f[0]
			only.focus_next = only.get_path_to(only)
			only.focus_previous = only.get_path_to(only)
		return
	var first: Control = f[0]
	var last: Control = f[f.size() - 1]
	first.focus_previous = first.get_path_to(last)
	last.focus_next = last.get_path_to(first)


func focus_first() -> void:
	relink_focus()
	var f := focusables()
	if not f.is_empty() and is_visible_in_tree():
		(f[0] as Control).grab_focus()

class_name GAdvisorNote
extends PanelContainer
## The advisor note (spec 5.13): the cold open's hand-off on the G desk. A paper note beside
## the rail with a thin amber arrow to the ACTIONS plate. Not modal: Esc keeps opening the
## menu and Enter keeps committing; only its x closes it, and only for this session (the x
## does not change GameConfig). It also goes when main_ui clears the first-lever nudge
## (first use of the lever, or turn 3), through main_ui.first_lever_cleared.
##
## Without the hand-off the same note carries today's first-turns hint instead (classic's
## GettingStartedHint label, its text and its visibility read by GDesk): ADVISOR and the x
## only, no arrow and no pulse. The lever note wins whenever the first-lever hint is on.

signal dismissed

const PREFIX := "Advisor: "
const SUFFIX := " (the glowing button)."

## Set by the x for the rest of this session (a run restarted in the same session keeps it).
static var dismissed_this_session := false
## The same for the plain first-turns hint (its own x, its own flag).
static var plain_dismissed_this_session := false

var arrow_y: float = 28.0
## The arrow to the ACTIONS plate: the lever note only.
var show_arrow := true
var _body: Label
var _where: Label
var _rule: ColorRect
var close_button: Button


func _init() -> void:
	name = "AdvisorNote"
	mouse_filter = Control.MOUSE_FILTER_STOP
	var sb := GDesk.make_box(GDesk.C.paper, GDesk.C.paper_dark, 1, 2)
	sb.content_margin_left = 14
	sb.content_margin_right = 12
	sb.content_margin_top = 10
	sb.content_margin_bottom = 12
	add_theme_stylebox_override("panel", sb)
	var vb := VBoxContainer.new()
	vb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vb.add_theme_constant_override("separation", 8)
	add_child(vb)
	var head := HBoxContainer.new()
	head.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vb.add_child(head)
	# Faces only in 2a (spec 4.2: Courier Prime for all paper); the paper itself is 2b.
	var title := GDesk.make_label("ADVISOR", "small", GDesk.C.ink, "GCapsBold")
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_child(title)
	close_button = Button.new()
	close_button.name = "CloseX"
	close_button.text = "x"
	close_button.focus_mode = Control.FOCUS_NONE
	close_button.tooltip_text = "Hide this note"
	close_button.custom_minimum_size = Vector2(28, 24)
	close_button.add_theme_font_size_override("font_size", ThemeManager.get_font_size("small"))
	close_button.add_theme_color_override("font_color", GDesk.C.paper)
	close_button.add_theme_color_override("font_hover_color", Color.WHITE)
	var xb := GDesk.make_box(GDesk.C.ink, Color(0, 0, 0, 0), 1, 2)
	close_button.add_theme_stylebox_override("normal", xb)
	close_button.add_theme_stylebox_override("hover", xb)
	close_button.add_theme_stylebox_override("pressed", xb)
	close_button.pressed.connect(func(): dismissed.emit())
	head.add_child(close_button)
	_body = GDesk.make_label("", "body", GDesk.C.ink, "GType")
	_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_body.custom_minimum_size = Vector2(390, 0)
	vb.add_child(_body)
	_rule = ColorRect.new()
	_rule.color = Color(GDesk.C.ink, 0.35)
	_rule.custom_minimum_size = Vector2(0, 1)
	_rule.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vb.add_child(_rule)
	_where = GDesk.make_label("", "small", GDesk.C.ink, "GTypeBold")
	_where.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_where.custom_minimum_size = Vector2(390, 0)
	vb.add_child(_where)


func set_hint(hint_text: String, action_name: String) -> void:
	_body.text = display_case(trim_hint(hint_text))
	_where.text = where_line(action_name)
	_where.visible = _where.text != ""
	_rule.visible = _where.visible
	# Shrink back to the content when the where line goes (the plain first-turns note).
	reset_size()
	queue_redraw()


static func trim_hint(text: String) -> String:
	"""Exact string checks (spec 5.13): drop a leading "Advisor: " and a trailing
	" (the glowing button)." when present; anything else is kept as written."""
	var t := text
	if t.begins_with(PREFIX):
		t = t.substr(PREFIX.length())
	if t.ends_with(SUFFIX):
		t = t.substr(0, t.length() - SUFFIX.length())
	return t


static func display_case(text: String) -> String:
	"""After the "Advisor: " trim the game's line starts in lower case ("you do not know...");
	the note starts it with a capital, for display only. Nothing else changes."""
	if text == "":
		return text
	return text.substr(0, 1).to_upper() + text.substr(1)


static func where_line(action_name: String) -> String:
	if action_name.strip_edges() == "":
		return ""
	return "%s is in Actions, the glowing button." % action_name


func body_text() -> String:
	return _body.text


func where_text() -> String:
	return _where.text


func _draw() -> void:
	# The thin amber arrow from the note's left edge to the hinted plate (plain look: a line).
	if not show_arrow:
		return
	var tip := Vector2(-32, arrow_y)
	draw_line(Vector2(0, arrow_y), tip, GDesk.C.amber, 2.0, true)
	draw_line(tip, tip + Vector2(7, -5), GDesk.C.amber, 2.0, true)
	draw_line(tip, tip + Vector2(7, 5), GDesk.C.amber, 2.0, true)

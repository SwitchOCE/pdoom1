extends VBoxContainer
class_name ResearchQualitySelector
## Research Quality selector (Issue #500).
## Player picks the org-wide stance: Rushed / Standard / Thorough.
## Shows the speed-vs-safety trade-off as STATIC text. Live risk-pool values are
## insight-gated and belong on the Lab Ledger page, NOT here (see TWO_ACT_STRUCTURE.md, #528).

signal quality_selected(mode: String)

const MODES := ["rushed", "standard", "thorough"]
const LABELS := {"rushed": "Rushed", "standard": "Standard", "thorough": "Thorough"}

# Static copy -- no live numbers (those are hidden until insight unlocks them).
const TRADEOFFS := {
	"rushed":   "2.0x speed. Erodes research integrity, widens capability overhang.",
	"standard": "Baseline speed. No side effects.",
	"thorough": "0.5x speed. Repairs research integrity, narrows capability overhang.",
}
const ACTIVE_COLOR := Color(0.3, 0.8, 0.3)
const INACTIVE_COLOR := Color(0.7, 0.7, 0.7)

var _buttons := {}
var _tradeoff_label: Label
var _current_mode: String = "standard"
## G desk (fork/design/godot-g/spec.md 5.8, A4): while the selector sits in the G Plan drawer,
## skip the per-button font_color override (it outranks any theme variation) and use the
## GQualityButton type variation at ThemeManager's body size. Same buttons, same signal.
var g_style := false

func _ready():
	var title := Label.new()
	title.text = "Research Quality"
	add_child(title)

	var row := HBoxContainer.new()
	add_child(row)

	var group := ButtonGroup.new()
	for mode in MODES:
		var b := Button.new()
		b.text = LABELS[mode]
		b.toggle_mode = true
		b.button_group = group
		b.tooltip_text = TRADEOFFS[mode]
		b.pressed.connect(_on_mode_pressed.bind(mode))  # user click only; programmatic set fires 'toggled', not 'pressed'
		row.add_child(b)
		_buttons[mode] = b

	_tradeoff_label = Label.new()
	_tradeoff_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(_tradeoff_label)

	_set_active(_current_mode, false)

func _on_mode_pressed(mode: String):
	_set_active(mode, true)

func _set_active(mode: String, user_initiated: bool):
	if not _buttons.has(mode):
		return
	_current_mode = mode
	for m in MODES:
		_buttons[m].button_pressed = (m == mode)
		if not g_style:
			_buttons[m].add_theme_color_override("font_color", ACTIVE_COLOR if m == mode else INACTIVE_COLOR)
	_tradeoff_label.text = TRADEOFFS[mode]
	if user_initiated:
		quality_selected.emit(mode)

func update_from_state(state: Dictionary):
	"""Reflect the authoritative mode from the state dict. Emits no signal (no feedback loop)."""
	var mode: String = state.get("research_quality_mode", "standard")
	if mode != _current_mode:
		_set_active(mode, false)

func set_g_style(on: bool) -> void:
	"""Switch the G style on (in the G Plan drawer) or off (back in classic). Display only."""
	g_style = on
	for m in MODES:
		if not _buttons.has(m):
			continue
		var b: Button = _buttons[m]
		if on:
			b.remove_theme_color_override("font_color")
			b.theme_type_variation = &"GQualityButton"
			b.add_theme_font_size_override("font_size", ThemeManager.get_font_size("body"))
		else:
			b.theme_type_variation = &""
			b.remove_theme_font_size_override("font_size")
	_set_active(_current_mode, false)

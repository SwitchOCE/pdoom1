class_name GResourceCell
extends HBoxContainer
## One resource cell of the G top strip (fork/design/godot-g/spec.md 5.1.2, take a): a dark
## icon plate with the resource's tier icon, the caps label, the value, an optional "last turn"
## chip (EE-7, filled by GDesk), an optional tag, and for reputation the note "0 ends the run".
##
## One shown amount drives the cell (GTiers.shown_amount): the value text is today's
## GameConfig.format_money / format_scalar of the raw amount, exactly as the classic top bar
## prints it; the tier, the warn colour and the tag read the shown amount.
##
## A tier change crossfades the old icon into the new one (spec 6.2: two TextureRects, 0.25 s);
## with reduced motion it swaps at once. The tween belongs to this node, so it freezes under
## the pause menu like every G tween (spec 6.3).
##
## VIEW-ONLY: writes no game state, draws no random number, creates no timer.

const CROSSFADE_S := 0.25
const PLATE_LEAD := 40     # money's plate and icon (px on the 1920x1080 canvas)
const PLATE := 32          # every other resource
const NOTE_GAP := 12       # value -> rule -> note (spec 5.1.2)

## Reduced motion (spec 6.5): the swap is instant when GPrefs.reduced_motion() is on, or when
## this flag is set (tests). Static so every cell follows at once.
static var reduced_motion := false

var key: String = ""
var plate: PanelContainer
var cap: Label
var value: Label
var chip: Label = null
var tag_box: PanelContainer
var tag_label: Label
var note: Control = null
var note_zero: Label = null
var note_text: Label = null

## The tier shown now (-1 before the first amount), and the shown amount it came from.
var tier: int = -1
var shown: float = 0.0
var tag: Dictionary = {}

var _front: TextureRect   # the icon on screen
var _back: TextureRect    # the incoming icon during a crossfade
var _fade: Tween


func _init(resource_key: String = "", caps_text: String = "", with_chip: bool = false) -> void:
	key = resource_key
	name = "Cell_%s" % resource_key
	add_theme_constant_override("separation", 8)
	mouse_filter = Control.MOUSE_FILTER_PASS
	if resource_key == "":
		return
	var lead := resource_key == "money"
	var px := PLATE_LEAD if lead else PLATE
	plate = GDesk.make_panel("GTile")
	plate.name = "Plate"
	plate.custom_minimum_size = Vector2(px, px)
	plate.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	plate.mouse_filter = Control.MOUSE_FILTER_PASS
	add_child(plate)
	_front = _make_icon("Icon", px)
	_back = _make_icon("IconNext", px)
	_back.visible = false
	plate.add_child(_front)
	plate.add_child(_back)
	# Hierarchy (spec 4.4): caps `small` in `dim`; money's value at `header` (rank 2), the rest
	# at `label` (rank 3); every number in mono.
	cap = GDesk.make_label(caps_text, "small", GDesk.C.dim, "GCaps")
	cap.name = "Caps"
	cap.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	cap.mouse_filter = Control.MOUSE_FILTER_PASS
	add_child(cap)
	value = GDesk.make_label("--", "header" if lead else "label", GDesk.C.bone, "GMono")
	value.name = "Value"
	value.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	value.mouse_filter = Control.MOUSE_FILTER_PASS
	add_child(value)
	if with_chip:
		chip = GDesk.make_label("", "small", GDesk.C.bone, "GMono")
		chip.name = "Delta"
		chip.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		chip.mouse_filter = Control.MOUSE_FILTER_PASS
		chip.visible = false
		add_child(chip)
	tag_box = GDesk.make_keycap("")
	tag_box.name = "Tag"
	tag_box.theme_type_variation = &"GTag"
	tag_box.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	tag_box.mouse_filter = Control.MOUSE_FILTER_PASS
	tag_box.visible = false
	tag_label = tag_box.get_meta("label") as Label
	add_child(tag_box)
	if resource_key == "reputation":
		_build_note()


func _make_icon(n: String, px: int) -> TextureRect:
	var r := TextureRect.new()
	r.name = n
	r.custom_minimum_size = Vector2(px, px)
	r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	# Spec 11.2: in Godot 4 the filter is a CanvasItem property; 128 px art shown at 32-40 px
	# needs its mipmaps (the import generates them).
	r.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	r.mouse_filter = Control.MOUSE_FILTER_PASS
	return r


func _build_note() -> void:
	"""Reputation only (spec 5.1.2, A10): a 12 px gap and a 1 px rule after the value, then
	"0 ends the run" in `small` `muted`, the 0 bold in the lifted red `blood_text` (4.86:1 on
	the panel; `blood` itself is for lines only). True to the code: reputation <= 0 ends the
	run (game_state.gd)."""
	var m := MarginContainer.new()
	m.name = "Note"
	m.add_theme_constant_override("margin_left", NOTE_GAP - 8)   # 8 is the cell's separation
	m.mouse_filter = Control.MOUSE_FILTER_PASS
	m.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	add_child(m)
	var hb := HBoxContainer.new()
	hb.add_theme_constant_override("separation", NOTE_GAP)
	hb.mouse_filter = Control.MOUSE_FILTER_PASS
	m.add_child(hb)
	var rule := ColorRect.new()
	rule.name = "Rule"
	rule.color = GDesk.C.frame_hi
	rule.custom_minimum_size = Vector2(1, 20)
	rule.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	rule.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hb.add_child(rule)
	var words := HBoxContainer.new()
	words.add_theme_constant_override("separation", 5)
	words.mouse_filter = Control.MOUSE_FILTER_PASS
	hb.add_child(words)
	note_zero = GDesk.make_label("0", "small", GDesk.C.blood_text, "GMonoSemi")
	note_zero.name = "Zero"
	note_zero.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	note_zero.mouse_filter = Control.MOUSE_FILTER_PASS
	words.add_child(note_zero)
	note_text = GDesk.make_label("ends the run", "small", GDesk.C.muted)
	note_text.name = "Words"
	note_text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	note_text.mouse_filter = Control.MOUSE_FILTER_PASS
	words.add_child(note_text)
	note = m


# --- refresh -------------------------------------------------------------------------------

func set_amount(raw: float) -> void:
	"""Show a raw amount: today's text, and the tier, colour and tag of its shown amount."""
	value.text = GameConfig.format_money(raw) if key == "money" else GameConfig.format_scalar(raw)
	shown = GTiers.shown_amount(raw)
	# Warn colour reads the SHOWN amount (spec 5.1.2): "-0" never turns red.
	GDesk.set_ink(value, GDesk.C.warn if shown < 0.0 else GDesk.C.bone)
	_set_tag(GTiers.tag(key, shown))
	_set_tier(GTiers.tier(key, shown))


func _set_tag(t: Dictionary) -> void:
	tag = t
	if t.is_empty():
		tag_box.visible = false
		return
	tag_label.text = String(t.text)
	var colour: Color = GDesk.C.amber if String(t.tone) == "amber" else GDesk.C.warn
	GDesk.set_ink(tag_label, colour)
	# GTag's hairline is warn; the amber tag takes the same hairline in amber (not filled).
	if String(t.tone) == "amber":
		tag_box.add_theme_stylebox_override("panel", _amber_hairline())
	else:
		tag_box.remove_theme_stylebox_override("panel")
	tag_box.visible = true


static func _amber_hairline() -> StyleBoxFlat:
	"""theme/g_theme.tres GTag's box (1 px hairline, margins 6/1, radius 2), in amber."""
	var sb := GDesk.make_box(Color(0, 0, 0, 0), GDesk.C.amber, 1, 2)
	sb.content_margin_left = 6
	sb.content_margin_right = 6
	sb.content_margin_top = 1
	sb.content_margin_bottom = 1
	sb.anti_aliasing = false
	return sb


func _set_tier(t: int) -> void:
	if t == tier:
		return
	var first := tier < 0
	tier = t
	var tex := load(GTiers.icon_path(key, t)) as Texture2D
	if _fade != null and _fade.is_valid():
		_fade.kill()
		_settle()
	if first or reduced_motion or GPrefs.reduced_motion() or not is_inside_tree():
		_front.texture = tex
		_front.modulate.a = 1.0
		_back.visible = false
		return
	# Crossfade (spec 6.2): the new icon fades in over the old one, the old fades out.
	_back.texture = tex
	_back.modulate.a = 0.0
	_back.visible = true
	_fade = create_tween().set_parallel(true)
	_fade.tween_property(_back, "modulate:a", 1.0, CROSSFADE_S)
	_fade.tween_property(_front, "modulate:a", 0.0, CROSSFADE_S)
	_fade.chain().tween_callback(_settle)


func _settle() -> void:
	"""End of a crossfade (or one cut short): the incoming icon becomes the front one."""
	if _back.visible:
		_front.texture = _back.texture
	_front.modulate.a = 1.0
	_back.visible = false
	_back.modulate.a = 0.0


func icon_texture() -> Texture2D:
	"""The texture the cell settles on (the incoming one during a crossfade)."""
	return _back.texture if _back.visible else _front.texture


func is_fading() -> bool:
	return _fade != null and _fade.is_valid() and _fade.is_running()


func icon_rects() -> Array:
	return [_front, _back]

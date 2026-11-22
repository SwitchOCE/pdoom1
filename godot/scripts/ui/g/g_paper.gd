class_name GPaper
extends RefCounted
## G's paper (fork/design/godot-g/spec.md 4.3, 5.11, 5.12, 5.13): the one light thing on the
## desk. A styling helper, static, for today's panels -- the event dialog, the month review
## and the advisor note -- never a second copy of them:
##   * the paper itself: a StyleBoxTexture 9-slice of assets/textures/g/paper_sheet.png
##     (1024x1024, margins 64; the middle stretches, as G's seam check chose), with a flat
##     paper fill as the fallback when the file is missing;
##   * ink: near-black text, Courier Prime for the typed words, Barlow Condensed caps for the
##     small heads. Paper labels at `small` are bold, paper keycaps are inverted (ink tile,
##     paper letter) (spec 4.5);
##   * the event paper (5.11): today's EventDialog builds the panel, its buttons, their keys,
##     the queue and the priority exactly as today; when the layout is g it asks this helper
##     for the paper, the heading, the stamp, the option rows and the footer. Every button is
##     still today's Button, in today's order, with today's disabled state, tooltip and press.
##
## Both dialogs are mounted on get_tree().root, outside GDesk, so the paper sets
## theme/g_theme.tres on the panel itself (A7). Sizes come from ThemeManager (GDesk.set_step),
## never a literal. Display only: writes no game state, draws no random number, no timers.

const PAPER_PATH := "res://assets/textures/g/paper_sheet.png"
## The 9-slice margin of the paper texture (spec 11.2).
const MARGIN := 64
## A short note (the advisor) is under 2 x 64 px tall, so it slices the same sheet at 40.
const NOTE_MARGIN := 40

## The event paper: width and top on the 1920x1080 canvas (spec 3.2; the review's top, 5.12).
const EVENT_WIDTH := 702.0   # spec 3.2: centred, top 132, 702 wide, height by content
const TOP := 132.0
## Space kept free under a paper (the bottom strip).
const BOTTOM_GAP := 88.0

## The event's heading and stamp (spec 5.11; mock-up words).
const EVENT_HEADING := "ACROSS YOUR DESK"
const STAMP_TEXT := "NEEDS A REPLY"
## The review's door shows its key as a keycap (spec 5.12); Space is today's key for it.
const DOOR_KEYCAP := "Space"

## Ink on paper. `ink` and `ink_soft` are G's tokens; the alert ink is the reason line's
## (a dark red that keeps 4.5:1 on the darker bottom of the sheet).
const INK_ALERT := Color("#5c140c")

## The arrival (spec 6.2 "Event paper arrives", "Month review arrives"): modulate.a 0 -> 1 and
## y +12 -> 0 over 0.2 s, display only; the dialog's buttons are live from the first frame.
const ARRIVE_SECONDS := 0.2
const ARRIVE_SHIFT := 12.0
const META_BASE_Y := "g_base_y"
const META_SLIDE := "g_slide"

static var _paper_tex: Texture2D = null


# --- the paper -------------------------------------------------------------------------

static func texture() -> Texture2D:
	if _paper_tex == null and ResourceLoader.exists(PAPER_PATH):
		_paper_tex = load(PAPER_PATH)
	return _paper_tex


static func paper_style(margin: int = MARGIN) -> StyleBox:
	"""The paper 9-slice (or, without the file, a flat paper fill in the same place)."""
	var tex := texture()
	if tex == null:
		var flat := GDesk.make_box(GDesk.C.paper, GDesk.C.paper_dark, 1, 2)
		return flat
	var sb := StyleBoxTexture.new()
	sb.texture = tex
	sb.texture_margin_left = margin
	sb.texture_margin_top = margin
	sb.texture_margin_right = margin
	sb.texture_margin_bottom = margin
	sb.axis_stretch_horizontal = StyleBoxTexture.AXIS_STRETCH_MODE_STRETCH
	sb.axis_stretch_vertical = StyleBoxTexture.AXIS_STRETCH_MODE_STRETCH
	return sb


static func g_theme() -> Theme:
	return load(GDesk.THEME_PATH) as Theme


static func skin(panel: Control, margin: int = MARGIN) -> void:
	"""Paper on a panel that lives outside the desk: G's theme on the panel itself (A7) and
	the paper 9-slice as its "panel" stylebox."""
	panel.theme = g_theme()
	panel.add_theme_stylebox_override("panel", paper_style(margin))
	panel.set_meta("g_paper", true)


static func ink_label(text: String, size_name: String, face: String = "GType",
		colour: Color = GDesk.C.ink) -> Label:
	"""Typed ink. A `small` label on paper is bold (spec 4.5) and takes the next size step in
	the compact view (720p), where a colour lift cannot help dark ink."""
	var l := GDesk.make_label(text, size_name, colour, face)
	if size_name == "small":
		if face == "GType":
			l.theme_type_variation = &"GTypeBold"
		GDesk.compact_step_up(l)
	return l


static func ink_keycap(text: String) -> PanelContainer:
	"""A paper keycap, inverted (spec 4.5): an ink tile with the letter in paper."""
	var kc := PanelContainer.new()
	kc.name = "Keycap"
	kc.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sb := GDesk.make_box(GDesk.C.ink, Color(0, 0, 0, 0), 1, 2)
	sb.content_margin_left = 7
	sb.content_margin_right = 7
	sb.content_margin_top = 2
	sb.content_margin_bottom = 2
	kc.add_theme_stylebox_override("panel", sb)
	var l := GDesk.make_label(text, "small", GDesk.C.paper, "GMonoSemi")
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	GDesk.compact_step_up(l)
	kc.add_child(l)
	kc.set_meta("label", l)
	return kc


static func ink_rule(alpha: float = 0.55, height: int = 1) -> ColorRect:
	var r := ColorRect.new()
	r.color = Color(GDesk.C.ink, alpha)
	r.custom_minimum_size = Vector2(0, height)
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return r


static func autosize(dialog: Control, content: Control, width: float, viewport_size: Vector2,
		top: float = TOP) -> void:
	"""Size a Panel (not a container) to its content: `content` spans the panel's width and is
	as tall as its minimum, and the panel follows it. Centred across, at `top` (moved up only
	when a tall paper would run into the bottom strip)."""
	var w := minf(width, viewport_size.x - 40.0)
	dialog.custom_minimum_size = Vector2(w, 0)
	dialog.size = Vector2(w, dialog.size.y)
	dialog.position.x = roundf((viewport_size.x - w) / 2.0)
	dialog.position.y = top
	content.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	var fit := func() -> void:
		if not is_instance_valid(dialog) or not is_instance_valid(content):
			return
		var h := content.get_combined_minimum_size().y
		dialog.custom_minimum_size.y = h
		dialog.size.y = h
		var room := viewport_size.y - BOTTOM_GAP - h
		var y := clampf(minf(top, room), 20.0, top)
		# The arrival slide (arrive) is an offset on top of the resting place, so a content
		# resize mid-slide moves the resting place without cutting the slide short.
		dialog.set_meta(META_BASE_Y, y)
		dialog.position.y = y + float(dialog.get_meta(META_SLIDE, 0.0))
	content.minimum_size_changed.connect(fit)
	content.resized.connect(fit)
	dialog.set_meta("g_fit", fit)
	fit.call()


static func padded(dialog: Control, left: int, top: int, right: int, bottom: int,
		sep: int) -> Array:
	"""A MarginContainer on the paper (the margins keep text off the burnt edges) with a
	VBoxContainer in it: [margin, vbox]."""
	var m := MarginContainer.new()
	m.name = "PaperMargin"
	m.mouse_filter = Control.MOUSE_FILTER_IGNORE
	m.add_theme_constant_override("margin_left", left)
	m.add_theme_constant_override("margin_right", right)
	m.add_theme_constant_override("margin_top", top)
	m.add_theme_constant_override("margin_bottom", bottom)
	dialog.add_child(m)
	var vb := VBoxContainer.new()
	vb.name = "Paper"
	vb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vb.add_theme_constant_override("separation", sep)
	m.add_child(vb)
	return [m, vb]


# --- the arrival (spec 6.2) ------------------------------------------------------------

static func arrive(dialog: Control) -> Tween:
	"""Fade and slide a paper in as it lands. The tween is created on the dialog itself, so it
	is pausable like the dialog (spec 6.3) and dies with it when an answer frees the dialog
	mid-fade. Input is untouched: modulate and an offset change neither the buttons nor the
	blocker. Reduced motion (6.5), or a dialog not in the tree: no tween, it is simply there.
	Returns the tween (null when instant)."""
	if dialog == null or not is_instance_valid(dialog):
		return null
	var running = (dialog.get_meta("g_arrive") if dialog.has_meta("g_arrive") else null)
	if running is Tween and (running as Tween).is_valid():
		(running as Tween).kill()
	_set_slide(0.0, dialog)
	dialog.modulate.a = 1.0
	if GPrefs.reduced_motion() or not dialog.is_inside_tree():
		if dialog.has_meta("g_arrive"):
			dialog.remove_meta("g_arrive")
		return null
	dialog.modulate.a = 0.0
	_set_slide(ARRIVE_SHIFT, dialog)
	var t := dialog.create_tween().set_parallel(true)
	t.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	t.tween_property(dialog, "modulate:a", 1.0, ARRIVE_SECONDS)
	t.tween_method(_set_slide.bind(dialog), ARRIVE_SHIFT, 0.0, ARRIVE_SECONDS)
	dialog.set_meta("g_arrive", t)
	return t


static func _set_slide(v: float, dialog: Control) -> void:
	if not is_instance_valid(dialog):
		return
	var base := float(dialog.get_meta(META_BASE_Y, dialog.position.y - float(dialog.get_meta(META_SLIDE, 0.0))))
	dialog.set_meta(META_SLIDE, v)
	dialog.position.y = base + v


static func arriving(dialog: Control) -> bool:
	"""True while a paper's arrival runs (tests)."""
	if dialog == null or not is_instance_valid(dialog):
		return false
	var t = (dialog.get_meta("g_arrive") if dialog.has_meta("g_arrive") else null)
	return t is Tween and (t as Tween).is_valid() and (t as Tween).is_running()


# --- the event paper (spec 5.11) -------------------------------------------------------

static func build_event(dialog: Panel, event: Dictionary, viewport_size: Vector2) -> VBoxContainer:
	"""The paper, its heading and stamp, the event's name and words. Returns the container
	today's presenter puts the option buttons and the reason line into (as the classic path
	returns its main_vbox)."""
	skin(dialog)
	dialog.name = "GEventPaper"
	# Bottom 66: the last line sits above the sheet's 64 px bottom band, which the picture
	# darkens toward its scorched edge (ink there falls under 4.5, spec 4.3/4.5).
	var parts := padded(dialog, 44, 36, 44, 66, 10)
	var m: MarginContainer = parts[0]
	var vb: VBoxContainer = parts[1]

	var head := HBoxContainer.new()
	head.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vb.add_child(head)
	var heading := ink_label(EVENT_HEADING, "small", "GCapsBold")
	heading.name = "Heading"
	heading.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	heading.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	head.add_child(heading)
	if not EventDialog.is_navigation_popup(event):
		# Every event this dialog shows waits for its answer (#452); a one-option free door
		# is not a question, so it carries no stamp.
		head.add_child(stamp(STAMP_TEXT))

	var title := ink_label(String(event.get("name", "Event")), "label", "GTypeBold")
	title.name = "Title"
	title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vb.add_child(title)
	var desc := ink_label(String(event.get("description", "An event has occurred!")), "body")
	desc.name = "Description"
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vb.add_child(desc)
	var gap := Control.new()
	gap.custom_minimum_size = Vector2(0, 4)
	gap.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vb.add_child(gap)
	autosize(dialog, m, EVENT_WIDTH, viewport_size)
	return vb


static func stamp(text: String) -> PanelContainer:
	"""An ink rubber stamp: a 2 px ink frame round bold caps."""
	var p := PanelContainer.new()
	p.name = "Stamp"
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sb := GDesk.make_box(Color(0, 0, 0, 0), GDesk.C.ink, 2, 1)
	sb.content_margin_left = 5
	sb.content_margin_right = 5
	sb.content_margin_top = 3   # clear of the 2 px frame
	sb.content_margin_bottom = 3
	p.add_theme_stylebox_override("panel", sb)
	var l := ink_label(text, "small", "GCapsBold")
	# A little paper round the caps inside the frame, so the bold caps do not fill their own box.
	var air := StyleBoxEmpty.new()
	air.content_margin_left = 3
	air.content_margin_right = 3
	air.content_margin_top = 1
	air.content_margin_bottom = 1
	l.add_theme_stylebox_override("normal", air)
	p.add_child(l)
	p.set_meta("label", l)
	return p


static func shown_cost(summary: String) -> String:
	"""Today's cost summary without its brackets: " ($500, 1 Attention)" -> "$500, 1 Attention",
	" (Free)" -> "Free". The words are today's (EventDialog.format_cost_summary)."""
	var s := summary.strip_edges()
	if s.begins_with("(") and s.ends_with(")"):
		s = s.substr(1, s.length() - 2)
	return s


static func row_box(bg: Color, border: Color, width: int) -> StyleBoxFlat:
	var sb := GDesk.make_box(bg, border, width, 2)
	sb.content_margin_left = 0
	sb.content_margin_right = 0
	sb.content_margin_top = 0
	sb.content_margin_bottom = 0
	return sb


static func style_option(btn: Button, index: int, choice_text: String, cost_summary: String) -> void:
	"""Today's option button as a paper row: the key tile (DialogKeys.label_for, the key MainUI
	routes), the option's text and its cost in bold ink. Same Button, same press, same tooltip;
	a disabled option keeps its ink and is drawn dashed (G never fades text)."""
	btn.set_meta("g_text", btn.text)       # today's face, kept for anyone who reads it
	btn.text = ""
	btn.modulate = Color.WHITE
	btn.custom_minimum_size = Vector2(0, 52)
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var normal := row_box(Color(GDesk.C.ink, 0.04), Color(GDesk.C.ink, 0.45), 1)
	var hover := row_box(Color(GDesk.C.ink, 0.10), GDesk.C.ink, 2)
	var disabled := row_box(Color(GDesk.C.ink, 0.10), Color(0, 0, 0, 0), 1)
	for st in ["normal", "focus"]:
		btn.add_theme_stylebox_override(st, normal)
	for st in ["hover", "pressed", "hover_pressed"]:
		btn.add_theme_stylebox_override(st, hover)
	btn.add_theme_stylebox_override("disabled", disabled)
	btn.draw.connect(func() -> void:
		if btn.disabled:
			GDesk.draw_dashed_rect(btn, Rect2(Vector2.ZERO, btn.size), Color(GDesk.C.ink, 0.6)))

	var m := MarginContainer.new()
	m.name = "Row"
	m.mouse_filter = Control.MOUSE_FILTER_IGNORE
	m.add_theme_constant_override("margin_left", 12)
	m.add_theme_constant_override("margin_right", 14)
	m.add_theme_constant_override("margin_top", 8)
	m.add_theme_constant_override("margin_bottom", 8)
	btn.add_child(m)
	m.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var hb := HBoxContainer.new()
	hb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hb.add_theme_constant_override("separation", 14)
	m.add_child(hb)
	var kc := ink_keycap(DialogKeys.label_for(index))
	kc.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	kc.custom_minimum_size = Vector2(30, 0)
	hb.add_child(kc)
	var t := ink_label(choice_text, "body", "GTypeBold")
	t.name = "OptionText"
	t.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	t.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	t.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hb.add_child(t)
	var c := ink_label(shown_cost(cost_summary), "small", "GTypeBold")
	c.name = "Cost"
	c.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	c.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	c.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	hb.add_child(c)
	_follow_content_height(btn, m, 52.0)


static func style_door(btn: Button, choice_text: String) -> void:
	"""A one-option free door (the month review's "Begin planning <Month>"): a dark ink button
	with an amber ring, its words in paper and its key as a keycap, `Space` (spec 5.12). No
	Enter (10.4). Same Button, same press; Space still works through today's meta."""
	btn.set_meta("g_text", btn.text)
	btn.text = ""
	btn.modulate = Color.WHITE
	btn.custom_minimum_size = Vector2(0, 54)
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var normal := row_box(GDesk.C.ink, GDesk.C.amber_line, 1)
	var hover := row_box(GDesk.C.ink_soft, GDesk.C.amber, 2)
	for st in ["normal", "focus", "disabled"]:
		btn.add_theme_stylebox_override(st, normal)
	for st in ["hover", "pressed", "hover_pressed"]:
		btn.add_theme_stylebox_override(st, hover)
	var m := MarginContainer.new()
	m.name = "Row"
	m.mouse_filter = Control.MOUSE_FILTER_IGNORE
	m.add_theme_constant_override("margin_left", 18)
	m.add_theme_constant_override("margin_right", 12)
	m.add_theme_constant_override("margin_top", 10)
	m.add_theme_constant_override("margin_bottom", 10)
	btn.add_child(m)
	m.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var hb := HBoxContainer.new()
	hb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hb.add_theme_constant_override("separation", 12)
	m.add_child(hb)
	var t := GDesk.make_label(choice_text, "body", GDesk.C.paper, "GCapsBold")
	t.name = "DoorText"
	t.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	t.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hb.add_child(t)
	var kc := GDesk.make_keycap(DOOR_KEYCAP)
	kc.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	hb.add_child(kc)
	_follow_content_height(btn, m, 54.0)


static func _follow_content_height(btn: Button, content: Control, floor_h: float) -> void:
	"""Children do not size a Button: follow the content's height (a wrapped option grows)."""
	var follow := func() -> void:
		if is_instance_valid(btn) and is_instance_valid(content):
			btn.custom_minimum_size.y = maxf(floor_h, content.get_combined_minimum_size().y)
	content.minimum_size_changed.connect(follow)
	follow.call()


static func style_reason(label: Label) -> void:
	"""Today's rejection line (shown in place when a choice is refused), in alert ink."""
	label.theme_type_variation = &"GTypeBold"
	GDesk.set_step(label, "body")
	GDesk.set_ink(label, INK_ALERT)


static func add_event_footer(vb: VBoxContainer, state: Dictionary, host: Node) -> void:
	"""Footer (spec 5.11, 5.5): the money in hand and, once the month plays, the hours still
	held for events -- the same reading the Attention card's WATCH face shows."""
	var hb := HBoxContainer.new()
	hb.name = "Footer"
	hb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vb.add_child(ink_rule(0.35))
	vb.add_child(hb)
	var money := ink_label("in hand %s" % GameConfig.format_money(float(state.get("money", 0.0))),
		"small", "GType")
	money.name = "InHand"
	money.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hb.add_child(money)
	var held := held_hours(host)
	if held >= 0:
		var h := ink_label("held for events %d hr" % held, "small", "GType")
		h.name = "HeldForEvents"
		h.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		hb.add_child(h)


static func held_hours(host: Node) -> int:
	"""The desk's held hours while the month plays; -1 in the plan phase or without a desk."""
	if host == null or not host.has_method("get_g_desk"):
		return -1
	var desk = host.get_g_desk()
	if desk == null or not is_instance_valid(desk):
		return -1
	if String(host.get("current_turn_phase")).to_upper() == "ACTION_SELECTION":
		return -1
	return int(desk.held_now())

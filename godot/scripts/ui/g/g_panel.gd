class_name GPanel
extends PanelContainer
## A G panel (fork/design/godot-g/spec.md 4.3). The ground is the theme's `GPanel` stylebox
## (theme/g_theme.tres): a 9-slice of the script-made grime texture with the soot baked in.
## Over it, in this panel's own _draw (so one panel, not two stacked containers), the theme's
## `frame` stylebox (the 1 px `frame` hairline) and four brass corner ticks, 12x2 + 2x12 each.
## _draw runs after the panel's stylebox and before its children, so the hairline and the ticks
## sit on the ground and under the text.
##
## Subclasses (the P(Doom) and Attention cards, the feed) and the sheets use it; a caller that
## needs a different frame (the P(Doom) card's band colour) sets `frame_override`.
##
## Display only: draws, never writes game state, draws no random number.

const TICK_LEN := 12.0
const TICK_W := 2.0

## Draw the four corner ticks (spec 4.3). Off for panels that sit flush with a strip.
var ticks := true
## A frame to draw instead of the theme's hairline (null = the theme's `frame`).
var frame_override: StyleBox = null


func _init() -> void:
	theme_type_variation = &"GPanel"


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED or what == NOTIFICATION_THEME_CHANGED:
		queue_redraw()


func _draw() -> void:
	var r := Rect2(Vector2.ZERO, size)
	var fr: StyleBox = frame_override
	if fr == null and has_theme_stylebox(&"frame"):
		fr = get_theme_stylebox(&"frame")
	if fr != null:
		fr.draw(get_canvas_item(), r)
	if ticks:
		draw_ticks(self, r, GDesk.C.tick)


static func draw_ticks(ci: CanvasItem, r: Rect2, colour: Color) -> void:
	"""Four L-shaped brass ticks on the corners of `r` (the mock-up's .cn corners)."""
	var x0 := r.position.x
	var y0 := r.position.y
	var x1 := r.end.x
	var y1 := r.end.y
	for rect in [
			Rect2(x0, y0, TICK_LEN, TICK_W), Rect2(x0, y0, TICK_W, TICK_LEN),
			Rect2(x1 - TICK_LEN, y0, TICK_LEN, TICK_W), Rect2(x1 - TICK_W, y0, TICK_W, TICK_LEN),
			Rect2(x0, y1 - TICK_W, TICK_LEN, TICK_W), Rect2(x0, y1 - TICK_LEN, TICK_W, TICK_LEN),
			Rect2(x1 - TICK_LEN, y1 - TICK_W, TICK_LEN, TICK_W), Rect2(x1 - TICK_W, y1 - TICK_LEN, TICK_W, TICK_LEN)]:
		ci.draw_rect(rect, colour)


# --- today's modal panels in the G look (spec 5.7.4, 5.9.3; phase 2b) ----------------------
# The door submenus and the ledger are today's panels, built by today's code with today's
# rows, keys and handlers. In G they only change their look: the G panel ground, hairline and
# ticks; G's theme (faces); G's close x and "[ESC] close" hint; G buttons (a disabled control is
# hatched with a dashed edge and keeps its text colour, never faded, spec 4.3); and any text
# sitting on the panel lifted, keeping its hue, until it reaches 4.5:1 on the panel (spec 4.5).
# Text on a card of its own (a nested panel with its own stylebox) is left as today's. No
# sizes change, except the close x, which takes G's close-x size (body). In the compact view
# (720p) the lifted text follows GDesk's compact lift (toward bone), as G's own small text
# does. Today's 10-11 px grid names and costs keep their size (stepping them up at 720p
# pushes the grid out of today's fixed-size panel) and take G's medium sans.

const SKIN_TARGET := 4.8


static func skin_modal(dialog: Control) -> void:
	"""Give today's modal panel the G look. Idempotent; display only."""
	if dialog == null or not is_instance_valid(dialog) or dialog.has_meta("g_skinned"):
		return
	dialog.set_meta("g_skinned", true)
	var th: Theme = load(GDesk.THEME_PATH)
	dialog.theme = th
	dialog.add_theme_stylebox_override("panel", th.get_stylebox(&"panel", &"GPanel"))
	var frame: StyleBox = th.get_stylebox(&"frame", &"GPanel")
	dialog.draw.connect(func() -> void:
		var r := Rect2(Vector2.ZERO, dialog.size)
		if frame != null:
			frame.draw(dialog.get_canvas_item(), r)
		draw_ticks(dialog, r, GDesk.C.tick))
	dialog.queue_redraw()
	_skin_children(dialog, dialog)


static func _skin_children(dialog: Control, n: Node) -> void:
	for ch in n.get_children():
		if ch is Control:
			_skin_control(dialog, ch as Control)
		_skin_children(dialog, ch)


static func _on_own_card(dialog: Control, c: Control) -> bool:
	"""True when something between `c` and the dialog draws its own ground (a nested card)."""
	var p := c.get_parent()
	while p != null and p != dialog:
		if (p is PanelContainer or p is Panel) and (p as Control).has_theme_stylebox_override("panel"):
			return true
		p = p.get_parent()
	return false


static func _skin_control(dialog: Control, c: Control) -> void:
	if c is Button:
		var b := c as Button
		if b.get_parent() == dialog and b.tooltip_text == "Close (ESC)":
			# The close x from SubmenuChrome.add_close_affordance: G's close button.
			for st in ["normal", "hover", "pressed", "focus", "disabled"]:
				b.remove_theme_stylebox_override(StringName(st))
			b.theme_type_variation = &"GClose"
			b.text = "x"
			GDesk.set_step(b, "body")   # as G's own close x (GSheet): a thin glyph needs the size
			GDesk.track_theme_ink(b)    # and is lifted in the compact view (720p)
			return
		if _on_own_card(dialog, b):
			return
		if not b.has_theme_stylebox_override("normal"):
			# A plain button of today's (the grid choices, the list rows): G's button, so a
			# disabled one is the hatch with a dashed edge instead of a 50% fade.
			b.theme_type_variation = &"GButton"
			GDesk.hook_dashed_edge(b)
			if b.disabled and b.modulate == Color(0.5, 0.5, 0.5):
				b.modulate = Color.WHITE
		_lift(b, "font_color", true)
		return
	if c is Label:
		var l := c as Label
		if _on_own_card(dialog, l):
			return
		if l.modulate != Color.WHITE and l.modulate.a >= 1.0:
			# Today's "unaffordable" fade on a cost line: G keeps the text and inks it dim.
			l.modulate = Color.WHITE
			if l.has_theme_color_override(&"font_color"):
				GDesk.set_ink(l, GDesk.C.dim)
		if l.get_parent() == dialog and l.text == "[ESC] close":
			l.theme_type_variation = &"GMono"
			l.set_meta("g_lift", true)
			GDesk.set_ink(l, GDesk.C.muted)
			return
		if l.theme_type_variation == &"" \
				and l.get_theme_font_size(&"font_size") < ThemeManager.get_font_size("small"):
			# Today's 10-11 px grid names and costs keep their size (a step up pushes the grid out
			# of today's fixed-size panel) but take G's medium sans, so they stay legible at 720p.
			l.theme_type_variation = &"GSansMed"
		_lift(l, "font_color", false)


static func _lift(c: Control, prop: String, button: bool) -> void:
	"""Lift an overridden text colour (keeping its hue) to SKIN_TARGET on the panel. A colour
	with alpha is made opaque first (on the dark panel it would only lose contrast)."""
	if not c.has_theme_color_override(StringName(prop)):
		if button:
			GDesk.track_theme_ink(c)
		return
	var col: Color = c.get_theme_color(StringName(prop))
	var solid := Color(col, 1.0)
	if col.a < 1.0:
		solid = GDesk.C.panel_solid.lerp(Color(col, 1.0), col.a)
	if GDesk.contrast_ratio(solid, GDesk.C.panel_solid) < SKIN_TARGET:
		solid = GDesk.lift_to(solid, GDesk.C.panel_solid, SKIN_TARGET)
	# In the compact view (720p) today's thin text is lifted further, as G's own small text.
	c.set_meta("g_lift", true)
	GDesk.set_ink(c, solid, prop)

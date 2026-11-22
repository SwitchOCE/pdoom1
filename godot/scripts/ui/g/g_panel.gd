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

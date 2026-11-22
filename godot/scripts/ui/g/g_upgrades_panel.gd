class_name GUpgradesPanel
extends GSheet
## The Upgrades sheet (fork/design/godot-g/spec.md 5.9.1), plain look.
##
## Body: today's upgrades label and scroll, reparented into body_slot by LayoutController
## (spec 2.2 step 4). main_ui._populate_upgrades() keeps filling that list on every update, so
## content, prices, affordability and clicks are today's; when the layout is g it builds each
## row on G's own path (A4), with the same text, disabled state, tooltip and handler.

var body_slot: VBoxContainer
var _empty_note: Label


func _init() -> void:
	kind = "g_upgrades"
	name = "GUpgradesPanel"


func _panel_layout() -> void:
	_anchor_left_column(280, 600)


func _build() -> void:
	title_label.text = "UPGRADES"
	header_right.text = "bought once, kept for the run"
	body_slot = VBoxContainer.new()
	body_slot.name = "BodySlot"
	body_slot.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body_slot.add_theme_constant_override("separation", 8)
	body.add_child(body_slot)
	_empty_note = GDesk.make_label("No upgrades to show.", "small", GDesk.C.muted)
	body_slot.add_child(_empty_note)
	body_slot.child_entered_tree.connect(_on_slot_child_entered)
	body_slot.child_exiting_tree.connect(_on_slot_child_exiting)


func _on_slot_child_entered(n: Node) -> void:
	"""Today's "Upgrades:" label, while it sits in G's sheet, takes G's text colour (and the
	compact view's lift); its own colour comes back when LayoutController moves it home."""
	if not (n is Label) or n == _empty_note:
		return
	var l := n as Label
	if not l.has_meta("g_prev_ink"):
		l.set_meta("g_prev_ink", l.get_theme_color(&"font_color"))
	l.set_meta("g_lift", true)
	GDesk.set_step(l, "body")
	GDesk.set_ink(l, GDesk.C.muted)


func _on_slot_child_exiting(n: Node) -> void:
	if not (n is Label) or not n.has_meta("g_prev_ink"):
		return
	var l := n as Label
	l.add_theme_color_override(&"font_color", l.get_meta("g_prev_ink"))
	l.remove_theme_font_size_override(&"font_size")
	for m in ["g_prev_ink", "g_ink", "g_lift", "g_size"]:
		l.remove_meta(m)


func refresh() -> void:
	# The live list arrives by reparent; the note shows only when nothing was moved in.
	_empty_note.visible = body_slot.get_child_count() <= 1
	relink_focus()

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


func refresh() -> void:
	# The live list arrives by reparent; the note shows only when nothing was moved in.
	_empty_note.visible = body_slot.get_child_count() <= 1
	relink_focus()

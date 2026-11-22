extends Control
## Player Guide - Tutorial and help information

## G desk (fork/design/godot-g/spec.md 5.9.4): the guide can open as an overlay over a live
## run instead of as its own scene. In embedded mode Back closes the overlay through the
## modal stack (no scene change, so the run is untouched), and Esc is left to ModalStack
## like any other modal. The default (false) is today's standalone screen, unchanged.
var embedded: bool = false
var modal_stack = null  # ModalStack (untyped, as in MainUI) -- set by the G desk when embedded

func _ready():
	print("[PlayerGuide] Guide displayed")
	if embedded:
		var back := get_node_or_null("Panel/VBox/ButtonRow/BackButton") as Button
		if back != null:
			back.text = "Back to Game"

func _on_back_pressed():
	"""Return to welcome screen (standalone) or close the overlay (embedded)"""
	if embedded:
		if modal_stack != null:
			modal_stack.dismiss(self)
		if is_inside_tree() and not is_queued_for_deletion():
			queue_free()
		return
	print("[PlayerGuide] Returning to welcome screen")
	SceneTransition.go_to("res://scenes/welcome.tscn")

func _input(event: InputEvent):
	"""Handle keyboard shortcuts"""
	if embedded:
		return  # Esc reaches MainUI -> ModalStack, which closes the top modal (spec 6.4)
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE:
			_on_back_pressed()

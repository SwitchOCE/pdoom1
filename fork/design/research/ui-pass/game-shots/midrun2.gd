extends SceneTree
var out := ""
var pending_buttons: Array = []
func _initialize():
	call_deferred("_run")
func _shot(name: String) -> void:
	root.get_texture().get_image().save_png(out + "/" + name + ".png")
	print("SHOT ", name)
func _find_main(n: Node) -> Node:
	if n.has_method("_on_commit_plan_button_pressed"):
		return n
	for c in n.get_children():
		var r = _find_main(c)
		if r: return r
	return null
func _frames(k: int) -> void:
	for i in k:
		await process_frame
func _on_opened(_d, buttons: Array) -> void:
	pending_buttons = buttons
func _run():
	out = OS.get_environment("SHOT_DIR")
	change_scene_to_file("res://scenes/main.tscn")
	await _frames(90)
	var gm = root.get_node("GameManager")
	gm.day_tick_seconds = 0.01
	var plans = [["safety_research", "scouting"], ["hire_staff", "safety_research"], ["fundraise", "safety_research"], ["safety_research", "publicity"], ["safety_research", "scouting"]]
	var events_shot := 0
	for m in plans.size():
		var main = _find_main(current_scene)
		if not main.event_dialog.dialog_opened.is_connected(_on_opened):
			main.event_dialog.dialog_opened.connect(_on_opened)
		for id in plans[m]:
			main._on_dynamic_action_pressed(id, id)
		await _frames(10)
		_shot("m%d_plan_queued" % (m + 1))
		main._on_commit_plan_button_pressed()
		var idle := 0
		for t in 3000:
			await process_frame
			if pending_buttons.size() > 0:
				await _frames(15)
				if events_shot < 2:
					events_shot += 1
					_shot("m%d_event%d" % [m + 1, events_shot])
				var b = pending_buttons[pending_buttons.size() - 1]
				pending_buttons = []
				if is_instance_valid(b):
					print("PRESS ", b.text)
					b.pressed.emit()
				await _frames(15)
				idle = 0
			elif not gm.month_playback_active:
				idle += 1
				if idle > 120:
					break
		print("MONTH ", m + 1, " phase ", gm.state.current_phase, " turn ", gm.state.turn)
	await _frames(30)
	_shot("m6_plan_start")
	quit()

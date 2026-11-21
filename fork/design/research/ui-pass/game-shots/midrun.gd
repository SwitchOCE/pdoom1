extends SceneTree
var out := ""
var shots := {}
func _initialize():
	call_deferred("_run")
func _shot(name: String) -> void:
	if shots.has(name):
		return
	shots[name] = true
	root.get_texture().get_image().save_png(out + "/" + name + ".png")
	print("SHOT ", name)
func _find_main(n: Node) -> Node:
	if n.has_method("_on_commit_plan_button_pressed"):
		return n
	for c in n.get_children():
		var r = _find_main(c)
		if r: return r
	return null
func _visible_dialog(n: Node) -> Node:
	if n is CanvasItem and not n.is_visible_in_tree():
		return null
	var s = n.get_script()
	if s and String(s.resource_path).ends_with("event_dialog.gd"):
		return n
	for c in n.get_children():
		var r = _visible_dialog(c)
		if r: return r
	return null
func _first_button(n: Node) -> Button:
	if n is Button and n.is_visible_in_tree() and not n.disabled and n.text.strip_edges() != "":
		return n
	for c in n.get_children():
		var r = _first_button(c)
		if r: return r
	return null
func _frames(k: int) -> void:
	for i in k:
		await process_frame
func _run():
	out = OS.get_environment("SHOT_DIR")
	change_scene_to_file("res://scenes/main.tscn")
	await _frames(90)
	var gm = root.get_node("GameManager")
	gm.day_tick_seconds = 0.02
	var plans = [["safety_research", "scouting"], ["hire_staff", "safety_research"], ["fundraise", "safety_research"], ["safety_research", "publicity"]]
	for m in plans.size():
		var main = _find_main(current_scene)
		for id in plans[m]:
			main.plan_controller.select_action(id)
		await _frames(10)
		if m == 3:
			_shot("plan_month4_queued")
		main._on_commit_plan_button_pressed()
		for t in 1200:
			await process_frame
			var d = _visible_dialog(current_scene)
			if d:
				await _frames(20)
				var label = "event" if not shots.has("event") else ("event2" if not shots.has("event2") else "")
				if label != "": _shot(label)
				var b = _first_button(d)
				if b:
					print("PRESS ", b.text)
					b.pressed.emit()
				await _frames(20)
			elif not gm.month_playback_active and gm.state.current_phase == GameState.TurnPhase.ACTION_SELECTION and t > 60:
				break
		await _frames(40)
		_shot("plan_month%d" % (m + 2))
	quit()

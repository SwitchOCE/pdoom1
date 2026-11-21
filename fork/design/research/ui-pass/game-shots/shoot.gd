extends SceneTree
var scenes = ["res://scenes/welcome.tscn", "res://scenes/main.tscn", "res://scenes/player_guide.tscn"]
func _initialize():
	call_deferred("_run")
func _run():
	var out = OS.get_environment("SHOT_DIR")
	for p in scenes:
		if not ResourceLoader.exists(p):
			print("MISSING ", p)
			continue
		change_scene_to_file(p)
		for i in 90:
			await process_frame
		var img = root.get_texture().get_image()
		var name = p.get_file().get_basename()
		img.save_png(out + "/" + name + ".png")
		print("SHOT ", name)
	quit()

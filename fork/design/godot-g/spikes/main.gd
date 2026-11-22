extends Control

const SPECIMEN := preload("res://specimen_theme.tres")
const OFFICE := preload("res://assets/office_wide_day.webp")
const DOOM_LAYER := preload("res://doom_layer.gdshader")
const Dateline := preload("res://dateline.gd")

var _shots := ""
var _run_failed := false


func _ready() -> void:
	var args := OS.get_cmdline_user_args()
	_shots = OS.get_environment("PDOOM_SPIKE_SHOTS")
	print("ENV engine=%s os=%s method=%s driver=%s adapter=%s vendor=%s window=%s" % [
		Engine.get_version_info()["string"], OS.get_name(),
		RenderingServer.get_current_rendering_method(),
		RenderingServer.get_current_rendering_driver_name(),
		RenderingServer.get_video_adapter_name(), RenderingServer.get_video_adapter_vendor(),
		DisplayServer.window_get_size()
	])
	match args[0] if not args.is_empty() else "font":
		"shader":
			await _office_demo(args.has("quick"))
		"font":
			await _font_demo()
		"dateline", "dateline-skip", "dateline-new-date":
			await _dateline_demo(args[0])
		_:
			push_error("Unknown spike mode.")
			_run_failed = true
	get_tree().quit(1 if _run_failed else 0)


func _office_demo(quick: bool) -> void:
	var office := TextureRect.new()
	office.texture = OFFICE
	office.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	office.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	add_child(office)
	office.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var layer := ShaderMaterial.new()
	layer.shader = DOOM_LAYER
	office.material = layer
	var luminance := []
	for band in [0, 3, 6]:
		layer.set_shader_parameter("band", float(band))
		await RenderingServer.frame_post_draw
		var image := get_viewport().get_texture().get_image()
		if image.get_size() != Vector2i(1920, 1080):
			push_error("Expected a 1920 x 1080 shader capture.")
			_run_failed = true
		var average := _luminance_grid(image)
		luminance.append(average)
		print("BAND %d size=%s mean_luma=%.4f" % [band, image.get_size(), average])
		if not quick:
			_save_shot(image, "room-%d.webp" % band)
	if not (luminance[0] > luminance[1] and luminance[1] > luminance[2]):
		push_error("Band samples did not darken in order.")
		_run_failed = true

	layer.set_shader_parameter("band", 0.0)
	var middle_band := 0.0
	var middle_luminance := 0.0
	var transition := create_tween()
	transition.tween_property(layer, "shader_parameter/band", 3.0, 0.4)
	while transition.is_running():
		await RenderingServer.frame_post_draw
		var current: float = layer.get_shader_parameter("band")
		if middle_band == 0.0 and current >= 1.5 and current < 3.0:
			middle_band = current
			middle_luminance = _luminance_grid(get_viewport().get_texture().get_image())
	print("TWEEN start=0.0 intermediate=%.3f intermediate_luma=%.4f end=%.2f duration_ms=400" % [
		middle_band, middle_luminance, layer.get_shader_parameter("band")
	])
	if not (luminance[0] > middle_luminance and middle_luminance > luminance[1]):
		push_error("No intermediate shade was rendered during the tween.")
		_run_failed = true

	if not quick:
		layer.set_shader_parameter("band", 3.0)
		var plain := PackedFloat64Array()
		var shaded := PackedFloat64Array()
		for enabled in [false, true, true, false]:
			office.material = layer if enabled else null
			var times := await _frame_times(120)
			if enabled:
				shaded.append_array(times)
			else:
				plain.append_array(times)
		_print_frame_times("plain", plain)
		_print_frame_times("shader", shaded)


func _luminance_grid(image: Image) -> float:
	var samples := 0
	var total := 0.0
	for y in range(20, image.get_height(), 40):
		for x in range(20, image.get_width(), 40):
			total += image.get_pixel(x, y).get_luminance()
			samples += 1
	return total / samples


func _frame_times(count: int) -> PackedFloat64Array:
	for warmup in 45:
		await RenderingServer.frame_post_draw
	var times := PackedFloat64Array()
	var before := Time.get_ticks_usec()
	for frame in count:
		await RenderingServer.frame_post_draw
		var after := Time.get_ticks_usec()
		times.append((after - before) / 1000.0)
		before = after
	return times


func _print_frame_times(label: String, samples: PackedFloat64Array) -> void:
	var total := 0.0
	for sample in samples:
		total += sample
	samples.sort()
	var p95 := samples[ceili(samples.size() * 0.95) - 1]
	print("FRAME %s n=%d mean_ms=%.3f p95_ms=%.3f" % [
		label, samples.size(), total / samples.size(), p95
	])


func _font_demo() -> void:
	var background := ColorRect.new()
	background.color = Color("#15110f")
	add_child(background)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var rows := VBoxContainer.new()
	rows.position = Vector2(56, 36)
	rows.theme = SPECIMEN.duplicate()
	rows.add_theme_constant_override("separation", 16)
	add_child(rows)

	var base := rows.theme.default_font
	var fonts := [
		base as FontFile,
		rows.theme.get_font("font", "Plate") as FontFile,
		rows.theme.get_font("font", "Readout") as FontFile,
		(rows.theme.get_font("font", "Dateline") as FontVariation).base_font as FontFile,
	]
	for font in fonts:
		if font == null:
			push_error("Expected a bundled FontFile for each face.")
			_run_failed = true
			return
		print("FONT name=%s style=%s aa=%d hint=%d subpixel=%d mipmaps=%s msdf=%s" % [
			font.get_font_name(), font.get_font_style_name(), font.antialiasing, font.hinting,
			font.subpixel_positioning, font.generate_mipmaps, font.multichannel_signed_distance_field,
		])

	var lines := [
		["small", &"Readout", "small   IBM Plex Mono Medium   0 / 8 hours   $9,420   40.2%"],
		["body", &"Label", "body   IBM Plex Sans Regular   Available projects and staff"],
		["header", &"Dateline", "header   Courier Prime Bold   NOVEMBER 1, 2017"],
		["title", &"Plate", "title   BARLOW CONDENSED SEMIBOLD   MONTH PLAN"],
	]
	for row in lines:
		var label := Label.new()
		var font_size := ThemeManager.get_font_size(row[0])
		label.theme_type_variation = row[1]
		if row[1] != &"Label":
			rows.theme.set_font_size("font_size", row[1], font_size)
		label.text = "%s   %d px" % [row[2], font_size]
		label.add_theme_color_override("font_color", Color("#d6cebd"))
		rows.add_child(label)
		if label.get_theme_font_size("font_size") != font_size:
			push_error("Theme lookup disagrees with ThemeManager.")
			_run_failed = true
		print("SIZE %s effective=%d face=%s" % [
			row[0], label.get_theme_font_size("font_size"),
			label.get_theme_font("font").get_font_name(),
		])
	await RenderingServer.frame_post_draw
	var image := get_viewport().get_texture().get_image()
	print("FONT_FRAME pixels=%s logical=%s" % [image.get_size(), get_viewport_rect().size])
	if image.get_size() != DisplayServer.window_get_size():
		push_error("Font capture dimensions do not match the window.")
		_run_failed = true
	_save_shot(image, "font-%d.webp" % image.get_width())


func _dateline_demo(mode: String) -> void:
	var dateline := Dateline.new()
	dateline.theme = SPECIMEN.duplicate()
	dateline.theme.set_font_size("font_size", &"Dateline", ThemeManager.get_font_size("header"))
	add_child(dateline)
	await dateline.exercise(mode)
	_run_failed = dateline.failed


func _save_shot(image: Image, file_name: String) -> void:
	if _shots.is_empty():
		return
	var shot := _shots.path_join(file_name)
	var result := image.save_webp(shot, true, 0.82)
	print("SHOT %s result=%s" % [shot, error_string(result)])
	if result != OK:
		_run_failed = true

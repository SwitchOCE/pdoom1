extends Control

const DATE := "NOVEMBER 1, 2017"
const STRIKE_COUNT := 6
const INK := Color("#d9d1bf")

var failed := false
var _label := Label.new()
var _rng := RandomNumberGenerator.new()
var _strikes := AudioStreamRandomizer.new()
var _carriage: AudioStream
var _players: Array[AudioStreamPlayer] = []
var _sequence: Tween
var _strike_count := 0
var _busy := false


func _ready() -> void:
	_label.position = Vector2(56, 24)
	_label.theme_type_variation = &"Dateline"
	_label.add_theme_color_override("font_color", INK)
	_label.visible_characters = 0
	add_child(_label)
	for index in STRIKE_COUNT:
		_strikes.add_stream(index, load("res://assets/sfx/key-%d.wav" % index))
	_carriage = preload("res://assets/sfx/carriage.wav")
	_rng.seed = 1917


func begin(date_text: String) -> bool:
	if _busy:
		if date_text == _label.text:
			return false
		_skip_to(date_text)
		return true
	_busy = true
	_label.text = date_text
	_label.visible_characters = 0
	_strike_count = 0
	_sequence = create_tween()
	for index in date_text.length():
		var character := date_text[index]
		var interval := 0.060
		if index > 0:
			interval = 0.095 + _rng.randf_range(-0.022, 0.022)
			if character == " ":
				interval += 0.060
			if date_text[index - 1] == ",":
				interval += 0.040
		_sequence.tween_interval(interval)
		_sequence.tween_callback(_reveal.bind(index, character))
	_sequence.tween_interval(0.320)
	_sequence.tween_callback(_play_carriage)
	return true


func _reveal(index: int, character: String) -> void:
	_label.visible_characters = index + 1
	if character == " ":
		print("SPACE index=%d frame=%d" % [index, Engine.get_process_frames()])
		return
	# The 4.5.1 Randomizer playback consumes the engine's global RNG even
	# with neutral settings. Read its variants and do every draw locally.
	var variant := _rng.randi_range(0, _strikes.streams_count - 1)
	var pitch := _rng.randf_range(0.975, 1.025)
	var volume := _rng.randf_range(-1.0, 1.0)
	_play(_strikes.get_stream(variant), pitch, volume)
	_strike_count += 1
	print("STRIKE index=%d ascii=%d frame=%d variant=%d pitch=%.6f db=%.3f" % [
		index, character.unicode_at(0), Engine.get_process_frames(), variant, pitch, volume,
	])


func _play_carriage() -> void:
	var player := _play(_carriage, 1.0, 0.0)
	player.finished.connect(func() -> void: _busy = false)
	print("CARRIAGE frame=%d" % Engine.get_process_frames())


func _play(stream: AudioStream, pitch: float, volume: float) -> AudioStreamPlayer:
	var player := AudioStreamPlayer.new()
	player.bus = &"SFX"
	player.stream = stream
	player.pitch_scale = pitch
	player.volume_db = volume
	add_child(player)
	_players.append(player)
	player.finished.connect(_release.bind(player))
	player.play()
	return player


func _release(player: AudioStreamPlayer) -> void:
	_players.erase(player)
	player.queue_free()


func _input(event: InputEvent) -> void:
	if _busy and event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
		_skip_to(_label.text)
		get_viewport().set_input_as_handled()


func _skip_to(date_text: String) -> void:
	_sequence.kill()
	_label.text = date_text
	_label.visible_characters = -1
	for player in _players:
		player.stop()
		player.queue_free()
	_players.clear()
	_busy = false
	print("SKIP frame=%d strikes=%d visible=%d active_players=%d" % [
		Engine.get_process_frames(), _strike_count,
		_label.get_total_character_count(), _players.size(),
	])


func exercise(mode: String) -> void:
	_check(AudioServer.get_bus_index(&"SFX") == 1, "SFX bus 1")
	print("AUDIO_DRIVER %s" % AudioServer.get_driver_name())
	await get_tree().create_timer(0.30, false).timeout
	_check(begin(DATE), "start accepted")
	while _strike_count < 5:
		await get_tree().process_frame
	_check(not begin(DATE), "repeat of current date ignored while typing")
	if mode == "dateline-skip":
		var event := InputEventKey.new()
		event.keycode = KEY_SPACE
		event.pressed = true
		Input.parse_input_event(event)
		await get_tree().process_frame
		_check(_label.visible_ratio == 1.0, "space reveals entire date")
		await get_tree().create_timer(1.0, false).timeout
		_check(_strike_count == 5 and _players.is_empty(), "no strikes or players after skip")
	elif mode == "dateline-new-date":
		var next_date := "DECEMBER 1, 2017"
		_check(begin(next_date), "different date accepted while typing")
		_check(_label.text == next_date and _label.visible_ratio == 1.0, "new date appears whole")
		await get_tree().create_timer(1.0, false).timeout
		_check(_strike_count == 5 and _players.is_empty(), "no overlapping strikes for new date")
	else:
		while _label.visible_ratio < 1.0:
			await get_tree().process_frame
		await get_tree().create_timer(0.45, false).timeout
		_check(not begin(DATE), "repeat of current date ignored during carriage tail")
		while _busy:
			await get_tree().process_frame
		_check(_strike_count == 14, "14 single strikes for 16 characters")
	await get_tree().create_timer(0.25, false).timeout


func _check(condition: bool, label: String) -> void:
	print("CHECK %s %s" % ["OK" if condition else "FAIL", label])
	if not condition:
		failed = true
		push_error(label)

class_name GTypeSound
extends Node
## The dateline's typewriter sound (fork/design/godot-g/spec.md 7.2): a fixed pool of
## AudioStreamPlayers on the SFX bus, so overlapping strike tails never cut each other. Every
## choice of strike, pitch and level comes from the caller (GDateline's own seeded generator);
## this node draws no random number, and it never uses AudioStreamRandomizer, whose playback
## draws from Godot's global generator (spec 7.4).
##
## Volume is today's SFX slider: the bus's level is GameConfig.sfx_volume (game_config.gd
## apply_audio_settings), so SFX at 0 mutes it. Pausable: the players inherit the tree's pause
## like every G node (spec 6.3), so a strike pauses with the game and resumes after.
##
## VIEW-ONLY: no game state is read or written here.

## Pool size (spec 7.2, N2): a strike rings 0.78 s and the fastest gap is 0.073 s, so up to
## 11 can ring at once.
const POOL_SIZE := 12
const BUS := &"SFX"
const DIR := "res://assets/audio/sfx/typewriter/"
const STRIKE_COUNT := 6

## The six one-shot strikes and the carriage return (rendered by the fork's synthesize.py,
## spec 7.1). A plain array, not an AudioStreamRandomizer (spec 7.4).
var strikes: Array[AudioStream] = [
	preload(DIR + "strike_01.wav"), preload(DIR + "strike_02.wav"),
	preload(DIR + "strike_03.wav"), preload(DIR + "strike_04.wav"),
	preload(DIR + "strike_05.wav"), preload(DIR + "strike_06.wav"),
]
var carriage: AudioStream = preload(DIR + "carriage_return.wav")

var players: Array[AudioStreamPlayer] = []
var _started: Array[int] = []      # per player: the order it last started in (oldest = lowest)
var _plays := 0


func _init() -> void:
	name = "TypeSound"
	for i in range(POOL_SIZE):
		var p := AudioStreamPlayer.new()
		p.name = "Strike%02d" % i
		p.bus = BUS
		add_child(p)
		players.append(p)
		_started.append(-1)


func play_strike(pick: int, pitch: float, volume_db: float) -> AudioStreamPlayer:
	"""Play strike `pick` (0..5) at `pitch` and `volume_db` on the next free player. Silent
	(returns null) when the player has turned the typewriter sound off in G desk options."""
	if not GPrefs.typewriter_sound():
		return null
	return _play(strikes[clampi(pick, 0, STRIKE_COUNT - 1)], pitch, volume_db)


func play_carriage() -> AudioStreamPlayer:
	if not GPrefs.typewriter_sound():
		return null
	return _play(carriage, 1.0, 0.0)


func stop_all() -> void:
	"""Silence every player at once (the busy rule cuts a type-on to set, spec 7.3)."""
	for p in players:
		p.stop()


func ringing() -> int:
	"""How many players are sounding now (tests and the timing log)."""
	var n := 0
	for p in players:
		if p.playing:
			n += 1
	return n


func _play(stream: AudioStream, pitch: float, volume_db: float) -> AudioStreamPlayer:
	var p := _next_player()
	p.stream = stream
	p.pitch_scale = pitch
	p.volume_db = volume_db
	p.play()
	_plays += 1
	_started[players.find(p)] = _plays
	return p


func _next_player() -> AudioStreamPlayer:
	"""The first free player, else the one that started longest ago (spec 7.2)."""
	var oldest := 0
	for i in range(players.size()):
		if not players[i].playing:
			return players[i]
		if _started[i] < _started[oldest]:
			oldest = i
	return players[oldest]

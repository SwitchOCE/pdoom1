class_name GDateline
extends Control
## The dateline (fork/design/godot-g/spec.md 5.1.1, 7): the date, typed in on a worn ribbon
## when a run or a month begins, with a typewriter strike per letter.
##
## Draws each glyph itself (draw_char) in the theme's GDateline face (Courier Prime Bold) at
## the size GDesk sets through ThemeManager, 5 px extra advance per glyph, in its font_color.
## The ribbon is a fixed pattern of opacity and y offset per glyph (H's RIB_OP / RIB_DY).
##
## States: set (all glyphs), typing (glyphs 0..n and a caret block), busy-tail (all glyphs,
## the carriage return and the room tail still ringing). `busy` is true from the start of a
## type-on until its end time (spec 7.3).
##
## Randomness (spec 7.4): every timing jitter, strike pick, pitch and level comes from `rng`,
## this node's own RandomNumberGenerator, seeded with hash(text) before each type-on, so the
## same date always types the same way. Nothing here touches Godot's global generator.
##
## VIEW-ONLY: GDesk decides when to type (the triggers in spec 5.1.1) from the states it is
## sent; nothing here reads or writes game state. No timers: one Tween per type-on, created on
## this node, so it pauses with the game (spec 6.3).

## The worn ribbon, copied from fork/design/hifi3/H/concept.html RIB_OP / RIB_DY (H spec 3.3:
## "fixed, not random").
const RIB_OP := [1.0, 0.86, 0.97, 0.9, 1.0, 0.82, 0.95, 1.0, 0.88]
const RIB_DY := [0, 1, 0, 0, -1, 0, 1, 0, 0]
const TRACK := 5.0                 # extra advance per glyph, px (spec 5.1.1)
const CARET_W := 14.0              # the mock-up's caret block: 14 x 26 at 28 px, 4 px gap
const CARET_GAP := 4.0
const CARET_ALPHA := 0.85

# The schedule (spec 7.2), seconds.
const FIRST_AT := 0.06
const STEP := 0.095
const JITTER := 0.022
const SPACE_EXTRA := 0.060
const COMMA_EXTRA := 0.040
const CR_AFTER := 0.32
const CR_SLIDE := 0.24
const CR_STOP := 0.35
const ROOM_TAIL := 0.7
const PITCH_SPREAD := 0.025        # pitch_scale 0.975 .. 1.025
const LEVEL_SPREAD := 1.0          # volume_db -1 .. +1

## The text shown (set, or being typed).
var text: String = ""
## Glyphs drawn while typing (-1 = all).
var visible_count: int = -1
## True from the start of a type-on until its end time (the room tail has died away).
var busy := false
## Spec 6.5: show the date set and play no sound.
var reduced_motion := false
## The strike player (GDesk's TypeSound). Null = silent (standalone, tests).
var sound: GTypeSound = null
## This node's own generator (spec 7.4).
var rng := RandomNumberGenerator.new()

## The schedule of the type-on in progress (or the last one), and a log of what fired when:
## [{i, ch, at (s since start), frame, pick, pitch, db}] plus a "cr" and a "done" entry.
var current_schedule: Dictionary = {}
var type_log: Array = []
## How many type-ons have started on this node (tests, the capture harness).
var type_count := 0

var _tween: Tween
var _t0_usec := 0


func _init() -> void:
	name = "Dateline"
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	theme_type_variation = &"GDateline"
	custom_minimum_size = Vector2(420, 0)


func _notification(what: int) -> void:
	if what == NOTIFICATION_THEME_CHANGED or what == NOTIFICATION_RESIZED:
		queue_redraw()


# --- the schedule (pure) ------------------------------------------------------------------

static func date_text(calendar: Dictionary) -> String:
	"""'NOVEMBER 1, 2017' from state["calendar"] (spec 5.1.1). "" when there is no date."""
	var m := int(calendar.get("month", 0))
	if m < 1 or m > 12:
		return ""
	return "%s %d, %d" % [String(Clock.MONTH_NAMES[m - 1]).to_upper(),
		int(calendar.get("day", 0)), int(calendar.get("year", 0))]


static func schedule(t: String, r: RandomNumberGenerator) -> Dictionary:
	"""Spec 7.2. Seconds from the start: the first letter at 0.06; each next letter 0.095
	+- 0.022 later, a space 0.06 later still, a letter after a comma 0.04 later still; spaces
	are silent. The carriage return 0.32 after the last letter; the end 0.24 + 0.35 + 0.7 after
	that. Per strike: pick 0..5, never the previous strike's; pitch_scale 0.975..1.025;
	volume_db -1..+1. All from `r`, in character order.
	Returns {letter_times, picks, pitches, volumes (per character; pick -1 for a space),
	strikes (count), cr_time, end_time}."""
	var times: Array = []
	var picks: Array = []
	var pitches: Array = []
	var volumes: Array = []
	var at := FIRST_AT
	var prev_pick := -1
	var strikes := 0
	for i in range(t.length()):
		var ch := t[i]
		if i > 0:
			at += STEP + r.randf_range(-JITTER, JITTER)
			if ch == " ":
				at += SPACE_EXTRA
			if t[i - 1] == ",":
				at += COMMA_EXTRA
		times.append(at)
		if ch == " ":
			picks.append(-1)
			pitches.append(1.0)
			volumes.append(0.0)
			continue
		var pick := r.randi_range(0, GTypeSound.STRIKE_COUNT - 1)
		if prev_pick >= 0:
			# One draw over the five other strikes: never the previous one, no retry loop.
			pick = (prev_pick + 1 + r.randi_range(0, GTypeSound.STRIKE_COUNT - 2)) % GTypeSound.STRIKE_COUNT
		prev_pick = pick
		picks.append(pick)
		pitches.append(r.randf_range(1.0 - PITCH_SPREAD, 1.0 + PITCH_SPREAD))
		volumes.append(r.randf_range(-LEVEL_SPREAD, LEVEL_SPREAD))
		strikes += 1
	var last: float = times[times.size() - 1] if not times.is_empty() else 0.0
	var cr := last + CR_AFTER
	return {
		"letter_times": times, "picks": picks, "pitches": pitches, "volumes": volumes,
		"strikes": strikes, "cr_time": cr, "end_time": cr + CR_SLIDE + CR_STOP + ROOM_TAIL,
	}


# --- what GDesk calls ---------------------------------------------------------------------

func type_text(t: String) -> void:
	"""Type `t` in (a run or a month begins). The busy rule (spec 7.3): while a type-on runs,
	the same text is ignored and a different one is shown set, with every strike stopped."""
	if busy:
		if t != text:
			_cut_to(t)
		return
	if reduced_motion or t == "":
		_show_set(t)
		return
	_start(t)


func set_text(t: String) -> void:
	"""Show `t` set, no sound (inside a month, a load, a resume). While a type-on runs, the
	same text lets it finish; a different text cuts it to set and stops the strikes."""
	if busy:
		if t != text:
			_cut_to(t)
		return
	_show_set(t)


func stop_typing() -> void:
	"""Cut a type-on in progress to set and silence it (the desk is leaving)."""
	if busy:
		_cut_to(text)


func typing() -> bool:
	return busy and visible_count >= 0 and visible_count < text.length()


func elapsed() -> float:
	"""Seconds since the type-on in progress started (wall clock; the timing log)."""
	return float(Time.get_ticks_usec() - _t0_usec) / 1000000.0


# --- the type-on --------------------------------------------------------------------------

func _start(t: String) -> void:
	text = t
	visible_count = 0
	busy = true
	type_count += 1
	rng.seed = hash(t)
	current_schedule = schedule(t, rng)
	type_log = []
	_t0_usec = Time.get_ticks_usec()
	_kill_tween()
	_tween = create_tween()
	var times: Array = current_schedule.letter_times
	var prev := 0.0
	for i in range(times.size()):
		_tween.tween_interval(maxf(float(times[i]) - prev, 0.0))
		_tween.tween_callback(_strike.bind(i))
		prev = float(times[i])
	_tween.tween_interval(maxf(float(current_schedule.cr_time) - prev, 0.0))
	_tween.tween_callback(_carriage)
	_tween.tween_interval(float(current_schedule.end_time) - float(current_schedule.cr_time))
	_tween.tween_callback(_done)
	queue_redraw()


func _strike(i: int) -> void:
	visible_count = i + 1
	queue_redraw()
	var pick := int(current_schedule.picks[i])
	var entry := {"i": i, "ch": text[i], "at": elapsed(), "frame": Engine.get_process_frames(),
		"pick": pick}
	if pick >= 0:
		var pitch := float(current_schedule.pitches[i])
		var db := float(current_schedule.volumes[i])
		entry["pitch"] = pitch
		entry["db"] = db
		if sound != null:
			sound.play_strike(pick, pitch, db)
	type_log.append(entry)


func _carriage() -> void:
	visible_count = -1
	queue_redraw()
	type_log.append({"i": -1, "ch": "CR", "at": elapsed(), "frame": Engine.get_process_frames()})
	if sound != null:
		sound.play_carriage()


func _done() -> void:
	busy = false
	visible_count = -1
	type_log.append({"i": -2, "ch": "END", "at": elapsed(), "frame": Engine.get_process_frames()})
	queue_redraw()


func _cut_to(t: String) -> void:
	_kill_tween()
	if sound != null:
		sound.stop_all()
	busy = false
	_show_set(t)


func _show_set(t: String) -> void:
	text = t
	visible_count = -1
	queue_redraw()


func _kill_tween() -> void:
	if _tween != null and _tween.is_valid():
		_tween.kill()
	_tween = null


# --- drawing ------------------------------------------------------------------------------

func _metrics() -> Dictionary:
	var font := get_theme_font("font")
	var fs := get_theme_font_size("font_size")
	var asc := font.get_ascent(fs)
	var desc := font.get_descent(fs)
	return {"font": font, "size": fs, "ascent": asc, "descent": desc,
		"base_y": roundf((size.y + asc - desc) / 2.0)}


func _draw() -> void:
	if text == "":
		return
	var m := _metrics()
	var font: Font = m.font
	var fs: int = m.size
	var ink := get_theme_color("font_color")
	var n := text.length() if visible_count < 0 else mini(visible_count, text.length())
	var x := 0.0
	for i in range(n):
		var c := ink
		c.a *= float(RIB_OP[i % RIB_OP.size()])
		draw_char(font, Vector2(x, float(m.base_y) + float(RIB_DY[i % RIB_DY.size()])), text[i], fs, c)
		x += font.get_char_size(text.unicode_at(i), fs).x + TRACK
	if typing():
		var h := roundf(float(fs) * 26.0 / 28.0)
		var c2 := ink
		c2.a *= CARET_ALPHA
		draw_rect(Rect2(x - TRACK + CARET_GAP, roundf((size.y - h) / 2.0), CARET_W, h), c2)


func text_width(count: int = -1) -> float:
	"""The drawn width of the first `count` glyphs (-1 = all): advances plus tracking, no
	trailing track."""
	var n := text.length() if count < 0 else mini(count, text.length())
	if n <= 0:
		return 0.0
	var m := _metrics()
	var w := 0.0
	for i in range(n):
		w += (m.font as Font).get_char_size(text.unicode_at(i), int(m.size)).x + TRACK
	return w - TRACK


func get_text_boxes() -> Array:
	"""The capture harness's text box for the drawn date (spec 4.5: custom-drawn text is
	measured too), in the screenshot's pixel space."""
	var n := text.length() if visible_count < 0 else mini(visible_count, text.length())
	if n <= 0 or not is_visible_in_tree():
		return []
	var m := _metrics()
	var vp := get_viewport()
	var scale := Vector2.ONE
	if vp != null:
		var vis := vp.get_visible_rect().size
		var px := Vector2(vp.get_texture().get_size())
		if vis.x > 0.0 and vis.y > 0.0:
			scale = px / vis
	var top := float(m.base_y) - float(m.ascent) - 1.0
	var r := get_global_transform_with_canvas() * Rect2(Vector2(0.0, top),
		Vector2(text_width(n), float(m.ascent) + float(m.descent) + 2.0))
	return [{"x": r.position.x * scale.x, "y": r.position.y * scale.y,
		"w": r.size.x * scale.x, "h": r.size.y * scale.y,
		"text": text.substr(0, n),
		"node": String(get_path())}]

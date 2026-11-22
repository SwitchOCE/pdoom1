extends Node
## G capture and same-seed harness (fork/design/godot-g/spec.md 12.1 item 5, 12.3, 4.5).
##
## Run the real game through this scene, in its own fresh process and isolated profile:
##   godot --path godot res://tests/visual/g_capture.tscn -- --mode=parity --layout=g
##   godot --path godot res://tests/visual/g_capture.tscn -- --mode=shots --layout=classic --out=DIR
## The driver script writes the profile's user://config.cfg ([game] last_seed) and
## user://g_ui.cfg ([g] desk=true|false) BEFORE the process starts, so the normal boot
## (_boot_game -> start_new_game("", true)) starts the run on that seed. This scene then
## navigates to main.tscn through SceneTransition and drives it from a node that sits beside
## the current scene.
##
## Classic mode depends on no G file: nothing here names a G class, so the same file runs on
## lean (today's game) and must give the same hash there.
##
## parity (from phase 1b, spec 12.1 item 5): assert the seed; open the Scouting door the way
##   a player does -- classic: a mouse click on its action-bar button; g: a click on the ACTIONS
##   plate, then on the sheet's Scouting row -- and click scout_read, scout_read, scout_meetups
##   in the submenu, asserting the queue grows after each; commit with Space; answer each event
##   with its first enabled option; reach the month review, advance it with Space; assert the
##   next month opens in action_selection; print the hash of GameManager.state.to_dict().
## mouse (g only): the same month by mouse alone -- the plays as above, the Commit plate, each
##   event's first enabled option and the review's button all clicked -- and the same hash.
## shots: the same fixture, saving a PNG and a JSON of text boxes at each state of 12.3 that
##   phases 1a-1b have: month 1, Staff, Ledger, Guide, the Actions sheet just opened in month 1
##   (G only), the Actions sheet with three plays and the detail card, a door's submenu, the Plan drawer with eight or more plays, Upgrades,
##   WATCH after commit (with G's plain feed), an event, the review.
##   Phase 1c adds the WATCH sub-states: 12_w1_peek (the V peek before Commit), 05_watch and
##   13_w2_mid (playback right after Commit and mid-month, the feed folded), 14_feed_full (G:
##   the feed's full log, opened by a click on its header), 06_event (W3) and 07_review (W4).
##   Phase 7 adds 15_late_band5 (12.3 state 6: the debug doom nudge, after the hash) and waits
##   for every G motion (6.2) to end before each shot.
## tiers (g, phase 5): month 1 (t1_month1), three Purchase Compute through the action slots,
##   the month played as in parity, and month 2 (t2_month2) with other tiers. Not a same-seed run.
##   JSON format: {"boxes":[{x,y,w,h,text,node}]} in the PNG's pixel space, as
##   fork/design/godot-g/tools/contrast_godot.py reads it.
## room (g only, phase 3a): the room forced to each doom band 0-6 with the production material
##   (the room's debug-only override), then `simple` and `off` at band 3; PNG + JSON as shots.
##   Add Godot's --rendering-method gl_compatibility to capture the Compatibility renderer.
## roomcost (g only): the room's cost check (spec 5.14 "Cost"): mean frame time of the plain
##   room against the graded room (band 6: shader, glows and floor smoke), same UI, VSync off,
##   and the 2 ms budget verdict. Needs no
##   seed in the profile; run it in an isolated profile (APPDATA / XDG_DATA_HOME) on the PC
##   being measured, at 1920x1080.
## dateline (g only, phase 4): the parity fixture, watching the dateline. It asserts the new
##   game types once, the boundary state types the new month as the review appears, and the
##   WATCH day changes in between type nothing; it prints a timing log line per letter, the
##   carriage return and the end (DLTIME: scheduled ms, fired ms on the wall clock, frame), and
##   with --out=DIR saves dl_01_midtype, dl_02_typed, dl_03_month_change (mid-type over the
##   review) and dl_04_month_typed. Without --out the timing log is not disturbed by captures.
##
## Output lines start with "G_CAPTURE". Exit code 0 = every assert passed, 1 = a failure.

const MAIN_SCENE := "res://scenes/main.tscn"
const PICKS := ["scout_read", "scout_read", "scout_meetups"]
const GUIDE_SCENE := "res://scenes/player_guide.tscn"
const SEED := "g-parity-1"
const BOOT_TIMEOUT_S := 60.0
const MONTH_TIMEOUT_S := 240.0

var is_driver := false
var mode := "parity"
var layout := "classic"
var out_dir := ""
var no_handoff := false   # shots: leave the first-lever hand-off off (month 1 as a returning player sees it)
var _fail := false
var _events_seen: Array = []     # ids from GameManager.event_triggered, in arrival order
var _main_ui: Node = null
var _dl_mid_shot := false      # dateline mode: the boot type-on's mid-type shot is taken


func _ready() -> void:
	if not is_driver:
		# The scene's own node is the current scene, which go_to frees. The driver lives
		# beside it under the root, so it survives the swap to main.tscn.
		var d = (get_script() as GDScript).new()
		d.is_driver = true
		d.name = "GCaptureDriver"
		get_tree().root.add_child.call_deferred(d)
		return
	process_mode = Node.PROCESS_MODE_ALWAYS
	for a in OS.get_cmdline_user_args():
		var s := String(a)
		if s.begins_with("--mode="):
			mode = s.substr(7)
		elif s.begins_with("--layout="):
			layout = s.substr(9)
		elif s.begins_with("--out="):
			out_dir = s.substr(6)
		elif s == "--no-handoff":
			no_handoff = true
	_say("start mode=%s layout=%s user_dir=%s" % [mode, layout, OS.get_user_data_dir()])
	_run.call_deferred()


# --- helpers ------------------------------------------------------------------------------

func _say(msg: String) -> void:
	print("G_CAPTURE %s" % msg)


func _check(cond: bool, msg: String) -> bool:
	if cond:
		_say("ok   %s" % msg)
	else:
		_say("FAIL %s" % msg)
		_fail = true
	return cond


func _frames(n: int) -> void:
	for _i in range(n):
		await get_tree().process_frame


func _finish() -> void:
	_say("result %s" % ("FAIL" if _fail else "PASS"))
	get_tree().quit(1 if _fail else 0)


static func state_hash() -> String:
	return JSON.stringify(GameManager.state.to_dict(), "", true, true).sha256_text()


func _phase() -> String:
	return String(_main_ui.current_turn_phase).to_upper()


func _active_layout() -> String:
	var v = _main_ui.get("_ui_layout")
	return String(v) if v != null else String(GameConfig.ui_layout)


func _desk() -> Node:
	if _main_ui.has_method("get_g_desk"):
		return _main_ui.call("get_g_desk")
	return null


func _top_kind() -> String:
	var ms = _main_ui.get("modal_stack")
	if ms != null and ms.has_method("top_kind"):
		return String(ms.top_kind())
	return ""


func _key(code: int) -> void:
	var e := InputEventKey.new()
	e.keycode = code
	e.physical_keycode = code
	e.pressed = true
	Input.parse_input_event(e)
	await _frames(1)
	var u := InputEventKey.new()
	u.keycode = code
	u.physical_keycode = code
	u.pressed = false
	Input.parse_input_event(u)
	await _frames(2)


# --- the run ------------------------------------------------------------------------------

func _run() -> void:
	if mode == "dateline" and layout != "g":
		_check(false, "--mode=dateline needs --layout=g")
		_finish()
		return
	if mode in ["shots", "room", "tiers"] and out_dir == "":
		_check(false, "--out=DIR is required for %s" % mode)
		_finish()
		return
	if out_dir != "":
		DirAccess.make_dir_recursive_absolute(out_dir)
	if not mode.ends_with("cost"):
		_check(String(GameConfig.game_seed) == SEED,
			"user://config.cfg carried last_seed (GameConfig.game_seed=%s)" % GameConfig.game_seed)
	GameManager.event_triggered.connect(func(ev): _events_seen.append(String(ev.get("id", "?"))))
	if mode == "shots" and not no_handoff:
		# A first run reaches main.tscn through the cold open, which hands off to the first-lever
		# advisor on its way out. The harness skips the cold open, so it sets that same view
		# flag here (shots only; the parity run leaves every setting as the profile has it).
		GameConfig.show_first_lever_hint = true
	SceneTransition.go_to(MAIN_SCENE)

	# Boot: wait for main.tscn, the run, and the plan phase.
	var t0 := Time.get_ticks_msec()
	while true:
		await _frames(1)
		var cs := get_tree().current_scene
		if _main_ui == null and cs != null and cs.scene_file_path == MAIN_SCENE:
			_main_ui = cs.find_child("MainUI", true, false)
		if mode == "dateline" and out_dir != "" and not _dl_mid_shot and _main_ui != null \
				and _desk() != null:
			# The new game's type-on starts with the first state, before the boot settles.
			var dl0 = _desk().get("dateline")
			if dl0 != null and bool(dl0.call("typing")) and int(dl0.get("visible_count")) >= 7:
				_dl_mid_shot = true
				await _shot("dl_01_midtype", true)
		if _main_ui != null and GameManager.is_initialized and GameManager.state != null \
				and _phase() == "ACTION_SELECTION" and _boot_shots_done():
			break
		if Time.get_ticks_msec() - t0 > BOOT_TIMEOUT_S * 1000.0:
			_check(false, "boot reached action_selection")
			_finish()
			return
	# The run's baseline simulation runs on its own thread and writes VerificationTracker
	# from there (today's code). Acting while it runs races that thread, so wait for it to
	# finish and harvest it. Neither touches GameState or its RNG; both layouts do the same.
	while BaselineSimulator._is_computing:
		await _frames(1)
	BaselineSimulator.get_baseline_score_if_ready(String(GameManager.state.game_seed_str))
	await _frames(10)

	if not mode.ends_with("cost"):
		_check(String(GameManager.state.game_seed_str) == SEED,
			"run seed is %s (got %s)" % [SEED, GameManager.state.game_seed_str])
	_check(_active_layout() == layout, "active layout is %s (got %s)" % [layout, _active_layout()])
	if layout == "g":
		_check(_desk() != null, "the G desk is up")
	_say("boot hash %s" % state_hash())
	if mode == "dateline":
		await _dateline_watch("boot", 1, "dl_01_midtype", "dl_02_typed")

	if mode == "room" or mode == "roomcost":
		if layout != "g" or _desk() == null or _desk().get("room") == null:
			_check(false, "mode %s needs the G desk (--layout=g, G on in the profile)" % mode)
			_finish()
			return
		if mode == "room":
			await _room_shots()
		else:
			await _room_cost()
		_finish()
		return

	if mode == "shots" and no_handoff:
		# Month 1 without the hand-off: the note carries classic's first-turns line instead.
		await _frames(20)
		var desk := _desk()
		if desk != null:
			var gs: Label = _main_ui.get("getting_started_hint")
			_check(String(desk.call("advisor_mode")) == "plain", "no hand-off: the note is in its plain mode")
			_check(String(desk.get("advisor_note").call("body_text")) == gs.text,
				"the note carries classic's first-turns line: '%s'" % gs.text)
		await _shot("01b_no_handoff")
		_finish()
		return
	if mode == "shots":
		await _shots_plan_phase()

	if mode == "tiers":
		# Phase 5 shots (not the same-seed fixture): month 1, then three Purchase Compute
		# through the retained action slots so month 2 shows other money and compute tiers.
		# The amber dev-build badge sits over the strip's right end; hidden for these shots.
		_hide_dev_badge()
		await _frames(20)
		await _shot("t1_month1")
		if not await _queue_buy_compute(3):
			_finish()
			return
	else:
		# Queue: through the Scouting door, three choices, the way a player does (spec 12.1 item 5).
		for n in range(PICKS.size()):
			if not await _pick_through_scouting(String(PICKS[n]), n + 1):
				_finish()
				return
	_say("queued hash %s" % state_hash())
	if mode == "shots":
		await _shots_queued()
		# W1: the V peek before Commit (view only; V is today's toggle_view in both layouts).
		await _key(KEY_V)
		await _frames(6)
		await _shot("12_w1_peek")
		await _key(KEY_V)
		await _frames(4)

	# Commit through the Space path (mouse mode: the Commit plate, which runs the same handler).
	await _close_g_sheets()
	if mode == "mouse":
		var plate: Control = _desk().get("commit_plate")
		_check(String(_desk().get("commit_path")) == "end_turn", "the Commit plate runs the Space path")
		await _click(plate)
	else:
		await _key(KEY_SPACE)
	if _phase() == "ACTION_SELECTION":
		_say("note: the commit did not take at once (warnings?); pressing Space again")
		await _key(KEY_SPACE)
	_check(_phase() != "ACTION_SELECTION", "Space committed the month (phase %s)" % _phase())
	var start_turn: int = int(GameManager.state.turn)

	if mode == "shots":
		await _frames(6)
		await _shot("05_watch")

	# Play the month: answer events with their first enabled option, then the review.
	var answered := 0
	var reviewed := false
	var handled: Dictionary = {}
	var event_shot := false
	var mid_shot := false
	t0 = Time.get_ticks_msec()
	while not reviewed:
		await _frames(1)
		if Time.get_ticks_msec() - t0 > MONTH_TIMEOUT_S * 1000.0:
			_check(false, "the month reached its review in %ds" % int(MONTH_TIMEOUT_S))
			_finish()
			return
		if mode == "shots" and not mid_shot and _top_kind() == "" \
				and int(GameManager.state.turn) - start_turn >= 8:
			# W2 mid-month (shots only: a capture takes a few frames, which playback's timer
			# does not wait for, so it can only move the moment of the shot, never the run).
			# An event can arrive while the frame is captured: then the shot is retaken later.
			mid_shot = true
			await _shot("13_w2_mid")
			if _top_kind() != "":
				_say("note: an event arrived during the W2 shot; retaking it later")
				mid_shot = false
				continue
			var d := _desk()
			if d != null:
				var fp = d.get("feed_panel")
				await _click(fp.get("_title"))
				await _frames(4)
				if not bool(fp.get("expanded")) and _top_kind() != "":
					_say("note: an event took the click on the feed header; retaking later")
					mid_shot = false
					continue
				_check(bool(fp.get("expanded")), "a click on the feed's header opens the full log")
				await _shot("14_feed_full")
				if _top_kind() != "":
					_say("note: an event arrived during the full-log shot; retaking it later")
					fp.call("set_expanded", false)
					mid_shot = false
					continue
				await _click(fp.get("_toggle_full"))
				await _frames(2)
				if bool(fp.get("expanded")):
					fp.call("set_expanded", false)   # an event took the click: fold it directly
				_check(not bool(fp.get("expanded")), "the feed is folded again")
		if _top_kind() != "event":
			continue
		var dlg = _main_ui.active_dialog
		if dlg == null or not is_instance_valid(dlg) or handled.has(dlg.get_instance_id()):
			continue
		handled[dlg.get_instance_id()] = true
		await _frames(3)
		var idx := handled.size() - 1
		var ev_id: String = String(_events_seen[idx]) if idx < _events_seen.size() else "?"
		var is_review := ev_id == "__month_review__"
		if is_review:
			if answered == 0:
				_say("NOTE: the seed's first month has no event before its review")
			_check(true, "the run reached the month review")
			if mode == "shots":
				if not event_shot:
					_say("note: no event shot (no event this month)")
				await _shot("07_review")
			if mode == "dateline":
				await _dateline_watch("month", 2, "dl_03_month_change", "dl_04_month_typed")
			if mode == "mouse":
				var nav: Button = _main_ui.active_dialog_buttons[0]
				await _click(nav)
			else:
				await _key(KEY_SPACE)
			reviewed = true
		else:
			var buttons: Array = _main_ui.active_dialog_buttons
			var pick: Button = null
			for b in buttons:
				if b is Button and not (b as Button).disabled:
					pick = b
					break
			_check(pick != null, "event %s has an enabled option" % ev_id)
			if pick == null:
				_finish()
				return
			if mode == "shots" and not event_shot:
				await _shot("06_event")
				event_shot = true
			_say("event %s -> first enabled option '%s'" % [ev_id, pick.text.strip_edges()])
			if mode == "mouse":
				await _click(pick)
			else:
				pick.pressed.emit()
			answered += 1
			await _frames(2)

	# The next month opens in action_selection.
	t0 = Time.get_ticks_msec()
	while _phase() != "ACTION_SELECTION" and Time.get_ticks_msec() - t0 < 20000:
		await _frames(1)
	_check(_phase() == "ACTION_SELECTION", "the next month opens in action_selection (phase %s)" % _phase())
	_check(int(GameManager.state.turn) > start_turn, "the turn advanced (%d -> %d)" % [start_turn, int(GameManager.state.turn)])
	await _frames(5)
	_say("events answered %d: %s" % [answered, str(_events_seen)])
	if mode == "dateline":
		var dl = _desk().get("dateline")
		_check(int(dl.get("type_count")) == 2,
			"the next month's plan opens with no third type-on (type_count %d)" % int(dl.get("type_count")))
	_say("HASH layout=%s seed=%s turn=%d %s" % [layout, SEED, int(GameManager.state.turn), state_hash()])

	if mode == "tiers":
		# After the hash: close month 2's opening notices (an unlock card's Continue) and let
		# the achievement toast and any tier crossfade (0.25 s) finish before the shot.
		for _i in range(5):
			var cont := _visible_button("Continue")
			if cont == null:
				break
			cont.pressed.emit()
			await _frames(5)
		await get_tree().create_timer(6.0, false).timeout
		_hide_dev_badge()
		await _shot("t2_month2")
	if mode == "shots":
		await _late_band_shot()
	if mode == "shots" and layout == "classic":
		# Today's guide is a scene of its own, reached from the menus, not over the run.
		SceneTransition.go_to(GUIDE_SCENE)
		await _frames(20)
		await _shot("04_guide")
	_finish()


# --- the room (phase 3a, spec 5.14) ------------------------------------------------------------

func _room_shots() -> void:
	"""room: the room forced to each band 0-6 with the production material, then `simple` and
	`off` at band 3. The override is the room's debug-only one; it holds the band instantly.
	Doom is never touched, so the state hash must not move."""
	var room = _desk().get("room")
	var before := state_hash()
	await _frames(20)
	_check(String(room.get("mode")) == "full", "room effects is full (the default)")
	var bd = room.get("backdrop")
	_check(bd != null and bd.material == room.get("material_room"), "the Backdrop carries the room material")
	_say("room renderer %s, adapter %s" % [RenderingServer.get_current_rendering_method(),
		RenderingServer.get_video_adapter_name()])
	for b in range(7):
		_check(bool(room.call("debug_force_band", b)), "debug override takes band %d (debug build)" % b)
		await _frames(8)
		await _shot("room-band-%d" % b)
	for m in ["simple", "off"]:
		room.call("set_mode", m)
		room.call("debug_force_band", 3)
		await _frames(8)
		await _shot("room-%s-band-3" % m)
	room.call("set_mode", "full")
	room.call("debug_force_band", -1)
	await _frames(4)
	_check(state_hash() == before, "the room shots left the game state as it was")
	_say("HASH layout=%s seed=%s turn=%d %s" % [layout, SEED, int(GameManager.state.turn), state_hash()])


func _room_cost() -> void:
	"""roomcost: mean frame time of the plain room (`off`, today's) against the graded room
	(`full`), same UI, VSync off, band 6, the worst case: every layer, floor smoke included
	(spec 5.14 "Cost"). Order plain, graded, graded, plain; each run is
	ROOMCOST_WARMUP frames then ROOMCOST_FRAMES samples of wall-clock frame time. Budget: the
	graded room may cost at most 2 ms a frame more than the plain one (spec 5.14 "Cost")."""
	var room = _desk().get("room")
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	Engine.max_fps = 0
	room.call("debug_force_band", 6)
	_say("ROOMCOST renderer %s, adapter %s %s, window %s" % [RenderingServer.get_current_rendering_method(),
		RenderingServer.get_video_adapter_vendor(), RenderingServer.get_video_adapter_name(),
		str(get_viewport().get_visible_rect().size)])
	var runs := {"off": [], "full": []}
	for m in ["off", "full", "full", "off"]:
		room.call("set_mode", m)
		room.call("debug_force_band", 6)
		await _frames(ROOMCOST_WARMUP)
		var last := Time.get_ticks_usec()
		for _i in range(ROOMCOST_FRAMES):
			await get_tree().process_frame
			var now := Time.get_ticks_usec()
			runs[m].append(float(now - last) / 1000.0)
			last = now
	var plain := _stats(runs["off"])
	var graded := _stats(runs["full"])
	var delta: float = graded["mean"] - plain["mean"]
	_say("ROOMCOST plain  mean %.3f ms  p95 %.3f ms  (%d frames)" % [plain["mean"], plain["p95"], runs["off"].size()])
	_say("ROOMCOST graded mean %.3f ms  p95 %.3f ms  (%d frames)" % [graded["mean"], graded["p95"], runs["full"].size()])
	_say("ROOMCOST delta %.3f ms per frame; budget 2.0 ms: %s" % [delta, "WITHIN" if delta <= 2.0 else "OVER -> make simple the default"])
	room.call("set_mode", "full")
	room.call("debug_force_band", -1)


const ROOMCOST_WARMUP := 45
const ROOMCOST_FRAMES := 240


static func _stats(xs: Array) -> Dictionary:
	if xs.is_empty():
		return {"mean": 0.0, "p95": 0.0}
	var s := xs.duplicate()
	s.sort()
	var total := 0.0
	for v in s:
		total += float(v)
	return {"mean": total / float(s.size()), "p95": float(s[mini(s.size() - 1, int(floor(0.95 * s.size())))])}


func _boot_shots_done() -> bool:
	"""Dateline mode with --out: the boot waits for its mid-type shot (or the type-on's end)."""
	if mode != "dateline" or out_dir == "" or _dl_mid_shot:
		return true
	var d := _desk()
	return d != null and not bool(d.get("dateline").get("busy"))


func _dateline_watch(tag: String, count: int, mid_name: String, done_name: String) -> void:
	"""Phase 4: the dateline's type-on number `count` is running; shoot it mid-type and set
	(with --out), and print its timing log."""
	var dl = _desk().get("dateline")
	_check(int(dl.get("type_count")) == count,
		"%s: type-on number %d (type_count %d)" % [tag, count, int(dl.get("type_count"))])
	_say("dateline %s text '%s' busy %s visible %d" % [tag, String(dl.get("text")),
		str(dl.get("busy")), int(dl.get("visible_count"))])
	var t0 := Time.get_ticks_msec()
	if out_dir != "" and tag == "boot" and not _dl_mid_shot:
		_check(false, "boot: the mid-type shot was taken while the boot settled")
	if out_dir != "" and tag != "boot":
		while bool(dl.call("typing")) and int(dl.get("visible_count")) < 7 \
				and Time.get_ticks_msec() - t0 < 5000:
			await _frames(1)
		_check(bool(dl.call("typing")), "%s: still typing for the mid-type shot" % tag)
		await _shot(mid_name, true)
	while bool(dl.get("busy")) and Time.get_ticks_msec() - t0 < 10000:
		await _frames(1)
	_check(not bool(dl.get("busy")), "%s: the type-on ended" % tag)
	var sch: Dictionary = dl.get("current_schedule")
	var times: Array = sch.get("letter_times", [])
	for e in dl.get("type_log"):
		var i := int(e.get("i", -9))
		var at_s := float(times[i]) if i >= 0 and i < times.size() else \
			(float(sch.get("cr_time", 0.0)) if i == -1 else float(sch.get("end_time", 0.0)))
		_say("DLTIME %s i=%d ch='%s' sched_ms=%.1f fired_ms=%.1f late_ms=%.1f frame=%d pick=%d pitch=%.4f db=%.3f" % [
			tag, i, String(e.get("ch", "")), at_s * 1000.0, float(e.get("at", 0.0)) * 1000.0,
			(float(e.get("at", 0.0)) - at_s) * 1000.0, int(e.get("frame", 0)),
			int(e.get("pick", -1)), float(e.get("pitch", 1.0)), float(e.get("db", 0.0))])
	if out_dir != "":
		await _shot(done_name, true)


func _slot_container() -> Container:
	for child in _main_ui.actions_list.get_children():
		if child is Container:
			return child
	return null


func _slot_for(action_id: String) -> int:
	var stack := _slot_container()
	if stack == null:
		return -1
	var buttons: Array = stack.get_children()
	for i in range(buttons.size()):
		var b = buttons[i]
		if b is Button and String(b.get_meta("action_id", "")) == action_id:
			return i
	return -1


func _slot_button(i: int) -> Button:
	return _slot_container().get_children()[i] as Button


func _hide_dev_badge() -> void:
	for b in get_tree().root.find_children("*", "DevBuildBadge", true, false):
		(b as CanvasLayer).visible = false


func _visible_button(text: String) -> Button:
	for b in get_tree().root.find_children("*", "Button", true, false):
		if (b as Button).text.strip_edges() == text and (b as Button).is_visible_in_tree():
			return b as Button
	return null


func _queue_buy_compute(n: int) -> bool:
	"""Tiers shots: press the Purchase Compute slot n times (the 1a fixture's path), asserting
	the queue grows after each press."""
	for k in range(n):
		var i := _slot_for("buy_compute")
		if not _check(i >= 0 and not _slot_button(i).disabled, "Purchase Compute slot is live (%d)" % (k + 1)):
			return false
		var before: int = _main_ui.plan_controller.queue_size()
		_main_ui._trigger_action_by_index(i)
		await _frames(3)
		if not _check(_main_ui.plan_controller.queue_size() == before + 1, "Purchase Compute %d queued" % (k + 1)):
			return false
	return true


# --- the plays, the way a player makes them ---------------------------------------------

func _to_window(p: Vector2) -> Vector2:
	"""Canvas position -> window position. Input events are in window pixels; the canvas is
	1920x1080 at any window size (stretch canvas_items), so at 1280x720 a click must be scaled.
	At 1920x1080 this is the identity."""
	return get_viewport().get_final_transform() * p


func _click(c: Control) -> void:
	"""A real left click at the centre of the control, through Input (so GUI hit-testing,
	barriers and z-order decide what it lands on, as for a player)."""
	await _frames(1)
	var p := _to_window(c.get_global_rect().get_center())
	var mm := InputEventMouseMotion.new()
	mm.position = p
	mm.global_position = p
	Input.parse_input_event(mm)
	await _frames(2)
	var down := InputEventMouseButton.new()
	down.button_index = MOUSE_BUTTON_LEFT
	down.pressed = true
	down.position = p
	down.global_position = p
	Input.parse_input_event(down)
	await _frames(1)
	var up := down.duplicate() as InputEventMouseButton
	up.pressed = false
	Input.parse_input_event(up)
	await _frames(3)


func _wheel_into_view(c: Control) -> void:
	"""Scroll the mouse wheel over c's ScrollContainer until c is wholly inside it, as a player
	would for a row below the fold."""
	var sc: ScrollContainer = null
	var n := c.get_parent()
	while n != null:
		if n is ScrollContainer:
			sc = n
			break
		n = n.get_parent()
	if sc == null:
		return
	var turns := 0
	while not sc.get_global_rect().encloses(c.get_global_rect()) and turns < 60:
		var down := c.get_global_rect().position.y > sc.get_global_rect().position.y
		var w := InputEventMouseButton.new()
		w.button_index = MOUSE_BUTTON_WHEEL_DOWN if down else MOUSE_BUTTON_WHEEL_UP
		w.pressed = true
		w.factor = 1.0
		w.position = _to_window(sc.get_global_rect().get_center())
		w.global_position = w.position
		Input.parse_input_event(w)
		var wu := w.duplicate() as InputEventMouseButton
		wu.pressed = false
		Input.parse_input_event(wu)
		await _frames(2)
		turns += 1
	if turns > 0:
		_say("scrolled %d wheel steps to bring %s into view" % [turns, c.name])


func _hover(c: Control) -> void:
	var mm := InputEventMouseMotion.new()
	mm.position = _to_window(c.get_global_rect().get_center())
	mm.global_position = mm.position
	Input.parse_input_event(mm)
	await _frames(3)


func _sheet_open(kind: String) -> bool:
	var d := _desk()
	if d == null:
		return false
	var sh = d.call("sheet_for", kind)
	return sh != null and (sh as Control).visible


func _open_scouting() -> bool:
	"""Classic: click the Scouting button on the action bar. g: open the Actions sheet with the
	ACTIONS plate (unless the door return already put it back) and click the Scouting row."""
	if layout == "g":
		if not _sheet_open("g_actions"):
			await _click(_desk().get("plate_actions"))
		if not _check(_sheet_open("g_actions"), "the ACTIONS plate opened the Actions sheet"):
			return false
		var row: Control = _desk().get("actions_panel").call("row_for", "scouting")
		if not _check(row != null, "the sheet has a Scouting row"):
			return false
		await _frames(12)   # the sheet's open tween
		await _wheel_into_view(row)
		await _click(row)
	else:
		var slot := _slot_for("scouting")
		if not _check(slot >= 0, "the action bar has a Scouting button"):
			return false
		await _click(_slot_button(slot))
	var dlg = _main_ui.active_dialog
	return _check(dlg != null and is_instance_valid(dlg) and String(dlg.get_meta("submenu_id", "")) == "scouting",
		"the Scouting submenu is open")


func _pick_through_scouting(pick_id: String, n: int) -> bool:
	_check(_active_layout() == layout, "pick %d: layout still %s" % [n, layout])
	if not await _open_scouting():
		return false
	var opts := GameActions.get_scouting_options()
	var idx := -1
	for i in range(opts.size()):
		if String(opts[i].get("id", "")) == pick_id:
			idx = i
	var buttons: Array = _main_ui.active_dialog_buttons
	if not _check(idx >= 0 and idx < buttons.size(), "pick %d: %s is a Scouting choice" % [n, pick_id]):
		return false
	var btn: Button = buttons[idx]
	_check(not btn.disabled, "pick %d: %s is not disabled" % [n, pick_id])
	var before: int = _main_ui.plan_controller.queue_size()
	await _click(btn)
	var after: int = _main_ui.plan_controller.queue_size()
	var last := String(_main_ui.plan_controller.queued_actions[-1].get("id", "")) if after > 0 else ""
	return _check(after == before + 1 and last == pick_id,
		"pick %d: the queue grew with %s (%d -> %d)" % [n, pick_id, before, after])


func _close_g_sheets() -> void:
	var d := _desk()
	if d != null:
		d.call("close_g_sheets")
		await _frames(2)


# --- shots --------------------------------------------------------------------------------

func _shots_plan_phase() -> void:
	await _frames(20)
	# For the record: one month-1 shot with the hint pulse left running (caught wherever it is).
	await _shot("01_month1_pulse", false)
	await _shot("01_month1")
	var desk := _desk()

	# Staff, from the rail in G; from today's Staff button in classic.
	if desk != null:
		desk.call("open_staff")
	else:
		_main_ui._on_open_employee_screen()
	await _frames(20)
	await _shot("02_staff")
	await _key(KEY_ESCAPE)
	await _frames(10)
	_say("after staff: top_kind='%s'" % _top_kind())

	# Ledger.
	if desk != null:
		desk.call("open_ledger")
	else:
		_main_ui._show_ledger_screen()
	await _frames(20)
	await _shot("03_ledger")
	await _key(KEY_ESCAPE)
	await _frames(10)
	_say("after ledger: top_kind='%s'" % _top_kind())

	# The embedded guide (G only; classic's guide is captured at the end, from its scene).
	if desk != null:
		desk.call("toggle_guide")
		await _frames(20)
		await _shot("04_guide")
		await _key(KEY_ESCAPE)
		await _frames(10)
		_say("after guide: top_kind='%s'" % _top_kind())
	_check(_phase() == "ACTION_SELECTION", "back on the plan after the doors")

	# 08 (G): the Actions sheet just opened in month 1 with the first-lever nudge on -- the
	# row the advisor calls "the glowing button" must be in view without scrolling.
	if desk != null:
		await _click(desk.get("plate_actions"))
		await _frames(20)
		var ap = desk.get("actions_panel")
		var hid := String(ap.get("hint_id"))
		var row: Control = ap.call("row_for", hid) if hid != "" else null
		var sc: Control = ap.get("_scroll")
		_check(row != null and sc.get_global_rect().encloses(row.get_global_rect()),
			"the nudged row '%s' is in view when the sheet opens" % hid)
		await _shot("08_actions")
		await _key(KEY_ESCAPE)
		await _frames(10)


func _shots_queued() -> void:
	"""The 1b states (spec 12.3), with the three plays queued. Shots only; the queue is put back
	to the three fixture plays before the run goes on."""
	var desk := _desk()
	await _frames(10)
	# 08b: the Actions sheet with three plays and the detail card (classic: a hovered tile).
	if desk != null:
		if not _sheet_open("g_actions"):
			await _click(desk.get("plate_actions"))
		var ap = desk.get("actions_panel")
		await _wheel_into_view(ap.call("row_for", "buy_compute"))
		await _hover(ap.call("row_for", "buy_compute"))
		if String(ap.get("detail_id")) == "":
			_say("note: hover did not raise the detail card; focusing the row instead")
			(ap.call("row_for", "buy_compute") as Control).grab_focus()
		await _frames(10)
		_check(String(ap.get("detail_id")) != "", "the detail card shows %s" % ap.get("detail_id"))
	else:
		var slot := _slot_for("buy_compute")
		if slot >= 0:
			await _hover(_slot_button(slot))
		await _frames(10)
	await _shot("08b_queued")

	# 09: a door's submenu, opened from the sheet (classic: from its action-bar button).
	if await _open_scouting():
		await _frames(10)
		await _shot("09_door")
		await _key(KEY_ESCAPE)
		await _frames(10)

	# 10: the Plan drawer with eight or more plays (classic: today's queue with the same plays).
	await _close_g_sheets()
	for i in range(3):
		var slot := _slot_for("buy_compute")
		if slot >= 0:
			_main_ui._trigger_action_by_index(slot)
			await _frames(3)
	for i in range(2):
		await _pick_through_scouting("scout_read", 4 + i)
		await _frames(3)
	await _close_g_sheets()
	var n: int = _main_ui.plan_controller.queue_size()
	if desk != null:
		await _click(desk.get("attention_card").get("choose_button"))
		if not _sheet_open("g_plan"):
			desk.call("open_sheet", "g_plan")
		await _frames(10)
		_say("plan drawer rows %d" % int(desk.get("plan_panel").call("row_count")))
	await _frames(10)
	_say("plan shot with %d plays queued" % n)
	_check(n >= 8, "eight or more plays queued for the plan shot (%d)" % n)
	await _shot("10_plan")
	await _close_g_sheets()
	# Put the fixture's queue back exactly: today's Undo removes the first queued copy of the
	# last id, not the last entry, so clear and pick the three plays again.
	_main_ui._on_clear_queue_button_pressed()
	await _frames(3)
	for k in range(PICKS.size()):
		await _pick_through_scouting(String(PICKS[k]), 10 + k)
	await _close_g_sheets()
	var ids: Array = []
	for q in _main_ui.plan_controller.queued_actions:
		ids.append(String(q.get("id", "")))
	_check(ids == PICKS, "the queue is the fixture's three plays again (%s)" % str(ids))

	# 11: Upgrades (classic: today's upgrades list, on the main screen).
	if desk != null:
		await _click(desk.get("plate_upgrades"))
		await _frames(10)
	await _shot("11_upgrades")
	await _close_g_sheets()
	await _frames(5)


func _shot(name: String, hold_pulse: bool = true) -> void:
	# Phase 7: the G motions of spec 6.2 (a sheet's open fade, the PLAN <-> WATCH fade, a
	# paper's arrival, the P(Doom) arc, the room's band tween, a tier crossfade) end before the
	# frame is taken, so every shot is the state at rest. Display only: the wait moves the
	# moment of the shot, never the run (playback's timer does not wait for it).
	await _settle_motion()
	# The contrast gate measures the rest state: hold today's hint pulses (the ACTIONS plate
	# and the hinted Actions row, alpha 1 -> 0.4 -> 1) at full alpha for this frame only.
	var held := _hold_pulses() if hold_pulse else []
	await RenderingServer.frame_post_draw
	if hold_pulse:
		await RenderingServer.frame_post_draw
	var img := get_viewport().get_texture().get_image()
	for t in held:
		if is_instance_valid(t) and (t as Tween).is_valid():
			(t as Tween).play()
	var png := out_dir.path_join("%s-%s.png" % [layout, name])
	var err := img.save_png(png)
	var vp_size := get_viewport().get_visible_rect().size
	var scale := Vector2(img.get_width() / vp_size.x, img.get_height() / vp_size.y)
	var boxes := _text_boxes(scale)
	var jf := FileAccess.open(out_dir.path_join("%s-%s.json" % [layout, name]), FileAccess.WRITE)
	jf.store_string(JSON.stringify({"size": [img.get_width(), img.get_height()], "boxes": boxes}, " "))
	jf.close()
	_say("shot %s (%dx%d, %d boxes, err %d)" % [png, img.get_width(), img.get_height(), boxes.size(), err])


func _g_moving() -> Array:
	"""The G motions (spec 6.2) still running, by name. Empty in classic. While the month
	plays, only the fades that change text alpha count: each workday moves doom, so the arc,
	the room and a tier icon may ease again every day, and waiting for them would let the
	month run on past the state being shot."""
	var out: Array = []
	var d := _desk()
	if d == null:
		return out
	var playing := _phase() != "ACTION_SELECTION"
	for k in ["actions_panel", "plan_panel", "upgrades_panel"]:
		var sh = d.get(k)
		if sh != null and bool(sh.call("opening")):
			out.append(k)
	for k in ["feed_panel", "playback_bar"]:
		var part = d.get(k)
		if part != null and bool(d.call("view_fading", part)):
			out.append(k)
	var dlg = _main_ui.get("active_dialog")
	if dlg is Control and is_instance_valid(dlg) and dlg.has_meta("g_arrive"):
		var pt = dlg.get_meta("g_arrive")
		if pt is Tween and (pt as Tween).is_valid() and (pt as Tween).is_running():
			out.append("paper")
	if playing:
		return out
	var dc = d.get("doom_card")
	if dc != null and bool(dc.call("arc_tweening")):
		out.append("arc")
	var room = d.get("room")
	if room != null:
		var rt = room.get("_tween")
		if rt is Tween and (rt as Tween).is_valid() and (rt as Tween).is_running():
			out.append("room")
	var cells = d.get("resource_cells")
	if cells is Dictionary:
		for k in cells:
			if bool((cells[k] as Node).call("is_fading")):
				out.append("tier_" + String(k))
	return out


func _settle_motion() -> void:
	var t0 := Time.get_ticks_msec()
	var moving := _g_moving()
	while not moving.is_empty() and Time.get_ticks_msec() - t0 < 5000:
		await _frames(1)
		moving = _g_moving()
	if not moving.is_empty():
		_say("note: still moving at the shot: %s" % str(moving))


func _late_band_shot() -> void:
	"""12.3 state 6: late game, a band 5 room, reached with today's debug doom nudge (PageUp,
	main_ui._input, debug builds only). It writes game state, so it runs only in shots mode,
	after the hash. main_ui's nudge refreshes classic's own UI by calling its handler, not by
	the game's state signal, so the G desk is handed the same state the same way."""
	for _i in range(5):
		var cont := _visible_button("Continue")
		if cont == null:
			break
		cont.pressed.emit()
		await _frames(5)
	await _close_g_sheets()
	for _i in range(12):
		if ThemeManager.get_doom_band_index(float(GameManager.state.doom)) >= 5:
			break
		await _key(KEY_PAGEUP)
		var d := _desk()
		if d != null:
			d.call("_on_state", GameManager.get_game_state())
	var band := ThemeManager.get_doom_band_index(float(GameManager.state.doom))
	_check(band == 5, "late game: doom %.1f is in band index 5 (got %d)" % [float(GameManager.state.doom), band])
	await _frames(10)
	await _shot("15_late_band5")


func _hold_pulses() -> Array:
	"""Pause the desk's pulse tweens and put their nodes at full alpha. Presentation only."""
	var out: Array = []
	var d := _desk()
	if d == null:
		return out
	var ap = d.get("actions_panel")
	for pair in [[d.get("_advisor_pulse"), d.get("plate_actions")],
			[ap.get("_hint_tween") if ap != null else null, ap.get("_hint_row") if ap != null else null]]:
		var t = pair[0]
		if t is Tween and (t as Tween).is_valid() and (t as Tween).is_running():
			(t as Tween).pause()
			out.append(t)
			if pair[1] is CanvasItem and is_instance_valid(pair[1]):
				(pair[1] as CanvasItem).modulate.a = 1.0
	return out


func _text_boxes(scale: Vector2) -> Array:
	var out: Array = []
	_collect(get_tree().root, scale, out)
	return out


func _collect(n: Node, scale: Vector2, out: Array) -> void:
	if n is CanvasItem and not (n as CanvasItem).is_visible_in_tree():
		return
	if n is Control:
		var c := n as Control
		var text := ""
		if c is RichTextLabel:
			text = (c as RichTextLabel).get_parsed_text()
		elif c is Label:
			text = (c as Label).text
		elif c is Button:
			text = (c as Button).text
		text = text.strip_edges()
		if text != "" and _alpha(c) > 0.05:
			var r: Rect2 = c.get_global_transform_with_canvas() * Rect2(Vector2.ZERO, c.size)
			# Only what is on screen: a row scrolled out of a ScrollContainer (or any ancestor
			# that clips its contents) is cut to its visible part, or left out when none shows.
			var vis := _visible_part(c, r)
			if vis.size.x >= 1.0 and vis.size.y >= 1.0:
				var box := {
					"x": vis.position.x * scale.x, "y": vis.position.y * scale.y,
					"w": vis.size.x * scale.x, "h": vis.size.y * scale.y,
					"text": text.substr(0, 80), "node": String(c.get_path()),
				}
				if vis != r:
					box["clipped"] = true
					box["full_h"] = r.size.y * scale.y
				out.append(box)
	if n.has_method("get_text_boxes"):
		for b in n.call("get_text_boxes"):
			out.append(b)
	for ch in n.get_children():
		_collect(ch, scale, out)


func _visible_part(c: Control, r: Rect2) -> Rect2:
	var vis := r
	var n: Node = c.get_parent()
	while n != null:
		if n is Control and (n as Control).clip_contents:
			var pc := n as Control
			var pr: Rect2 = pc.get_global_transform_with_canvas() * Rect2(Vector2.ZERO, pc.size)
			vis = vis.intersection(pr)
			if vis.size.x <= 0.0 or vis.size.y <= 0.0:
				return Rect2()
		n = n.get_parent()
	return vis


func _alpha(c: CanvasItem) -> float:
	var a := 1.0
	var n: Node = c
	while n != null:
		if n is CanvasItem:
			a *= (n as CanvasItem).modulate.a
		n = n.get_parent()
	return a * c.self_modulate.a

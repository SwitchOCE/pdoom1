extends GutTest
## Commit plate parity (fork/design/godot-g/spec.md 5.6, V1; 12.2 "1a").
##
## The G desk draws ONE Commit plate for today's two buttons. It must run exactly today's
## path for each branch:
##   * queue not empty -> the plate click == a press of the classic EndTurnButton
##     ("COMMIT THE MONTH >", main_ui._on_end_turn_button_pressed);
##   * queue empty     -> the plate click == a press of the classic CommitPlanButton
##     ("Plan (Enter)", main_ui._on_commit_plan_button_pressed).
## "The same" = the same feed lines from the press and the same hash of the full game state
## (GameState.to_dict() carries the RNG state, so an extra draw would show).
##
## Each branch boots main.tscn twice on one seed -- classic (GPrefs.desk off) and G -- and
## compares. The run is booted fresh each time (start_new_game force, as _boot_game does).

const MAIN_SCENE := "res://scenes/main.tscn"
const SEED := "g-commit-parity"

var _prev_seed: String
var _prev_layout: String


func before_all() -> void:
	_prev_seed = GameConfig.game_seed
	_prev_layout = GameConfig.ui_layout


func after_all() -> void:
	GameConfig.game_seed = _prev_seed
	GameConfig.ui_layout = _prev_layout
	GPrefs.reload_prefs()


func after_each() -> void:
	await _stop_playback()


func _stop_playback() -> void:
	"""End the committed month's playback loop and let its pending day-tick coroutine see the
	flag and exit, so it can never tick the NEXT boot's run."""
	GameManager.month_playback_active = false
	await get_tree().create_timer(GameManager.day_tick_seconds + 0.1, false).timeout


func _boot(desk_on: bool) -> Dictionary:
	GameConfig.game_seed = SEED
	GameConfig.ui_layout = "classic"
	GPrefs.set_desk(desk_on, false)
	var root: Node = load(MAIN_SCENE).instantiate()
	add_child_autofree(root)
	var main_ui: Node = root.find_child("MainUI", true, false)
	for _i in range(120):
		await get_tree().process_frame
		if GameManager.is_initialized and String(main_ui.current_turn_phase).to_upper() == "ACTION_SELECTION" \
				and GameManager.state != null and String(GameManager.state.game_seed_str) == SEED:
			break
	# The run's baseline simulation runs on its own thread and writes VerificationTracker from
	# there (pre-existing). Pressing while it runs races that thread and can raise an engine
	# error, so wait until it has finished, then harvest it (joins the thread and caches the
	# result, so the next boot on this seed starts no new thread).
	for _i in range(600):
		if not BaselineSimulator._is_computing:
			break
		await get_tree().process_frame
	BaselineSimulator._wait_for_background()   # join it, even if an earlier suite started it
	BaselineSimulator.get_baseline_score_if_ready(SEED)
	await get_tree().process_frame
	return {"root": root, "main_ui": main_ui}


static func state_hash() -> String:
	return JSON.stringify(GameManager.state.to_dict(), "", true, true).sha256_text()


func _slot_for(main_ui: Node, action_id: String) -> int:
	for child in main_ui.actions_list.get_children():
		if child is Container:
			var buttons: Array = child.get_children()
			for i in range(buttons.size()):
				var b = buttons[i]
				if b is Button and String(b.get_meta("action_id", "")) == action_id:
					return i
			break
	return -1


func _queue_buy_compute(main_ui: Node) -> void:
	var slot := _slot_for(main_ui, "buy_compute")
	assert_gt(slot, -1, "the Purchase Compute slot exists")
	var before: int = main_ui.plan_controller.queue_size()
	main_ui._trigger_action_by_index(slot)
	assert_eq(main_ui.plan_controller.queue_size(), before + 1, "the play was queued")


func _feed_texts(main_ui: Node, from: int) -> Array:
	var out := []
	var lines: Array = main_ui._feed_lines
	for i in range(from, lines.size()):
		out.append(String(lines[i].get("text", "")))
	return out


func _run(desk_on: bool, queue_one: bool) -> Dictionary:
	var b: Dictionary = await _boot(desk_on)
	var main_ui: Node = b.main_ui
	assert_eq(main_ui.get("_ui_layout"), "g" if desk_on else "classic", "layout under test")
	assert_eq(String(GameManager.state.game_seed_str), SEED, "seed under test")
	if queue_one:
		_queue_buy_compute(main_ui)
	var hash_before := state_hash()
	var feed_from: int = main_ui._feed_lines.size()
	if desk_on:
		var desk = main_ui.get_g_desk()
		assert_eq(desk.commit_path, "end_turn" if queue_one else "commit_plan",
			"the plate names the path it will run")
		var key: String = desk.commit_keycap_label.text
		assert_eq(key, KeybindManager.get_key_name("end_turn" if queue_one else "commit_plan"),
			"the keycap names the key that runs the same path")
		desk.commit_plate.pressed.emit()
	else:
		var btn: Button = main_ui.end_turn_button if queue_one else main_ui.commit_plan_button
		assert_false(btn.disabled, "the classic button is enabled for this branch")
		btn.pressed.emit()
	var out := {
		"hash_before": hash_before,
		"hash_after": state_hash(),
		"feed": _feed_texts(main_ui, feed_from),
		"mode": main_ui.screen_mode.current_mode,
	}
	await _stop_playback()
	b.root.queue_free()
	await get_tree().process_frame
	return out


func test_plate_with_queue_matches_classic_end_turn_button() -> void:
	var classic: Dictionary = await _run(false, true)
	var g: Dictionary = await _run(true, true)
	assert_eq(g.hash_before, classic.hash_before, "same state before the press")
	assert_ne(classic.hash_after, classic.hash_before, "the press committed something")
	assert_eq(g.hash_after, classic.hash_after, "same state hash after the press")
	assert_eq(g.feed, classic.feed, "same feed lines from the press")
	assert_eq(g.mode, classic.mode, "both land in the same view")


func test_plate_with_empty_queue_matches_classic_commit_plan_button() -> void:
	var classic: Dictionary = await _run(false, false)
	var g: Dictionary = await _run(true, false)
	assert_eq(g.hash_before, classic.hash_before, "same state before the press")
	assert_ne(classic.hash_after, classic.hash_before, "the press committed something")
	assert_eq(g.hash_after, classic.hash_after, "same state hash after the press")
	assert_eq(g.feed, classic.feed, "same feed lines from the press")


func test_plate_is_inert_outside_the_plan_phase() -> void:
	var b: Dictionary = await _boot(true)
	var main_ui: Node = b.main_ui
	var desk = main_ui.get_g_desk()
	desk.commit_plate.pressed.emit()   # empty queue -> today's Enter path
	assert_ne(String(main_ui.current_turn_phase).to_upper(), "ACTION_SELECTION", "month in play")
	var h := state_hash()
	desk.press_commit_plate()
	assert_eq(desk.commit_path, "", "no path while the month plays")
	assert_true(desk.commit_plate.disabled, "the plate is inert")
	assert_eq(state_hash(), h, "a click while the month plays changes nothing")

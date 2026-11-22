extends GutTest
## G desk phase 1c (fork/design/godot-g/spec.md 12.2 "1c"): WATCH.
##   * workday N of M against Clock;
##   * held hours = the remaining reserve (state["attention_reserved"]), not the allocation;
##   * the closed face with and without a pre-boundary snapshot;
##   * the opening hold read after the commit handler returns, not 0 (R2-4);
##   * a boundary event followed by the review: W3 then W4, current_event cleared after each
##     close, both close paths (R2-4);
##   * the card's summary line for equal, free, differing, self-priced (option_verbs) and
##     non-window events (R2-5);
##   * each WATCH sub-state W1-W4 (banner, Attention card, Commit, rail);
##   * the feed: folding, the full log, a filter toggle; the doom feed line hidden in G and
##     shown in classic (Alex's Q2).

const MAIN_SCENE := "res://scenes/main.tscn"
const SEED := "g-watch-1c"

var _prev_hint: bool
var _prev_seed: String
var _root: Node = null


func before_each() -> void:
	_prev_hint = GameConfig.show_first_lever_hint
	_prev_seed = GameConfig.game_seed
	GameConfig.show_first_lever_hint = false


func after_each() -> void:
	GameConfig.show_first_lever_hint = _prev_hint
	GameConfig.game_seed = _prev_seed
	GAdvisorNote.plain_dismissed_this_session = false
	GPrefs.reload_prefs()
	await _stop_playback()


func _stop_playback() -> void:
	"""End any committed month's playback loop and let its pending tick see the flag."""
	GameManager.month_playback_active = false
	await get_tree().create_timer(GameManager.day_tick_seconds + 0.1, false).timeout


# --- helpers -----------------------------------------------------------------------------

func _boot(desk_on: bool = true) -> Node:
	GameConfig.game_seed = SEED
	GPrefs.set_desk(desk_on, false)
	var root: Node = load(MAIN_SCENE).instantiate()
	add_child_autofree(root)
	_root = root
	var main_ui: Node = root.find_child("MainUI", true, false)
	for _i in range(120):
		await get_tree().process_frame
		if GameManager.is_initialized and String(main_ui.current_turn_phase).to_upper() == "ACTION_SELECTION":
			break
	# The baseline simulation thread writes VerificationTracker (pre-existing); wait for it
	# and join it before any commit, as the commit parity tests do.
	for _i in range(600):
		if not BaselineSimulator._is_computing:
			break
		await get_tree().process_frame
	BaselineSimulator._wait_for_background()
	await _frames(2)
	return main_ui


func _frames(n: int = 2) -> void:
	for _i in range(n):
		await get_tree().process_frame


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


func _commit_one_play(main_ui: Node) -> void:
	"""Queue Purchase Compute (no hours) and press the Commit plate (today's Space path)."""
	var slot := _slot_for(main_ui, "buy_compute")
	assert_gt(slot, -1, "the Purchase Compute slot exists")
	main_ui._trigger_action_by_index(slot)
	var desk = main_ui.get_g_desk()
	assert_eq(desk.commit_path, "end_turn", "the plate runs the Space path")
	desk.commit_plate.pressed.emit()
	# Hold the month still for the checks (no day tick, so no event can arrive): the playback
	# loop sees the flag when its first tick timer fires and stops.
	GameManager.month_playback_active = false


func _window_event(id: String, extra: Dictionary = {}) -> Dictionary:
	var ev := {"id": id, "name": "Test window %s" % id, "description": "A test window.",
		"type": "popup", "options": [
			{"id": "a", "text": "Handle it", "costs": {"money": 1000}, "effects": {}},
			{"id": "b", "text": "Let it go", "costs": {}, "effects": {}},
		]}
	ev.merge(extra, true)
	return WindowResolver.present_for_dialog(ev)


func _review_event(label: String) -> Dictionary:
	return {
		"id": "__month_review__", "name": "Month Review -- %s" % label, "type": "popup",
		"description": "%s begins." % label,
		"options": [{"id": "begin_planning", "text": "Begin planning %s" % label, "costs": {}, "effects": {}}],
		"review": {"heading": "Month Review", "period": label, "lede": "%s begins." % label,
			"attention": "Attention: 20 fresh decisions this month.",
			"movement_title": "Last month's movement", "movement": [],
			"rivals_title": "Rivals this month", "rivals": [], "closing": ""},
	}


func _answer_shown(ed) -> void:
	"""The answer path's close (report_choice_result on success), without resolving the test
	event in the real game."""
	ed._pending_dialog = ed._showing_dialog
	ed._pending_event = ed.current_event
	ed.report_choice_result(true, "")


# --- workday N of M -----------------------------------------------------------------------

func test_workday_n_of_m_against_clock() -> void:
	var sy := 2017
	var sm := 7
	var sd := 4
	# Brute force over 14 months of turns: N = position of the turn among the turns of its
	# calendar month, M = their count.
	var by_month: Dictionary = {}
	for t in range(0, 320):
		var mi := Clock.month_index(t, sy, sm, sd)
		if not by_month.has(mi):
			by_month[mi] = []
		by_month[mi].append(t)
	var checked := 0
	for mi in by_month:
		var turns: Array = by_month[mi]
		if turns[-1] == 319:
			continue   # a month cut off by the scan
		for i in range(turns.size()):
			var nm := GDesk.workday_of_month(int(turns[i]), sy, sm, sd)
			assert_eq(nm, Vector2i(i + 1, turns.size()), "turn %d" % int(turns[i]))
			checked += 1
	assert_gt(checked, 250, "a year of workdays checked")
	# July 2017 from Tue 4 Jul: 20 workdays (4-7, 10-14, 17-21, 24-28, 31).
	assert_eq(GDesk.workday_of_month(0, sy, sm, sd), Vector2i(1, 20), "the run's first day")


# --- held hours ----------------------------------------------------------------------------

func test_held_hours_are_the_remaining_reserve_not_the_allocation() -> void:
	var mp := MonthPlan.new()
	mp.attention_total = 20
	mp.attention_spent = 3
	mp.attention_reserved = 17
	mp.reserve_used = 5
	assert_eq(mp.reserve_remaining(), 12, "17 held, 5 used by events")
	var st := {"attention_reserved": mp.reserve_remaining(), "month_plan": mp.to_dict(),
		"safety_researchers": 2, "capability_researchers": 0, "compute_engineers": 1, "managers": 0}
	assert_eq(GAttentionCard.held_left(st), 12)
	var card := GAttentionCard.new()
	add_child_autofree(card)
	card.set_face("watch")
	card.update_watch_face(st, {"hold": 17, "spent": 3}, "")
	assert_eq(card.held_text(), "12 left", "the remaining reserve, not the 17 allocated")
	assert_eq(card._held_cells.get_child_count(), 17, "one cell per hour held at Commit")
	var lit := 0
	for c in card._held_cells.get_children():
		if (c as ColorRect).color.a > 0.5:
			lit += 1
	assert_eq(lit, 12, "the cells still held are lit")
	assert_eq(card.spent_text(), "Spent at Commit: 3 hr")
	assert_eq(card._header_total.text, "held after Commit")
	assert_string_contains(card.staff_text(), "Safety  2")
	assert_string_contains(card.staff_text(), "Compute  1")
	assert_false(card.staff_text().contains("Managers"), "roles with nobody are left out")
	assert_eq(card.reply_text(), "", "no reply line outside W3")


# --- the closed face ------------------------------------------------------------------------

func test_closed_face_with_and_without_a_pre_boundary_snapshot() -> void:
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	var st: Dictionary = main_ui._last_state.duplicate(true)
	var mi := GDesk.month_index_of(st)
	# The month played: 17 held at Commit, 5 left on its last day.
	desk.opening_hold = {"mi": mi, "hold": 17, "spent": 3}
	desk.month_snapshot = {"mi": mi, "held": 5, "label": "July"}
	# The boundary opens the next month before the review shows: a state of August.
	var next := st.duplicate(true)
	var t := int(st.turn)
	while Clock.month_index(t, int(st.start_year), int(st.start_month), int(st.start_day)) == mi:
		t += 1
	next["turn"] = t
	next["attention_reserved"] = 0
	desk._on_state(next)
	assert_eq(desk.month_snapshot.held, 5, "a state of the next month leaves the snapshot alone")
	var ed = main_ui.event_dialog
	ed.present(_review_event("August 2017"))
	await _frames(3)
	assert_eq(desk.watch_state(), "W4")
	assert_eq(desk.attention_card.face, "closed")
	assert_eq(desk.attention_card.closed_lines(),
		["July, closed", "Used on events  12 hr", "Unspent, evaporated  5 hr"],
		"used = opening hold - last held; unspent = last held")
	# No snapshot (a load, or a layout flip during the review): only "<Month>, closed".
	desk.opening_hold = {}
	desk.month_snapshot = {}
	desk._refresh_watch()
	assert_eq(desk.attention_card.closed_lines(), ["July, closed"])
	# A real flip during the review: the new desk has no snapshot either.
	main_ui._toggle_ui_layout()
	var guard := 0
	while main_ui.get("_ui_layout") != "g" and guard < 3:
		main_ui._toggle_ui_layout()
		guard += 1
	var desk2 = main_ui.get_g_desk()
	desk2._on_state(next)
	await _frames(2)
	assert_eq(desk2.watch_state(), "W4", "the review is still up after the flip")
	assert_eq(desk2.attention_card.closed_lines(), ["July, closed"], "flip during the review: no counts")
	ed._showing_dialog.queue_free()
	await _frames(2)


# --- the opening hold (R2-4) -----------------------------------------------------------------

func test_opening_hold_is_read_after_the_commit_handler_returns() -> void:
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	var at_signal := []
	var probe := func(phase: String) -> void:
		if phase == "turn_end":
			at_signal.append(GameManager.state.get_reserve_attention())
	GameManager.turn_phase_changed.connect(probe)
	_commit_one_play(main_ui)
	GameManager.turn_phase_changed.disconnect(probe)
	await _frames(2)
	assert_eq(at_signal, [0], "at turn_end the month's reserve is not set yet (end_month sets it later)")
	var hold: int = int(desk.opening_hold.get("hold", -1))
	assert_gt(hold, 0, "the opening hold is not 0")
	assert_eq(hold, int(GameManager.state.month_plan.attention_total) - int(desk.opening_hold.spent),
		"every hour not spent at Commit is held")
	assert_eq(desk.opening_hold.spent, int(GameManager.state.month_plan.attention_spent))
	assert_eq(desk.watch_state(), "W2")
	assert_eq(desk.attention_card.face, "watch")
	assert_eq(desk.attention_card.held_text(), "%d left" % GameManager.state.get_reserve_attention())
	assert_eq(desk.attention_card.spent_text(), "Spent at Commit: %d hr" % int(desk.opening_hold.spent))
	# The doom line this commit logged (Alex's Q2): in the model, not in G's feed.
	var logged := false
	for e in main_ui._feed_lines:
		if GFeedPanel.plain(String(e.text)).contains("(change:"):
			logged = true
	assert_true(logged, "today's game logged its doom line")
	desk.feed_panel.render_now()
	assert_true(desk.feed_panel.visible, "the commit put the view in WATCH")
	assert_false(desk.feed_panel.plain_text().contains("(change:"), "G's feed does not show it")
	assert_gt(desk.feed_panel.hidden_count(), 0)


# --- the summary line (R2-5) -----------------------------------------------------------------

func test_reply_summary_for_equal_free_differing_self_priced_and_non_window_events() -> void:
	var equal := _window_event("eq", {"unignorable": true, "window": {"attention_cost": 2}})
	assert_eq(GAttentionCard.reply_summary(equal), "This reply costs 2 hr", "equal")
	var free := _window_event("free", {"unignorable": true, "window": {"attention_cost": 0}})
	assert_eq(GAttentionCard.reply_summary(free), "Replies to this cost no hours", "free")
	var differing := _window_event("diff")   # a legacy popup: its free-out pays no hours
	assert_eq(int(EventDialog.costs_with_window_attention(differing, differing.options[0]).get("attention", 0)), 1)
	assert_eq(int(EventDialog.costs_with_window_attention(differing, differing.options[1]).get("attention", 0)), 0)
	assert_eq(GAttentionCard.reply_summary(differing), "", "differing: no line")
	var own := _window_event("own", {"unignorable": true})
	own.options[0]["costs"] = {"attention": 3}   # an option that prices its own hours
	assert_eq(GAttentionCard.reply_summary(own), "", "an option's own price differs: no line")
	var verbs := _window_event("verbs", {"window": {"option_verbs": {"a": "handle_reserve", "b": "ignore"}}})
	assert_eq(GAttentionCard.reply_summary(verbs), "", "self-priced (option_verbs): no line")
	var raw := {"id": "plain", "options": [{"id": "a", "costs": {}}, {"id": "b", "costs": {}}]}
	assert_eq(GAttentionCard.reply_summary(raw), "", "not a window (no display stamp): no line")
	assert_eq(GAttentionCard.reply_summary(_review_event("August 2017")), "", "the review: no line")
	assert_eq(GAttentionCard.reply_summary({}), "")


# --- the four sub-states, a boundary event then the review -------------------------------------

func test_each_watch_sub_state_and_an_event_then_the_review() -> void:
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	var ed = main_ui.event_dialog
	assert_eq(desk.watch_state(), "plan")
	assert_false(desk.playback_bar.visible, "PLAN view: no playback bar")
	# W1: the V peek before Commit.
	var slot := _slot_for(main_ui, "buy_compute")
	main_ui._trigger_action_by_index(slot)
	main_ui.screen_mode.toggle_mode()
	await _frames()
	assert_eq(desk.watch_state(), "W1")
	assert_eq(desk.mode_label.text, "## WATCH")
	assert_true(desk.playback_bar.visible)
	assert_eq(desk.playback_text(), "not committed yet")
	assert_eq(desk.workday_cells()[0] + desk.workday_cells()[1], 0, "bar empty")
	assert_eq(desk.attention_card.face, "plan", "W1: the PLAN face")
	assert_eq(desk.commit_path, "end_turn", "W1: Commit as in PLAN")
	assert_true(desk.commit_keycap.visible)
	assert_true(desk.held_plate.visible, "W1: the held plate as in PLAN")
	assert_false(desk.plate_actions.disabled, "W1: the rail as in PLAN")
	main_ui.screen_mode.toggle_mode()
	await _frames()
	# W2: playback.
	desk.commit_plate.pressed.emit()
	GameManager.month_playback_active = false   # hold the month still for the checks below
	await _frames(2)
	assert_eq(desk.watch_state(), "W2")
	var st: Dictionary = desk._last_state
	var nm := GDesk.workday_of_month(int(st.turn), int(st.start_year), int(st.start_month), int(st.start_day))
	assert_eq(desk.playback_text(), "workday %d of %d" % [nm.x, nm.y], "workday N of M from Clock")
	assert_eq(desk.workday_cells(), [nm.x - 1, 1, nm.y - nm.x], "played, today, ahead")
	assert_eq(desk.attention_card.face, "watch")
	assert_eq(desk.commit_caption.text, "MONTH IN PLAY")
	assert_true(desk.commit_plate.disabled, "inert")
	assert_false(desk.commit_keycap.visible)
	assert_false(desk.held_plate.visible, "the card carries the hold now")
	assert_true(desk.plate_actions.disabled and desk.plate_upgrades.disabled, "ACTIONS, UPGRADES rest")
	assert_false(desk.plate_actions.keycap_shown())
	assert_true(desk.plate_staff.keycap_shown(), "Staff keeps its key")
	assert_eq(desk.ink_of(desk.speed_pause), GDesk.C.dim, "|| unlit")
	# The speed segments run today's dial.
	var before: float = GameManager.day_tick_seconds
	desk.speed_buttons["4x"].pressed.emit()
	assert_almost_eq(GameManager.day_tick_seconds, 0.05, 0.0001, "4x is today's 0.05 s")
	assert_eq(desk.speed_buttons["4x"].theme_type_variation, &"GSegmentOn", "and is lit")
	main_ui.screen_mode.speed_changed.emit(before)
	# W3: an event waits (a boundary event, with the review queued behind it).
	var closed_seen: Array = []
	var on_closed := func() -> void:
		closed_seen.append(ed.current_event.duplicate())
	ed.dialog_closed.connect(on_closed)
	var ev := _window_event("boundary", {"unignorable": true})
	ed.present(ev)
	ed.present(_review_event("August 2017"))
	await _frames(2)
	assert_eq(String(ed.current_event.get("id", "")), "boundary", "current_event is the event on screen")
	assert_eq(desk.watch_state(), "W3")
	assert_eq(desk.ink_of(desk.speed_pause), GDesk.C.amber, "|| lit while the event waits")
	assert_true(desk.view_watch_button.disabled, "the view switch is inert")
	assert_false(desk.view_keycap.visible)
	assert_eq(desk.attention_card.reply_text(), "This reply costs 1 hr", "the card's summary line")
	assert_true(desk.commit_plate.disabled and not desk.commit_keycap.visible, "Commit inert, no keycap")
	assert_false(desk.plate_staff.keycap_shown(), "keycaps hidden under the event")
	# Answer it (the answer path): current_event is cleared before dialog_closed.
	_answer_shown(ed)
	assert_eq(closed_seen.size(), 1)
	assert_true(closed_seen[0].is_empty(), "answer path: cleared before dialog_closed")
	await _frames(4)
	# W4: the review.
	assert_true(MonthReviewPanel.is_month_review(ed.current_event), "the review is on screen")
	assert_eq(desk.watch_state(), "W4")
	assert_eq(desk.commit_caption.text, "MONTH COMPLETE")
	assert_true(desk.commit_plate.disabled)
	assert_string_ends_with(desk.playback_text(), " played out")
	assert_eq(desk.workday_cells()[1] + desk.workday_cells()[2], 0, "bar full")
	assert_eq(desk.attention_card.face, "closed")
	# Close it from outside (the external teardown path).
	ed._showing_dialog.queue_free()
	await _frames(3)
	assert_eq(closed_seen.size(), 2)
	assert_true(closed_seen[1].is_empty(), "teardown path: cleared before dialog_closed")
	assert_true(ed.current_event.is_empty())
	assert_eq(desk.watch_state(), "W2", "back to playback once nothing waits")
	ed.dialog_closed.disconnect(on_closed)


func test_current_event_standalone_both_close_paths() -> void:
	var ed := EventDialog.new()
	ed.state_provider = func() -> Dictionary: return {"money": 1e9}
	add_child_autofree(ed)
	var seen: Array = []
	ed.dialog_closed.connect(func() -> void: seen.append(ed.current_event.duplicate()))
	ed.present(_window_event("one"))
	await _frames(2)
	assert_eq(String(ed.current_event.get("id", "")), "one")
	_answer_shown(ed)
	assert_eq(seen, [{}], "answer path")
	ed.present(_window_event("two"))
	await _frames(2)
	assert_eq(String(ed.current_event.get("id", "")), "two")
	ed._showing_dialog.queue_free()
	await _frames(2)
	assert_eq(seen, [{}, {}], "teardown path")


# --- the feed ----------------------------------------------------------------------------------

func test_doom_rule_on_each_kind_of_line() -> void:
	var stamp := "[color=gray][Jul 4, 2017][/color] "
	var hide := [
		"[color=lime]Doom 12.0 -> 12.9 (change: +0.9)\n  `- Panic: +0.5\n  `- Momentum: doom spiral (1.2)[/color]",
		"[color=lime]Doom +2.0 (legacy calculation)[/color]",
		"[color=white]  Safety/alignment work reduced doom by 1.2[/color]",
		"[color=white]  Capabilities research added 0.5 doom[/color]",
		"[color=gray][debug] doom +5 -> 12.0%[/color]",
		"[color=gray]  `- delta[/color] [color=red]doom +3.0[/color]",
	]
	for t in hide:
		assert_eq(GFeedPanel.display_text(stamp + t), "", "hidden: %s" % t)
	var cut := {
		"[color=gray]  `- delta[/color] [color=lime]money +$20k[/color], [color=red]doom +3.0[/color]":
			"[color=gray]  `- delta[/color] [color=lime]money +$20k[/color]",
		"[color=gray]  `- delta[/color] [color=red]doom +3.0[/color], [color=lime]money +$20k[/color]":
			"[color=gray]  `- delta[/color] [color=lime]money +$20k[/color]",
		"[color=white]  WARNING: Research leak detected! (+1.5 doom)[/color]":
			"[color=white]  WARNING: Research leak detected![/color]",
		"[color=lime]Alignment tax debate affects team morale (-3 reputation, +2 doom)[/color]":
			"[color=lime]Alignment tax debate affects team morale (-3 reputation)[/color]",
		"[color=lime][RISK] Capabilities event (severe): +9.0 doom[/color]":
			"[color=lime][RISK] Capabilities event (severe)[/color]",
		"[color=white]  WARNING: Ledger fallout ('x'): unpaid $5,000, +1.0 doom, -2.0 reputation[/color]":
			"[color=white]  WARNING: Ledger fallout ('x'): unpaid $5,000, -2.0 reputation[/color]",
	}
	for t in cut:
		assert_eq(GFeedPanel.display_text(stamp + t), stamp + String(cut[t]), "doom part cut: %s" % t)
	var keep := [
		"[color=red][!]CRITICAL: Doom at 85.0% (Critical) - Very close to game over![/color]",
		"[color=magenta]Turn Phase: turn_end[/color]",
		"[color=gold]VICTORY! p(doom) reached 0![/color]",
		"[color=gray]FEED | arxiv -- New paper on doom scenarios[/color]",
	]
	for t in keep:
		assert_eq(GFeedPanel.display_text(stamp + t), stamp + t, "kept: %s" % t)


func test_doom_feed_line_is_hidden_in_g_and_shown_in_classic() -> void:
	var line := "[color=lime]Doom 12.0 -> 12.9 (change: +0.9)[/color]"
	var main_ui: Node = await _boot(true)
	var desk = main_ui.get_g_desk()
	main_ui.screen_mode.toggle_mode()
	main_ui.log_message(line)
	main_ui.log_message("[color=cyan]after the doom line[/color]")
	await _frames(3)
	assert_true(String(main_ui._feed_lines[-2].text).contains("Doom 12.0 -> 12.9"), "main_ui logs it unchanged")
	assert_false(desk.feed_panel.plain_text().contains("Doom 12.0"), "G's feed hides it")
	assert_string_contains(desk.feed_panel.plain_text(), "after the doom line")
	desk.feed_panel.set_expanded(true)
	assert_false(desk.feed_panel.plain_text().contains("Doom 12.0"), "the full log hides it too")
	desk.feed_panel.set_expanded(false)
	main_ui.screen_mode.toggle_mode()
	_root.queue_free()
	await _frames(2)
	var classic: Node = await _boot(false)
	assert_null(classic.get_g_desk(), "classic layout")
	classic.log_message(line)
	await _frames(2)
	assert_string_contains(classic.message_log.text, "Doom 12.0 -> 12.9 (change: +0.9)", "classic's feed shows it")


func test_phase_trace_is_left_out_of_g_and_kept_in_classic() -> void:
	var line := "[color=magenta]Turn Phase: turn_start[/color]"
	assert_true(GFeedPanel.is_phase_line(line))
	assert_false(GFeedPanel.is_phase_line("[color=cyan]Phase of the moon[/color]"))
	var main_ui: Node = await _boot(true)
	var desk = main_ui.get_g_desk()
	main_ui.screen_mode.toggle_mode()
	main_ui.log_message(line)
	main_ui.log_message("[color=cyan]after the phase line[/color]")
	await _frames(3)
	assert_false(desk.feed_panel.plain_text().contains("Turn Phase"), "G's feed leaves it out")
	assert_string_contains(desk.feed_panel.plain_text(), "after the phase line")
	desk.feed_panel.set_expanded(true)
	assert_false(desk.feed_panel.plain_text().contains("Turn Phase"), "the full log too")
	desk.feed_panel.set_expanded(false)
	main_ui.screen_mode.toggle_mode()
	_root.queue_free()
	await _frames(2)
	var classic: Node = await _boot(false)
	classic.log_message(line)
	await _frames(2)
	assert_string_contains(classic.message_log.text, "Turn Phase: turn_start", "classic's feed keeps it")


func test_feed_names_the_choice_instead_of_its_id_in_g_only() -> void:
	var main_ui: Node = await _boot(true)
	var desk = main_ui.get_g_desk()
	main_ui.screen_mode.toggle_mode()
	var fp = desk.feed_panel
	fp.note_event({"options": [{"id": "respond_publicly", "text": "Respond Publicly"}]})
	main_ui.log_message("[color=cyan]Event choice: respond_publicly[/color]")
	main_ui.log_message("[color=cyan]Event choice: never_shown_id[/color]")
	await _frames(3)
	var text: String = fp.plain_text()
	assert_string_contains(text, "You chose: Respond Publicly", "the option's own text")
	assert_string_contains(text, "You chose: Never Shown Id", "no event seen: the id made readable")
	assert_false(text.contains("Event choice:"), "no raw id line in G")
	# A line keeps the name it was first shown with, even if a later event reuses the id.
	fp.note_event({"options": [{"id": "respond_publicly", "text": "Something Else"}]})
	main_ui.log_message("[color=cyan]after[/color]")
	await _frames(3)
	assert_string_contains(fp.plain_text(), "You chose: Respond Publicly")
	main_ui.screen_mode.toggle_mode()
	_root.queue_free()
	await _frames(2)
	var classic: Node = await _boot(false)
	classic.log_message("[color=cyan]Event choice: respond_publicly[/color]")
	await _frames(2)
	assert_string_contains(classic.message_log.text, "Event choice: respond_publicly", "classic unchanged")


func test_folded_feed_starts_on_a_whole_line() -> void:
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	main_ui.screen_mode.toggle_mode()
	var fp = desk.feed_panel
	await _frames(2)
	var long := "a long line that wraps onto a second line in the feed panel at this width, so rows differ in height"
	for n in range(1, 13):
		var shown: Array = []
		for d in range(n):
			for i in range(3):
				shown.append({"day": "Jul %d, 2017" % (d + 4), "msg": (long if (i + d) % 2 == 0 else "short %d" % i), "raw": ""})
		fp._fill_rows(shown)
		await _frames(4)
		assert_almost_eq(fp.first_row_cut(), 0.0, 0.5, "%d days: the top row is whole" % n)
	# A row that settles taller after the landing (a late wrap) lands the feed again.
	var last_msg: RichTextLabel = fp._rows.get_child(fp._rows.get_child_count() - 1).find_child("Msg", true, false)
	last_msg.text = long + " " + long + " " + long
	await _frames(6)
	assert_almost_eq(fp.first_row_cut(), 0.0, 0.5, "after a row grows, the top row is whole again")
	# So does a change in the view's height.
	fp._scroll.custom_minimum_size.y = fp._scroll.size.y + 37
	await _frames(6)
	assert_almost_eq(fp.first_row_cut(), 0.0, 0.5, "after the view resizes, the top row is whole again")
	fp._scroll.custom_minimum_size.y = 0
	main_ui.screen_mode.toggle_mode()


func test_feed_folds_a_busy_day_and_opens_the_full_log() -> void:
	assert_eq(GFeedPanel.day_name("Jul 4, 2017"), "Tue 4 Jul")
	var shown: Array = []
	for i in range(6):
		shown.append({"day": "Jul 4, 2017", "msg": "a%d" % i, "raw": ""})
	for i in range(2):
		shown.append({"day": "Jul 5, 2017", "msg": "b%d" % i, "raw": ""})
	var rows := GFeedPanel.fold(shown)
	assert_eq(rows.size(), 1 + 4 + 2)
	assert_eq(rows[0].kind, "fold")
	assert_eq(rows[0].count, 2, "6 lines, the newest 4 kept")
	assert_eq(rows[1].msg, "a2")
	assert_eq(rows[5].msg, "b0")
	assert_true(rows[5].first_of_day, "the next day's first line carries its day")
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	main_ui.screen_mode.toggle_mode()
	var fp = desk.feed_panel
	var day: String = GameManager.state.get_formatted_date()
	for i in range(9):
		main_ui.log_message("[color=cyan]busy line %d[/color]" % i)
	await _frames(3)
	var text: String = fp.plain_text()
	assert_string_contains(text, "more lines from %s" % GFeedPanel.day_name(day))
	assert_string_contains(text, "busy line 8")
	assert_false(text.contains("busy line 0"), "older lines of the day are folded")
	assert_true(fp.newest_edge_lit(), "the newest line has the amber edge")
	var top_folded: float = fp.get_global_rect().position.y
	fp._title.pressed.emit()
	await _frames(2)
	assert_true(fp.expanded)
	assert_string_contains(fp.plain_text(), "busy line 0", "the full log has every line")
	assert_lt(fp.get_global_rect().position.y, top_folded, "the full log grows the panel")
	assert_gt(fp.get_global_rect().position.y, desk.rail.get_global_rect().end.y - 1.0, "but stays under the rail")
	fp._toggle_full.pressed.emit()
	await _frames(2)
	assert_false(fp.expanded)
	assert_almost_eq(fp.get_global_rect().position.y, top_folded, 0.5, "folded back to its box")
	# A filter toggle runs today's handler through today's button.
	var was: bool = main_ui._feed_important_only
	main_ui.log_message("flavour probe", "flavour")
	fp.press_filter("feed_filter_button")
	await _frames(3)
	assert_eq(main_ui._feed_important_only, not was, "today's filter flipped")
	assert_eq(main_ui.watch_screen.feed_filter_button.button_pressed, not was, "classic's toggle follows")
	assert_eq(fp.plain_text().contains("flavour probe"), was, "and the G feed follows it")
	assert_string_starts_with(fp._filter_arxiv.text, "[x]" if not was else "[ ]")
	fp.press_filter("feed_filter_button")
	await _frames(2)
	assert_eq(main_ui._feed_important_only, was, "back")
	main_ui.screen_mode.toggle_mode()

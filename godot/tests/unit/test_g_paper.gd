extends GutTest
## G desk phase 2b (fork/design/godot-g/spec.md 12.2 "2b"), on the real main.tscn:
##   * the event paper keeps today's keys (Q W E and the 1 2 3 alias), Esc is swallowed (#452)
##     and the event keeps its priority (PRIORITY_MUST_ANSWER): only the look changes;
##   * the review on paper: today's one-button door, Space and its meta, a `Space` keycap;
##   * classic keeps today's panels;
##   * the advisor note is on paper;
##   * the door submenus and the ledger take the G panel look in G only, every text on the
##     panel at 4.5:1 or more;
##   * GIcons maps the six new ids and the two fallbacks, and each id renders its G texture on
##     each surface where it can appear (R3-3), toned with a colour multiply.

const MAIN_SCENE := "res://scenes/main.tscn"

var _prev_hint: bool
var _prev_baseline: int
var _root: Node = null


func before_each() -> void:
	_prev_hint = GameConfig.show_first_lever_hint
	GameConfig.show_first_lever_hint = false
	# Blind baseline: no background baseline thread per boot. Today's simulator replaces a
	# finished, unjoined thread when the next game starts, and the engine's "Thread object is
	# being destroyed" error then fails whichever test boots next (a flake, see the report).
	_prev_baseline = GameConfig.baseline_mode
	GameConfig.baseline_mode = 2


func after_each() -> void:
	GameConfig.show_first_lever_hint = _prev_hint
	GameConfig.baseline_mode = _prev_baseline
	GAdvisorNote.plain_dismissed_this_session = false
	GAdvisorNote.dismissed_this_session = false
	GPrefs.reload_prefs()
	GameManager.month_playback_active = false


# --- helpers -----------------------------------------------------------------------------

func _boot(desk_on: bool = true) -> Node:
	GPrefs.set_desk(desk_on, false)
	var root: Node = load(MAIN_SCENE).instantiate()
	add_child_autofree(root)
	_root = root
	var main_ui: Node = root.find_child("MainUI", true, false)
	for _i in range(120):
		await get_tree().process_frame
		if GameManager.is_initialized and String(main_ui.current_turn_phase).to_upper() == "ACTION_SELECTION":
			break
	await _frames(2)
	return main_ui


func _frames(n: int = 2) -> void:
	for _i in range(n):
		await get_tree().process_frame


func _press(code: int) -> void:
	var ev := InputEventKey.new()
	ev.keycode = code
	ev.physical_keycode = code
	ev.pressed = true
	get_viewport().push_input(ev)
	var up := ev.duplicate() as InputEventKey
	up.pressed = false
	get_viewport().push_input(up)


func _event(id: String, n_options: int = 3) -> Dictionary:
	var opts: Array = []
	var texts := ["Handle it", "Delegate it", "Let it go"]
	for i in range(n_options):
		opts.append({"id": "opt%d" % i, "text": texts[i % texts.size()],
			"costs": {"money": 1000} if i == 0 else {}, "effects": {}})
	return {"id": id, "name": "Test event %s" % id, "description": "Something needs a reply.",
		"type": "popup", "options": opts}


func _review_event() -> Dictionary:
	return {
		"id": "__month_review__", "name": "Month Review -- August 2017", "type": "popup",
		"description": "August 2017 begins.",
		"options": [{"id": "begin_planning", "text": "Begin planning August 2017", "costs": {}, "effects": {}}],
		"review": {"heading": "Month Review", "period": "August 2017", "lede": "August 2017 begins.",
			"attention": "Attention: 20 fresh decisions this month.", "movement": [], "rivals": [],
			"closing": "Queue this month's actions, then press COMMIT THE MONTH to play the month out."},
	}


func _hold_choices(main_ui: Node, ed) -> Array:
	"""Record choices instead of resolving them in the real game (the dialog stays up)."""
	var seen: Array = []
	if ed.choice_selected.is_connected(main_ui._on_event_choice_selected):
		ed.choice_selected.disconnect(main_ui._on_event_choice_selected)
	ed.choice_selected.connect(func(_ev, cid): seen.append(cid))
	return seen


func _labels(node: Node, out: Array = []) -> Array:
	if node is Label and (node as Label).is_visible_in_tree() and (node as Label).text.strip_edges() != "":
		out.append(node)
	for ch in node.get_children():
		_labels(ch, out)
	return out


# --- the event paper (spec 5.11) ---------------------------------------------------------

func test_event_paper_keeps_todays_keys_esc_and_priority() -> void:
	var main_ui: Node = await _boot()
	var ed = main_ui.event_dialog
	var seen := _hold_choices(main_ui, ed)
	ed.present(_event("keys"))
	await _frames(3)
	var dialog: Control = ed._showing_dialog
	assert_eq(String(dialog.name), "GEventPaper", "the event is on G paper")
	assert_eq(dialog.theme, load(GDesk.THEME_PATH), "the panel carries g_theme.tres (A7)")
	assert_true(dialog.get_theme_stylebox("panel") is StyleBoxTexture, "paper 9-slice")
	assert_eq(main_ui.modal_stack.top_kind(), "event")
	assert_eq(int(main_ui.modal_stack._entries[-1]["priority"]), ModalStack.PRIORITY_MUST_ANSWER,
		"the event keeps PRIORITY_MUST_ANSWER")
	var buttons: Array = main_ui.active_dialog_buttons
	assert_eq(buttons.size(), 3, "today's three buttons, in today's order")
	for i in range(3):
		var kc: Control = (buttons[i] as Button).find_child("Keycap", true, false)
		assert_eq((kc.get_meta("label") as Label).text, DialogKeys.label_for(i), "key tile %d" % i)
	assert_eq(((buttons[0] as Button).find_child("Cost", true, false) as Label).text, "$1,000")
	assert_eq(((buttons[2] as Button).find_child("Cost", true, false) as Label).text, "Free")
	assert_not_null(dialog.find_child("Stamp", true, false), "NEEDS A REPLY stamp")
	# Esc does nothing (#452).
	_press(KEY_ESCAPE)
	await _frames(2)
	assert_true(is_instance_valid(dialog) and dialog.is_inside_tree(), "Esc is swallowed")
	assert_eq(seen, [], "and chose nothing")
	# Nothing else may open over it.
	main_ui._open_submenu("scouting")
	await _frames(2)
	assert_eq(main_ui.modal_stack.top_kind(), "event", "a submenu is refused under the event")
	# Q W E, and 1 2 3 as today's alias.
	for pair in [[KEY_W, "opt1"], [KEY_E, "opt2"], [KEY_Q, "opt0"], [KEY_2, "opt1"], [KEY_3, "opt2"]]:
		_press(pair[0])
		await _frames(1)
		assert_eq(seen[-1] if not seen.is_empty() else "", pair[1], "key %s -> %s" % [pair[0], pair[1]])
	# Enter is not an answer (10.4).
	var n := seen.size()
	_press(KEY_ENTER)
	await _frames(1)
	assert_eq(seen.size(), n, "Enter answers nothing")
	dialog.queue_free()
	await _frames(2)


func test_event_paper_rows_never_fade_and_have_a_footer() -> void:
	var main_ui: Node = await _boot()
	var ed = main_ui.event_dialog
	_hold_choices(main_ui, ed)
	var ev := _event("broke")
	ev["options"][0]["costs"] = {"money": 1e12}
	ed.present(ev)
	await _frames(3)
	var dialog: Control = ed._showing_dialog
	var b0: Button = main_ui.active_dialog_buttons[0]
	assert_true(b0.disabled, "today's affordability: the unaffordable option is disabled")
	assert_eq(b0.modulate, Color.WHITE, "but not faded (G draws it dashed)")
	assert_true(b0.tooltip_text.contains("CANNOT AFFORD"), "today's tooltip kept")
	assert_eq(String(b0.get_meta("g_text")).substr(0, 4), "[Q] ", "today's face is kept as meta")
	var foot: Label = dialog.find_child("InHand", true, false)
	assert_string_starts_with(foot.text, "in hand $")
	assert_null(dialog.find_child("HeldForEvents", true, false), "no held line in the plan phase")
	for l in _labels(dialog):
		var c: Color = (l as Label).get_theme_color("font_color")
		assert_true(c == GDesk.C.ink or c == GDesk.C.paper or c == GPaper.INK_ALERT,
			"'%s' is ink (or a keycap's paper letter)" % (l as Label).text)
	dialog.queue_free()
	await _frames(2)


func test_review_on_paper_keeps_its_door() -> void:
	var main_ui: Node = await _boot()
	var ed = main_ui.event_dialog
	var seen := _hold_choices(main_ui, ed)
	ed.present(_review_event())
	await _frames(3)
	var dialog: Control = ed._showing_dialog
	assert_eq(String(dialog.name), "GReviewPaper")
	# Phase 7: the review arrives with a 0.2 s slide (spec 6.2); its resting place is top 132.
	var arrival = (dialog.get_meta("g_arrive") if dialog.has_meta("g_arrive") else null)
	if arrival is Tween and (arrival as Tween).is_valid():
		(arrival as Tween).custom_step(1.0)
	assert_eq(dialog.size.x, 700.0)
	assert_eq(dialog.position.y, 132.0)
	assert_true(dialog.get_meta("space_advances", false), "B1: Space still opens the door")
	assert_true(dialog.get_meta("is_event_dialog", false), "#452")
	var door: Button = main_ui.active_dialog_buttons[0]
	assert_eq(main_ui.active_dialog_buttons.size(), 1)
	var kc: Control = door.find_child("Keycap", true, false)
	assert_eq((kc.get_meta("label") as Label).text, "Space", "the keycap shows Space")
	assert_eq((door.find_child("DoorText", true, false) as Label).text, "Begin planning August 2017")
	_press(KEY_ENTER)
	await _frames(1)
	assert_eq(seen, [], "no Enter on the review (10.4)")
	_press(KEY_SPACE)
	await _frames(1)
	assert_eq(seen, ["begin_planning"], "Space goes through the door")
	dialog.queue_free()
	await _frames(2)


func _blocker() -> ColorRect:
	"""The event presenter's root-level click blocker (z 999, stops input)."""
	var found: ColorRect = null
	for c in get_tree().root.get_children():
		if c is ColorRect and c.z_index == 999 and c.mouse_filter == Control.MOUSE_FILTER_STOP:
			found = c
	return found


func test_g_dim_leaves_the_top_strip_lit() -> void:
	# Phase 4 (H spec 3.3): the dateline sits above every dim layer, so a new month's date types
	# in where the player can read it. The blocker still stops input over the whole screen.
	var main_ui: Node = await _boot()
	var ed = main_ui.event_dialog
	_hold_choices(main_ui, ed)
	ed.present(_review_event())
	await _frames(3)
	var blocker := _blocker()
	assert_not_null(blocker, "the click blocker is up")
	assert_eq([blocker.anchor_left, blocker.anchor_top, blocker.anchor_right, blocker.anchor_bottom],
		[0.0, 0.0, 1.0, 1.0], "input is blocked everywhere")
	assert_eq(blocker.color.a, 0.0, "the blocker itself draws nothing")
	var dim: ColorRect = blocker.get_node_or_null("GDim")
	assert_not_null(dim, "the dim is its own layer")
	var strip: Control = main_ui.get_g_desk().top_strip
	assert_almost_eq(dim.offset_top, strip.get_global_rect().end.y, 0.5, "the dim starts below the strip")
	assert_almost_eq(dim.color.a, MonthReviewPanel.BACKDROP_ALPHA, 0.001, "the review's dim is kept below it")
	assert_eq(dim.mouse_filter, Control.MOUSE_FILTER_IGNORE)
	var menu: Control = main_ui.get_g_desk().menu_button
	assert_eq(menu.modulate, GDesk.MENU_DIMMED, "the MENU plate, unusable under an event, is dimmed")
	ed._showing_dialog.queue_free()
	await _frames(4)
	assert_eq(menu.modulate, Color.WHITE, "lit again once the event is gone")


func test_classic_dim_still_covers_the_whole_screen() -> void:
	var main_ui: Node = await _boot(false)
	var ed = main_ui.event_dialog
	_hold_choices(main_ui, ed)
	ed.present(_event("classic"))
	await _frames(3)
	var blocker := _blocker()
	assert_not_null(blocker)
	assert_almost_eq(blocker.color.a, 0.6, 0.001, "today's dim, full screen")
	assert_null(blocker.get_node_or_null("GDim"), "no G dim layer in classic")
	ed._showing_dialog.queue_free()
	await _frames(2)


func test_classic_keeps_todays_event_and_review() -> void:
	var main_ui: Node = await _boot(false)
	var ed = main_ui.event_dialog
	_hold_choices(main_ui, ed)
	ed.present(_event("classic"))
	await _frames(3)
	var dialog: Control = ed._showing_dialog
	assert_ne(String(dialog.name), "GEventPaper")
	assert_eq(dialog.size, Vector2(600, 450), "today's generic footprint")
	assert_string_starts_with((main_ui.active_dialog_buttons[0] as Button).text, "[Q] ")
	dialog.queue_free()
	await _frames(3)
	ed.present(_review_event())
	await _frames(3)
	dialog = ed._showing_dialog
	assert_ne(String(dialog.name), "GReviewPaper")
	assert_string_contains((main_ui.active_dialog_buttons[0] as Button).text, "[SPACE]")
	dialog.queue_free()
	await _frames(2)


# --- the advisor note (5.13) -------------------------------------------------------------

func _mean_luma(img: Image, r: Rect2i) -> float:
	var total := 0.0
	var n := 0
	for y in range(r.position.y, r.end.y, 2):
		for x in range(r.position.x, r.end.x, 2):
			total += img.get_pixel(x, y).get_luminance()
			n += 1
	return total / maxf(n, 1)


func test_paper_has_clean_straight_edges() -> void:
	# Alex, build E: no torn edges on the paper. A torn or burnt rim is a sharp dark band at
	# the very edge; the sheet's soft shading is not. So the outer 8 px of each side (and the
	# outer 24 px of each corner) must be about as light as the paper just inside it.
	var img := (GPaper.texture() as Texture2D).get_image()
	if img.is_compressed():
		img.decompress()
	var w := img.get_width()
	var h := img.get_height()
	var pairs := {
		"top": [Rect2i(0, 0, w, 8), Rect2i(0, 8, w, 40)],
		"bottom": [Rect2i(0, h - 8, w, 8), Rect2i(0, h - 48, w, 40)],
		"left": [Rect2i(0, 0, 8, h), Rect2i(8, 0, 40, h)],
		"right": [Rect2i(w - 8, 0, 8, h), Rect2i(w - 48, 0, 40, h)],
		"top-left corner": [Rect2i(0, 0, 24, 24), Rect2i(24, 24, 48, 48)],
		"top-right corner": [Rect2i(w - 24, 0, 24, 24), Rect2i(w - 72, 24, 48, 48)],
		"bottom-left corner": [Rect2i(0, h - 24, 24, 24), Rect2i(24, h - 72, 48, 48)],
		"bottom-right corner": [Rect2i(w - 24, h - 24, 24, 24), Rect2i(w - 72, h - 72, 48, 48)],
	}
	for side in pairs:
		var rim := _mean_luma(img, pairs[side][0])
		var inside := _mean_luma(img, pairs[side][1])
		assert_gt(rim, inside * 0.9, "%s has no dark rim (%.3f against %.3f just inside)" % [side, rim, inside])


func test_advisor_note_is_on_paper() -> void:
	var main_ui: Node = await _boot()
	var note: Control = main_ui.get_g_desk().advisor_note
	var sb := note.get_theme_stylebox("panel")
	assert_true(sb is StyleBoxTexture, "the note is G paper")
	assert_eq((sb as StyleBoxTexture).texture.resource_path, GPaper.PAPER_PATH)


# --- submenu and ledger in the G look (5.7.4, 5.9.3) ------------------------------------

func _assert_skinned_and_readable(dialog: Control, what: String) -> void:
	assert_true(dialog.has_meta("g_skinned"), "%s has the G look" % what)
	assert_eq(dialog.theme, load(GDesk.THEME_PATH))
	var th: Theme = load(GDesk.THEME_PATH)
	assert_eq(dialog.get_theme_stylebox("panel"), th.get_stylebox("panel", "GPanel"),
		"%s: the G panel ground" % what)
	for l in _labels(dialog):
		var lab := l as Label
		if GPanel._on_own_card(dialog, lab):
			continue
		var c: Color = lab.get_theme_color("font_color")
		var a := c.a * lab.modulate.a
		var on := GDesk.C.panel_solid.lerp(Color(c, 1.0), a)
		assert_gte(GDesk.contrast_ratio(on, GDesk.C.panel_solid), 4.5,
			"%s: '%s' reaches 4.5:1 on the panel" % [what, lab.text])


func test_door_submenu_and_ledger_take_the_g_look_in_g_only() -> void:
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	desk.open_sheet("g_actions")
	await _frames(2)
	desk.actions_panel.press_row("scouting")
	await _frames(3)
	var sub: Control = main_ui.active_dialog
	assert_eq(String(sub.get_meta("submenu_id", "")), "scouting")
	_assert_skinned_and_readable(sub, "the scouting door")
	var x: Button = null
	for ch in sub.get_children():
		if ch is Button and (ch as Button).tooltip_text == "Close (ESC)":
			x = ch
	assert_eq(x.theme_type_variation, &"GClose", "G's close x")
	assert_eq(main_ui.active_dialog_buttons.size(), GameActions.get_scouting_options().size(),
		"same choices")
	main_ui.modal_stack.dismiss_all()
	await _frames(3)
	desk.open_ledger()
	await _frames(3)
	_assert_skinned_and_readable(main_ui.active_dialog, "the ledger")
	main_ui.modal_stack.dismiss_all()
	await _frames(2)


func test_classic_door_and_ledger_keep_todays_look() -> void:
	var main_ui: Node = await _boot(false)
	main_ui._open_submenu("scouting")
	await _frames(2)
	assert_false(main_ui.active_dialog.has_meta("g_skinned"), "classic submenu untouched")
	assert_null(main_ui.active_dialog.theme)
	main_ui.modal_stack.dismiss_all()
	await _frames(2)
	main_ui._show_ledger_screen()
	await _frames(2)
	assert_false(main_ui.active_dialog.has_meta("g_skinned"), "classic ledger untouched")
	main_ui.modal_stack.dismiss_all()
	await _frames(2)


# --- icons (5.7.1, R3-3) -----------------------------------------------------------------

func test_gicons_maps_the_six_new_ids_and_the_two_fallbacks() -> void:
	var want := {
		"advertise": "g_new/advertise.png", "travel": "g_new/travel.png",
		"publicity": "g_new/publicity.png", "scout_shitpost": "g_new/post_online.png",
		"scout_meetups": "g_new/meetups.png", "order_supplies": "g_new/supplies.png",
		"scout_read": "actions_research/action_research_ml_fundamentals_64.png",
		"tour_offices": "actions_facilities/action_facility_expand_office_64.png",
	}
	for id in want:
		assert_eq(GIcons.path_for(id), GIcons.ICON_ROOT + String(want[id]), "%s -> %s" % [id, want[id]])
		var t := GIcons.for_action(id)
		assert_not_null(t, "%s loads" % id)
		assert_eq(t.resource_path, GIcons.ICON_ROOT + String(want[id]))
		assert_eq(GIcons.tone_for(id), GIcons.NEW_TONE if GIcons.G_NEW.has(id) else Color.WHITE,
			"%s tone" % id)
	for id in GIcons.G_NEW:
		var img: Image = GIcons.for_action(id).get_image()
		assert_eq(Vector2i(img.get_width(), img.get_height()), Vector2i(128, 128), "%s is 128x128" % id)
	assert_eq(GIcons.path_for("buy_compute"), "", "other ids keep today's icon")
	assert_eq(GIcons.tone_for("buy_compute"), Color.WHITE)


func _surfaces(id: String) -> Array:
	"""Where an id can appear, from the data (spec 5.7.1, R3-3)."""
	var out: Array = []
	for a in GameActions.get_all_actions():
		if String(a.get("id", "")) == id:
			out.append("actions_sheet")
	var parent := ""
	for sub in SubmenuController.GRID_CONFIG.keys():
		var probe = SubmenuController.new(null, null)
		for o in probe._options_for(sub):
			if String(o.get("id", "")) == id:
				parent = sub
	if parent != "":
		out.append("submenu:" + parent)
	var a := GameActions.get_action_by_id(id)
	if not a.is_empty() and not bool(a.get("is_submenu", false)) \
			and not ActionBarRenderer.COMING_SOON_ACTION_IDS.has(id):
		out.append("plan_drawer")
	return out


func test_each_new_icon_renders_on_each_surface_it_can_appear_on() -> void:
	var main_ui: Node = await _boot()
	var desk = main_ui.get_g_desk()
	main_ui.game_manager.state.money = 1e9   # so every choice can be queued for the drawer check
	var checked := 0
	for id in GIcons.G_NEW:
		var want: String = GIcons.path_for(id)
		var surfaces := _surfaces(id)
		assert_false(surfaces.is_empty(), "%s has at least one surface" % id)
		for s in surfaces:
			if s == "actions_sheet":
				desk.open_sheet("g_actions")
				await _frames()
				var row: Button = desk.actions_panel.row_for(id)
				assert_not_null(row, "%s has a row on the Actions sheet" % id)
				var ic: TextureRect = row.find_child("Icon", true, false)
				assert_eq(ic.texture.resource_path, want, "%s on the Actions sheet" % id)
				assert_eq(Color(ic.self_modulate, 1.0), GIcons.NEW_TONE, "%s toned on the sheet" % id)
				assert_eq(ic.texture_filter, CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS, "%s uses its mipmaps on the sheet" % id)
				desk.close_sheet("g_actions")
				checked += 1
			elif s.begins_with("submenu:"):
				var sub := String(s).substr(8)
				desk.open_sheet("g_actions")
				await _frames()
				desk.actions_panel.press_row(sub)
				await _frames()
				var opts := SubmenuController.new(null, null)._options_for(sub)
				var idx := -1
				for k in range(opts.size()):
					if String(opts[k].get("id", "")) == id:
						idx = k
				var btn: Button = main_ui.active_dialog_buttons[idx]
				assert_eq(btn.icon.resource_path, want, "%s in the %s grid" % [id, sub])
				assert_eq(btn.get_theme_color("icon_normal_color"), GIcons.NEW_TONE, "%s toned in the grid" % id)
				assert_eq(btn.texture_filter, CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS, "%s uses its mipmaps in the grid" % id)
				btn.pressed.emit()   # queue it, so the drawer check below has it
				await _frames(3)
				main_ui.modal_stack.dismiss_all()
				await _frames()
				checked += 1
			elif s == "plan_drawer":
				desk.open_sheet("g_plan")
				await _frames()
				var found := false
				for k in range(desk.plan_panel.row_count()):
					if String(main_ui.plan_controller.queued_actions[k].id) == id:
						assert_eq(desk.plan_panel.row_icon(k).resource_path, want, "%s in the Plan drawer" % id)
						found = true
				assert_true(found, "%s has a Plan drawer row" % id)
				desk.close_sheet("g_plan")
				checked += 1
	assert_gte(checked, 8, "every id checked on its surfaces (%d checks)" % checked)
	main_ui._on_clear_queue_button_pressed()
	await _frames(2)

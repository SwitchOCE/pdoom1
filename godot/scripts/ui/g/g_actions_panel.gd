class_name GActionsPanel
extends GSheet
## The Actions sheet (fork/design/godot-g/spec.md 5.7), plain look.
##
## Rows: the list ActionBarRenderer already builds, in the same order and with the same
## filters (hidden ids, coming-soon ids, locks). The renderer hands it to the desk when the
## layout is g (set_rows); the classic flat grid is still built, hidden, for keys 1-9.
## Row click, ADD TO PLAN and OPEN all run main_ui._on_dynamic_action_pressed(id, name), the
## handler the action bar uses, with its refusals shown in the G toast. Doors reach
## main_ui._open_submenu through that same handler.
##
## Blocked rows use EXACTLY today's admission test on the live, unrounded values (A5,
## main_ui._on_dynamic_action_pressed): the aggregate and the typed hour checks, then
## GameState.can_afford. A blocked row stays clickable so the click reaches today's handler
## and its refusal; only N in "x N money short" is rounded, and only for display.
##
## VIEW-ONLY: reads state through read-only calls; writes nothing; draws no random number.

const ROW_HEIGHT := 52

## [{action: Dictionary, slot: int}] in the renderer's order.
var rows: Array = []
var hint_id: String = ""

var _list: VBoxContainer
var _scroll: ScrollContainer
var _row_nodes: Dictionary = {}      # action id -> Button
var _row_info: Dictionary = {}       # action id -> {blocked, reason, coming_soon, clickable, ...}
var _ids_built: Array = []
var _hint_tween: Tween
var _hint_row: Control = null

# Detail card (spec 5.7.2).
var detail: PanelContainer
var _d_name: Label
var _d_desc: Label
var _d_cost: Label
var _d_fit: Label
var _d_reason: Label
var detail_primary: Button
var detail_back: Button
var detail_id: String = ""


func _init() -> void:
	kind = "g_actions"
	name = "GActionsPanel"


func _panel_layout() -> void:
	_anchor_left_column(280, 600)


func _build() -> void:
	title_label.text = "ACTIONS"
	_scroll = ScrollContainer.new()
	_scroll.name = "Scroll"
	_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	body.add_child(_scroll)
	_list = VBoxContainer.new()
	_list.name = "Rows"
	_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_list.add_theme_constant_override("separation", 6)
	_scroll.add_child(_list)
	_build_detail()


func _build_detail() -> void:
	detail = PanelContainer.new()
	detail.name = "DetailCard"
	detail.mouse_filter = Control.MOUSE_FILTER_STOP
	var sb := GDesk.make_box(GDesk.C.panel2, GDesk.C.frame_hi, 1, 2)
	sb.content_margin_left = 18
	sb.content_margin_right = 18
	sb.content_margin_top = 14
	sb.content_margin_bottom = 14
	detail.add_theme_stylebox_override("panel", sb)
	add_child(detail)
	detail.position = Vector2(904, 544)
	detail.custom_minimum_size = Vector2(480, 272)
	detail.size = Vector2(480, 272)
	var vb := VBoxContainer.new()
	vb.add_theme_constant_override("separation", 8)
	vb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	detail.add_child(vb)
	_d_name = GDesk.make_label("", "body", GDesk.C.bone)
	vb.add_child(_d_name)
	_d_desc = GDesk.make_label("", "small", GDesk.C.muted)
	_d_desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_d_desc.custom_minimum_size = Vector2(440, 0)
	vb.add_child(_d_desc)
	_d_cost = GDesk.make_label("", "small", GDesk.C.bone)
	vb.add_child(_d_cost)
	_d_fit = GDesk.make_label("", "small", GDesk.C.muted)
	_d_fit.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_d_fit.custom_minimum_size = Vector2(440, 0)
	vb.add_child(_d_fit)
	_d_reason = GDesk.make_label("", "small", GDesk.C.warn)
	vb.add_child(_d_reason)
	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vb.add_child(spacer)
	var hb := HBoxContainer.new()
	hb.add_theme_constant_override("separation", 10)
	vb.add_child(hb)
	detail_primary = Button.new()
	detail_primary.name = "Primary"
	detail_primary.focus_mode = Control.FOCUS_NONE
	detail_primary.custom_minimum_size = Vector2(180, 40)
	detail_primary.add_theme_font_size_override("font_size", ThemeManager.get_font_size("small"))
	GDesk.style_flat_button(detail_primary, true)
	detail_primary.pressed.connect(_on_detail_primary)
	hb.add_child(detail_primary)
	detail_back = Button.new()
	detail_back.name = "Back"
	detail_back.text = "BACK"
	detail_back.tooltip_text = "Hide this card"
	detail_back.focus_mode = Control.FOCUS_NONE
	detail_back.custom_minimum_size = Vector2(110, 40)
	detail_back.add_theme_font_size_override("font_size", ThemeManager.get_font_size("small"))
	GDesk.style_flat_button(detail_back)
	detail_back.pressed.connect(hide_detail)
	hb.add_child(detail_back)
	detail.visible = false


# --- data in ---------------------------------------------------------------------------------

func set_rows(new_rows: Array) -> void:
	rows = new_rows
	refresh()


func set_hint(action_id: String) -> void:
	hint_id = action_id
	_refresh_hint()
	_reveal_hint_later()


func refresh() -> void:
	_rebuild_if_needed()
	var gs = _state()
	var st: Dictionary = host._last_state if host != null and host.get("_last_state") is Dictionary else {}
	var left := GAttentionCard.hours_left_after_queue(st, _queued())
	header_right.text = "Hours left: %d plan, %d op" % [int(left.planning), int(left.operating)]
	var in_plan := {}
	if host != null and host.get("plan_controller") != null:
		for q in host.plan_controller.queued_actions:
			var qid := String(q.get("id", ""))
			in_plan[qid] = int(in_plan.get(qid, 0)) + 1
	for r in rows:
		var action: Dictionary = r.action
		var id := String(action.get("id", ""))
		if not _row_nodes.has(id):
			continue
		var info := row_info_for(action, gs, host)
		info["slot"] = int(r.slot)
		info["in_plan"] = int(in_plan.get(id, 0))
		_row_info[id] = info
		_paint_row(_row_nodes[id], action, info)
	_refresh_hint()
	if detail.visible and detail_id != "":
		show_detail(detail_id)
	relink_focus()


func _state():
	if host == null or host.get("game_manager") == null:
		return null
	return host.game_manager.state


# --- the blocked test (A5) ---------------------------------------------------------------

static func row_info_for(action: Dictionary, gs, main_ui) -> Dictionary:
	"""What a row shows and whether its click reaches today's handler. `gs` is the live
	GameState (read-only calls only). Mirrors main_ui._on_dynamic_action_pressed exactly:
	doors are never blocked (the handler opens them above its cost guards); plays are blocked
	by the aggregate-or-typed hour check, then by GameState.can_afford."""
	var id := String(action.get("id", ""))
	var info := {"door": bool(action.get("is_submenu", false)), "coming_soon": false,
		"blocked": false, "reason": "", "clickable": true}
	if ActionBarRenderer.COMING_SOON_ACTION_IDS.has(id):
		info.coming_soon = true
		info.blocked = true
		info.reason = "COMING SOON"
		info.clickable = false
		return info
	if info.door or gs == null:
		return info
	var cost: int = GameActions.attention_cost(action)
	var hour_type: String = GameActions.hour_type(action)
	if gs.get_available_attention() < cost or gs.get_available_hours(hour_type) < cost:
		info.blocked = true
		info.reason = "x needs %d %s hr" % [cost, MonthPlan.family_of(hour_type)]
	elif not gs.can_afford(action.get("costs", {})):
		info.blocked = true
		info.reason = shortfall_text(action.get("costs", {}), gs)
	# Safety net: classic's own tile (the same row in the hidden flat grid) refuses a click
	# when it is disabled; a G row never accepts what the classic bar would not.
	if not info.blocked and main_ui != null and main_ui.has_method("_find_action_button"):
		var tile = main_ui._find_action_button(id)
		if tile != null and is_instance_valid(tile) and tile.disabled:
			info.blocked = true
			info.reason = "x not available now"
			info.clickable = false
	return info


static func shortfall_text(costs: Dictionary, gs) -> String:
	"""The first resource GameState.can_afford refuses, as "x N <resource> short". N is the
	unrounded shortfall, rounded for display only."""
	for res in ["money", "compute", "research", "papers", "reputation"]:
		if costs.has(res):
			var have := float(gs.get(res))
			var need := float(costs[res])
			if have < need:
				var short := need - have
				var n := GameConfig.format_money(short) if res == "money" else GameConfig.format_scalar(short)
				return "x %s %s short" % [n, res]
	return "x cannot afford"


static func cost_line(action: Dictionary, main_ui) -> String:
	"""A play's hours and pool, then its costs as today's _format_costs_inline prints them
	(without the Attention part, which the hours already say). "Free" when it costs nothing."""
	var parts: Array = []
	var cost: int = GameActions.attention_cost(action)
	if cost > 0:
		parts.append("%d %s hr" % [cost, MonthPlan.family_of(GameActions.hour_type(action))])
	var costs: Dictionary = (action.get("costs", {}) as Dictionary).duplicate()
	costs.erase("attention")
	costs.erase("action_points")
	costs.erase("hour_type")
	var text := ""
	if main_ui != null and main_ui.has_method("_format_costs_inline"):
		text = String(main_ui._format_costs_inline(costs))
	if text != "" and text != "Free":
		parts.append(text)
	return "Free" if parts.is_empty() else "  -  ".join(parts)


func door_line(action: Dictionary) -> String:
	var id := String(action.get("id", ""))
	var n := -1
	if host != null and host.get("submenu_controller") != null:
		n = int(host.submenu_controller.option_count(id))
	return "%d choices" % n if n >= 0 else "choices"


# --- rows ------------------------------------------------------------------------------------

func _rebuild_if_needed() -> void:
	var ids: Array = []
	for r in rows:
		ids.append(String(r.action.get("id", "")))
	if ids == _ids_built:
		return
	_ids_built = ids
	_stop_hint()
	for c in _list.get_children():
		_list.remove_child(c)
		c.queue_free()
	_row_nodes.clear()
	for r in rows:
		var row := _make_row(r.action, int(r.slot))
		_list.add_child(row)
		_row_nodes[String(r.action.get("id", ""))] = row


func _make_row(action: Dictionary, slot: int) -> Button:
	var id := String(action.get("id", ""))
	var nm := String(action.get("name", id))
	var b := Button.new()
	b.name = "Row_%s" % id
	b.set_meta("action_id", id)
	b.focus_mode = Control.FOCUS_ALL
	b.custom_minimum_size = Vector2(0, ROW_HEIGHT)
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	b.tooltip_text = String(action.get("description", ""))
	var hb := HBoxContainer.new()
	hb.name = "H"
	hb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hb.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	hb.offset_left = 8
	hb.offset_right = -10
	hb.add_theme_constant_override("separation", 10)
	b.add_child(hb)
	var kc := GDesk.make_keycap(str(slot + 1) if slot < 9 else "")
	kc.name = "Slot"
	kc.custom_minimum_size = Vector2(28, 0)
	kc.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	hb.add_child(kc)
	var tile := PanelContainer.new()
	tile.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tile.custom_minimum_size = Vector2(40, 40)
	tile.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	tile.add_theme_stylebox_override("panel", GDesk.make_box(GDesk.C.well, GDesk.C.frame, 1, 2))
	hb.add_child(tile)
	var ic := TextureRect.new()
	ic.name = "Icon"
	ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	ic.custom_minimum_size = Vector2(32, 32)
	ic.texture = GIcons.for_action(id)
	tile.add_child(ic)
	var vb := VBoxContainer.new()
	vb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vb.add_theme_constant_override("separation", 0)
	vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vb.alignment = BoxContainer.ALIGNMENT_CENTER
	vb.name = "VBox"
	hb.add_child(vb)
	var name_l := GDesk.make_label(nm, "body", GDesk.C.bone)
	name_l.name = "Name"
	name_l.clip_text = true
	vb.add_child(name_l)
	var line2 := GDesk.make_label("", "small", GDesk.C.muted)
	line2.name = "Line2"
	line2.clip_text = true
	vb.add_child(line2)
	var chip := GDesk.make_label("", "small", GDesk.C.held)
	chip.name = "Chip"
	chip.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hb.add_child(chip)
	var reason := GDesk.make_label("", "small", GDesk.C.warn)
	reason.name = "Reason"
	reason.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hb.add_child(reason)
	var tab := GDesk.make_label("", "body", GDesk.C.muted)
	tab.name = "Tab"
	tab.custom_minimum_size = Vector2(16, 0)
	tab.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tab.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hb.add_child(tab)
	b.pressed.connect(func(): press_row(id))
	b.mouse_entered.connect(func(): show_detail(id))
	b.focus_entered.connect(func(): show_detail(id))
	return b


func _paint_row(b: Button, action: Dictionary, info: Dictionary) -> void:
	var hb := b.get_node("H")
	var slot := int(info.get("slot", 99))
	var kc: Control = hb.get_node("Slot")
	(kc.get_meta("label") as Label).text = str(slot + 1) if slot < 9 and not info.coming_soon else ""
	kc.modulate.a = 1.0 if (slot < 9 and not info.coming_soon) else 0.0
	(hb.get_node("VBox/Line2") as Label).text = door_line(action) if info.door else cost_line(action, host)
	var n := int(info.get("in_plan", 0))
	(hb.get_node("Chip") as Label).text = ("%d in plan" % n) if n > 0 else ""
	(hb.get_node("Reason") as Label).text = String(info.reason)
	(hb.get_node("Tab") as Label).text = ">" if info.door else ("" if info.blocked else "+")
	b.disabled = not bool(info.clickable)
	GDesk.style_row(b, bool(info.blocked))


func press_row(id: String) -> void:
	"""A row click: today's handler, unless the row is coming soon (the classic tile is
	disabled too, so neither layout can reach it)."""
	var info: Dictionary = _row_info.get(id, {})
	if not bool(info.get("clickable", true)):
		return
	if host == null:
		return
	var action := GameActions.get_action_by_id(id)
	host._on_dynamic_action_pressed(id, String(action.get("name", id)))


func row_for(action_id: String) -> Button:
	return _row_nodes.get(action_id, null)


func row_state(action_id: String) -> Dictionary:
	return _row_info.get(action_id, {})


func row_ids() -> Array:
	return _ids_built.duplicate()


# --- detail card (spec 5.7.2) ------------------------------------------------------------

func show_detail(id: String) -> void:
	var action := GameActions.get_action_by_id(id)
	if action.is_empty():
		return
	detail_id = id
	var info: Dictionary = _row_info.get(id, row_info_for(action, _state(), host))
	_d_name.text = String(action.get("name", id))
	_d_desc.text = String(action.get("description", ""))
	if bool(info.get("door", false)):
		_d_cost.text = door_line(action) + " inside"
		_d_fit.text = ""
		detail_primary.text = "OPEN"
	else:
		_d_cost.text = cost_line(action, host)
		_d_fit.text = fit_line(action)
		detail_primary.text = "ADD TO PLAN"
	_d_reason.text = String(info.get("reason", ""))
	detail_primary.disabled = not bool(info.get("clickable", true))
	detail.visible = true


func fit_line(action: Dictionary) -> String:
	"""N <pool> hours left, $M left after the plan so far (hours and money shown minus what
	the queue lists, as the Attention card and the header show them)."""
	if host == null:
		return ""
	var st: Dictionary = host._last_state if host.get("_last_state") is Dictionary else {}
	var fam := MonthPlan.family_of(GameActions.hour_type(action))
	var left := int(GAttentionCard.hours_left_after_queue(st, _queued()).get(fam, 0))
	var queued_money := 0.0
	if host.get("plan_controller") != null:
		queued_money = float(host.plan_controller.calculate_queued_costs().get("money", 0))
	var money_after := float(st.get("money", 0)) - queued_money
	var money_part := "%s left after the plan so far" % GameConfig.format_money(money_after)
	# A play that costs no hours (Purchase Compute) gets no hours part.
	if GameActions.attention_cost(action) <= 0:
		return money_part
	return "%d %s hours left, %s" % [left, fam, money_part]


func _queued() -> Array:
	if host == null or host.get("plan_controller") == null:
		return []
	return host.plan_controller.queued_actions


func hide_detail() -> void:
	detail.visible = false
	detail_id = ""


func _on_detail_primary() -> void:
	if detail_id != "":
		press_row(detail_id)


func hide_panel() -> void:
	_stop_hint()
	hide_detail()
	super.hide_panel()


func show_panel() -> void:
	super.show_panel()
	_refresh_hint()
	_reveal_hint_later(true)


# --- first-lever pulse inside the sheet (spec 5.13) --------------------------------------

func _refresh_hint() -> void:
	var row: Control = _row_nodes.get(hint_id, null) if hint_id != "" else null
	if row != null and row == _hint_row and visible and hint_pulsing():
		return
	_stop_hint()
	if row == null or not visible:
		return
	_hint_row = row
	_hint_tween = row.create_tween().set_loops()
	_hint_tween.tween_property(row, "modulate:a", 0.4, 0.6)
	_hint_tween.tween_property(row, "modulate:a", 1.0, 0.6)


func _reveal_hint_later(take_focus: bool = false) -> void:
	"""The advisor says "the glowing button"; at 1080p the Scouting row starts below the fold,
	so scroll the list until the pulsing row is in view. Waits for the containers to lay out
	first. On open the hinted row also takes the focus from the first row, so the detail card
	describes the row in view, not one scrolled off the top. Display only: moves the list's
	scroll and the keyboard focus, nothing else."""
	if hint_id == "" or not visible or not is_inside_tree():
		return
	await get_tree().process_frame
	await get_tree().process_frame
	reveal_hint()
	if take_focus and visible:
		var row: Control = _row_nodes.get(hint_id, null)
		var owner_c := get_viewport().gui_get_focus_owner()
		if row != null and is_instance_valid(row) and row.focus_mode != Control.FOCUS_NONE \
				and (owner_c == null or is_ancestor_of(owner_c)):
			row.grab_focus()


func reveal_hint() -> void:
	var row: Control = _row_nodes.get(hint_id, null) if hint_id != "" else null
	if row == null or not is_instance_valid(row) or not visible:
		return
	_scroll.ensure_control_visible(row)


func _stop_hint() -> void:
	if _hint_tween != null and _hint_tween.is_valid():
		_hint_tween.kill()
	_hint_tween = null
	if _hint_row != null and is_instance_valid(_hint_row):
		_hint_row.modulate.a = 1.0
	_hint_row = null


func hint_pulsing() -> bool:
	return _hint_tween != null and _hint_tween.is_valid()

class_name GPlanPanel
extends GSheet
## The Plan drawer (fork/design/godot-g/spec.md 5.8). The look is the theme's (2a): rows are
## GRaised, hours in the pool's colour, numbers in mono.
##
## One row per entry of plan_controller.queued_actions, in order, with an x that runs
## main_ui._remove_queued_action(id, name). For a repeated play that removes the FIRST queued
## copy of the id, whichever row was clicked, exactly as today's tiles do (10.3). No reorder:
## the queue has none (16).
## Total row and AFTER THESE COSTS are worked out from values already on screen (shown money
## and reputation minus the queued costs from calculate_queued_costs). Results of plays are
## not included (Q5).
## RESEARCH QUALITY and UNDER WAY are today's live nodes, reparented in by LayoutController
## (spec 2.2 step 4) into quality_slot and underway_slot.
## Footer: UNDO / CLEAR / RESERVE HOURS run today's handlers and mirror today's buttons'
## disabled states.
##
## VIEW-ONLY: writes nothing itself; draws no random number.

var _rows_box: VBoxContainer
var _scroll: ScrollContainer
var _total: Label
var _after: Label
var quality_slot: VBoxContainer
var underway_slot: VBoxContainer
var undo_button: Button
var clear_button: Button
var reserve_button: Button
var _row_ids: Array = []


func _init() -> void:
	kind = "g_plan"
	name = "GPlanPanel"


func _panel_layout() -> void:
	# 700..1468 on the 1920 canvas, offset from the right column (spec 3.2).
	_anchor_right_column(1920 - 1468, 768)


func _build() -> void:
	title_label.text = "THE MONTH AHEAD"
	header_right.text = "runs top to bottom"
	var esc := GDesk.make_keycap("Esc")
	esc.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	header.add_child(esc)
	header.move_child(esc, header.get_child_count() - 2)

	var heads := HBoxContainer.new()
	heads.name = "ColumnHeads"
	heads.add_theme_constant_override("separation", 10)
	body.add_child(heads)
	for spec in [["#", 32], ["PLAY", 0], ["HOURS", 110], ["COST", 150], ["", 40]]:
		var l := GDesk.make_label(String(spec[0]), "small", GDesk.C.muted, "GCaps")
		if int(spec[1]) > 0:
			l.custom_minimum_size = Vector2(int(spec[1]), 0)
		else:
			l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		heads.add_child(l)

	_scroll = ScrollContainer.new()
	_scroll.name = "Scroll"
	_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	body.add_child(_scroll)
	_rows_box = VBoxContainer.new()
	_rows_box.name = "Rows"
	_rows_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_rows_box.add_theme_constant_override("separation", 4)
	_scroll.add_child(_rows_box)

	_total = GDesk.make_label("", "small", GDesk.C.bone, "GSansMed")
	_total.name = "Total"
	body.add_child(_total)
	_after = GDesk.make_label("", "small", GDesk.C.muted)
	_after.name = "After"
	body.add_child(_after)

	quality_slot = VBoxContainer.new()
	quality_slot.name = "QualitySlot"
	body.add_child(quality_slot)
	underway_slot = VBoxContainer.new()
	underway_slot.name = "UnderWaySlot"
	body.add_child(underway_slot)

	var foot := HBoxContainer.new()
	foot.name = "Footer"
	foot.add_theme_constant_override("separation", 10)
	body.add_child(foot)
	undo_button = _foot_button("UNDO", "undo_action", "Z")
	undo_button.pressed.connect(func(): _run("_on_undo_last_button_pressed", "undo_last_button"))
	foot.add_child(undo_button)
	clear_button = _foot_button("CLEAR", "clear_queue", "C")
	clear_button.pressed.connect(func(): _run("_on_clear_queue_button_pressed", "clear_queue_button"))
	foot.add_child(clear_button)
	reserve_button = _foot_button("RESERVE HOURS", "g_reserve", "R")
	reserve_button.tooltip_text = "Hold 1 operating hour for events this month"
	reserve_button.pressed.connect(func(): _run("_on_reserve_ap_button_pressed", "reserve_ap_button"))
	foot.add_child(reserve_button)


func _foot_button(caption: String, bind: String, fallback: String) -> Button:
	var b := Button.new()
	b.focus_mode = Control.FOCUS_ALL
	b.text = "%s [%s]" % [caption, GDesk.key_name(bind, fallback)]
	b.custom_minimum_size = Vector2(0, 40)
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	GDesk.set_step(b, "small")
	GDesk.style_flat_button(b)
	GDesk.track_theme_ink(b)
	return b


func _run(handler: String, classic_button: String) -> void:
	"""Run today's handler only when today's button for it is enabled."""
	if host == null:
		return
	var cb = host.get(classic_button)
	if cb != null and is_instance_valid(cb) and cb.disabled:
		return
	host.call(handler)
	refresh()


func refresh() -> void:
	if host == null or host.get("plan_controller") == null:
		_total.text = "Total: 0 plays"
		_after.text = ""
		return
	var queued: Array = host.plan_controller.queued_actions
	_rebuild_rows(queued)
	var hours := GAttentionCard.queued_hours(queued)
	var costs: Dictionary = host.plan_controller.calculate_queued_costs()
	var money_text := String(host._format_costs_inline(costs))
	var n := queued.size()
	_total.text = "Total: %d play%s  -  %d planning hr, %d operating hr  -  %s" % [
		n, "" if n == 1 else "s", int(hours.planning), int(hours.operating),
		"no other costs" if money_text == "Free" else money_text]
	var st: Dictionary = host._last_state if host.get("_last_state") is Dictionary else {}
	var money_after := float(st.get("money", 0)) - float(costs.get("money", 0))
	var rep_after := float(st.get("reputation", 0)) - float(costs.get("reputation", 0))
	_after.text = "AFTER THESE COSTS:  %s money,  %s reputation  (results of plays not included)" % [
		GameConfig.format_money(money_after), GameConfig.format_scalar(rep_after)]
	_mirror(undo_button, host.get("undo_last_button"))
	_mirror(clear_button, host.get("clear_queue_button"))
	_mirror(reserve_button, host.get("reserve_ap_button"))
	relink_focus()


func _mirror(b: Button, classic) -> void:
	b.disabled = classic == null or not is_instance_valid(classic) or classic.disabled


func _rebuild_rows(queued: Array) -> void:
	var ids: Array = []
	for q in queued:
		ids.append(String(q.get("id", "")))
	if ids == _row_ids and _rows_box.get_child_count() == ids.size() + (1 if ids.is_empty() else 0):
		return
	_row_ids = ids
	for c in _rows_box.get_children():
		_rows_box.remove_child(c)
		c.queue_free()
	if queued.is_empty():
		_rows_box.add_child(GDesk.make_label("Nothing queued yet. Choose plays in Actions.", "small", GDesk.C.muted))
		return
	for i in range(queued.size()):
		_rows_box.add_child(_make_row(i, queued[i]))


func _make_row(i: int, q: Dictionary) -> Control:
	var id := String(q.get("id", ""))
	var nm := String(q.get("name", id))
	var action := GameActions.get_action_by_id(id)
	var row := PanelContainer.new()
	row.name = "Row%d" % i
	row.set_meta("action_id", id)
	row.theme_type_variation = &"GRaised"
	var hb := HBoxContainer.new()
	hb.add_theme_constant_override("separation", 10)
	row.add_child(hb)
	var num := GDesk.make_label(str(i + 1), "small", GDesk.C.muted, "GMono")
	num.custom_minimum_size = Vector2(32, 0)
	num.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	num.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hb.add_child(num)
	var ic := TextureRect.new()
	ic.name = "Icon"
	ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	ic.custom_minimum_size = Vector2(32, 32)
	ic.texture = GIcons.for_action(id)
	hb.add_child(ic)
	var vb := VBoxContainer.new()
	vb.add_theme_constant_override("separation", 0)
	vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hb.add_child(vb)
	var name_l := GDesk.make_label(nm, "body", GDesk.C.bone)
	name_l.clip_text = true
	vb.add_child(name_l)
	var where := String(action.get("category", ""))
	# "--" (nothing in that column) is a thin glyph: the semi-bold mono carries it (2a addendum).
	var where_l := GDesk.make_label(where.capitalize() if where != "" else "--", "small", GDesk.C.muted,
		"" if where != "" else "GMonoSemi")
	GDesk.compact_step_up(where_l)
	vb.add_child(where_l)
	var cost := GameActions.attention_cost(action)
	var fam := MonthPlan.family_of(GameActions.hour_type(action))
	var hours_l := GDesk.make_label(
		"%d %s" % [cost, fam] if cost > 0 else "--",
		"small", (GDesk.C.plan if fam == "planning" else GDesk.C.op) if cost > 0 else GDesk.C.muted,
		"GMono" if cost > 0 else "GMonoSemi")
	GDesk.compact_step_up(hours_l)
	hours_l.custom_minimum_size = Vector2(110, 0)
	hours_l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hb.add_child(hours_l)
	var costs: Dictionary = (action.get("costs", {}) as Dictionary).duplicate()
	costs.erase("attention")
	costs.erase("action_points")
	costs.erase("hour_type")
	var ct := String(host._format_costs_inline(costs)) if host != null else "Free"
	var cost_l := GDesk.make_label("--" if ct == "Free" else ct, "small",
		GDesk.C.muted if ct == "Free" else GDesk.C.bone, "GMonoSemi" if ct == "Free" else "GMono")
	GDesk.compact_step_up(cost_l)
	cost_l.custom_minimum_size = Vector2(150, 0)
	cost_l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	cost_l.clip_text = true
	hb.add_child(cost_l)
	var x := Button.new()
	x.name = "Remove"
	x.text = "x"
	x.tooltip_text = "Remove %s from the plan (removes the first queued copy)" % nm
	x.focus_mode = Control.FOCUS_ALL
	x.custom_minimum_size = Vector2(40, 36)
	GDesk.set_step(x, "body")
	x.theme_type_variation = &"GClose"
	GDesk.track_theme_ink(x)  # a thin glyph: lifted in the compact view
	x.pressed.connect(func(): remove_entry(id, nm))
	hb.add_child(x)
	return row


func remove_entry(id: String, nm: String) -> void:
	if host == null:
		return
	host._remove_queued_action(id, nm)
	refresh()
	if visible:
		focus_first()


func row_count() -> int:
	return _row_ids.size()


func row_icon(i: int) -> Texture2D:
	var row := _rows_box.get_node_or_null("Row%d" % i)
	if row == null:
		return null
	var ic := row.find_child("Icon", true, false) as TextureRect
	return ic.texture if ic != null else null

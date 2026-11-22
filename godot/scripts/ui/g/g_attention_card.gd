class_name GAttentionCard
extends PanelContainer
## Attention card, PLAN face (spec 5.5), plain look. Phase 1c adds the WATCH and closed faces.
##
## Hours: one cell per hour of each pool, filled = hours left after the plan so far: the
## game's own planning_hours_left / operating_hours_left minus the hours the queued plays
## list (queued_hours), so the figures move as plays are queued, as classic's "N/20
## allocated" does, and agree with the held plate and the Plan drawer. (Today's game books a
## queued play's hours only into attention_spent, not into the typed pools, so the typed
## pools alone never move while planning.) The row's total is the pool's unspent hours plus
## its spent hours (MonthPlan.hours_spent). No spill cell and no spill legend (spec 10.1).
## "Reserved" shows the plan-time reserve (classic's "N reserved"). In WATCH the two hour
## rows hide until 1c's WATCH face (the queue is gone and today's game never booked its hours
## into the typed pools, so their "N left" would overstate), and the card shows the held
## hours that remain instead, worked out as classic's WATCH strip does ("reserve N",
## screen_mode.gd): attention_reserved, or the unspent hours when nothing is reserved.
## THIS MONTH: the queued plays in order, consecutive repeats grouped with their row range,
## then "N plays" and the money total from PlanController.calculate_queued_costs().

const CELL := Vector2(16, 26)
const CELL_GAP := 3

var _header_total: Label
var _plan_cells: HBoxContainer
var _plan_left: Label
var _op_cells: HBoxContainer
var _op_left: Label
var _reserved: Label
var _plan_row: HBoxContainer
var _op_row: HBoxContainer
var _list: VBoxContainer
var _total: Label
## 1b seam: "CHOOSE ACTIONS [A]" / "OPEN PLAN [Q]" opens the Actions sheet or the Plan
## drawer. Hidden until those sheets exist, so no dead button is ever shown.
var choose_button: Button


func _init() -> void:
	name = "AttentionCard"
	mouse_filter = Control.MOUSE_FILTER_STOP
	custom_minimum_size = Vector2(416, 274)
	add_theme_stylebox_override("panel", GDesk.make_box(GDesk.C.panel, GDesk.C.frame_hi, 1, 0))
	var m := MarginContainer.new()
	m.mouse_filter = Control.MOUSE_FILTER_IGNORE
	m.add_theme_constant_override("margin_left", 16)
	m.add_theme_constant_override("margin_right", 16)
	m.add_theme_constant_override("margin_top", 10)
	m.add_theme_constant_override("margin_bottom", 14)
	add_child(m)
	var vb := VBoxContainer.new()
	vb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vb.add_theme_constant_override("separation", 12)
	m.add_child(vb)

	var head := HBoxContainer.new()
	head.mouse_filter = Control.MOUSE_FILTER_IGNORE
	head.add_theme_constant_override("separation", 8)
	vb.add_child(head)
	var icon_path := "res://assets/icons/resources/resource_action_points_64.png"
	if ResourceLoader.exists(icon_path):
		var ic := TextureRect.new()
		ic.texture = load(icon_path)
		ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		ic.custom_minimum_size = Vector2(24, 24)
		ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
		head.add_child(ic)
	var title := GDesk.make_label("ATTENTION", "small", GDesk.C.muted)
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_child(title)
	_header_total = GDesk.make_label("-- hr this month", "small", GDesk.C.muted)
	_header_total.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	head.add_child(_header_total)

	var rows := _hour_row(vb, "PLANNING", GDesk.C.plan)
	_plan_cells = rows[0]
	_plan_left = rows[1]
	_plan_row = rows[2]
	rows = _hour_row(vb, "OPERATING", GDesk.C.op)
	_op_cells = rows[0]
	_op_left = rows[1]
	_op_row = rows[2]
	_reserved = GDesk.make_label("", "small", GDesk.C.held)
	_reserved.visible = false
	vb.add_child(_reserved)

	var sep := HSeparator.new()
	sep.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vb.add_child(sep)
	vb.add_child(GDesk.make_label("THIS MONTH", "small", GDesk.C.muted))
	_list = VBoxContainer.new()
	_list.name = "ThisMonth"
	_list.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_list.add_theme_constant_override("separation", 2)
	vb.add_child(_list)
	_total = GDesk.make_label("", "small", GDesk.C.muted)
	vb.add_child(_total)

	choose_button = Button.new()
	choose_button.name = "ChooseButton"
	choose_button.focus_mode = Control.FOCUS_NONE
	choose_button.visible = false
	vb.add_child(choose_button)


func _hour_row(parent: Control, caption: String, colour: Color) -> Array:
	var hb := HBoxContainer.new()
	hb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hb.add_theme_constant_override("separation", 10)
	parent.add_child(hb)
	var cap := GDesk.make_label(caption, "small", colour)
	cap.custom_minimum_size = Vector2(96, 0)
	cap.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hb.add_child(cap)
	var cells := HBoxContainer.new()
	cells.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cells.add_theme_constant_override("separation", CELL_GAP)
	cells.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hb.add_child(cells)
	var left := GDesk.make_label("", "small", GDesk.C.bone)
	left.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	left.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	left.custom_minimum_size = Vector2(64, 0)
	hb.add_child(left)
	return [cells, left, hb]


func update_plan_face(state: Dictionary, queued: Array, costs: Dictionary,
		watching: bool = false) -> void:
	var mp: Dictionary = state.get("month_plan", {})
	_header_total.text = "%d hr this month" % int(mp.get("attention_total", 0))
	var spent: Dictionary = mp.get("hours_spent", {})
	var unspent_plan := int(state.get("planning_hours_left", 0))
	var unspent_op := int(state.get("operating_hours_left", 0))
	var left := hours_left_after_queue(state, queued)
	_fill(_plan_cells, int(left.planning), unspent_plan + int(spent.get("planning", 0)), GDesk.C.plan_fill)
	_fill(_op_cells, int(left.operating), unspent_op + int(spent.get("operating", 0)), GDesk.C.op_fill)
	_set_left(_plan_left, int(left.planning))
	_set_left(_op_left, int(left.operating))
	var reserved := int(mp.get("attention_reserved", 0))
	_plan_row.visible = not watching
	_op_row.visible = not watching
	if watching:
		_reserved.visible = true
		_reserved.text = "Reserved: %d hr" % held_remaining(state)
	else:
		_reserved.visible = reserved > 0
		_reserved.text = "Reserved: %d hr" % reserved
	_fill_list(queued, costs)


static func held_remaining(state: Dictionary) -> int:
	"""The held hours that remain, as classic's WATCH strip works them out ("reserve N",
	screen_mode.gd): attention_reserved when anything is reserved, else total - spent."""
	var mp: Dictionary = state.get("month_plan", {})
	var reserved := int(mp.get("attention_reserved", 0))
	if reserved > 0:
		return reserved
	return maxi(0, int(mp.get("attention_total", 0)) - int(mp.get("attention_spent", 0)))


static func queued_hours(queued: Array) -> Dictionary:
	"""Hours the queued plays list, by family: {planning, operating}. Each entry is a
	PlanController queue entry ({id, name}); the hours are the action's own attention cost
	and hour type, as the Plan drawer shows them. Pure."""
	var out := {"planning": 0, "operating": 0}
	for q in queued:
		var a := GameActions.get_action_by_id(String(q.get("id", "")))
		var fam := MonthPlan.family_of(GameActions.hour_type(a))
		out[fam] = int(out.get(fam, 0)) + GameActions.attention_cost(a)
	return out


static func hours_left_after_queue(state: Dictionary, queued: Array) -> Dictionary:
	"""Hours left after the plan so far, by family: the game's unspent hours minus the hours
	the queue lists, floored at 0. {planning, operating}. Pure."""
	var q := queued_hours(queued)
	return {
		"planning": maxi(0, int(state.get("planning_hours_left", 0)) - int(q.planning)),
		"operating": maxi(0, int(state.get("operating_hours_left", 0)) - int(q.operating)),
	}


func _set_left(l: Label, n: int) -> void:
	l.text = "%d left" % n
	l.add_theme_color_override("font_color", GDesk.C.warn if n <= 0 else GDesk.C.bone)


func _fill(row: HBoxContainer, filled: int, total: int, colour: Color) -> void:
	total = maxi(total, filled)
	while row.get_child_count() > total:
		var c := row.get_child(row.get_child_count() - 1)
		row.remove_child(c)
		c.free()
	while row.get_child_count() < total:
		var cell := ColorRect.new()
		cell.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row.add_child(cell)
	# Shrink cells to fit when a month has more hours than the card is wide.
	var room := 416.0 - 32.0 - 96.0 - 64.0 - 20.0
	var w := CELL.x
	if total > 0:
		w = clampf(floorf((room - CELL_GAP * (total - 1)) / float(total)), 4.0, CELL.x)
	for i in range(row.get_child_count()):
		var cell := row.get_child(i) as ColorRect
		cell.custom_minimum_size = Vector2(w, CELL.y)
		cell.color = colour if i < filled else GDesk.C.well


func _fill_list(queued: Array, costs: Dictionary) -> void:
	for c in _list.get_children():
		_list.remove_child(c)
		c.free()
	if queued.is_empty():
		_list.add_child(GDesk.make_label("Nothing queued yet", "small", GDesk.C.muted))
		_total.visible = false
		return
	for g in group_queue(queued):
		var hb := HBoxContainer.new()
		hb.mouse_filter = Control.MOUSE_FILTER_IGNORE
		hb.add_theme_constant_override("separation", 10)
		var num := GDesk.make_label(g.rows, "small", GDesk.C.muted)
		num.custom_minimum_size = Vector2(40, 0)
		hb.add_child(num)
		var nm := String(g.name)
		if int(g.count) > 1:
			nm += " x%d" % int(g.count)
		var name_l := GDesk.make_label(nm, "small", GDesk.C.bone)
		name_l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		name_l.clip_text = true
		hb.add_child(name_l)
		_list.add_child(hb)
	var n := queued.size()
	var money := float(costs.get("money", 0))
	var parts := ["%d play%s" % [n, "" if n == 1 else "s"]]
	if money > 0.0:
		parts.append(GameConfig.format_money(money))
	_total.text = "  -  ".join(parts)
	_total.visible = true


static func group_queue(queued: Array) -> Array:
	"""Consecutive repeats of one play fold into one row with its 1-based row range:
	[{name, count, rows: "2-3"}]. Pure; unit-tested."""
	var out: Array = []
	var i := 0
	while i < queued.size():
		var id := String(queued[i].get("id", ""))
		var nm := String(queued[i].get("name", id))
		var j := i
		while j + 1 < queued.size() and String(queued[j + 1].get("id", "")) == id:
			j += 1
		var rows := str(i + 1) if j == i else "%d-%d" % [i + 1, j + 1]
		out.append({"name": nm, "count": j - i + 1, "rows": rows, "id": id})
		i = j + 1
	return out

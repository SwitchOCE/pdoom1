class_name GAttentionCard
extends GPanel
## Attention card, PLAN face (spec 5.5). Phase 1c adds the WATCH and closed faces.
## The look (phase 2a, spec 4.4 rank 2): the hour bar and its HOURS LEFT figure at `label`
## in mono; THIS MONTH (rank 3) in `small`; the panel is a GPanel (grime, hairline, ticks).
##
## Hours (Q1, Alex 2026-11-22): the card shows the TOTAL hours left, the aggregate the game's
## own queue check uses: MonthPlan.available() = attention_total - attention_spent -
## attention_reserved. GameManager.select_action already adds a queued play's hours to
## attention_spent (and a removal or clear refunds them), so the queue is in the figure once
## and it moves as plays are queued, as classic's "N/20 allocated" does. One bar shows the
## same figure: one cell per hour of the month's total, lit = hours left, the rest unlit.
## There is no per-pool split and no per-pool "left": today's game never books a queued
## play's typed hours (Pip's #1379), so a per-pool figure would not be the game's.
## No spill cell and no spill legend (spec 10.1). "Reserved" shows the plan-time reserve
## (classic's "N reserved"). In WATCH the bar and the total hide until 1c's WATCH face,
## and the card shows the held hours that remain instead, worked out as classic's WATCH strip
## does ("reserve N", screen_mode.gd): attention_reserved, or the unspent hours when nothing
## is reserved.
## THIS MONTH: the queued plays in order, consecutive repeats grouped with their row range,
## then "N plays" and the money total from PlanController.calculate_queued_costs().

const CELL := Vector2(16, 26)
const CELL_GAP := 3
const EMPTY_ALPHA := 0.2
const LEFT_W := 72.0     # "20 hr" in mono at `label`

var _header_total: Label
## The one hours bar and figure: total hours left this month (Q1).
var _cells: HBoxContainer
var _left: Label
var _left_row: HBoxContainer
var _reserved: Label
var _list: VBoxContainer
var _total: Label
## 1b seam: "CHOOSE ACTIONS [A]" / "OPEN PLAN [Q]" opens the Actions sheet or the Plan
## drawer. Hidden until those sheets exist, so no dead button is ever shown.
var choose_button: Button


func _init() -> void:
	name = "AttentionCard"
	mouse_filter = Control.MOUSE_FILTER_STOP
	custom_minimum_size = Vector2(416, 274)
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
	var title := GDesk.make_label("ATTENTION", "body", GDesk.C.muted, "GCaps")
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_child(title)
	_header_total = GDesk.make_label("-- hr this month", "small", GDesk.C.muted)
	_header_total.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	head.add_child(_header_total)

	_left_row = HBoxContainer.new()
	_left_row.name = "HoursRow"
	_left_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_left_row.add_theme_constant_override("separation", 10)
	vb.add_child(_left_row)
	var left_cap := GDesk.make_label("HOURS LEFT", "small", GDesk.C.muted, "GCaps")
	left_cap.custom_minimum_size = Vector2(96, 0)
	left_cap.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_left_row.add_child(left_cap)
	_cells = HBoxContainer.new()
	_cells.name = "Cells"
	_cells.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_cells.add_theme_constant_override("separation", CELL_GAP)
	_cells.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_left_row.add_child(_cells)
	_left = GDesk.make_label("", "label", GDesk.C.bone, "GMono")
	_left.name = "HoursLeft"
	_left.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_left.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_left.custom_minimum_size = Vector2(LEFT_W, 0)
	_left_row.add_child(_left)
	_reserved = GDesk.make_label("", "small", GDesk.C.held, "GMono")
	_reserved.visible = false
	vb.add_child(_reserved)

	var sep := ColorRect.new()
	sep.color = GDesk.C.frame
	sep.custom_minimum_size = Vector2(0, 1)
	sep.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vb.add_child(sep)
	vb.add_child(GDesk.make_label("THIS MONTH", "small", GDesk.C.muted, "GCaps"))
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
	choose_button.custom_minimum_size = Vector2(0, 44)
	GDesk.set_step(choose_button, "body")
	GDesk.style_flat_button(choose_button)
	vb.add_child(choose_button)


func update_plan_face(state: Dictionary, queued: Array, costs: Dictionary,
		watching: bool = false) -> void:
	var mp: Dictionary = state.get("month_plan", {})
	_header_total.text = "%d hr this month" % int(mp.get("attention_total", 0))
	var left := hours_left(state)
	# One bar, one colour (no planning/operating split, Q1): the warm paper tone.
	_fill(_cells, left, int(mp.get("attention_total", 0)), GDesk.C.paper_dark)
	_set_left(_left, left)
	var reserved := int(mp.get("attention_reserved", 0))
	_left_row.visible = not watching
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


static func hours_left(state: Dictionary) -> int:
	"""Total hours left this month (Q1): MonthPlan.available() from the state's month_plan,
	attention_total - attention_spent - attention_reserved, floored at 0. A queued play is
	already in attention_spent (GameManager.select_action adds it), so the queue is counted
	once. Pure."""
	var mp: Dictionary = state.get("month_plan", {})
	return maxi(0, int(mp.get("attention_total", 0)) - int(mp.get("attention_spent", 0))
		- int(mp.get("attention_reserved", 0)))


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


func _set_left(l: Label, n: int) -> void:
	l.text = "%d hr" % n
	GDesk.set_ink(l, GDesk.C.warn if n <= 0 else GDesk.C.bone)


func _fill(row: HBoxContainer, lit: int, total: int, colour: Color) -> void:
	"""One cell per hour of the month's total; the first `lit` (the hours left) lit, the
	rest a faint ghost (Q1: the same figure as HOURS LEFT, no per-pool split)."""
	total = maxi(total, lit)
	while row.get_child_count() > total:
		var c := row.get_child(row.get_child_count() - 1)
		row.remove_child(c)
		c.free()
	while row.get_child_count() < total:
		var cell := ColorRect.new()
		cell.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row.add_child(cell)
	# Shrink cells to fit when a month has more hours than the card is wide.
	var room := 416.0 - 32.0 - 96.0 - LEFT_W - 20.0
	var w := CELL.x
	if total > 0:
		w = clampf(floorf((room - CELL_GAP * (total - 1)) / float(total)), 4.0, CELL.x)
	for i in range(row.get_child_count()):
		var cell := row.get_child(i) as ColorRect
		cell.custom_minimum_size = Vector2(w, CELL.y)
		cell.color = colour if i < lit else Color(colour, EMPTY_ALPHA)


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
		var num := GDesk.make_label(g.rows, "small", GDesk.C.muted, "GMono")
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

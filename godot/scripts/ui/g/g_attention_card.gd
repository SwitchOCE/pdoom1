class_name GAttentionCard
extends GPanel
## Attention card, three faces (spec 5.5): PLAN (plan phase, also the W1 V peek), WATCH (the
## month plays: W2 playback, W3 an event waiting) and closed (W4, under the month review).
## The look (phase 2a, spec 4.4 rank 2): the hour bars and their figures at `label` in mono;
## THIS MONTH (rank 3) in `small`; the panel is a GPanel (grime, hairline, ticks).
##
## PLAN face. Hours (Q1, Alex 2026-11-22): the card shows the TOTAL hours left, the aggregate
## the game's own queue check uses: MonthPlan.available() = attention_total - attention_spent -
## attention_reserved. GameManager.select_action already adds a queued play's hours to
## attention_spent (and a removal or clear refunds them), so the queue is in the figure once
## and it moves as plays are queued, as classic's "N/20 allocated" does. One bar shows the
## same figure: one cell per hour of the month's total, lit = hours left, the rest unlit.
## There is no per-pool split and no per-pool "left": today's game never books a queued
## play's typed hours (Pip's #1379), so a per-pool figure would not be the game's.
## No spill cell and no spill legend (spec 10.1). "Reserved" shows the plan-time reserve
## (classic's "N reserved"). THIS MONTH: the queued plays in order, consecutive repeats
## grouped with their row range, then "N plays" and the money total from
## PlanController.calculate_queued_costs().
##
## WATCH face (spec 5.5, A6, R2-4). HELD = the REMAINING reserve, state["attention_reserved"]
## (to_dict fills it from get_reserve_attention() = month_plan.reserve_remaining()), never the
## allocation month_plan.attention_reserved, which keeps counting hours already used. One
## silver cell per hour held at Commit (the opening hold GDesk reads after the commit handler
## returns), lit = still held. "Spent at Commit" is attention_spent read with the opening
## hold. While an event waits (W3) one summary line may show (reply_summary); the event
## paper's per-option prices stay the authority. STAFF AT WORK: a count per role.
##
## Closed face (W4): "<Month>, closed", and from GDesk's own pre-boundary snapshot "Used on
## events N hr" (opening hold - last held) and "Unspent, evaporated N hr" (last held). With no
## snapshot (a load, or a layout flip during the review) only "<Month>, closed". It does not
## name which event used the hours (spec 10.6).

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
var _plan_box: VBoxContainer
# WATCH face
var _watch_box: VBoxContainer
var _held_cells: HBoxContainer
var _held_left: Label
var _spent_at_commit: Label
var _reply: Label
var _staff_grid: GridContainer
# closed face
var _closed_box: VBoxContainer
var _closed_title: Label
var _closed_used: Label
var _closed_unspent: Label
## "plan" | "watch" | "closed": the face on show.
var face := "plan"

const ROLES := [
	["safety_researchers", "Safety", "employee_role_safety_specialist_64.png"],
	["capability_researchers", "Capabilities", "employee_role_researcher_64.png"],
	["compute_engineers", "Compute", "employee_role_engineer_64.png"],
	["managers", "Managers", "employee_role_manager_64.png"],
]
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

	_plan_box = VBoxContainer.new()
	_plan_box.name = "PlanFace"
	_plan_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_plan_box.add_theme_constant_override("separation", 12)
	vb.add_child(_plan_box)
	_build_watch_face(vb)
	_build_closed_face(vb)
	vb = _plan_box

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


func _build_watch_face(parent: VBoxContainer) -> void:
	_watch_box = VBoxContainer.new()
	_watch_box.name = "WatchFace"
	_watch_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_watch_box.add_theme_constant_override("separation", 12)
	_watch_box.visible = false
	parent.add_child(_watch_box)
	var row := HBoxContainer.new()
	row.name = "HeldRow"
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_theme_constant_override("separation", 10)
	_watch_box.add_child(row)
	var cap := GDesk.make_label("HELD", "small", GDesk.C.muted, "GCaps")
	cap.custom_minimum_size = Vector2(96, 0)
	cap.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	row.add_child(cap)
	_held_cells = HBoxContainer.new()
	_held_cells.name = "HeldCells"
	_held_cells.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_held_cells.add_theme_constant_override("separation", CELL_GAP)
	_held_cells.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(_held_cells)
	_held_left = GDesk.make_label("", "label", GDesk.C.held, "GMono")
	_held_left.name = "HeldLeft"
	_held_left.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_held_left.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_held_left.custom_minimum_size = Vector2(LEFT_W, 0)
	row.add_child(_held_left)
	_spent_at_commit = GDesk.make_label("", "small", GDesk.C.muted, "GMono")
	_spent_at_commit.name = "SpentAtCommit"
	_watch_box.add_child(_spent_at_commit)
	# W3: one summary line for the event waiting, only when every reply costs the same.
	_reply = GDesk.make_label("", "small", GDesk.C.amber, "GMono")
	_reply.name = "ReplyLine"
	_reply.visible = false
	_watch_box.add_child(_reply)
	var sep := ColorRect.new()
	sep.color = GDesk.C.frame
	sep.custom_minimum_size = Vector2(0, 1)
	sep.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_watch_box.add_child(sep)
	_watch_box.add_child(GDesk.make_label("STAFF AT WORK", "small", GDesk.C.muted, "GCaps"))
	_staff_grid = GridContainer.new()
	_staff_grid.name = "StaffAtWork"
	_staff_grid.columns = 2
	_staff_grid.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_staff_grid.add_theme_constant_override("h_separation", 24)
	_staff_grid.add_theme_constant_override("v_separation", 6)
	_watch_box.add_child(_staff_grid)


func _build_closed_face(parent: VBoxContainer) -> void:
	_closed_box = VBoxContainer.new()
	_closed_box.name = "ClosedFace"
	_closed_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_closed_box.add_theme_constant_override("separation", 10)
	_closed_box.visible = false
	parent.add_child(_closed_box)
	_closed_title = GDesk.make_label("", "label", GDesk.C.bone, "GCapsMed")
	_closed_title.name = "ClosedTitle"
	_closed_box.add_child(_closed_title)
	_closed_used = GDesk.make_label("", "small", GDesk.C.bone, "GMono")
	_closed_used.name = "UsedOnEvents"
	_closed_box.add_child(_closed_used)
	_closed_unspent = GDesk.make_label("", "small", GDesk.C.muted, "GMono")
	_closed_unspent.name = "UnspentEvaporated"
	_closed_box.add_child(_closed_unspent)


func set_face(which: String) -> void:
	"""Show one face: "plan", "watch" or "closed". The header's right text follows."""
	face = which
	_plan_box.visible = which == "plan"
	_watch_box.visible = which == "watch"
	_closed_box.visible = which == "closed"
	match which:
		"watch":
			_header_total.text = "held after Commit"
		"closed":
			_header_total.text = ""
	_header_total.visible = _header_total.text != ""
	if which != "plan":
		choose_button.visible = false


func update_plan_face(state: Dictionary, queued: Array, costs: Dictionary) -> void:
	var mp: Dictionary = state.get("month_plan", {})
	if face == "plan":
		_header_total.text = "%d hr this month" % int(mp.get("attention_total", 0))
		_header_total.visible = true
	var left := hours_left(state)
	# One bar, one colour (no planning/operating split, Q1): the warm paper tone.
	_fill(_cells, left, int(mp.get("attention_total", 0)), GDesk.C.paper_dark)
	_set_left(_left, left)
	var reserved := int(mp.get("attention_reserved", 0))
	_reserved.visible = reserved > 0
	_reserved.text = "Reserved: %d hr" % reserved
	_fill_list(queued, costs)


func update_watch_face(state: Dictionary, opening: Dictionary, reply_line: String,
		held: int = -1) -> void:
	"""The month plays (W2, W3). `opening` is GDesk's opening hold ({hold, spent}, empty until
	it has been read after the commit handler returned). `held` is the hours still held (by
	default held_left(state); GDesk passes the opening hold itself until a newer state comes)."""
	if held < 0:
		held = held_left(state)
	var hold := int(opening.get("hold", held)) if not opening.is_empty() else held
	_fill(_held_cells, held, maxi(hold, held), GDesk.C.held)
	_held_left.text = "%d left" % held
	GDesk.set_ink(_held_left, GDesk.C.warn if held <= 0 else GDesk.C.held)
	if opening.is_empty():
		_spent_at_commit.text = ""
		_spent_at_commit.visible = false
	else:
		_spent_at_commit.text = "Spent at Commit: %d hr" % int(opening.get("spent", 0))
		_spent_at_commit.visible = true
	_reply.text = reply_line
	_reply.visible = reply_line != ""
	_fill_staff(state)


func update_closed_face(month_name: String, snapshot: Dictionary) -> void:
	"""W4. `snapshot` is GDesk's pre-boundary copy ({hold, held}) or empty."""
	_closed_title.text = "%s, closed" % month_name if month_name != "" else "Month closed"
	var has := not snapshot.is_empty()
	_closed_used.visible = has
	_closed_unspent.visible = has
	if has:
		var held := int(snapshot.get("held", 0))
		_closed_used.text = "Used on events  %d hr" % maxi(0, int(snapshot.get("hold", 0)) - held)
		_closed_unspent.text = "Unspent, evaporated  %d hr" % held


static func held_left(state: Dictionary) -> int:
	"""The held hours that REMAIN (spec 5.5, A6): state["attention_reserved"], which to_dict
	fills from get_reserve_attention() = month_plan.reserve_remaining(). Pure."""
	return maxi(0, int(state.get("attention_reserved", 0)))


static func reply_summary(event: Dictionary) -> String:
	"""The W3 summary line (spec 5.5, R2-5), or "" for none. Uses each option's TOTAL shown
	price, EventDialog.costs_with_window_attention (the option's own costs with the window's
	Attention folded in), so it can never disagree with the paper's option rows.
	Known only for an event the window path stamped for display
	(WindowResolver.present_for_dialog: every window the playback presents carries the stamp,
	legacy popups with no `window` block included) whose window has no `option_verbs` (hiring
	prompts name their own price in the option text and stamp 0). All equal N > 0: "This reply
	costs N hr"; all equal 0: "Replies to this cost no hours"; anything else: no line."""
	if event.is_empty() or not event.has(WindowResolver.DISPLAY_ATTENTION_KEY):
		return ""
	if WindowResolver.window_config(event).has("option_verbs"):
		return ""
	var options = event.get("options", [])
	if not (options is Array) or (options as Array).is_empty():
		return ""
	var first := -1
	for opt in options:
		if not (opt is Dictionary):
			return ""
		var n := int(EventDialog.costs_with_window_attention(event, opt).get("attention", 0))
		if first < 0:
			first = n
		elif n != first:
			return ""
	if first > 0:
		return "This reply costs %d hr" % first
	return "Replies to this cost no hours"


func _fill_staff(state: Dictionary) -> void:
	for c in _staff_grid.get_children():
		_staff_grid.remove_child(c)
		c.free()
	var any := false
	for role in ROLES:
		var n := int(state.get(role[0], 0))
		if n <= 0:
			continue
		any = true
		var hb := HBoxContainer.new()
		hb.mouse_filter = Control.MOUSE_FILTER_IGNORE
		hb.add_theme_constant_override("separation", 8)
		var path := "res://assets/icons/employee_roles/" + String(role[2])
		if ResourceLoader.exists(path):
			var ic := TextureRect.new()
			ic.texture = load(path)
			ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			ic.custom_minimum_size = Vector2(20, 20)
			ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
			ic.size_flags_vertical = Control.SIZE_SHRINK_CENTER
			hb.add_child(ic)
		var l := GDesk.make_label("%s  %d" % [role[1], n], "small", GDesk.C.bone, "GMono")
		l.name = "Role_%s" % role[0]
		l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		hb.add_child(l)
		_staff_grid.add_child(hb)
	if not any:
		_staff_grid.add_child(GDesk.make_label("No staff yet", "small", GDesk.C.muted))


func staff_text() -> String:
	"""The STAFF AT WORK rows as plain text (tests)."""
	var parts: Array = []
	for hb in _staff_grid.get_children():
		if hb is Label:
			parts.append((hb as Label).text)
			continue
		for c in hb.get_children():
			if c is Label:
				parts.append((c as Label).text)
	return ", ".join(parts)


func held_text() -> String:
	return _held_left.text


func spent_text() -> String:
	return _spent_at_commit.text if _spent_at_commit.visible else ""


func reply_text() -> String:
	return _reply.text if _reply.visible else ""


func closed_lines() -> Array:
	var out: Array = [_closed_title.text]
	for l in [_closed_used, _closed_unspent]:
		if l.visible:
			out.append(l.text)
	return out


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

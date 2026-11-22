class_name GFeedPanel
extends GPanel
## The WATCH feed (fork/design/godot-g/spec.md 5.10): bottom-left, 24 / bottom 1004, 560x288,
## shown in the WATCH view only.
##
## Rendered from the model main_ui already keeps (main_ui._feed_lines) with today's filter
## (main_ui._feed_passes_filter), on main_ui.feed_changed. It never moves or reads
## WatchScreen's message_log. Display only: writes nothing, draws no random number.
##
## Folded (the default): each line shows its day (mono, `muted`, on the first line of that
## day) and the game's message; the newest line has an amber left edge. Lines from the same
## day beyond the newest four collapse into "+ N more lines from <Day D Mon>".
## The full log is one click away (builder's choice, spec 5.10): the header button (or a
## fold line) switches the panel to the full log -- every stored line that passes the filter,
## unfolded, in one scrolling text -- and the panel grows up to just under the rail, so the
## rail's Staff, Ledger and Guide plates stay in reach. The same button folds it again.
## The two filter toggles are today's WatchScreen CheckButtons ("Hide arxiv flood", "Hide
## rival intel"), mirrored as small text toggles ("[x] HIDE ARXIV", "[ ] HIDE RIVALS", today's
## full words in their tooltips, so the header fits the panel's 560 px); a click sets today's button, whose toggled
## signal runs main_ui._on_feed_filter_changed / _on_rivals_filter_changed exactly as a
## click on classic's toggle does. The feed has no keycaps (none to hide while an event waits).
##
## Alex's Q2 (2026-11-22, ADR-0015, G drops the doom chip): G does not print doom changes in
## numbers. display_text() filters G's rendering of each line (main_ui logs it unchanged, and
## classic's feed still shows it): a line that is a doom change in numbers is hidden (today's
## "Doom X -> Y (change: +Z)" with its breakdown and momentum lines, the legacy "Doom +N"
## line, "Safety/alignment work reduced doom by N", "Capabilities research added N doom", the
## debug nudge line); a doom part inside a line about something else is cut out of it (the
## "doom +N" in a delta summary, "(+N doom)" after a warning, "+N doom" in a ledger-fallout or
## risk-event list). The P(Doom) card still shows the level.

const MAX_ROWS := 40          # folded: rows rendered (the panel scrolls; the newest at the bottom)
const FOLD_KEEP := 4          # folded: lines kept per day; older lines of that day fold away
const FULL_MAX_LINES := 500   # the full log: main_ui keeps at most FEED_MAX_LINES (500)
const EXPANDED_TOP := 480.0   # the full log grows up to here (the rail ends at ~456)
const DAY_W := 64.0

var host: Node = null
var expanded := false
var _title: Button
var _toggle_full: Button
var _filter_arxiv: Button
var _filter_rivals: Button
var _scroll: ScrollContainer
var _rows: VBoxContainer
var _full: RichTextLabel
var _rendered_count := -1
var _hidden_count := 0
var _render_pending := false
var _base_top := 0.0
var _follow := true           # the folded feed keeps its end in view (set on each render, cleared by the player's own scroll)
var _in_land := false
var _choice_names: Dictionary = {}   # option id -> its player-facing text, from events shown
var _choice_lines: Dictionary = {}   # stored line -> its G rendering, fixed at first sight


func _init() -> void:
	name = "FeedPanel"
	mouse_filter = Control.MOUSE_FILTER_STOP
	var m := MarginContainer.new()
	m.mouse_filter = Control.MOUSE_FILTER_IGNORE
	m.add_theme_constant_override("margin_left", 16)
	m.add_theme_constant_override("margin_right", 12)
	m.add_theme_constant_override("margin_top", 8)
	m.add_theme_constant_override("margin_bottom", 12)
	add_child(m)
	var vb := VBoxContainer.new()
	vb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vb.add_theme_constant_override("separation", 6)
	m.add_child(vb)

	var head := HBoxContainer.new()
	head.name = "Header"
	head.mouse_filter = Control.MOUSE_FILTER_IGNORE
	head.add_theme_constant_override("separation", 8)
	vb.add_child(head)
	_title = _text_button("FEED", "GCaps")
	_title.name = "Title"
	_title.tooltip_text = "Show the full log (click again to fold it)"
	_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_title.alignment = HORIZONTAL_ALIGNMENT_LEFT
	# The header never widens the panel (560 wide, spec 3.2): the title gives way first.
	_title.clip_text = true
	_title.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	_title.pressed.connect(toggle_expanded)
	head.add_child(_title)
	_filter_arxiv = _text_button("[ ] HIDE ARXIV", "GMono")
	_filter_arxiv.name = "FilterArxiv"
	_filter_arxiv.tooltip_text = "Hide arxiv flood: collapse the low-severity arxiv/research-flavour feed stream"
	_filter_arxiv.pressed.connect(_on_filter_pressed.bind("feed_filter_button"))
	head.add_child(_filter_arxiv)
	_filter_rivals = _text_button("[ ] HIDE RIVALS", "GMono")
	_filter_rivals.name = "FilterRivals"
	_filter_rivals.tooltip_text = "Hide rival intel: collapse rival-lab intel lines in the feed"
	_filter_rivals.pressed.connect(_on_filter_pressed.bind("rivals_filter_button"))
	head.add_child(_filter_rivals)
	_toggle_full = _text_button("ALL", "GCaps")
	_toggle_full.name = "ToggleFull"
	_toggle_full.tooltip_text = "Show the full log (click again to fold it)"
	_toggle_full.pressed.connect(toggle_expanded)
	head.add_child(_toggle_full)

	_scroll = ScrollContainer.new()
	_scroll.name = "Folded"
	_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_scroll.mouse_filter = Control.MOUSE_FILTER_PASS
	vb.add_child(_scroll)
	_rows = VBoxContainer.new()
	_rows.name = "Rows"
	_rows.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_rows.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_rows.add_theme_constant_override("separation", 3)
	_scroll.add_child(_rows)
	# Land on a whole line in the same layout pass that sizes the rows, so no frame shows the
	# rebuilt list at a stale scroll (spec 5.10; Alex, checkpoint A shots g-05/g-06).
	_scroll.sort_children.connect(_land)
	_scroll.gui_input.connect(_on_scroll_input)
	_scroll.get_v_scroll_bar().scrolling.connect(func(): _follow = false)

	_full = RichTextLabel.new()
	_full.name = "FullLog"
	_full.bbcode_enabled = true
	_full.scroll_active = true
	_full.scroll_following = true
	_full.fit_content = false
	_full.selection_enabled = true
	_full.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_full.visible = false
	_full.set_meta("g_size_prop", "normal_font_size")
	GDesk.set_step(_full, "small")
	GDesk.compact_step_up(_full)   # 720p: the body ink is already bone; only size can carry it
	GDesk.set_ink(_full, GDesk.C.bone, "default_color")
	vb.add_child(_full)


func _text_button(text: String, face: String) -> Button:
	"""A flat text button: no box, only its text. `face` "GCaps" takes the theme's GButton
	(Barlow caps), anything else GClose (Plex Mono); both are Button variations."""
	var b := Button.new()
	b.text = text
	b.flat = true
	b.focus_mode = Control.FOCUS_NONE
	b.theme_type_variation = &"GButton" if face == "GCaps" else &"GClose"
	GDesk.set_step(b, "small")
	for prop in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
		GDesk.set_ink(b, GDesk.C.muted if prop == "font_color" else GDesk.C.bone, prop)
	return b


func setup(main_ui: Node) -> void:
	host = main_ui
	render()


# --- the doom rule (Alex's Q2) -----------------------------------------------------------

const _TAGS := "(color|b|i|u|s|url|font_size|bgcolor|fgcolor|code|center|right|left)"
static var _re_tags: RegEx
static var _re_delta_doom: RegEx
static var _re_delta_doom_before: RegEx
static var _re_delta_doom_after: RegEx
static var _re_frag_list_before: RegEx
static var _re_frag_list_after: RegEx
static var _re_frag_paren: RegEx
static var _re_frag_colon: RegEx
static var _re_frag: RegEx
static var _re_doom_number: RegEx
static var _re_delta_empty: RegEx


static func _compile() -> void:
	if _re_tags != null:
		return
	_re_tags = RegEx.create_from_string("\\[/?" + _TAGS + "(=[^\\]]*)?\\]")
	# "[color=red]doom +3.0[/color]" in an EE-7 delta summary, with its list comma.
	var dd := "\\[color=[^\\]]*\\]doom [+-][0-9.]+\\[/color\\]"
	_re_delta_doom_before = RegEx.create_from_string(", " + dd)
	_re_delta_doom_after = RegEx.create_from_string(dd + ", ")
	_re_delta_doom = RegEx.create_from_string("\\s*" + dd)
	var frag := "[+-][0-9]+(\\.[0-9]+)?%? doom\\b"
	_re_frag_list_before = RegEx.create_from_string(",\\s*" + frag)
	_re_frag_list_after = RegEx.create_from_string(frag + ",\\s*")
	_re_frag_paren = RegEx.create_from_string("\\s*\\(" + frag + "\\)")
	_re_frag_colon = RegEx.create_from_string(":\\s*" + frag)
	_re_frag = RegEx.create_from_string("\\s*" + frag)
	# Anything left that still states a doom amount hides the whole line.
	_re_doom_number = RegEx.create_from_string(
		"(?i)(\\bdoom\\b:?\\s+(by\\s+)?[+-]?[0-9])|([0-9]+(\\.[0-9]+)?%?\\s+doom\\b)")
	_re_delta_empty = RegEx.create_from_string("delta\\[/color\\]\\s*$")


static func plain(text: String) -> String:
	"""The line without its BBCode tags."""
	_compile()
	return _re_tags.sub(text, "", true)


static func display_text(text: String) -> String:
	"""G's rendering of one stored feed line under Alex's Q2: the line as is, the line with
	its doom part cut out, or "" (hidden) when it is a doom change in numbers. Pure."""
	_compile()
	var t := text
	if t.contains("doom") or t.contains("Doom"):
		var had_delta := t.contains("delta[/color]")
		t = _re_delta_doom_before.sub(t, "", true)
		t = _re_delta_doom_after.sub(t, "", true)
		t = _re_delta_doom.sub(t, "", true)
		if had_delta and _re_delta_empty.search(t) != null:
			return ""
		t = _re_frag_list_before.sub(t, "", true)
		t = _re_frag_list_after.sub(t, "", true)
		t = _re_frag_paren.sub(t, "", true)
		t = _re_frag_colon.sub(t, "", true)
		t = _re_frag.sub(t, "", true)
		if _re_doom_number.search(plain(t)) != null:
			return ""
	return t


# --- render ------------------------------------------------------------------------------

func render() -> void:
	"""Coalesced: many lines can be logged in one frame (a day tick), so the panel re-renders
	once, at the end of the frame."""
	if _render_pending:
		return
	_render_pending = true
	_render_now.call_deferred()


func render_now() -> void:
	_render_pending = true
	_render_now()


func _render_now() -> void:
	if not _render_pending:
		return
	_render_pending = false
	if host == null or not is_instance_valid(host):
		return
	_refresh_filter_buttons()
	var shown := _shown_lines()
	if expanded:
		var parts: Array = []
		var start := maxi(0, shown.size() - FULL_MAX_LINES)
		for i in range(start, shown.size()):
			parts.append(String(shown[i].raw))
		_full.text = "\n".join(parts)
		_rendered_count = shown.size() - start
		return
	_fill_rows(shown)


func _shown_lines() -> Array:
	"""Every stored line that passes today's filter and G's doom rule, oldest first:
	[{raw, day, msg}] with the day stamp split off ("Jul 4, 2017")."""
	var lines: Array = host.get("_feed_lines") if host.get("_feed_lines") is Array else []
	var out: Array = []
	_hidden_count = 0
	for entry in lines:
		var channel := String(entry.get("channel", "normal"))
		if host.has_method("_feed_passes_filter") and not host._feed_passes_filter(channel):
			continue
		var raw := display_text(String(entry.get("text", "")))
		raw = _named_choice(raw)
		if raw == "":
			_hidden_count += 1
			continue
		var split := split_stamp(raw)
		if is_phase_line(String(split[1])):
			continue
		out.append({"raw": raw, "day": split[0], "msg": split[1]})
	return out


func note_event(event: Dictionary) -> void:
	"""Remember the player-facing text of an event's options while it is on screen, so G's
	feed can name the player's choice instead of printing its id (Alex, 2026-11-22: "raw IDs
	shouldn't be shown"). Read only."""
	for o in event.get("options", []):
		if o is Dictionary:
			var id := String(o.get("id", ""))
			var text := String(o.get("text", "")).strip_edges()
			if id != "" and text != "":
				_choice_names[id] = text


func _named_choice(raw: String) -> String:
	"""today's "Event choice: <id>" line, as "You chose: <name>" in G. The name comes from the
	event that was on screen (note_event); with none (a loaded game), the id is made readable.
	A line keeps the name it was first shown with. Classic's feed is unchanged."""
	var at := raw.find("Event choice: ")
	if at < 0:
		return raw
	if _choice_lines.has(raw):
		return String(_choice_lines[raw])
	var rest := raw.substr(at + 14)
	var end := rest.find("[")
	var id := (rest if end < 0 else rest.substr(0, end)).strip_edges()
	var nm := String(_choice_names.get(id, id.replace("_", " ").capitalize()))
	var out := raw.substr(0, at) + "You chose: " + nm + ("" if end < 0 else rest.substr(end))
	_choice_lines[raw] = out
	return out


static func is_phase_line(msg: String) -> bool:
	"""today's engine phase trace ("Turn Phase: turn_start"). G's playback bar and Commit
	already show the phase, so G's feed leaves it out; classic's feed is unchanged."""
	return plain(msg).strip_edges().begins_with("Turn Phase:")


static func split_stamp(raw: String) -> Array:
	"""[day, message] from main_ui.log_message's "[color=gray][Jul 4, 2017][/color] text"."""
	var pre := "[color=gray]["
	if raw.begins_with(pre):
		var close := raw.find("][/color] ")
		if close > 0:
			return [raw.substr(pre.length(), close - pre.length()), raw.substr(close + 10)]
	return ["", raw]


static func fold(shown: Array, keep: int = FOLD_KEEP) -> Array:
	"""Folding (spec 5.10): consecutive lines from the same day beyond the newest `keep`
	collapse into one fold row. Returns rows oldest first: {kind: "line"|"fold", day, msg,
	count, first_of_day}. Pure."""
	var out: Array = []
	var i := 0
	while i < shown.size():
		var day := String(shown[i].day)
		var j := i
		while j + 1 < shown.size() and String(shown[j + 1].day) == day:
			j += 1
		var n := j - i + 1
		var start := i
		if n > keep:
			out.append({"kind": "fold", "day": day, "count": n - keep, "msg": "", "first_of_day": true})
			start = j - keep + 1
		for k in range(start, j + 1):
			out.append({"kind": "line", "day": day, "msg": String(shown[k].msg),
				"first_of_day": k == start and n <= keep, "count": 1})
		i = j + 1
	return out


static func day_name(stamp: String) -> String:
	"""'Jul 4, 2017' -> 'Tue 4 Jul' (the fold line's <Day D Mon>). Pure calendar arithmetic."""
	var parts := stamp.replace(",", "").split(" ", false)
	if parts.size() < 3:
		return stamp
	var mi := Clock.MONTH_ABBR.find(parts[0])
	if mi < 0:
		return stamp
	var d := {"year": int(parts[2]), "month": mi + 1, "day": int(parts[1]),
		"hour": 12, "minute": 0, "second": 0}
	var wd := int(Time.get_datetime_dict_from_unix_time(Time.get_unix_time_from_datetime_dict(d)).weekday)
	var names := ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
	return "%s %d %s" % [names[wd], int(parts[1]), parts[0]]


static func short_day(stamp: String) -> String:
	"""'Jul 4, 2017' -> 'Jul 4' (the day column)."""
	var c := stamp.find(",")
	return stamp.substr(0, c) if c > 0 else stamp


func _fill_rows(shown: Array) -> void:
	for c in _rows.get_children():
		_rows.remove_child(c)
		c.free()
	var rows := fold(shown)
	if rows.size() > MAX_ROWS:
		rows = rows.slice(rows.size() - MAX_ROWS)
	_rendered_count = 0
	for r_i in range(rows.size()):
		var r: Dictionary = rows[r_i]
		var newest := r_i == rows.size() - 1
		var hb := HBoxContainer.new()
		hb.mouse_filter = Control.MOUSE_FILTER_IGNORE
		hb.add_theme_constant_override("separation", 8)
		var edge := ColorRect.new()
		edge.name = "Edge"
		edge.custom_minimum_size = Vector2(3, 0)
		edge.color = GDesk.C.amber if newest and r.kind == "line" else Color(0, 0, 0, 0)
		edge.mouse_filter = Control.MOUSE_FILTER_IGNORE
		hb.add_child(edge)
		var day := GDesk.make_label(short_day(String(r.day)) if bool(r.first_of_day) else "",
			"small", GDesk.C.muted, "GMono")
		day.custom_minimum_size = Vector2(DAY_W, 0)
		day.vertical_alignment = VERTICAL_ALIGNMENT_TOP
		hb.add_child(day)
		if r.kind == "fold":
			var b := _text_button("+ %d more line%s from %s" % [int(r.count),
				"" if int(r.count) == 1 else "s", day_name(String(r.day))], "GMonoReg")
			b.name = "Fold"
			b.alignment = HORIZONTAL_ALIGNMENT_LEFT
			b.tooltip_text = "Show the full log"
			b.pressed.connect(toggle_expanded)
			b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			hb.add_child(b)
		else:
			var t := RichTextLabel.new()
			t.name = "Msg"
			t.bbcode_enabled = true
			t.fit_content = true
			t.scroll_active = false
			t.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			t.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			t.mouse_filter = Control.MOUSE_FILTER_IGNORE
			t.set_meta("g_size_prop", "normal_font_size")
			GDesk.set_step(t, "small")
			GDesk.compact_step_up(t)   # 720p: the body ink is already bone; only size can carry it
			GDesk.set_ink(t, GDesk.C.bone, "default_color")
			t.text = String(r.msg).strip_edges()
			hb.add_child(t)
			_rendered_count += 1
		_rows.add_child(hb)
	_scroll_to_end()


func _scroll_to_end() -> void:
	# Land when the view next sorts (this frame's layout pass), once the new rows have sizes.
	_follow = true
	if is_instance_valid(_scroll):
		_scroll.queue_sort()


func _on_scroll_input(ev: InputEvent) -> void:
	# The player's own wheel scroll stops the follow until the next render (today's feed also
	# jumps to its end on each new line).
	if ev is InputEventMouseButton and (ev as InputEventMouseButton).pressed:
		var bi := (ev as InputEventMouseButton).button_index
		if bi == MOUSE_BUTTON_WHEEL_UP or bi == MOUSE_BUTTON_WHEEL_DOWN:
			_follow = false


func _land() -> void:
	"""Scroll the folded feed to its end, starting on a whole line: the oldest visible row
	would otherwise sit half under the panel's top edge. Room under the last row (under one
	row high) lets the scroll start on the first row whose top is at or below the plain end.
	Runs on every sort of the scroll view, so it settles in the same frame. Display only."""
	if _in_land or not _follow or expanded or not is_instance_valid(_scroll):
		return
	var natural := 0.0
	if _rows.get_child_count() > 0:
		var last := _rows.get_child(_rows.get_child_count() - 1) as Control
		natural = last.position.y + last.size.y
	if natural > _rows.size.y + 0.5:
		return   # the rows are not sorted yet; the sort that places them lands again
	_in_land = true
	var v := maxf(0.0, natural - _scroll.size.y)
	var top := v
	if v > 0.0:
		for r in _rows.get_children():
			if (r as Control).position.y >= v - 0.5:
				top = (r as Control).position.y
				break
	var want := natural + (top - v) if top - v > 0.5 else 0.0
	if absf(_rows.custom_minimum_size.y - want) > 0.5:
		# Room first; the view re-sorts with its new end and lands then (setting the scroll
		# now would be clamped to the old end).
		_rows.custom_minimum_size.y = want
		_in_land = false
		return
	_scroll.scroll_vertical = int(roundf(top))
	_rows.position.y = -float(_scroll.scroll_vertical)   # in place now, not on the next sort
	_in_land = false


func first_row_cut() -> float:
	"""How many pixels of the oldest visible folded row sit above the panel's top edge
	(0 = it starts on a whole line). For tests."""
	var v := float(_scroll.scroll_vertical)
	for r in _rows.get_children():
		var c := r as Control
		if c.position.y + c.size.y > v:
			return maxf(0.0, v - c.position.y)
	return 0.0


# --- full log, filters --------------------------------------------------------------------

func toggle_expanded() -> void:
	set_expanded(not expanded)


func set_expanded(on: bool) -> void:
	"""The full log (one click away) or the folded feed. The panel grows up to just under the
	rail while the full log shows, and returns to its own box when folded."""
	expanded = on
	_scroll.visible = not on
	_full.visible = on
	_toggle_full.text = "FOLD" if on else "ALL"
	_title.tooltip_text = "Fold the feed" if on else "Show the full log (click again to fold it)"
	_toggle_full.tooltip_text = _title.tooltip_text
	if _base_top == 0.0:
		_base_top = offset_top
	if anchor_top == 1.0:
		offset_top = (EXPANDED_TOP - 1080.0) if on else _base_top
	render_now()


func _watch_screen():
	if host == null or not is_instance_valid(host):
		return null
	var ws = host.get("watch_screen")
	return ws if ws != null and is_instance_valid(ws) else null


func _on_filter_pressed(which: String) -> void:
	"""Flip today's WatchScreen toggle: its toggled signal runs main_ui's own filter handler
	(and so persists the rival preference exactly as classic's toggle does)."""
	var ws = _watch_screen()
	if ws == null:
		return
	var b = ws.get(which)
	if b is BaseButton:
		(b as BaseButton).button_pressed = not (b as BaseButton).button_pressed
	_refresh_filter_buttons()


func _refresh_filter_buttons() -> void:
	var ws = _watch_screen()
	if ws == null:
		return
	for pair in [[_filter_arxiv, "feed_filter_button", "HIDE ARXIV"],
			[_filter_rivals, "rivals_filter_button", "HIDE RIVALS"]]:
		var b = ws.get(pair[1])
		var on: bool = b is BaseButton and (b as BaseButton).button_pressed
		(pair[0] as Button).text = "[%s] %s" % ["x" if on else " ", pair[2]]


func filter_on(which: String) -> bool:
	var ws = _watch_screen()
	var b = ws.get(which) if ws != null else null
	return b is BaseButton and (b as BaseButton).button_pressed


func press_filter(which: String) -> void:
	"""Tests and the harness: a click on one of the two toggles."""
	(_filter_arxiv if which == "feed_filter_button" else _filter_rivals).pressed.emit()


func set_month(text: String) -> void:
	_title.text = "FEED  -  %s" % text if text != "" else "FEED"


func line_count() -> int:
	return _rendered_count


func hidden_count() -> int:
	"""Lines G's doom rule hid on the last render (tests)."""
	return _hidden_count


func plain_text() -> String:
	"""What the panel shows, as plain text (tests)."""
	if expanded:
		return _full.get_parsed_text()
	var parts: Array = []
	for hb in _rows.get_children():
		var line := ""
		for c in hb.get_children():
			if c is RichTextLabel:
				line += (c as RichTextLabel).get_parsed_text()
			elif c is Button:
				line += (c as Button).text
			elif c is Label and (c as Label).text != "":
				line += (c as Label).text + " "
		parts.append(line)
	return "\n".join(parts)


func newest_edge_lit() -> bool:
	if _rows.get_child_count() == 0:
		return false
	var last := _rows.get_child(_rows.get_child_count() - 1)
	var e := last.get_node_or_null("Edge") as ColorRect
	return e != null and e.color == GDesk.C.amber

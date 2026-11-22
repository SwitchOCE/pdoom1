class_name GFeedPanel
extends PanelContainer
## The WATCH feed (fork/design/godot-g/spec.md 5.10), plain first cut so the month is not
## silent in G: bottom-left, 24 / bottom 1004, 560x288, shown in WATCH only. Phase 1c finishes
## it (styling, day column, folding, the filter toggles, the full-log overlay).
##
## Rendered from the model main_ui already keeps (main_ui._feed_lines) with today's filter
## (main_ui._feed_passes_filter), on main_ui.feed_changed. It never moves or reads
## WatchScreen's message_log. Display only: writes nothing, draws no random number.

const MAX_LINES := 60

var host: Node = null
var _title: Label
var _text: RichTextLabel
var _rendered_count := -1


func _init() -> void:
	name = "FeedPanel"
	mouse_filter = Control.MOUSE_FILTER_STOP
	add_theme_stylebox_override("panel", GDesk.make_box(GDesk.C.panel, GDesk.C.frame_hi, 1, 0))
	var m := MarginContainer.new()
	m.mouse_filter = Control.MOUSE_FILTER_IGNORE
	m.add_theme_constant_override("margin_left", 16)
	m.add_theme_constant_override("margin_right", 12)
	m.add_theme_constant_override("margin_top", 10)
	m.add_theme_constant_override("margin_bottom", 12)
	add_child(m)
	var vb := VBoxContainer.new()
	vb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vb.add_theme_constant_override("separation", 8)
	m.add_child(vb)
	_title = GDesk.make_label("FEED", "small", GDesk.C.muted)
	vb.add_child(_title)
	_text = RichTextLabel.new()
	_text.name = "Lines"
	_text.bbcode_enabled = true
	_text.scroll_active = true
	_text.scroll_following = true
	_text.fit_content = false
	_text.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_text.add_theme_font_size_override("normal_font_size", ThemeManager.get_font_size("small"))
	_text.add_theme_color_override("default_color", GDesk.C.bone)
	vb.add_child(_text)


func setup(main_ui: Node) -> void:
	host = main_ui
	render()


func render() -> void:
	"""The last MAX_LINES lines that pass today's filter, oldest first (the newest at the
	bottom, followed by the scroll)."""
	if host == null or not is_instance_valid(host):
		return
	var lines: Array = host.get("_feed_lines") if host.get("_feed_lines") is Array else []
	var shown: Array = []
	for i in range(lines.size() - 1, -1, -1):
		var entry: Dictionary = lines[i]
		if host.has_method("_feed_passes_filter") and not host._feed_passes_filter(String(entry.get("channel", "normal"))):
			continue
		shown.push_front(String(entry.get("text", "")))
		if shown.size() >= MAX_LINES:
			break
	_text.text = "\n".join(shown)
	_rendered_count = shown.size()


func set_month(text: String) -> void:
	_title.text = "FEED  -  %s" % text if text != "" else "FEED"


func line_count() -> int:
	return _rendered_count


func plain_text() -> String:
	return _text.get_parsed_text()

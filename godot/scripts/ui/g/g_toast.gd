class_name GToast
extends PanelContainer
## G's refusal toast (spec 5.6.1, A5). Today every PLAN-time refusal reaches
## EventResultPresenter.present_error, which writes the WATCH-only feed and plan_screen's toast;
## G hides ContentArea, so that toast is never seen. present_error now also emits
## main_ui.rejection_reported(message), and the desk shows it here: one line under the banner,
## `warn` text on panel-2, "[!] " + message, for 4 s like today's toast. A newer message
## replaces an older one.
##
## The hide is a Tween on this (pausable) node, so it freezes under the pause menu exactly
## like today's create_timer(4.0, false) (PAUSE_SEMANTICS "messages freeze"). No timer.

const SHOW_SECONDS := 4.0

var _label: Label
var _tween: Tween


func _init() -> void:
	name = "GToast"
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	visible = false
	theme_type_variation = &"GToast"     # warn hairline on panel-2 (theme/g_theme.tres)
	_label = GDesk.make_label("", "body", GDesk.C.warn, "GSansMed")
	_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(_label)


func show_message(message: String) -> void:
	if message == "":
		return
	_label.text = "[!] %s" % message
	visible = true
	if _tween != null and _tween.is_valid():
		_tween.kill()
	_tween = create_tween()
	_tween.tween_interval(SHOW_SECONDS)
	_tween.tween_callback(func(): visible = false)


func message_text() -> String:
	return _label.text

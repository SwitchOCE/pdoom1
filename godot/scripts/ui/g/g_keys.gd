class_name GKeys
extends RefCounted
## G key routing (fork/design/godot-g/spec.md 8.2): one static, pure decision.
##
## route(event, top_kind, phase, kb, skipped) -> an intent the desk performs:
##   "toggle_actions", "toggle_plan", "toggle_upgrades", "staff", "guide", "reserve", "undo",
##   "clear", "slot_N" (N = 0..8), or "" (not G's key: main_ui handles it exactly as today).
##
## `kb` is the key matcher: KeybindManager at run time, a small stub in unit tests, so this
## function never names an autoload. The six G binds are checked with six LITERAL calls (not
## a loop over a table), so tests/unit/test_navigation_principles.gd
## test_no_keybind_action_is_inert can see each one (spec 8.1, A2).
##
## `top_kind` is ModalStack.top_kind(), except that the desk passes "modal" for a registered
## modal that has no kind (today's submenus and the ledger are presented without one), so a
## kind-less modal is never mistaken for "nothing open".
## `skipped` lists the G binds whose key an existing (non-g_) bind already uses (V7): the
## existing bind wins and the G bind is not matched.
##
## Pure: reads the event and its arguments only. Writes nothing, draws no random number.

const SHEET_KINDS := ["g_actions", "g_plan", "g_upgrades"]


static func route(event: InputEvent, top_kind: String, phase: String, kb, skipped: Array = []) -> String:
	if event == null or not (event is InputEventKey):
		return ""
	# A modal that is not G's own (an event, the review, a submenu, the ledger, the bug form)
	# keeps every key: the dialog block handles it exactly as today (V5).
	if top_kind != "" and not top_kind.begins_with("g_"):
		return ""
	var in_plan := phase.to_upper() == "ACTION_SELECTION"

	if not skipped.has("g_actions") and kb.is_action_pressed(event, "g_actions"):
		return "toggle_actions" if in_plan else ""
	if not skipped.has("g_upgrades") and kb.is_action_pressed(event, "g_upgrades"):
		return "toggle_upgrades" if in_plan else ""
	if not skipped.has("g_plan") and kb.is_action_pressed(event, "g_plan"):
		return "toggle_plan" if in_plan else ""
	if not skipped.has("g_staff") and kb.is_action_pressed(event, "g_staff"):
		return "staff"
	if not skipped.has("g_guide") and kb.is_action_pressed(event, "g_guide"):
		return "guide"

	# Inside the Plan drawer: Z, C and R act on the plan (the desk checks today's buttons).
	if top_kind == "g_plan":
		if kb.is_action_pressed(event, "undo_action"):
			return "undo"
		if kb.is_action_pressed(event, "clear_queue"):
			return "clear"
		if not skipped.has("g_reserve") and kb.is_action_pressed(event, "g_reserve"):
			return "reserve"
	# Inside the Actions sheet: 1-9 are the same action slots as on the desk.
	if top_kind == "g_actions":
		for i in range(9):
			if kb.is_action_pressed(event, "action_%d" % (i + 1)):
				return "slot_%d" % i
	return ""


static func skipped_binds(binds: Dictionary) -> Array:
	"""V7: the G binds whose key (with the same modifiers) an existing non-g_ bind already
	uses. Saved profiles keep their keys and gain new defaults alongside, so a player who put
	Commit on A would otherwise get two actions on one key; the existing bind wins."""
	var out: Array = []
	for g_name in binds.keys():
		if not String(g_name).begins_with("g_"):
			continue
		var g: Dictionary = binds[g_name]
		for other in binds.keys():
			if String(other).begins_with("g_"):
				continue
			var o: Dictionary = binds[other]
			if int(o.get("key", -1)) == int(g.get("key", -2)) \
					and bool(o.get("shift", false)) == bool(g.get("shift", false)) \
					and bool(o.get("ctrl", false)) == bool(g.get("ctrl", false)) \
					and bool(o.get("alt", false)) == bool(g.get("alt", false)):
				out.append(g_name)
				break
	return out

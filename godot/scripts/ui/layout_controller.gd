class_name LayoutController
extends Node
## A/B layout controller (UI_PROPOSALS_2026-07-22 section 4). Sibling to ScreenModeController,
## same proven move: it does NOT duplicate scenes and does NOT rebuild the widget tree -- it
## REGISTERS the existing container nodes and flips a handful of their layout properties from a
## persisted flag (GameConfig.ui_layout). "classic" restores the captured scene defaults so it
## stays pixel-identical to today; "proposed" applies the P6/P9/P10/P11 container deltas.
##
## Every A/B difference this node owns lives in _apply_proposed / _restore_classic so the two
## arrangements are legible side by side and easy to tune. apply_layout() is idempotent: it
## always restores classic first, then layers proposed on top, so flip->flip->flip never drifts.
##
## VIEW-ONLY (ADR-0006): container properties only -- zero writes to game state, zero RNG, no
## turn-logic. P9 (grouped action submenus) and P10 (the committed-queue gantt) need game-data
## population hooks, so main_ui gates those on is_proposed(); this node owns the pure reflow:
##   P6  -- clamp the OfficeCat so it can't dominate the PLAN centre.
##   P11 -- rebalance the three column stretch ratios (reclaim the instrument dead-zone, give
##          the WATCH office-floor more of the right side) + dock the orphaned upgrades list.

signal layout_changed(name: String)

var current: String = "classic"

# Registered reflow targets (set by main_ui via register_targets()).
var _plan_col: Control
var _instrument_col: Control
var _watch_col: Control
var _office_cat: Control
var _plan_screen: Control            # VBox that parents the upgrades label + scroll
var _upgrades_label: Control
var _upgrades_scroll: Control

# Captured scene defaults (so "classic" restores byte-for-byte). Captured once, before any flip.
var _captured := false
var _orig_plan_ratio: float = 0.3
var _orig_instrument_ratio: float = 0.3
var _orig_watch_ratio: float = 0.4
var _orig_cat_min: Vector2 = Vector2.ZERO
var _orig_cat_hflags: int = 0
var _orig_upgrades_scroll_min: Vector2 = Vector2.ZERO

# The proposed-mode upgrades dock (a framed panel built on demand; freed on restore).
var _dock_panel: PanelContainer = null

# --- "g": the G desk (fork/design/godot-g/spec.md 2.1-2.2) ---------------------------------
# A third arrangement. apply_layout("g") restores classic, then _apply_g(): the desk node is
# built and seeded from the live UI first, then the classic chrome is hidden. Leaving g puts
# the chrome back (recorded visibility), re-applies the current PLAN/WATCH visibility, and
# frees the desk last. toggle() is unchanged (classic <-> proposed).
const G_DESK_SCENE := "res://scenes/ui/g/g_desk.tscn"
const G_CHROME_PATHS := ["TopBar", "HSeparator1", "ContentArea", "HSeparator2", "InfoBar", "BottomBar"]
var _host: Node = null                 # MainUI (set by register_g_host)
var g_desk: Control = null             # the live GDesk while the layout is g
var _g_hidden: Dictionary = {}         # node -> visibility before g hid it
# Live nodes moved into the G sheets (spec 2.2 step 4), with where they came from:
# [{node, parent, index, size_flags_v, min_size}], restored in reverse before the desk is freed.
var _g_moved: Array = []
# Today's room before g took it (spec 2.2 step 3): {backdrop, modulate, material, scrim,
# scrim_visible}, restored when the layout leaves g.
var _g_room_saved: Dictionary = {}

# Proposed column split: tighten the instrument column (D5/D6 dead-zone) and hand the reclaimed
# width to WATCH so the office floor breathes (P11). PLAN holds so the hand doesn't reflow.
const _PROPOSED_PLAN_RATIO := 0.30
const _PROPOSED_INSTRUMENT_RATIO := 0.24
const _PROPOSED_WATCH_RATIO := 0.46


func register_targets(plan_col: Control, instrument_col: Control, watch_col: Control,
		office_cat: Control, plan_screen: Control, upgrades_label: Control,
		upgrades_scroll: Control) -> void:
	"""Hand the controller the existing nodes it reflows. Captures their scene-default values
	on first call so classic can always restore them exactly."""
	_plan_col = plan_col
	_instrument_col = instrument_col
	_watch_col = watch_col
	_office_cat = office_cat
	_plan_screen = plan_screen
	_upgrades_label = upgrades_label
	_upgrades_scroll = upgrades_scroll
	_capture_defaults()


func _capture_defaults() -> void:
	if _captured:
		return
	if _plan_col != null:
		_orig_plan_ratio = _plan_col.size_flags_stretch_ratio
	if _instrument_col != null:
		_orig_instrument_ratio = _instrument_col.size_flags_stretch_ratio
	if _watch_col != null:
		_orig_watch_ratio = _watch_col.size_flags_stretch_ratio
	if _office_cat != null:
		_orig_cat_min = _office_cat.custom_minimum_size
		_orig_cat_hflags = _office_cat.size_flags_horizontal
	if _upgrades_scroll != null:
		_orig_upgrades_scroll_min = _upgrades_scroll.custom_minimum_size
	_captured = true


func register_g_host(host: Node) -> void:
	"""Hand the controller MainUI so the g arrangement can build its desk next to it."""
	_host = host


func is_proposed() -> bool:
	return current == "proposed"


func is_g() -> bool:
	return current == "g"


func apply_layout(name: String) -> void:
	"""Set the arrangement. Idempotent: restore classic, then (for proposed) layer the deltas,
	or (for g) build the G desk. Unknown names coerce to classic so a bad flag can never leave
	the UI half-reflowed."""
	var target := name if (name == "proposed" or name == "g") else "classic"
	_restore_classic()
	if target == "proposed":
		_apply_proposed()
	elif target == "g":
		_apply_g()
	current = target
	layout_changed.emit(current)


func toggle() -> String:
	"""Flip between the two arrangements and return the new one (for the dev hotkey)."""
	apply_layout("classic" if current == "proposed" else "proposed")
	return current


# --- classic (restore captured scene defaults) --------------------------------------------

func _restore_classic() -> void:
	_leave_g()
	if not _captured:
		return
	if _plan_col != null:
		_plan_col.size_flags_stretch_ratio = _orig_plan_ratio
	if _instrument_col != null:
		_instrument_col.size_flags_stretch_ratio = _orig_instrument_ratio
	if _watch_col != null:
		_watch_col.size_flags_stretch_ratio = _orig_watch_ratio
	if _office_cat != null:
		_office_cat.custom_minimum_size = _orig_cat_min
		_office_cat.size_flags_horizontal = _orig_cat_hflags
	_undock_upgrades()


# --- proposed (P6 + P11 container deltas) --------------------------------------------------

func _apply_proposed() -> void:
	# P11: rebalance the columns -- reclaim the instrument dead-zone for the WATCH office floor.
	if _plan_col != null:
		_plan_col.size_flags_stretch_ratio = _PROPOSED_PLAN_RATIO
	if _instrument_col != null:
		_instrument_col.size_flags_stretch_ratio = _PROPOSED_INSTRUMENT_RATIO
	if _watch_col != null:
		_watch_col.size_flags_stretch_ratio = _PROPOSED_WATCH_RATIO
	# P6: clamp the cat so it can't dominate the PLAN centre (no-op while it is hidden in the
	# scene; the clamp bites the moment the ambient-office lane un-hides it).
	if _office_cat != null:
		_office_cat.custom_minimum_size = Vector2(0, 0)
		_office_cat.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	# P11: dock the orphaned upgrades list into a framed panel (D6 -- stops it reading as
	# floating below the hand).
	_dock_upgrades()


func _dock_upgrades() -> void:
	"""Wrap the upgrades label + scroll in a titled PanelContainer. This is the ONE reparent in
	the harness (a single leaf subtree, exactly the doc-endorsed move): the object references
	main_ui/plan_screen hold to upgrades_list stay valid because reparent moves nodes, not refs.
	Fully reversible -- _undock_upgrades puts them back at the same index for pixel-identical
	classic."""
	if _dock_panel != null or _plan_screen == null or _upgrades_label == null or _upgrades_scroll == null:
		return
	var idx := _upgrades_label.get_index()
	_dock_panel = PanelContainer.new()
	_dock_panel.name = "UpgradesDock"
	_dock_panel.size_flags_vertical = Control.SIZE_SHRINK_END
	TerminalTheme.style_panel(_dock_panel, TerminalTheme.AMBER_DIM, TerminalTheme.PANEL_BG_DEEP)
	var vb := VBoxContainer.new()
	vb.add_theme_constant_override("separation", 2)
	_dock_panel.add_child(vb)
	_plan_screen.add_child(_dock_panel)
	_plan_screen.move_child(_dock_panel, idx)
	_upgrades_label.reparent(vb)
	_upgrades_scroll.reparent(vb)
	# Bound the scroll so a long upgrades list can't stretch back into the reclaimed dead-zone.
	_upgrades_scroll.custom_minimum_size = Vector2(0, 132)


func _undock_upgrades() -> void:
	if _dock_panel == null:
		return
	var idx := _dock_panel.get_index()
	if _upgrades_label != null and _plan_screen != null:
		_upgrades_label.reparent(_plan_screen)
		_plan_screen.move_child(_upgrades_label, idx)
	if _upgrades_scroll != null and _plan_screen != null:
		_upgrades_scroll.reparent(_plan_screen)
		_plan_screen.move_child(_upgrades_scroll, idx + 1)
		_upgrades_scroll.custom_minimum_size = _orig_upgrades_scroll_min
	_dock_panel.queue_free()
	_dock_panel = null


# --- g (the G desk) -------------------------------------------------------------------------

func _g_chrome() -> Array:
	"""Classic chrome the desk replaces: the top bar, separators, the content area, the info
	and bottom bars, plus ScreenModeController's banner and WATCH strip (spec 2.2 step 2)."""
	var out: Array = []
	if _host == null or not is_instance_valid(_host):
		return out
	for p in G_CHROME_PATHS:
		var n = _host.get_node_or_null(p)
		if n != null:
			out.append(n)
	var sm = _host.get("screen_mode")
	if sm != null:
		if sm.banner != null:
			out.append(sm.banner)
		if sm.watch_bar != null:
			out.append(sm.watch_bar)
	return out


func _apply_g() -> void:
	"""Spec 2.2, in order: the desk exists and is seeded before anything is hidden."""
	if _host == null or not is_instance_valid(_host) or g_desk != null:
		return
	var tm: Node = _host.get_parent()
	if tm == null:
		return
	# 1. Instance the desk directly after MainUI (later modals on TabManager draw above it).
	var desk: Control = load(G_DESK_SCENE).instantiate()
	tm.add_child(desk)
	tm.move_child(desk, _host.get_index() + 1)
	g_desk = desk
	var chrome := _g_chrome()
	desk.chrome_nodes = chrome
	desk.setup(_host)
	# 2. Hide the classic chrome, recording what was visible.
	_g_hidden.clear()
	for n in chrome:
		_g_hidden[n] = (n as CanvasItem).visible
		(n as CanvasItem).visible = false
	# 3. The room (spec 5.14): save today's Backdrop modulate and material and the scrim's
	#    visibility, then hand both to the desk's room layer, which applies GPrefs.room_effects.
	_g_take_room(desk)
	# 4. Reparent four live nodes into the persistent G sheets, exactly as _dock_upgrades does,
	#    recording parent and index: the upgrades label and scroll -> the Upgrades sheet; the
	#    research-quality selector and the in-flight hiring box -> the Plan drawer.
	_g_moved.clear()
	var up = desk.get("upgrades_panel")
	var pl = desk.get("plan_panel")
	if up != null:
		_g_move(_upgrades_label, up.body_slot, false)
		_g_move(_upgrades_scroll, up.body_slot, true)
	if pl != null:
		var rqs = _host.get("research_quality_selector")
		if _g_move(rqs, pl.quality_slot, false) and rqs.has_method("set_g_style"):
			rqs.set_g_style(true)
		_g_move(_host.get("_inflight_hiring_box"), pl.underway_slot, false)


func _g_room_nodes() -> Array:
	"""[Backdrop, BackdropScrim] of main.tscn (siblings of TabManager), or nulls."""
	if _host == null or not is_instance_valid(_host):
		return [null, null]
	var tm: Node = _host.get_parent()
	var main: Node = tm.get_parent() if tm != null else null
	if main == null:
		return [null, null]
	return [main.get_node_or_null("Backdrop"), main.get_node_or_null("BackdropScrim")]


func _g_take_room(desk: Node) -> void:
	var nodes := _g_room_nodes()
	var bd = nodes[0]
	var scrim = nodes[1]
	_g_room_saved = {}
	if bd is TextureRect:
		_g_room_saved["backdrop"] = bd
		_g_room_saved["modulate"] = (bd as TextureRect).modulate
		_g_room_saved["material"] = (bd as TextureRect).material
	if scrim is CanvasItem:
		_g_room_saved["scrim"] = scrim
		_g_room_saved["scrim_visible"] = (scrim as CanvasItem).visible
	var room = desk.get("room")
	if room != null and bd is TextureRect:
		room.attach(bd, scrim if scrim is CanvasItem else null)


func _g_restore_room(desk: Node) -> void:
	if desk != null and is_instance_valid(desk):
		var room = desk.get("room")
		if room != null and is_instance_valid(room):
			room.release()
	var bd = _g_room_saved.get("backdrop")
	if bd != null and is_instance_valid(bd):
		(bd as TextureRect).modulate = _g_room_saved.get("modulate", Color(1, 1, 1, 1))
		(bd as TextureRect).material = _g_room_saved.get("material")
	var scrim = _g_room_saved.get("scrim")
	if scrim != null and is_instance_valid(scrim):
		(scrim as CanvasItem).visible = bool(_g_room_saved.get("scrim_visible", true))
	_g_room_saved = {}


func _g_move(node, target: Node, expand: bool) -> bool:
	if node == null or not is_instance_valid(node) or target == null or node.get_parent() == null:
		return false
	var c := node as Control
	_g_moved.append({"node": c, "parent": c.get_parent(), "index": c.get_index(),
		"size_flags_v": c.size_flags_vertical, "min_size": c.custom_minimum_size})
	c.reparent(target, false)
	if expand:
		c.size_flags_vertical = Control.SIZE_EXPAND_FILL
	return true


func _g_restore_moved() -> void:
	for i in range(_g_moved.size() - 1, -1, -1):
		var e: Dictionary = _g_moved[i]
		var c = e["node"]
		var parent = e["parent"]
		if c == null or not is_instance_valid(c) or parent == null or not is_instance_valid(parent):
			continue
		c.reparent(parent, false)
		parent.move_child(c, mini(int(e["index"]), parent.get_child_count() - 1))
		c.size_flags_vertical = int(e["size_flags_v"])
		c.custom_minimum_size = e["min_size"]
		if c.has_method("set_g_style"):
			c.set_g_style(false)
	_g_moved.clear()


func _leave_g() -> void:
	"""Spec 2.2 leaving g, in order: G-owned modals closed, chrome back, current PLAN/WATCH
	visibility re-applied, then the desk freed."""
	if g_desk == null:
		return
	var desk := g_desk
	g_desk = null
	if is_instance_valid(desk):
		desk.detach()   # 1. stop listening; closes the embedded guide through ModalStack
	if _host != null and is_instance_valid(_host) and _host.get("modal_stack") != null:
		var guard := 0
		while String(_host.modal_stack.top_kind()).begins_with("g_") and guard < 8:
			_host.modal_stack.dismiss(_host.modal_stack.top_node())
			guard += 1
	# 2. Reparent the sheet nodes back, before anything is freed.
	_g_restore_moved()
	# 3. Backdrop modulate and material and the scrim back to what they were.
	_g_restore_room(desk)
	# 4. Chrome back, then the CURRENT mode's visibility (a flip in WATCH keeps WATCH).
	for n in _g_hidden:
		if n != null and is_instance_valid(n):
			(n as CanvasItem).visible = bool(_g_hidden[n])
	_g_hidden.clear()
	if _host != null and is_instance_valid(_host):
		var sm = _host.get("screen_mode")
		if sm != null:
			sm.set_mode(sm.current_mode)
	# 5. Free the desk.
	if is_instance_valid(desk):
		var parent := desk.get_parent()
		if parent != null:
			parent.remove_child(desk)
		desk.queue_free()

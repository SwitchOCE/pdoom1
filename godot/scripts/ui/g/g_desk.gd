class_name GDesk
extends Control
## The G desk (fork/design/godot-g/spec.md 2.2-2.3): a full-rect layer that LayoutController
## adds to TabManager directly after MainUI when the layout is "g". MainUI stays visible but
## empty (its chrome is hidden), so MainUI._input keeps every key and every handler exactly
## as today. Every G control calls the handler today's control calls (spec 9).
##
## Phase 1a, plain look: top strip (dateline slot with today's turn label text, plain
## resource numbers, Menu), banner and view switch, rail, P(Doom) card, Attention card (PLAN
## face), held plate, Commit plate, Feedback, the advisor note and the refusal toast.
## Phase 1b: the three sheets (Actions with its detail card and door return, the Plan drawer,
## Upgrades), presented through ModalStack (spec 2.4); G's keys through GKeys (spec 8); a plain
## WATCH feed (spec 5.10, finished in 1c).
## Phase 1c, WATCH (spec 5.2, 5.5, 5.6, 5.10): the playback bar and speed segments in the
## banner, the four WATCH sub-states W1-W4 (watch_state), the Attention card's WATCH and closed
## faces, Commit's WATCH captions, and the finished feed (folding, the full log, the filters).
## Phase 2a, the look (spec 4): the desk's root carries theme/g_theme.tres (g_desk.tscn), so
## every G control takes its faces, styleboxes and colour tokens from it through a theme type
## variation (GPanel, GPlate, GKeycap, GCaps, GMono, ...). The theme sets no font size: every
## size is set here in code through ThemeManager.get_font_size(), by rank (spec 4.4).
##
## VIEW-ONLY: reads the state dicts main_ui already receives, writes no game state, draws no
## random number (spec 7.4), creates no timers (spec 6.1).

# --- Colour tokens (spec 4.1, H's palette). The same tokens are the `GColors` colours in
# theme/g_theme.tres (tests/unit/test_g_theme.gd keeps the two equal); code that draws or
# sets a per-node colour reads them from here. ---
const C := {
	"void": Color("#090807"),
	"panel": Color(16.0 / 255.0, 14.0 / 255.0, 12.0 / 255.0, 0.95),
	"panel_solid": Color("#100e0c"),
	"panel2": Color("#1a1612"),
	"well": Color("#0d0b0a"),
	"frame": Color(196.0 / 255.0, 176.0 / 255.0, 138.0 / 255.0, 0.16),
	"frame_hi": Color(196.0 / 255.0, 176.0 / 255.0, 138.0 / 255.0, 0.28),
	"tick": Color("#6a573a"),
	"bone": Color("#d6cebd"),
	"muted": Color("#aaa08e"),
	"dim": Color("#968d7c"),
	"plan": Color("#c9a465"),
	"plan_fill": Color("#a8854b"),
	"op": Color("#93b3a9"),
	"op_fill": Color("#6c8f86"),
	"amber": Color("#d9a03a"),
	"amber_line": Color(217.0 / 255.0, 160.0 / 255.0, 58.0 / 255.0, 0.62),
	"warn": Color("#d58a52"),
	"blood": Color("#9b3328"),
	"blood_text": Color("#d25a49"),
	"held": Color("#c9d2d8"),
	"paper": Color("#c3b79c"),
	"paper_dark": Color("#afa286"),
	"ink": Color("#1a140d"),
	"ink_soft": Color("#221b13"),
	"rail_edge": Color("#3a1d33"),   # Pip's aubergine, kept as a 3 px trace (spec 5.3, Q13)
	"dateline": Color("#d9d1bf"),
}

const THEME_PATH := "res://theme/g_theme.tres"
const ICON_ROOT := "res://assets/icons/"
const RESOURCE_KEYS := ["money", "compute", "research", "papers", "reputation"]
const RESOURCE_CAPS := {
	"money": "MONEY", "compute": "COMPUTE", "research": "RESEARCH",
	"papers": "PAPERS", "reputation": "REPUTATION",
}

var host: Node = null              # MainUI (untyped, as ModalStack/SubmenuController do)
var chrome_nodes: Array = []       # classic chrome LayoutController hid; re-hidden on mode change
var _detached := false
var _last_state: Dictionary = {}
var _modal_open_cache := -1        # -1 unknown, 0 closed, 1 open (keycap visibility)

# Built nodes (public so tests and the capture harness can reach them).
var top_strip: PanelContainer
var dateline: Label
var resource_values: Dictionary = {}   # key -> Label (value)
var resource_cells: Dictionary = {}    # key -> Control (cell)
## EE-7 "last turn" change chips, copied from main_ui._delta_labels (money, compute and
## reputation only; the doom chip is a printed doom delta, ADR-0015, and is not shown).
const DELTA_CHIP_KEYS := ["money", "compute", "reputation"]
var resource_chips: Dictionary = {}    # key -> Label
var menu_button: Button
var banner: PanelContainer
var mode_label: Label
var view_plan_button: Button
var view_watch_button: Button
var view_keycap: Control
var rail: VBoxContainer
var plate_actions: GPlate
var plate_upgrades: GPlate
var plate_staff: GPlate
var plate_ledger: GPlate
var plate_guide: GPlate
var doom_card: GDoomCard
var attention_card: GAttentionCard
var advisor_note: GAdvisorNote
var _advisor_mode := ""            # "lever" | "plain" | "" (advisor_mode())
var toast: GToast
var bottom_strip: PanelContainer
var feedback_button: Button
var feedback_keycap: Control
var held_plate: PanelContainer
var held_value: Label
var commit_plate: Button
var commit_caption: Label
var commit_keycap: Control
var commit_keycap_label: Label

## Which path the Commit plate runs right now: "end_turn" (queue not empty), "commit_plan"
## (queue empty) or "" (inert). Public for the parity tests.
var commit_path: String = ""

var _guide: Control = null
var _advisor_pulse: Tween

# Phase 1b: the sheets (persistent children of Sheets, never freed while G is on), the feed.
var sheets: Control
var actions_panel: GActionsPanel
var plan_panel: GPlanPanel
var upgrades_panel: GUpgradesPanel
var feed_panel: GFeedPanel
## G binds a saved non-g_ bind already uses (V7): skipped by GKeys, keycaps hidden.
var skipped_binds: Array = []
var _keycap_top := "?"
# Door return (spec 5.7.4): the door the Actions sheet opened, and its submenu.
var _door_pending := ""
var _door_dialog: Control = null
var _door_id := ""

# Phase 1c: WATCH (spec 5.2, 5.5). Built nodes, public for tests and the capture harness.
var playback_bar: HBoxContainer
var playback_cells: HBoxContainer
var playback_label: Label
var speed_box: HBoxContainer
var speed_pause: Label
var speed_buttons: Dictionary = {}     # "1x" | "2x" | "4x" -> Button
## The opening hold (spec 5.5, R2-4): {mi, hold, spent}, read from the live state only after
## the commit handler has returned (deferred from turn_phase_changed("turn_end")).
var opening_hold: Dictionary = {}
## G's own copy of the last pre-boundary snapshot of the month in play: {mi, held, label}.
## Updated from every state of that month while it plays; a state of the next month never
## overwrites it, so the closed face can still say what the month used.
var month_snapshot: Dictionary = {}
var _watch_state := ""
var _state_seq := 0                    # counts the states seen (the opening hold's freshness)

const SHEET_SCENES := {
	"g_actions": "res://scenes/ui/g_actions_panel.tscn",
	"g_plan": "res://scenes/ui/g_plan_panel.tscn",
	"g_upgrades": "res://scenes/ui/g_upgrades_panel.tscn",
}


# --- setup / teardown -------------------------------------------------------------------

func _init() -> void:
	name = "GDesk"
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func setup(main_ui: Node) -> void:
	"""Build the desk and seed it from the LIVE UI (spec 2.2 step 1), so a flip in WATCH or
	with a modal up draws the right face at once."""
	host = main_ui
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_update_compact(true)
	_build()
	_connect()
	visible = host.visible
	_last_state = host._last_state if host.get("_last_state") is Dictionary else {}
	if not _last_state.is_empty():
		_on_state(_last_state)
	_refresh_mode()
	_refresh_phase()
	_refresh_advisor()
	_refresh_binds()
	_refresh_modal_keycaps(true)


func detach() -> void:
	"""Stop listening before LayoutController restores classic (spec 2.2 leaving g): the
	restore re-applies the PLAN/WATCH visibility, which must not re-hide the chrome."""
	_detached = true
	_close_guide()
	close_g_sheets()
	_stop_advisor_pulse()
	if KeybindManager.keybind_changed.is_connected(_on_binds_changed):
		KeybindManager.keybind_changed.disconnect(_on_binds_changed)
	if is_inside_tree() and get_viewport().size_changed.is_connected(_on_view_resized):
		get_viewport().size_changed.disconnect(_on_view_resized)
	if KeybindManager.profile_loaded.is_connected(_on_profile_loaded):
		KeybindManager.profile_loaded.disconnect(_on_profile_loaded)
	var gm = _gm()
	if gm != null:
		if gm.game_state_updated.is_connected(_on_state):
			gm.game_state_updated.disconnect(_on_state)
		if gm.turn_phase_changed.is_connected(_on_phase):
			gm.turn_phase_changed.disconnect(_on_phase)
	if host == null or not is_instance_valid(host):
		return
	var ed = _event_dialog()
	if ed != null:
		if ed.dialog_opened.is_connected(_on_event_dialog_opened):
			ed.dialog_opened.disconnect(_on_event_dialog_opened)
		if ed.dialog_closed.is_connected(_on_event_dialog_closed):
			ed.dialog_closed.disconnect(_on_event_dialog_closed)
	if host.screen_mode and host.screen_mode.mode_changed.is_connected(_on_mode_changed):
		host.screen_mode.mode_changed.disconnect(_on_mode_changed)
	for pair in [["queue_view_changed", _on_queue_view_changed],
			["feed_changed", _on_feed_changed],
			["rejection_reported", _on_rejection_reported],
			["first_lever_cleared", _on_first_lever_cleared],
			["visibility_changed", _on_host_visibility_changed]]:
		if host.has_signal(pair[0]) and host.is_connected(pair[0], pair[1]):
			host.disconnect(pair[0], pair[1])


func _gm():
	if host == null or not is_instance_valid(host):
		return null
	return host.game_manager


func _connect() -> void:
	var gm = _gm()
	if gm != null:
		gm.game_state_updated.connect(_on_state)
		gm.turn_phase_changed.connect(_on_phase)
	if host.screen_mode:
		host.screen_mode.mode_changed.connect(_on_mode_changed)
	if host.has_signal("queue_view_changed"):
		host.queue_view_changed.connect(_on_queue_view_changed)
	if host.has_signal("rejection_reported"):
		host.rejection_reported.connect(_on_rejection_reported)
	if host.has_signal("first_lever_cleared"):
		host.first_lever_cleared.connect(_on_first_lever_cleared)
	if host.has_signal("feed_changed"):
		host.feed_changed.connect(_on_feed_changed)
	host.visibility_changed.connect(_on_host_visibility_changed)
	var ed = _event_dialog()
	if ed != null:
		ed.dialog_opened.connect(_on_event_dialog_opened)
		ed.dialog_closed.connect(_on_event_dialog_closed)
	KeybindManager.keybind_changed.connect(_on_binds_changed)
	KeybindManager.profile_loaded.connect(_on_profile_loaded)
	if is_inside_tree() and not get_viewport().size_changed.is_connected(_on_view_resized):
		get_viewport().size_changed.connect(_on_view_resized)


# --- build -------------------------------------------------------------------------------

func _build() -> void:
	_build_top_strip()
	_build_banner()
	_build_rail()
	doom_card = GDoomCard.new()
	doom_card.pressed.connect(_on_doom_card_pressed)
	add_child(doom_card)
	doom_card.anchor_left = 1.0
	doom_card.anchor_right = 1.0
	doom_card.offset_left = -440
	doom_card.offset_right = -24
	doom_card.offset_top = 132
	doom_card.offset_bottom = 132 + 252
	_copy_lose_line()
	attention_card = GAttentionCard.new()
	attention_card.choose_button.pressed.connect(_on_choose_pressed)
	add_child(attention_card)
	attention_card.anchor_left = 1.0
	attention_card.anchor_right = 1.0
	attention_card.anchor_top = 1.0
	attention_card.anchor_bottom = 1.0
	attention_card.offset_left = -440
	attention_card.offset_right = -24
	attention_card.offset_bottom = -76
	attention_card.offset_top = -76 - 274
	attention_card.grow_vertical = Control.GROW_DIRECTION_BEGIN
	_build_bottom_strip()
	advisor_note = GAdvisorNote.new()
	advisor_note.dismissed.connect(_on_advisor_dismissed)
	add_child(advisor_note)
	advisor_note.position = Vector2(290, 130)
	advisor_note.custom_minimum_size = Vector2(420, 0)
	advisor_note.size = Vector2(420, 0)
	advisor_note.visible = false
	# The WATCH feed (spec 5.10 position: 24, bottom 1004, 560x288; L, B).
	feed_panel = GFeedPanel.new()
	add_child(feed_panel)
	feed_panel.anchor_top = 1.0
	feed_panel.anchor_bottom = 1.0
	feed_panel.offset_left = 24
	feed_panel.offset_right = 24 + 560
	feed_panel.offset_bottom = -76
	feed_panel.offset_top = -76 - 288
	feed_panel.setup(host)
	feed_panel.visible = false
	_build_sheets()
	# Above the sheets' barriers: the rail (switch or close a sheet by mouse) and the Attention
	# card (its OPEN / CLOSE PLAN button), then the toast (refusals show over an open sheet).
	move_child(rail, get_child_count() - 1)
	move_child(attention_card, get_child_count() - 1)
	toast = GToast.new()
	add_child(toast)
	toast.anchor_left = 0.5
	toast.anchor_right = 0.5
	toast.offset_left = -360
	toast.offset_right = 360
	toast.offset_top = 114
	toast.grow_horizontal = Control.GROW_DIRECTION_BOTH


func _build_sheets() -> void:
	sheets = Control.new()
	sheets.name = "Sheets"
	sheets.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(sheets)
	sheets.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	actions_panel = load(SHEET_SCENES["g_actions"]).instantiate()
	plan_panel = load(SHEET_SCENES["g_plan"]).instantiate()
	upgrades_panel = load(SHEET_SCENES["g_upgrades"]).instantiate()
	for sh in [actions_panel, plan_panel, upgrades_panel]:
		sheets.add_child(sh)
		sh.setup(host, self)
		sh.closed.connect(_on_sheet_closed)


func _build_top_strip() -> void:
	top_strip = make_panel("GStripTop")
	top_strip.name = "TopStrip"
	add_child(top_strip)
	# L, T, R (spec 3.2): anchors AND offsets, so the strip spans the full width.
	top_strip.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	top_strip.offset_top = 0
	top_strip.offset_bottom = 56
	var hb := _margin_hbox(top_strip, 24, 24, 24)
	# The dateline slot keeps today's turn label text until phase 4 (GDateline); it already
	# takes the dateline's face, Courier Prime Bold, tracked (spec 5.1.1). 420 wide at least.
	dateline = make_label("", "header", C.dateline, "GDateline")
	dateline.name = "Dateline"
	dateline.custom_minimum_size = Vector2(420, 0)
	dateline.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hb.add_child(dateline)
	var cells := HBoxContainer.new()
	cells.name = "ResourceStrip"
	cells.add_theme_constant_override("separation", 24)
	cells.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	hb.add_child(cells)
	for key in RESOURCE_KEYS:
		# A 1 px frame rule before each cell (the mock-up's cell separators).
		var rule := ColorRect.new()
		rule.color = C.frame
		rule.custom_minimum_size = Vector2(1, 32)
		rule.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		rule.mouse_filter = Control.MOUSE_FILTER_IGNORE
		cells.add_child(rule)
		var cell := HBoxContainer.new()
		cell.name = "Cell_%s" % key
		cell.add_theme_constant_override("separation", 8)
		cell.mouse_filter = Control.MOUSE_FILTER_PASS
		# Hierarchy (spec 4.4): money's value at `header` (rank 2), the rest at `label` (rank 3);
		# caps labels `small` in `dim`; every number in mono.
		var cap := make_label(RESOURCE_CAPS[key], "small", C.dim, "GCaps")
		cap.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		cap.mouse_filter = Control.MOUSE_FILTER_PASS
		cell.add_child(cap)
		var val := make_label("--", "header" if key == "money" else "label", C.bone, "GMono")
		val.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		val.mouse_filter = Control.MOUSE_FILTER_PASS
		cell.add_child(val)
		if DELTA_CHIP_KEYS.has(key):
			var chip := make_label("", "small", C.bone, "GMono")
			chip.name = "Delta"
			chip.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			chip.mouse_filter = Control.MOUSE_FILTER_PASS
			chip.visible = false
			cell.add_child(chip)
			resource_chips[key] = chip
		cells.add_child(cell)
		resource_values[key] = val
		resource_cells[key] = cell
	_copy_resource_tooltips()
	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hb.add_child(spacer)
	menu_button = make_plate_button("MENU", ICON_ROOT + "main_navigation/ui_system_settings_64.png",
		_key_name("", "Esc"))
	menu_button.name = "MenuButton"
	menu_button.tooltip_text = "Pause menu: save, settings, quit (Esc)"
	menu_button.pressed.connect(_on_menu_pressed)
	hb.add_child(menu_button)


func _build_banner() -> void:
	banner = make_panel("GBanner")
	banner.name = "Banner"
	add_child(banner)
	banner.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	banner.offset_top = 56
	banner.offset_bottom = 108
	var hb := _margin_hbox(banner, 24, 24, 12)
	mode_label = make_label("## PLAN", "label", C.amber, "GCaps")
	mode_label.name = "ModeLabel"
	mode_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hb.add_child(mode_label)
	_build_playback(hb)
	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hb.add_child(spacer)
	var view := make_label("VIEW", "small", C.muted, "GCaps")
	view.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hb.add_child(view)
	var seg := HBoxContainer.new()
	seg.name = "ViewSwitch"
	seg.add_theme_constant_override("separation", 0)
	seg.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	hb.add_child(seg)
	view_plan_button = _make_segment("PLAN")
	view_watch_button = _make_segment("WATCH")
	view_plan_button.pressed.connect(func(): _on_view_segment(0))
	view_watch_button.pressed.connect(func(): _on_view_segment(1))
	seg.add_child(view_plan_button)
	seg.add_child(view_watch_button)
	view_keycap = make_keycap(_key_name("toggle_view", "V"))
	view_keycap.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	hb.add_child(view_keycap)


func _build_playback(hb: HBoxContainer) -> void:
	"""Spec 5.2 (WATCH only): one segment per workday of the month, today's marked, then
	"workday N of M"; then the speed segments: || (a display, lit while an event has paused
	playback; today's pause is a stub), 1x, 2x, 4x (today's values, ScreenModeController)."""
	playback_bar = HBoxContainer.new()
	playback_bar.name = "PlaybackBar"
	playback_bar.add_theme_constant_override("separation", 12)
	playback_bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	playback_bar.visible = false
	hb.add_child(playback_bar)
	var gap := Control.new()
	gap.custom_minimum_size = Vector2(12, 0)
	playback_bar.add_child(gap)
	playback_cells = HBoxContainer.new()
	playback_cells.name = "Workdays"
	playback_cells.add_theme_constant_override("separation", 3)
	playback_cells.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	playback_cells.mouse_filter = Control.MOUSE_FILTER_IGNORE
	playback_bar.add_child(playback_cells)
	playback_label = make_label("", "small", C.muted, "GMono")
	playback_label.name = "WorkdayLabel"
	playback_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	playback_label.custom_minimum_size = Vector2(176, 0)
	playback_bar.add_child(playback_label)
	speed_box = HBoxContainer.new()
	speed_box.name = "SpeedSegments"
	speed_box.add_theme_constant_override("separation", 0)
	speed_box.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	playback_bar.add_child(speed_box)
	speed_pause = make_label("||", "small", C.dim, "GMonoSemi")
	speed_pause.name = "SpeedPause"
	speed_pause.custom_minimum_size = Vector2(36, 32)
	speed_pause.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	speed_pause.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	speed_pause.mouse_filter = Control.MOUSE_FILTER_PASS
	speed_pause.tooltip_text = "Playback pauses by itself while an event waits for your reply."
	compact_step_up(speed_pause)   # two thin strokes: at 720p colour alone cannot carry them
	speed_box.add_child(speed_pause)
	for key in ["1x", "2x", "4x"]:
		var b := _make_segment(key)
		b.name = "Speed_%s" % key
		b.custom_minimum_size = Vector2(48, 32)
		b.tooltip_text = "Playback speed"
		b.pressed.connect(_on_speed_pressed.bind(key))
		speed_box.add_child(b)
		speed_buttons[key] = b


func _build_rail() -> void:
	rail = VBoxContainer.new()
	rail.name = "Rail"
	rail.add_theme_constant_override("separation", 10)
	add_child(rail)
	rail.position = Vector2(24, 132)
	rail.custom_minimum_size = Vector2(232, 0)
	plate_actions = GPlate.new()
	plate_actions.name = "PlateActions"
	plate_actions.setup(ICON_ROOT + "main_navigation/ui_guide_actions_64.png", "ACTIONS",
		_key_name("g_actions", "A"))
	plate_actions.tooltip_text = "Choose this month's plays (keys 1-9 pick the first nine)"
	plate_actions.pressed.connect(func(): toggle_sheet("g_actions"))
	rail.add_child(plate_actions)
	plate_upgrades = GPlate.new()
	plate_upgrades.name = "PlateUpgrades"
	plate_upgrades.setup(ICON_ROOT + "buttons_normal/button_upgrade_normal_64.png", "UPGRADES",
		_key_name("g_upgrades", "U"))
	plate_upgrades.tooltip_text = "Buy upgrades for the lab"
	plate_upgrades.pressed.connect(func(): toggle_sheet("g_upgrades"))
	rail.add_child(plate_upgrades)
	plate_staff = GPlate.new()
	plate_staff.name = "PlateStaff"
	plate_staff.setup(ICON_ROOT + "main_navigation/ui_staff_management_64.png", "STAFF",
		_key_name("g_staff", "E"))
	plate_staff.tooltip_text = "Open the Employee screen (Esc returns here)"
	plate_staff.pressed.connect(open_staff)
	rail.add_child(plate_staff)
	plate_ledger = GPlate.new()
	plate_ledger.name = "PlateLedger"
	plate_ledger.setup(ICON_ROOT + "main_navigation/ui_budget_finance_64.png", "LEDGER",
		_key_name("open_ledger", "L"))
	plate_ledger.tooltip_text = "Open the Liability Ledger"
	plate_ledger.pressed.connect(open_ledger)
	rail.add_child(plate_ledger)
	var gap := Control.new()
	gap.custom_minimum_size = Vector2(0, 16)   # 26 px with the 10 px separation (spec 3.2)
	rail.add_child(gap)
	plate_guide = GPlate.new()
	plate_guide.name = "PlateGuide"
	plate_guide.setup(ICON_ROOT + "main_navigation/ui_guide_book_64.png", "GUIDE",
		_key_name("g_guide", "F1"))
	plate_guide.tooltip_text = "Open the Player Guide over the game (Esc or Back returns)"
	plate_guide.pressed.connect(toggle_guide)
	rail.add_child(plate_guide)


func _build_bottom_strip() -> void:
	bottom_strip = make_panel("GStripBottom")
	bottom_strip.name = "BottomStrip"
	add_child(bottom_strip)
	# L, B, R (spec 3.2): Feedback left, the held and Commit plates right (1276 and 1600).
	bottom_strip.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	bottom_strip.offset_top = -64
	bottom_strip.offset_bottom = 0
	var hb := _margin_hbox(bottom_strip, 24, 24, 16)
	feedback_button = make_plate_button("FEEDBACK", ICON_ROOT + "ui_controls/ui_control_bug_64.png",
		_key_name("bug_reporter", "N"))
	feedback_button.name = "FeedbackButton"
	feedback_button.tooltip_text = "Report a bug or send feedback"
	feedback_button.pressed.connect(_on_feedback_pressed)
	feedback_keycap = feedback_button.get_meta("keycap")
	hb.add_child(feedback_button)
	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hb.add_child(spacer)

	held_plate = make_panel("GHeld")
	held_plate.name = "HeldPlate"
	held_plate.custom_minimum_size = Vector2(308, 48)
	held_plate.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var hhb := _margin_hbox(held_plate, 14, 14, 10)
	var hl := make_label("HELD FOR EVENTS", "small", C.muted, "GCaps")
	hl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hhb.add_child(hl)
	held_value = make_label("up to -- hr", "label", C.bone, "GMono")
	held_value.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hhb.add_child(held_value)
	held_plate.tooltip_text = "Hours not spent on plays are held for events this month. Plays that charge their own hours (hiring) take more at Commit, so the hold can end up smaller."
	hb.add_child(held_plate)

	commit_plate = Button.new()
	commit_plate.name = "CommitPlate"
	commit_plate.focus_mode = Control.FOCUS_NONE
	commit_plate.custom_minimum_size = Vector2(296, 48)
	commit_plate.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	commit_plate.pressed.connect(press_commit_plate)
	hook_dashed_edge(commit_plate)
	var chb := HBoxContainer.new()
	chb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	chb.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	chb.offset_left = 14
	chb.offset_right = -10
	chb.add_theme_constant_override("separation", 10)
	commit_plate.add_child(chb)
	commit_caption = make_label("COMMIT THE MONTH", "label", C.amber, "GCapsBold")
	commit_caption.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	commit_caption.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	commit_caption.mouse_filter = Control.MOUSE_FILTER_IGNORE
	chb.add_child(commit_caption)
	commit_keycap = make_keycap("Space")
	commit_keycap.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	commit_keycap_label = commit_keycap.get_meta("label")
	chb.add_child(commit_keycap)
	hb.add_child(commit_plate)


func _copy_lose_line() -> void:
	"""Today's "Buy time -- survival is the score | Lose: P(Doom) = 100%" line lives in the
	classic ExplanationLabel (main.tscn), hidden in G with the classic chrome. Read its text
	and tooltip from there, never retyped."""
	if host == null:
		return
	var ex = host.find_child("ExplanationLabel", true, false)
	if ex is Label:
		doom_card.set_lose_line(String(ex.text))
		doom_card.tooltip_text = "%s\n\n%s" % [doom_card.tooltip_text, String(ex.tooltip_text)] \
			if String(ex.tooltip_text) != "" else doom_card.tooltip_text


func _copy_resource_tooltips() -> void:
	"""Spec 5.1.2: keep today's resource tooltips (main_ui._apply_balance_tooltips) on the
	matching cells. Read from the classic labels, never rebuilt here."""
	if host == null:
		return
	var labels := {
		"money": host.get("money_label"), "compute": host.get("compute_label"),
		"research": host.get("research_label"), "papers": host.get("papers_label"),
		"reputation": host.get("reputation_label"),
	}
	for key in labels:
		var l = labels[key]
		if l != null and is_instance_valid(l) and resource_cells.has(key):
			(resource_cells[key] as Control).tooltip_text = String(l.tooltip_text)


# --- refresh -----------------------------------------------------------------------------

func _on_state(state: Dictionary) -> void:
	if _detached:
		return
	_last_state = state
	_state_seq += 1
	_note_month_snapshot(state)
	if host != null and host.has_method("_format_turn_datetime"):
		dateline.text = host._format_turn_datetime(state)
	for key in RESOURCE_KEYS:
		var raw = state.get(key, 0)
		var lbl: Label = resource_values[key]
		lbl.text = GameConfig.format_money(raw) if key == "money" else GameConfig.format_scalar(raw)
		# Warn colour reads the SHOWN amount (spec 5.1.2): "-0" never turns red.
		var shown := _shown_amount(float(raw))
		set_ink(lbl, C.warn if shown < 0.0 else C.bone)
	plate_staff.set_status(str(int(state.get("total_staff", 0))))
	_refresh_ledger_plate()
	_refresh_delta_chips()
	doom_card.update_from_state(state)
	_refresh_attention()
	_refresh_held()
	_refresh_commit()
	_refresh_advisor()
	_refresh_sheets()
	_refresh_playback()
	feed_panel.set_month(month_label_of(state))


func _refresh_delta_chips() -> void:
	"""EE-7: the classic chips' own text and colour (main_ui._update_delta_chips runs first on
	the same state signal). Display only."""
	var src: Dictionary = host.get("_delta_labels") if host != null and host.get("_delta_labels") is Dictionary else {}
	for key in resource_chips:
		var chip: Label = resource_chips[key]
		var from = src.get(key, null)
		if from == null or not is_instance_valid(from) or String(from.text) == "":
			chip.text = ""
			chip.visible = false
			continue
		chip.text = String(from.text)
		chip.tooltip_text = String(from.tooltip_text)
		set_ink(chip, (from as Label).get_theme_color("font_color"))
		chip.visible = true


func _refresh_ledger_plate() -> void:
	"""Today's Ledger summary on the plate: its short word ("clean" / "$N owed"), and while
	the summary carries the #578 due-soon warning, the same "[!] " prefix in the warn colour,
	with the summary's full text ("[!] Ledger: $N owed | due ...") as the plate's tooltip."""
	var ls = host.get("ledger_screen") if host != null else null
	if ls == null or not ls.has_method("summary_word"):
		return
	var due_soon: bool = ls.has_method("summary_due_soon") and ls.summary_due_soon()
	plate_ledger.set_status(("[!] " if due_soon else "") + String(ls.summary_word()))
	plate_ledger.set_status_warn(due_soon)
	var full: String = String(ls.summary_text()) if ls.has_method("summary_text") else ""
	plate_ledger.tooltip_text = full if due_soon and full != "" else "Open the Liability Ledger"


static func _shown_amount(raw: float) -> float:
	"""sign(raw) * round_half_away(abs(raw)) -- the amount format_money/format_scalar print."""
	var a := absf(raw)
	var r := floorf(a + 0.5)
	return r if raw >= 0.0 else -r


func _on_phase(phase: String) -> void:
	if _detached:
		return
	if phase.to_lower() == "turn_end":
		# end_month() emits turn_end BEFORE it sets the month's implicit reserve, so the hold
		# is read only after the commit handler has returned (spec 5.5, R2-4).
		_capture_opening_hold.call_deferred()
	_refresh_phase()


func _refresh_phase() -> void:
	_refresh_commit()
	_refresh_held()
	_refresh_mode()
	var plan := _in_plan_phase()
	# The sheets are PLAN-only (spec 8.2): leaving the plan closes any that is open, and the
	# ACTIONS and UPGRADES plates rest until the next plan (1c styles their WATCH state).
	if not plan:
		close_g_sheets()
	plate_actions.disabled = not plan
	plate_upgrades.disabled = not plan
	# BaseButton.disabled sends no notification, so repaint the plates (keycap, text colour).
	_refresh_modal_keycaps(true)


func _on_queue_view_changed() -> void:
	if _detached:
		return
	_refresh_attention()
	_refresh_commit()
	_refresh_sheets()


func _on_mode_changed(_m: int) -> void:
	if _detached:
		return
	# screen_mode.set_mode re-shows registered nodes on every change (spec 2.2 step 2).
	for n in chrome_nodes:
		if n != null and is_instance_valid(n):
			(n as CanvasItem).visible = false
	_refresh_mode()
	_refresh_held()
	_refresh_advisor()


func _refresh_feed_visibility() -> void:
	var watching: bool = host != null and host.screen_mode != null \
		and host.screen_mode.current_mode == ScreenModeController.Mode.WATCH
	if watching and not feed_panel.visible:
		feed_panel.render()
	feed_panel.visible = watching


func _on_feed_changed() -> void:
	if _detached or feed_panel == null:
		return
	if feed_panel.visible:
		feed_panel.render()


func _refresh_mode() -> void:
	if host == null or host.screen_mode == null:
		return
	var watching: bool = host.screen_mode.current_mode == ScreenModeController.Mode.WATCH
	mode_label.text = "## WATCH" if watching else "## PLAN"
	_style_segment(view_plan_button, not watching)
	_style_segment(view_watch_button, watching)
	var event_waiting := _top_kind() == "event"
	view_plan_button.disabled = event_waiting
	view_watch_button.disabled = event_waiting
	view_keycap.visible = not event_waiting and not _modal_open()
	_refresh_feed_visibility()
	_refresh_playback()


# --- WATCH (spec 5.2, 5.5) ----------------------------------------------------------------

func _event_dialog():
	if host == null or not is_instance_valid(host):
		return null
	var ed = host.get("event_dialog")
	return ed if ed != null and is_instance_valid(ed) else null


func current_event() -> Dictionary:
	"""EventDialog.current_event (read-only, V2): the event on screen, {} when none."""
	var ed = _event_dialog()
	if ed == null:
		return {}
	var ev = ed.get("current_event")
	return ev if ev is Dictionary else {}


func _watching() -> bool:
	return host != null and host.screen_mode != null \
		and host.screen_mode.current_mode == ScreenModeController.Mode.WATCH


func watch_state() -> String:
	"""Which WATCH sub-state the desk is in (spec 5.2, A6), from the phase, the view, the top
	modal kind and EventDialog.current_event -- never from the calendar changing alone:
	  "plan" -- the plan phase in the PLAN view;
	  "W1"   -- the plan phase peeked at in the WATCH view (V), not committed yet;
	  "W2"   -- the month plays (turn_end / turn_start) with no event on top;
	  "W3"   -- an event waits for a reply while the month plays;
	  "W4"   -- the month review is up (the month has played out)."""
	if host == null:
		return "plan"
	var ev := current_event()
	if not ev.is_empty() and _top_kind() == "event":
		if MonthReviewPanel.is_month_review(ev):
			return "W4"
		if not _in_plan_phase():
			return "W3"
	if _in_plan_phase():
		return "W1" if _watching() else "plan"
	return "W2"


static func month_index_of(state: Dictionary, turn_offset: int = 0) -> int:
	if not state.has("turn"):
		return -1
	return Clock.month_index(maxi(0, int(state.get("turn", 0)) + turn_offset),
		int(state.get("start_year", 2017)), int(state.get("start_month", 7)),
		int(state.get("start_day", 1)))


static func month_label_of(state: Dictionary) -> String:
	if not state.has("turn"):
		return ""
	return Clock.month_label(int(state.get("turn", 0)), int(state.get("start_year", 2017)),
		int(state.get("start_month", 7)), int(state.get("start_day", 1)))


static func workday_of_month(turn: int, sy: int, sm: int, sd: int) -> Vector2i:
	"""(N, M): `turn` is workday N of the M workdays (turns) in its calendar month. Pure calls
	on Clock (one turn = one workday); the game computes nothing for this."""
	var mi := Clock.month_index(turn, sy, sm, sd)
	var first := turn
	while first > 0 and Clock.month_index(first - 1, sy, sm, sd) == mi:
		first -= 1
	var last := turn
	while Clock.month_index(last + 1, sy, sm, sd) == mi:
		last += 1
	return Vector2i(turn - first + 1, last - first + 1)


func _capture_opening_hold() -> void:
	"""Spec 5.5 (R2-4): read the month's opening hold once the commit handler has returned
	(called deferred from turn_phase_changed("turn_end")). Read-only on the live state."""
	if _detached:
		return
	var gm = _gm()
	if gm == null or gm.state == null:
		return
	var st = gm.state
	var mi := Clock.month_index(int(st.turn), int(st.start_year), int(st.start_month), int(st.start_day))
	var spent: int = int(st.month_plan.attention_spent) if st.month_plan != null else 0
	opening_hold = {"mi": mi, "hold": int(st.get_reserve_attention()), "spent": spent,
		"seq": _state_seq}
	month_snapshot = {"mi": mi, "held": int(st.get_reserve_attention()),
		"label": Clock.month_name(int(st.turn), int(st.start_year), int(st.start_month), int(st.start_day))}
	_refresh_watch()


func _note_month_snapshot(state: Dictionary) -> void:
	"""Keep G's pre-boundary snapshot: while the committed month plays, every state of THAT
	month (same calendar month as the opening hold) updates the held count. A state of the
	next month leaves it alone (spec 5.5: the boundary resets the month plan before the new
	month's state reaches the UI)."""
	if opening_hold.is_empty() or _in_plan_phase():
		return
	var mi := month_index_of(state)
	if mi != int(opening_hold.get("mi", -2)):
		return
	month_snapshot = {"mi": mi, "held": GAttentionCard.held_left(state),
		"label": String(month_snapshot.get("label", ""))}


func held_now() -> int:
	"""The hours still held: the latest state's remaining reserve; but the last state before
	the capture predates the month's reserve (end_month emits it before set_reserve), so until
	a newer state arrives the opening hold itself is the newest reading."""
	var op := opening_for_month()
	if not op.is_empty() and int(op.get("seq", -1)) == _state_seq:
		return int(op.get("hold", 0))
	return GAttentionCard.held_left(_last_state)


func opening_for_month() -> Dictionary:
	"""The opening hold, when it belongs to the month the state is in; else {}."""
	if opening_hold.is_empty() or int(opening_hold.get("mi", -2)) != month_index_of(_last_state):
		return {}
	return opening_hold


func closed_snapshot() -> Dictionary:
	"""{hold, held} for the closed face: the opening hold and the held count from the last
	pre-boundary state of the same month, once the boundary has passed. {} when G has no such
	snapshot (a load, or a layout flip during the review)."""
	if opening_hold.is_empty() or month_snapshot.is_empty():
		return {}
	var mi := int(opening_hold.get("mi", -2))
	if int(month_snapshot.get("mi", -3)) != mi or month_index_of(_last_state) == mi:
		return {}
	return {"hold": int(opening_hold.get("hold", 0)), "held": int(month_snapshot.get("held", 0)),
		"label": String(month_snapshot.get("label", ""))}


func closed_month_name() -> String:
	"""The month the review closes: the snapshot's, else the month of the previous workday
	(the review shows once the boundary has opened the next month)."""
	var snap := closed_snapshot()
	if not snap.is_empty() and String(snap.label) != "":
		return String(snap.label)
	if not _last_state.has("turn"):
		return ""
	var t := maxi(0, int(_last_state.get("turn", 0)) - 1)
	return Clock.month_name(t, int(_last_state.get("start_year", 2017)),
		int(_last_state.get("start_month", 7)), int(_last_state.get("start_day", 1)))


func _refresh_watch() -> void:
	"""Re-draw everything that depends on the WATCH sub-state."""
	if _detached or host == null:
		return
	_watch_state = watch_state()
	_refresh_attention()
	_refresh_held()
	_refresh_commit()
	_refresh_playback()


func _on_event_dialog_opened(_dialog: Control, _buttons: Array) -> void:
	# The feed names the player's choice from the event on screen (no raw ids in G).
	if is_instance_valid(feed_panel):
		feed_panel.note_event(current_event())
	# State and phase signals can arrive before an event is on ModalStack; refresh after
	# modal_stack.present has run (spec 5.5, R2-4).
	if not _detached:
		_refresh_watch.call_deferred()


func _on_event_dialog_closed() -> void:
	if not _detached:
		_refresh_watch.call_deferred()


func _refresh_playback() -> void:
	"""The banner's playback bar and speed segments (WATCH view only)."""
	if playback_bar == null or host == null:
		return
	playback_bar.visible = _watching()
	if not playback_bar.visible:
		return
	var ws := watch_state()
	var nm := Vector2i(0, 0)
	if _last_state.has("turn"):
		nm = workday_of_month(int(_last_state.get("turn", 0)), int(_last_state.get("start_year", 2017)),
			int(_last_state.get("start_month", 7)), int(_last_state.get("start_day", 1)))
	var n := nm.x
	var m := nm.y
	var label := ""
	match ws:
		"W1", "plan":
			n = 0
			label = "not committed yet"
		"W4":
			# The review shows once the boundary has opened the next month: the bar is the
			# closed month's (the previous workday's), full.
			m = workday_of_month(maxi(0, int(_last_state.get("turn", 0)) - 1),
				int(_last_state.get("start_year", 2017)), int(_last_state.get("start_month", 7)),
				int(_last_state.get("start_day", 1))).y
			n = m
			label = "%s played out" % closed_month_name()
		_:
			label = "workday %d of %d" % [n, m]
	_fill_workdays(n, m, ws == "W4")
	playback_label.text = label
	set_ink(speed_pause, C.amber if ws == "W3" else C.dim)
	var gm = _gm()
	var secs: float = float(gm.day_tick_seconds) if gm != null else 0.2
	for key in speed_buttons:
		var on := is_equal_approx(float(ScreenModeController._SPEEDS[key]), secs)
		_style_segment(speed_buttons[key], on)


func _fill_workdays(n: int, m: int, full: bool) -> void:
	"""One segment per workday: played ones in bone, today's in amber, the rest faint."""
	while playback_cells.get_child_count() > m:
		var c := playback_cells.get_child(playback_cells.get_child_count() - 1)
		playback_cells.remove_child(c)
		c.free()
	while playback_cells.get_child_count() < m:
		var cell := ColorRect.new()
		cell.mouse_filter = Control.MOUSE_FILTER_IGNORE
		cell.custom_minimum_size = Vector2(8, 16)
		playback_cells.add_child(cell)
	for i in range(m):
		var cell := playback_cells.get_child(i) as ColorRect
		if full or i < n - 1:
			cell.color = Color(C.bone, 0.7)
		elif i == n - 1:
			cell.color = C.amber
		else:
			cell.color = Color(C.bone, 0.14)


func playback_text() -> String:
	return playback_label.text if playback_bar != null and playback_bar.visible else ""


func workday_cells() -> Array:
	"""[played, today, ahead] counts of the bar (tests)."""
	var out := [0, 0, 0]
	for c in playback_cells.get_children():
		var col := (c as ColorRect).color
		if col == C.amber:
			out[1] += 1
		elif col.a > 0.5:
			out[0] += 1
		else:
			out[2] += 1
	return out


func _on_speed_pressed(key: String) -> void:
	"""Today's speed dial: emit screen_mode.speed_changed with today's value (main_ui maps it
	to game_manager.day_tick_seconds, as for classic's 1x/2x/4x buttons)."""
	if host == null or host.screen_mode == null:
		return
	host.screen_mode.speed_changed.emit(float(ScreenModeController._SPEEDS[key]))
	_refresh_playback()


func _refresh_attention() -> void:
	if host == null:
		return
	var queued: Array = host.plan_controller.queued_actions if host.plan_controller else []
	var costs: Dictionary = host.plan_controller.calculate_queued_costs() if host.plan_controller else {}
	# The face follows the WATCH sub-state (spec 5.2 table): PLAN face in the plan and W1,
	# WATCH face while the month plays (W2, W3), closed face under the review (W4).
	match watch_state():
		"W2", "W3":
			attention_card.set_face("watch")
			var reply := GAttentionCard.reply_summary(current_event()) if watch_state() == "W3" else ""
			attention_card.update_watch_face(_last_state, opening_for_month(), reply, held_now())
			return
		"W4":
			attention_card.set_face("closed")
			attention_card.update_closed_face(closed_month_name(), closed_snapshot())
			return
	attention_card.set_face("plan")
	attention_card.update_plan_face(_last_state, queued, costs)
	# CHOOSE ACTIONS [A] with an empty queue, OPEN PLAN [Q] otherwise, CLOSE PLAN [Q] while
	# the drawer is open (spec 5.5). PLAN phase only.
	var cb: Button = attention_card.choose_button
	cb.visible = _in_plan_phase()
	if plan_panel != null and plan_panel.visible:
		cb.text = "CLOSE PLAN [%s]" % _key_name("g_plan", "Q")
	elif queued.is_empty():
		cb.text = "CHOOSE ACTIONS [%s]" % _key_name("g_actions", "A")
	else:
		cb.text = "OPEN PLAN [%s]" % _key_name("g_plan", "Q")


func _refresh_held() -> void:
	"""Spec 5.6: the held plate is PLAN only (the plan and the W1 peek). Once the month plays
	the Attention card's WATCH face carries the hold and the plate is hidden."""
	var mp: Dictionary = _last_state.get("month_plan", {})
	var total := int(mp.get("attention_total", 0))
	var spent := int(mp.get("attention_spent", 0))
	# Every hour not spent on plays (spec 5.6): total - spent - reserved + reserved.
	held_value.text = "up to %d hr" % maxi(0, total - spent)
	held_plate.visible = _in_plan_phase()


func _in_plan_phase() -> bool:
	return host != null and String(host.current_turn_phase).to_upper() == "ACTION_SELECTION"


func _refresh_commit() -> void:
	"""Spec 5.6, V1: one plate, both of today's paths, each with its own eligibility."""
	if host == null:
		return
	var queue_empty: bool = host.plan_controller.is_queue_empty() if host.plan_controller else true
	var path := ""
	if _in_plan_phase():
		if not queue_empty and not host.end_turn_button.disabled:
			path = "end_turn"
		elif queue_empty and not host.commit_plan_button.disabled:
			path = "commit_plan"
	commit_path = path
	commit_plate.disabled = path == ""
	# Commit stays muted until something is queued (spec 4.4 rank 4): amber only when the
	# queue holds a play; inert is hatched with a dashed edge and keeps `dim` text (spec 4.3).
	match path:
		"end_turn":
			commit_caption.text = "COMMIT THE MONTH"
			_set_commit_caption("label", C.amber, "GCapsBold")
			commit_keycap_label.text = _key_name("end_turn", "Space")
			_style_commit("GCommitReady")
		"commit_plan":
			commit_caption.text = "HOLD ALL HOURS FOR EVENTS"
			_set_commit_caption("small", C.muted, "GCaps")
			commit_keycap_label.text = _key_name("commit_plan", "Enter")
			_style_commit("GCommitHold")
		_:
			# Spec 5.6 / 5.2: inert while the month plays; MONTH COMPLETE under the review.
			if watch_state() == "W4":
				commit_caption.text = "MONTH COMPLETE"
			elif not _in_plan_phase():
				commit_caption.text = "MONTH IN PLAY"
			else:
				commit_caption.text = "COMMIT THE MONTH"
			_set_commit_caption("label", C.dim, "GCaps")
			_style_commit("GCommitHold")
	commit_keycap.visible = path != "" and not _modal_open()


func press_commit_plate() -> void:
	"""The plate click runs EXACTLY today's handler for the path its caption names, and only
	when today's button for that path is enabled (spec 5.6)."""
	if host == null:
		return
	_refresh_commit()
	match commit_path:
		"end_turn":
			if not host.end_turn_button.disabled:
				host._on_end_turn_button_pressed()
		"commit_plan":
			if not host.commit_plan_button.disabled:
				host._on_commit_plan_button_pressed()
	_refresh_commit()


func _process(_delta: float) -> void:
	# ModalStack has no signal; the keycap rule (only the top layer shows a key) is a cheap
	# per-frame read of the slot ModalStack already keeps in sync.
	_refresh_modal_keycaps(false)
	# The WATCH sub-state reads the same slot plus EventDialog.current_event: redraw on change.
	if not _detached and host != null and watch_state() != _watch_state:
		_refresh_watch()


func _refresh_modal_keycaps(force: bool) -> void:
	"""Only the top layer shows a key. With nothing open every keycap shows; with a G sheet or
	the guide on top the rail keeps its keys (A, U, E, F1 act there, spec 8.2) and the desk's
	other keycaps hide; with any other modal on top no plate shows a key (spec 5.3)."""
	if _detached or host == null:
		return
	var top := effective_top_kind()
	var open := 1 if _modal_open() else 0
	if not force and open == _modal_open_cache and top == _keycap_top:
		return
	_modal_open_cache = open
	_keycap_top = top
	var show_keys := open == 0
	var rail_keys := top == "" or top.begins_with("g_")
	menu_button.get_meta("keycap").visible = show_keys
	feedback_keycap.visible = show_keys
	plate_actions.set_keycap_visible(rail_keys and not skipped_binds.has("g_actions"))
	plate_upgrades.set_keycap_visible(rail_keys and not skipped_binds.has("g_upgrades"))
	plate_staff.set_keycap_visible(rail_keys and not skipped_binds.has("g_staff"))
	plate_ledger.set_keycap_visible(show_keys)
	plate_guide.set_keycap_visible(rail_keys and not skipped_binds.has("g_guide"))
	plate_actions.set_lit(top == "g_actions")
	plate_upgrades.set_lit(top == "g_upgrades")
	plate_guide.set_lit(top == "g_guide")
	commit_keycap.visible = show_keys and commit_path != ""
	_refresh_mode()
	_refresh_attention()


func _modal_open() -> bool:
	if host == null:
		return false
	var d = host.get("active_dialog")
	return d != null and is_instance_valid(d)


func _top_kind() -> String:
	if host == null or host.get("modal_stack") == null:
		return ""
	return host.modal_stack.top_kind()


func effective_top_kind() -> String:
	"""ModalStack.top_kind(), or "modal" for a registered modal that has no kind (today's
	submenus and the ledger are presented without one), so GKeys never reads a kind-less
	modal as "nothing open"."""
	if host == null or host.get("modal_stack") == null:
		return ""
	var k: String = host.modal_stack.top_kind()
	if k == "" and host.modal_stack.depth() > 0:
		return "modal"
	return k


# --- advisor note (spec 5.13) ----------------------------------------------------------

func advisor_mode() -> String:
	"""What the advisor note carries now: "lever" (the cold open's first-lever hand-off, with
	arrow and pulse), "plain" (today's first-turns hint, classic's GettingStartedHint, shown
	under classic's own condition: its visible flag, set by main_ui from show_hints and the
	turn, in the PLAN view where classic draws it), or "" (no note). The lever note wins."""
	if GameConfig.show_first_lever_hint:
		return "" if GAdvisorNote.dismissed_this_session else "lever"
	var gs = _getting_started_hint()
	if gs == null or not gs.visible or String(gs.text) == "" \
			or GAdvisorNote.plain_dismissed_this_session:
		return ""
	var planning: bool = host.screen_mode == null \
		or host.screen_mode.current_mode == ScreenModeController.Mode.PLAN
	return "plain" if planning else ""


func _getting_started_hint() -> Label:
	var gs = host.get("getting_started_hint") if host != null else null
	return gs if gs is Label and is_instance_valid(gs) else null


func _refresh_advisor() -> void:
	if advisor_note == null:
		return
	var mode := advisor_mode()
	if mode == _advisor_mode:
		if mode == "plain":
			_show_plain_hint()
		return
	_advisor_mode = mode
	_stop_advisor_pulse()
	if actions_panel != null:
		actions_panel.set_hint("")
	match mode:
		"lever":
			var action_id: String = host._first_lever_action_id() if host != null else ""
			var action_name := String(GameActions.get_action_by_id(action_id).get("name", ""))
			advisor_note.set_hint(host._first_lever_hint_text() if host != null else "", action_name)
			# The ACTIONS plate is the rail's first plate: top 132, 52 tall (spec 3.2).
			advisor_note.arrow_y = 132.0 + 26.0 - advisor_note.position.y
			advisor_note.show_arrow = true
			advisor_note.visible = true
			_start_advisor_pulse()
			if actions_panel != null:
				actions_panel.set_hint(action_id)
		"plain":
			advisor_note.show_arrow = false
			_show_plain_hint()
			advisor_note.visible = true
		_:
			advisor_note.visible = false
	advisor_note.queue_redraw()


func _show_plain_hint() -> void:
	"""Classic's first-turns line, its own words, read from the classic label."""
	var gs := _getting_started_hint()
	var t := String(gs.text) if gs != null else ""
	if advisor_note.body_text() != GAdvisorNote.display_case(GAdvisorNote.trim_hint(t)) \
			or advisor_note.where_text() != "":
		advisor_note.set_hint(t, "")


func _start_advisor_pulse() -> void:
	_stop_advisor_pulse()
	# The hinted plate pulses like today's nudge (alpha 1 -> 0.4 -> 1, 0.6 s each way).
	_advisor_pulse = plate_actions.create_tween().set_loops()
	_advisor_pulse.tween_property(plate_actions, "modulate:a", 0.4, 0.6)
	_advisor_pulse.tween_property(plate_actions, "modulate:a", 1.0, 0.6)
	plate_actions.set_hint(true)


func _stop_advisor_pulse() -> void:
	if _advisor_pulse != null and _advisor_pulse.is_valid():
		_advisor_pulse.kill()
	_advisor_pulse = null
	if plate_actions != null:
		plate_actions.modulate.a = 1.0
		plate_actions.set_hint(false)


func _on_first_lever_cleared() -> void:
	if _detached:
		return
	_refresh_advisor()


func _on_advisor_dismissed() -> void:
	if _advisor_mode == "plain":
		GAdvisorNote.plain_dismissed_this_session = true
	else:
		GAdvisorNote.dismissed_this_session = true
	_refresh_advisor()


# --- toast (spec 5.6.1) ----------------------------------------------------------------

func _on_rejection_reported(message: String) -> void:
	if _detached:
		return
	toast.show_message(message)


# --- clicks ------------------------------------------------------------------------------

func _on_menu_pressed() -> void:
	# Same as Esc with nothing open (main_ui._input).
	if host != null and host.pause_menu and not host.pause_menu.visible:
		host.pause_menu.show_pause_menu()


func _on_feedback_pressed() -> void:
	if host != null:
		host._open_bug_report_panel()


func _on_doom_card_pressed() -> void:
	if host != null:
		host._show_doom_trend_expanded()


func _on_view_segment(which: int) -> void:
	if host == null or host.screen_mode == null:
		return
	var watching: bool = host.screen_mode.current_mode == ScreenModeController.Mode.WATCH
	if (which == 1) != watching:
		host.screen_mode.toggle_mode()


func open_ledger() -> void:
	if host != null:
		host._show_ledger_screen()


func open_staff() -> void:
	"""Spec 5.9.2 (V5): first dismiss any G-owned modal through ModalStack, then today's door."""
	if host == null:
		return
	_dismiss_g_modals()
	host._on_open_employee_screen()


func _dismiss_g_modals() -> void:
	if host == null or host.get("modal_stack") == null:
		return
	var guard := 0
	while host.modal_stack.top_kind().begins_with("g_") and guard < 8:
		host.modal_stack.dismiss(host.modal_stack.top_node())
		guard += 1


func toggle_guide() -> void:
	"""Spec 5.9.4: the Player Guide as an overlay over the live run, registered in ModalStack
	(kind g_guide, close mode FREE). No scene change happens. A second press closes it."""
	if host == null:
		return
	if _guide != null and is_instance_valid(_guide) and not _guide.is_queued_for_deletion():
		_close_guide()
		return
	if not host.modal_stack.can_present():
		return
	var tm: Node = host.tab_manager
	var guide: Control = load("res://scenes/player_guide.tscn").instantiate()
	guide.set("embedded", true)
	guide.set("modal_stack", host.modal_stack)
	guide.name = "GGuide"
	var barrier := ColorRect.new()
	barrier.name = "GGuideBarrier"
	barrier.color = Color(0, 0, 0, 0.5)
	barrier.mouse_filter = Control.MOUSE_FILTER_STOP
	tm.add_child(barrier)
	barrier.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	tm.add_child(guide)
	guide.tree_exited.connect(barrier.queue_free)
	if not host.modal_stack.present(guide, [], {"kind": "g_guide",
			"close_mode": ModalStack.CloseMode.FREE}):
		guide.queue_free()
		return
	_guide = guide


func _close_guide() -> void:
	if _guide != null and is_instance_valid(_guide):
		if host != null and host.get("modal_stack") != null:
			host.modal_stack.dismiss(_guide)
		if is_instance_valid(_guide) and not _guide.is_queued_for_deletion():
			_guide.queue_free()
	_guide = null


func guide_open() -> bool:
	return _guide != null and is_instance_valid(_guide) and not _guide.is_queued_for_deletion()


func _on_host_visibility_changed() -> void:
	if _detached or host == null:
		return
	# Spec 2.2: the desk hides with MainUI when the Employee screen takes over.
	visible = host.visible


# --- sheets (spec 2.4, 5.7-5.9) -----------------------------------------------------------

func sheet_for(kind: String) -> GSheet:
	match kind:
		"g_actions":
			return actions_panel
		"g_plan":
			return plan_panel
		"g_upgrades":
			return upgrades_panel
	return null


func open_sheet(kind: String) -> bool:
	"""Present the sheet through ModalStack (kind, close mode HIDE), then show it. Refused when
	ModalStack refuses (an unanswered event holds the top) or outside the plan. A newcomer
	pops the whole stack, so this also closes any other open G sheet (the switch, spec 6.2)."""
	var sh := sheet_for(kind)
	if sh == null or host == null or _detached or not _in_plan_phase():
		return false
	if not host.modal_stack.present(sh, [], {"kind": kind, "close_mode": ModalStack.CloseMode.HIDE}):
		return false
	sh.show_panel()
	_refresh_modal_keycaps(true)
	return true


func close_sheet(kind: String) -> void:
	var sh := sheet_for(kind)
	if sh == null or not sh.visible:
		return
	if host != null and host.get("modal_stack") != null and host.modal_stack.dismiss(sh):
		return
	sh.hide_panel()


func toggle_sheet(kind: String) -> void:
	"""A plate or its letter: close the sheet when it is on top, else open it (switching from
	another G sheet). Never acts over a modal that is not G's own."""
	var top := effective_top_kind()
	if top != "" and not top.begins_with("g_"):
		return
	if top == kind:
		close_sheet(kind)
	else:
		open_sheet(kind)


func close_g_sheets() -> void:
	for sh in [actions_panel, plan_panel, upgrades_panel]:
		if sh != null and sh.visible:
			if host != null and is_instance_valid(host) and host.get("modal_stack") != null:
				host.modal_stack.dismiss(sh)
			if sh.visible:
				sh.hide_panel()


func _on_sheet_closed() -> void:
	if _detached:
		return
	_refresh_modal_keycaps(true)


func _refresh_sheets() -> void:
	for sh in [actions_panel, plan_panel]:
		if sh != null and sh.visible:
			sh.refresh()
	if upgrades_panel != null:
		upgrades_panel.refresh.call_deferred()


func _on_choose_pressed() -> void:
	"""The Attention card's button: CHOOSE ACTIONS opens the Actions sheet; OPEN PLAN and
	CLOSE PLAN toggle the Plan drawer (spec 5.5)."""
	if plan_panel.visible:
		close_sheet("g_plan")
	elif host != null and host.plan_controller != null and host.plan_controller.queued_actions.is_empty():
		open_sheet("g_actions")
	else:
		open_sheet("g_plan")


func set_action_rows(ordered: Array) -> void:
	"""ActionBarRenderer hands over the row list it built the flat grid from: same order, same
	filters. Slot i is the grid index keys 1-9 trigger."""
	var out: Array = []
	for i in range(ordered.size()):
		out.append({"action": ordered[i], "slot": i})
	actions_panel.set_rows(out)


# --- doors (spec 5.7.4) ---------------------------------------------------------------------

func submenu_anchor_for(submenu_id: String) -> Control:
	"""main_ui._open_submenu asks this BEFORE it opens the submenu (opening pops the sheet): the
	Actions sheet row for that id when the sheet is open, else null (no anchor, as when no
	classic button is found). A door opened from the open sheet is remembered for the return."""
	_door_pending = ""
	if actions_panel == null or not actions_panel.visible:
		return null
	_door_pending = submenu_id
	return actions_panel.row_for(submenu_id)


func on_submenu_opened(submenu_id: String, dialog: Control) -> void:
	"""Called by main_ui._open_submenu after the submenu is up. If the Actions sheet opened it,
	return to the sheet when that submenu leaves the tree by any path (A3 guards apply)."""
	var from_sheet := _door_pending == submenu_id and submenu_id != ""
	_door_pending = ""
	if not from_sheet or dialog == null or not is_instance_valid(dialog):
		return
	if String(dialog.get_meta("submenu_id", "")) != submenu_id:
		return   # refused (an event holds the top) or replaced: nothing to return from
	_door_dialog = dialog
	_door_id = submenu_id
	dialog.tree_exited.connect(_on_door_closed.bind(dialog), CONNECT_ONE_SHOT)


func _on_door_closed(dialog: Control) -> void:
	if dialog != _door_dialog:
		return
	_door_dialog = null
	_door_return.call_deferred()


func door_return_allowed() -> bool:
	"""(b) still g and the desk in the tree, (c) no newer modal on top, (d) still the plan."""
	if _detached or not is_inside_tree() or host == null or not is_instance_valid(host):
		return false
	if not host.has_method("is_g_layout") or not host.is_g_layout():
		return false
	if host.modal_stack.depth() > 0:
		return false
	return _in_plan_phase()


func _door_return() -> void:
	var id := _door_id
	_door_id = ""
	if not door_return_allowed():
		return
	if open_sheet("g_actions"):
		var row := actions_panel.row_for(id)
		if row != null and row.focus_mode != Control.FOCUS_NONE:
			row.grab_focus()


# --- keys (spec 8) -----------------------------------------------------------------------

func handle_key(event: InputEvent) -> bool:
	"""main_ui._input calls this (layout g only) after the text-focus gate and the ledger block
	and before the Esc and dialog blocks. True = G performed it (main_ui marks it handled)."""
	if _detached or host == null:
		return false
	var phase := String(host.current_turn_phase)
	var intent := GKeys.route(event, effective_top_kind(), phase, KeybindManager, skipped_binds)
	if intent == "":
		return false
	perform(intent)
	return true


func perform(intent: String) -> void:
	match intent:
		"toggle_actions":
			toggle_sheet("g_actions")
		"toggle_plan":
			toggle_sheet("g_plan")
		"toggle_upgrades":
			toggle_sheet("g_upgrades")
		"staff":
			open_staff()
		"guide":
			toggle_guide()
		"undo":
			if not host.undo_last_button.disabled:
				host._on_undo_last_button_pressed()
		"clear":
			if not host.clear_queue_button.disabled:
				host._on_clear_queue_button_pressed()
		"reserve":
			if not host.reserve_ap_button.disabled:
				host._on_reserve_ap_button_pressed()
		_:
			if intent.begins_with("slot_"):
				host._trigger_action_by_index(int(intent.substr(5)))
	if plan_panel != null and plan_panel.visible:
		plan_panel.refresh()


func _refresh_binds() -> void:
	skipped_binds = GKeys.skipped_binds(KeybindManager.keybinds)
	_refresh_modal_keycaps(true)


func _on_binds_changed(_action: String, _key: int) -> void:
	if not _detached:
		_refresh_binds()


func _on_profile_loaded(_name: String) -> void:
	if not _detached:
		_refresh_binds()


# --- text boxes for the capture harness (spec 4.5) ---------------------------------------

func get_text_boxes() -> Array:
	"""All G text in this phase is in Labels, which the harness finds itself."""
	return []


# --- static builders: the look comes from theme/g_theme.tres (spec 4) ----------------------
# Each builder names a theme type variation; the desk's root carries the theme, so a control
# built here takes its face, stylebox and colours from it once it is in the desk's tree. Only
# sizes (always ThemeManager.get_font_size, spec 4.2) and per-state text colours are set here.

static func make_label(text: String, size_name: String, color: Color, face: String = "") -> Label:
	"""A label at a ThemeManager size step, in `color`. `face` is a Label variation of the theme:
	GCaps (Barlow Condensed SemiBold, tracked caps), GCapsBold, GCapsMed, GMono (IBM Plex Mono
	Medium, every number), GMonoReg, GMonoSemi, GSansMed, GType / GTypeBold (Courier Prime),
	GDateline; "" = the theme's default face, IBM Plex Sans."""
	var l := Label.new()
	l.text = text
	if face != "":
		l.theme_type_variation = StringName(face)
	set_step(l, size_name)
	set_ink(l, color)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return l


static func make_box(bg: Color, border: Color = Color(0, 0, 0, 0), width: int = 1,
		radius: int = 2) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = bg
	if border.a > 0.0:
		sb.border_color = border
		sb.set_border_width_all(width)
	sb.set_corner_radius_all(radius)
	return sb


static func make_panel(variation: String = "GPanel") -> PanelContainer:
	"""A PanelContainer whose stylebox is the theme's `variation` (GStripTop, GBanner,
	GStripBottom, GHeld, GRaised, GTile, ...). For a grimed card with ticks use GPanel.new()."""
	var p := PanelContainer.new()
	p.theme_type_variation = StringName(variation)
	return p


static func make_keycap(text: String, amber: bool = false) -> PanelContainer:
	"""A keycap (spec 4.3): the theme's GKeycap (or GKeycapAmber) hairline box, mono `small`."""
	var kc := PanelContainer.new()
	kc.name = "Keycap"
	kc.mouse_filter = Control.MOUSE_FILTER_IGNORE
	kc.theme_type_variation = &"GKeycapAmber" if amber else &"GKeycap"
	var l := make_label(text, "small", C.amber if amber else C.muted, "GMono")
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	kc.add_child(l)
	kc.set_meta("label", l)
	return kc


static func set_keycap_amber(kc: Control, amber: bool) -> void:
	if kc == null:
		return
	kc.theme_type_variation = &"GKeycapAmber" if amber else &"GKeycap"
	var l = kc.get_meta("label", null)
	if l is Label:
		set_ink(l as Label, C.amber if amber else C.muted)


static func make_plate_button(title: String, icon_path: String, key_text: String) -> Button:
	"""A flat text button with an icon and a keycap (Menu, Feedback): rank 4, caps `small` in
	`muted` (spec 4.4)."""
	var b := Button.new()
	b.focus_mode = Control.FOCUS_NONE
	b.flat = true
	b.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var hb := HBoxContainer.new()
	hb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hb.add_theme_constant_override("separation", 8)
	b.add_child(hb)
	var tex = load(icon_path) if ResourceLoader.exists(icon_path) else null
	if tex != null:
		var ic := TextureRect.new()
		ic.texture = tex
		ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		ic.custom_minimum_size = Vector2(24, 24)
		ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
		ic.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		ic.self_modulate = Color(1, 1, 1, 0.82)
		hb.add_child(ic)
	var l := make_label(title, "small", C.muted, "GCaps")
	l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hb.add_child(l)
	var kc := make_keycap(key_text)
	kc.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	hb.add_child(kc)
	b.set_meta("keycap", kc)
	b.set_meta("label", l)
	# Size the button to its content (children of a Button do not size it).
	hb.resized.connect(func(): b.custom_minimum_size = hb.get_combined_minimum_size())
	b.custom_minimum_size = hb.get_combined_minimum_size()
	return b


static func style_flat_button(b: Button, primary: bool = false) -> void:
	"""A G text button: the theme's GButton (bone on a dark plate, frame-hi hairline) or, for
	the one primary action on a card, GButtonAmber. Disabled = hatch and a dashed edge, the
	text keeps `dim` (spec 4.3)."""
	b.theme_type_variation = &"GButtonAmber" if primary else &"GButton"
	hook_dashed_edge(b)


static func style_row(b: Button, blocked: bool) -> void:
	"""A sheet row (spec 5.7.1): GRow at rest (bare), hover/focus with the amber hairline;
	GRowBlocked for a blocked row, hatched with a dashed edge (spec 4.3). The row's text keeps
	its colour, never faded."""
	b.theme_type_variation = &"GRowBlocked" if blocked else &"GRow"
	b.set_meta("g_dashed", blocked)
	hook_dashed_edge(b)
	b.queue_redraw()


static func style_upgrade_row(b: Button) -> void:
	"""The G upgrades row (A4): the theme's GUpgradeRow (raised panel-2 row; bought and
	unaffordable rows are the hatch with a dashed edge, no modulate), the text keeps `dim`."""
	b.theme_type_variation = &"GUpgradeRow"
	hook_dashed_edge(b)
	set_step(b, "body")
	track_theme_ink(b)


static func hook_dashed_edge(b: Control) -> void:
	"""StyleBoxes draw solid borders only, so a disabled control's dashed edge (spec 3.3, 4.3)
	is drawn on its own draw signal, over the hatch: while it is a disabled BaseButton, or while
	its meta "g_dashed" is true (blocked rows that stay clickable). Hooked once per control."""
	if b == null or b.has_meta("g_dash_hooked"):
		return
	b.set_meta("g_dash_hooked", true)
	var draw_it := func() -> void:
		var dashed: bool = bool(b.get_meta("g_dashed", false)) \
			or (b is BaseButton and (b as BaseButton).disabled)
		if dashed:
			draw_dashed_rect(b, Rect2(Vector2.ZERO, b.size), C.frame_hi)
	b.draw.connect(draw_it)


static func draw_dashed_rect(ci: CanvasItem, r: Rect2, colour: Color, dash: float = 4.0) -> void:
	var a := r.position + Vector2(0.5, 0.5)
	var e := r.end - Vector2(0.5, 0.5)
	ci.draw_dashed_line(a, Vector2(e.x, a.y), colour, 1.0, dash)
	ci.draw_dashed_line(Vector2(e.x, a.y), e, colour, 1.0, dash)
	ci.draw_dashed_line(e, Vector2(a.x, e.y), colour, 1.0, dash)
	ci.draw_dashed_line(Vector2(a.x, e.y), a, colour, 1.0, dash)


static func key_name(action: String, fallback: String) -> String:
	return _key_name(action, fallback)


static func contrast_ratio(a: Color, b: Color) -> float:
	var la := _rel_lum(a)
	var lb := _rel_lum(b)
	return (maxf(la, lb) + 0.05) / (minf(la, lb) + 0.05)


static func _rel_lum(c: Color) -> float:
	var f := func(v: float) -> float:
		return v / 12.92 if v <= 0.03928 else pow((v + 0.055) / 1.055, 2.4)
	return 0.2126 * f.call(c.r) + 0.7152 * f.call(c.g) + 0.0722 * f.call(c.b)


static func lift_to(c: Color, bg: Color, target: float, toward: Color = Color(0, 0, 0, 0)) -> Color:
	"""Lift a text colour toward a pale tint of itself (or toward `toward`, when given) until
	it reaches `target`:1 on `bg` (spec 4.1: doom text). The game's own colour is kept for
	strokes."""
	var pale := c.lerp(Color(0.96, 0.94, 0.92), 0.85) if toward.a <= 0.0 else Color(toward, 1.0)
	for i in range(0, 21):
		var t := float(i) / 20.0
		var cc := c.lerp(pale, t)
		cc.a = 1.0
		if contrast_ratio(cc, bg) >= target:
			return cc
	return pale


# --- compact view (2a addendum) ---------------------------------------------------------
# Below COMPACT_SCALE of the 1920x1080 canvas (1280x720 is 0.667) the canvas_items stretch
# draws `small` text a third smaller, and its strokes no longer reach their colour on screen.
# There G lifts its own small text toward `bone` (lift_to) and, for the classes that still
# fall short, takes the next size step (ThemeManager.get_font_size, never a literal). Every
# label made by make_label, and every control passed to set_step / set_ink /
# track_theme_ink, remembers its size step and colour in metadata; the live desk re-applies
# them when the viewport's size changes. At 1920x1080 nothing changes. Display only.

const COMPACT_SCALE := 0.8
## Lift target on the panel, toward bone (bone on the panel is ~12.4:1).
const COMPACT_TARGET := 11.0
## Size steps whose text is lifted in the compact view.
const COMPACT_LIFT_SIZES := ["small"]
const COMPACT_NEXT_STEP := {"small": "body"}

## True while the live desk's canvas renders below COMPACT_SCALE.
static var compact := false


static func is_compact_scale(scale: float) -> bool:
	return scale > 0.0 and scale < COMPACT_SCALE


static func compact_ink(c: Color) -> Color:
	"""The compact view's colour for lifted text: toward bone until COMPACT_TARGET on the
	panel (never darker than the colour itself). Dark ink (text on paper) is left alone."""
	if _rel_lum(c) < 0.1 or contrast_ratio(c, C.panel_solid) >= COMPACT_TARGET:
		return c
	var out := lift_to(c, C.panel_solid, COMPACT_TARGET, C.bone)
	out.a = c.a
	return out


static func _lifts(c: Control) -> bool:
	if c.has_meta("g_lift"):
		return bool(c.get_meta("g_lift"))
	return COMPACT_LIFT_SIZES.has(String(c.get_meta("g_size", "")))


static func set_step(c: Control, size_name: String) -> void:
	"""Set a control's font size step (remembered for the compact view)."""
	c.set_meta("g_size", size_name)
	_apply_step(c)


static func compact_step_up(c: Control) -> void:
	"""Mark a text class that a colour lift alone cannot carry at 720p: in the compact view it
	takes the next size step (COMPACT_NEXT_STEP)."""
	c.set_meta("g_up", true)
	_apply_step(c)


static func _apply_step(c: Control) -> void:
	var s := String(c.get_meta("g_size", ""))
	if s == "":
		return
	if compact and COMPACT_NEXT_STEP.has(s) and bool(c.get_meta("g_up", false)):
		s = COMPACT_NEXT_STEP[s]
	c.add_theme_font_size_override(StringName(c.get_meta("g_size_prop", "font_size")),
		ThemeManager.get_font_size(s))


static func set_ink(c: Control, colour: Color, prop: String = "font_color") -> void:
	"""Set a text colour override (remembered, and lifted in the compact view when the
	control's size step is lifted)."""
	var inks: Dictionary = c.get_meta("g_ink", {})
	inks[prop] = colour
	c.set_meta("g_ink", inks)
	c.add_theme_color_override(StringName(prop), compact_ink(colour) if compact and _lifts(c) else colour)


static func ink_of(c: Control, prop: String = "font_color") -> Color:
	"""The colour set_ink was given (before any compact lift)."""
	var inks: Dictionary = c.get_meta("g_ink", {})
	return inks.get(prop, c.get_theme_color(StringName(prop)))


static func track_theme_ink(c: Control, lift: bool = true) -> void:
	"""For a control whose text colours come from its theme variation (G buttons): in the
	compact view, override them with their lifted colours; re-applied whenever it enters the
	tree, so rows rebuilt later follow too."""
	c.set_meta("g_theme_ink", true)
	c.set_meta("g_lift", lift)
	if not c.has_meta("g_theme_ink_hooked"):
		c.set_meta("g_theme_ink_hooked", true)
		c.tree_entered.connect(_apply_theme_ink.bind(c))
	_apply_theme_ink(c)


const THEME_INK_PROPS := ["font_color", "font_disabled_color", "font_focus_color"]


static func _apply_theme_ink(c: Control) -> void:
	if not is_instance_valid(c) or not c.is_inside_tree():
		return
	for prop in THEME_INK_PROPS:
		c.remove_theme_color_override(StringName(prop))
	if not (compact and _lifts(c)):
		return
	for prop in THEME_INK_PROPS:
		c.add_theme_color_override(StringName(prop), compact_ink(c.get_theme_color(StringName(prop))))


static func apply_compact(root: Node) -> void:
	"""Re-apply every remembered size and colour under `root` for the current view."""
	if root is Control:
		var c := root as Control
		if c.has_meta("g_size"):
			_apply_step(c)
		if c.has_meta("g_ink"):
			var inks: Dictionary = c.get_meta("g_ink")
			for prop in inks:
				c.add_theme_color_override(StringName(prop),
					compact_ink(inks[prop]) if compact and _lifts(c) else inks[prop])
		if c.has_meta("g_theme_ink"):
			_apply_theme_ink(c)
	for ch in root.get_children():
		apply_compact(ch)


func view_scale() -> float:
	"""The canvas's scale on screen (1.0 at 1920x1080, 0.667 at 1280x720). A headless run
	draws nothing, so it counts as full size."""
	if not is_inside_tree() or DisplayServer.get_name() == "headless":
		return 1.0
	return get_viewport().get_final_transform().get_scale().x


func _on_view_resized() -> void:
	_update_compact(false)


func _update_compact(force: bool, scale: float = -1.0) -> void:
	"""Follow the view's scale: on a change into or out of the compact view, re-apply."""
	var on := is_compact_scale(view_scale() if scale < 0.0 else scale)
	if on == compact and not force:
		return
	compact = on
	apply_compact(self)


# --- small helpers ---------------------------------------------------------------------

func _margin_hbox(parent: Control, left: int, right: int, sep: int) -> HBoxContainer:
	var m := MarginContainer.new()
	m.add_theme_constant_override("margin_left", left)
	m.add_theme_constant_override("margin_right", right)
	m.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(m)
	var hb := HBoxContainer.new()
	hb.add_theme_constant_override("separation", sep)
	hb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	m.add_child(hb)
	return hb


func _make_segment(text: String) -> Button:
	var b := Button.new()
	b.text = text
	b.focus_mode = Control.FOCUS_NONE
	b.custom_minimum_size = Vector2(84, 32)
	set_step(b, "small")
	track_theme_ink(b)
	hook_dashed_edge(b)
	return b


func _style_segment(b: Button, current: bool) -> void:
	"""The current view has the amber underline (GSegmentOn); inert while an event waits
	(disabled: hatch and a dashed edge, spec 5.2)."""
	b.theme_type_variation = &"GSegmentOn" if current else &"GSegment"
	_apply_theme_ink(b)
	b.queue_redraw()


func _style_commit(variation: String) -> void:
	"""The plate's styleboxes come from the theme (GCommitReady / GCommitHold; disabled is the
	hatch in both). The keycap turns amber with the ready plate."""
	commit_plate.theme_type_variation = StringName(variation)
	commit_keycap.theme_type_variation = &"GKeycapAmber" if variation == "GCommitReady" else &"GKeycap"
	set_ink(commit_keycap_label, C.amber if variation == "GCommitReady" else C.muted)
	commit_plate.queue_redraw()


func _set_commit_caption(size_name: String, colour: Color, face: String) -> void:
	commit_caption.theme_type_variation = StringName(face)
	set_step(commit_caption, size_name)
	set_ink(commit_caption, colour)


static func _key_name(action: String, fallback: String) -> String:
	"""The key a bind is on now (rebinds are respected); the fallback when unbound."""
	if action == "":
		return fallback
	var n := String(KeybindManager.get_key_name(action))
	return fallback if n == "" or n == "Unbound" else n

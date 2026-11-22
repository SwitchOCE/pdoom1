class_name GPrefs
extends RefCounted
## G desk settings (fork/design/godot-g/spec.md 2.1). G keeps its own preferences in its own
## file, user://g_ui.cfg, section [g], so the G layer never writes GameConfig's file
## (game_config.gd is a gameplay autoload: bug fixes only).
##
## Read once on first use and again whenever a value changes. Pure presentation: nothing
## here is game state, nothing here draws a random number.
##
## Keys:
##   desk           bool   -- G on or off (default DESK_DEFAULT)
##   room_effects   String -- "full" | "simple" | "off" (default "full"; spec 5.14, phase 3a)
##   reduced_motion bool   -- default false (spec 6.5). Read by the room since phase 3a; the
##                            switch joins the options modal in phase 7, when every G motion
##                            honours it.
## (resources arrives with its reader in phase 6.)

## THE one place that decides whether G is on when nothing is saved yet. Alex's decision for
## the fork's builds: on. Flip this constant to make classic the default again.
const DESK_DEFAULT := true

const PATH := "user://g_ui.cfg"
const SECTION := "g"

static var _loaded := false
static var _desk: bool = DESK_DEFAULT
static var _room_effects: String = "full"
static var _reduced_motion: bool = false

const ROOM_EFFECTS := ["full", "simple", "off"]


static func reload_prefs(path: String = PATH) -> void:
	"""Read the file (missing file or keys -> defaults). Unknown values fall back to defaults."""
	_desk = DESK_DEFAULT
	_room_effects = "full"
	_reduced_motion = false
	var cf := ConfigFile.new()
	if cf.load(path) == OK:
		_desk = bool(cf.get_value(SECTION, "desk", DESK_DEFAULT))
		var re := String(cf.get_value(SECTION, "room_effects", "full"))
		_room_effects = re if re in ROOM_EFFECTS else "full"
		_reduced_motion = bool(cf.get_value(SECTION, "reduced_motion", false))
	_loaded = true


static func save_prefs(path: String = PATH) -> int:
	"""Write every key. Returns the ConfigFile error code (OK on success)."""
	_ensure_loaded()
	var cf := ConfigFile.new()
	cf.set_value(SECTION, "desk", _desk)
	cf.set_value(SECTION, "room_effects", _room_effects)
	cf.set_value(SECTION, "reduced_motion", _reduced_motion)
	return cf.save(path)


static func _ensure_loaded() -> void:
	if not _loaded:
		reload_prefs()


# --- getters ---------------------------------------------------------------------------

static func desk() -> bool:
	_ensure_loaded()
	return _desk


static func room_effects() -> String:
	_ensure_loaded()
	return _room_effects


static func reduced_motion() -> bool:
	_ensure_loaded()
	return _reduced_motion


# --- setters (persist = false keeps the change in memory only, for tests) ---------------

static func set_desk(on: bool, persist: bool = true) -> void:
	_ensure_loaded()
	_desk = on
	if persist:
		save_prefs()


static func set_room_effects(m: String, persist: bool = true) -> void:
	_ensure_loaded()
	_room_effects = m if m in ROOM_EFFECTS else "full"
	if persist:
		save_prefs()


static func set_reduced_motion(on: bool, persist: bool = true) -> void:
	_ensure_loaded()
	_reduced_motion = on
	if persist:
		save_prefs()

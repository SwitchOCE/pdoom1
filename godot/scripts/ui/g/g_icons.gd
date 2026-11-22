class_name GIcons
extends RefCounted
## The G icon map (fork/design/godot-g/spec.md 5.7.1, A11, R2-7): one resolver used on every G
## surface that draws an action icon -- the Actions sheet rows, the submenu option grid when
## the layout is g, and the Plan drawer rows. Classic and data/icon_mapping.json are untouched.
##
## Order: a G fallback for the two ids that have no mapping today and would show IconLoader's
## checkerboard; else today's IconLoader icon. The six commissioned icons (phase 2b, under
## assets/icons/g_new/) join this map when they exist; until then their ids keep today's icon.
##
## Pure lookup: reads files, writes nothing, draws no random number.

const ICON_ROOT := "res://assets/icons/"

## Ids with no IconLoader mapping today (spec 5.7.1): a fitting existing icon instead of the
## checkerboard placeholder.
const FALLBACKS := {
	"scout_read": "actions_research/action_research_ml_fundamentals_64.png",
	"tour_offices": "actions_facilities/action_facility_expand_office_64.png",
}

static var _cache: Dictionary = {}


static func path_for(action_id: String) -> String:
	"""The G file the resolver uses for this id, or "" when it falls through to IconLoader."""
	if FALLBACKS.has(action_id) and ResourceLoader.exists(ICON_ROOT + String(FALLBACKS[action_id])):
		return ICON_ROOT + String(FALLBACKS[action_id])
	return ""


static func for_action(action_id: String) -> Texture2D:
	var p := path_for(action_id)
	if p != "":
		if not _cache.has(p):
			_cache[p] = load(p)
		return _cache[p]
	return IconLoader.get_action_icon(action_id)

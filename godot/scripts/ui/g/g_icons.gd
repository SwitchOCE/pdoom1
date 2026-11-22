class_name GIcons
extends RefCounted
## The G icon map (fork/design/godot-g/spec.md 5.7.1, A11, R2-7): one resolver used on every G
## surface that draws an action icon -- the Actions sheet rows, the submenu option grid when
## the layout is g, and the Plan drawer rows. Classic and data/icon_mapping.json are untouched.
##
## Order: a G-only texture (the six commissioned icons, phase 2b, under assets/icons/g_new/)
## when its file exists; else a G fallback for the two ids that have no mapping today and would
## show IconLoader's checkerboard; else today's IconLoader icon.
##
## The six new icons read a little brighter than Pip's toned icons beside them (spec 11.4), so
## G tones them with a colour multiply (self_modulate on a TextureRect, the icon colours on a
## Button), never by editing their pixels: tone_for(id).
##
## Pure lookup: reads files, writes nothing, draws no random number.

const ICON_ROOT := "res://assets/icons/"

## The six new icons (Sol batch, phase 2b). Used only once the file exists.
const G_NEW := {
	"advertise": "g_new/advertise.png",
	"travel": "g_new/travel.png",
	"publicity": "g_new/publicity.png",
	"scout_shitpost": "g_new/post_online.png",
	"scout_meetups": "g_new/meetups.png",
	"order_supplies": "g_new/supplies.png",
}

## The multiply that brings the new icons down to the brightness of Pip's (spec 11.4).
const NEW_TONE := Color(0.78, 0.76, 0.72, 1.0)

## Ids with no IconLoader mapping today (spec 5.7.1): a fitting existing icon instead of the
## checkerboard placeholder.
const FALLBACKS := {
	"scout_read": "actions_research/action_research_ml_fundamentals_64.png",
	"tour_offices": "actions_facilities/action_facility_expand_office_64.png",
}

static var _cache: Dictionary = {}


static func path_for(action_id: String) -> String:
	"""The G file the resolver uses for this id, or "" when it falls through to IconLoader."""
	if G_NEW.has(action_id) and ResourceLoader.exists(ICON_ROOT + String(G_NEW[action_id])):
		return ICON_ROOT + String(G_NEW[action_id])
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


static func tone_for(action_id: String) -> Color:
	"""The colour multiply for this id's G icon: NEW_TONE for the six new icons, else white."""
	if G_NEW.has(action_id) and path_for(action_id) == ICON_ROOT + String(G_NEW[action_id]):
		return NEW_TONE
	return Color.WHITE


static func tone_button(b: Button, action_id: String) -> void:
	"""Tone a Button's icon (the submenu grid in G): every icon colour state, so hover and
	press keep the same brightness relation to Pip's icons."""
	var t := tone_for(action_id)
	if t == Color.WHITE:
		return
	for prop in ["icon_normal_color", "icon_hover_color", "icon_pressed_color",
			"icon_hover_pressed_color", "icon_focus_color", "icon_disabled_color"]:
		b.add_theme_color_override(StringName(prop), t)

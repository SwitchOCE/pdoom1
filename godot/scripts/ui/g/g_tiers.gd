class_name GTiers
extends RefCounted
## Resource tiers for the G top strip (fork/design/godot-g/spec.md 5.1.2, take a).
##
## Static and pure: the shown amount, its tier and its tag. Everything reads the SHOWN amount,
## the number the top strip prints (GameConfig.format_money / format_scalar: whole units,
## rounded half away from zero, the sign from the raw value), never the raw float. So
## reputation 60 and 60.25 both print "60" and draw tier 3; 60.5 prints "61" and draws tier 4;
## 0.25 prints "0" and draws tier 0 (H council). No forecast and no hidden value (ADR-0001):
## the tier restates the number beside it. The real loss rule (reputation <= 0 ends the run,
## game_state.gd) stays on game state and is not read here.
##
## VIEW-ONLY: reads numbers it is given, writes nothing, draws no random number.

const KEYS := ["money", "compute", "research", "papers", "reputation"]

## Upper bounds of tiers 0-3 (inclusive); tier 4 is anything above. Tier 0 is zero or below.
## 20,000 is the game's low-funds line and 20 / 30 its reputation warnings (main_ui's commit
## warnings); the rest are round steps (spec 5.1.2, open question Q3).
const TIERS := {
	"money": [0, 20000, 99999, 249999],
	"compute": [0, 49, 99, 199],
	"research": [0, 9, 19, 49],
	"papers": [0, 1, 4, 9],
	"reputation": [0, 20, 30, 60],
}

const ICON_DIR := "res://assets/icons/g_tiers/"
## The shipped file names (spec 11.2): reputation's are rep-0..4.
const FILE_PREFIX := {
	"money": "money", "compute": "compute", "research": "research",
	"papers": "papers", "reputation": "rep",
}

## Tags (spec 5.1.2): hairline, not filled. Each restates a line the game already warns on at
## Commit (main_ui's low-funds and reputation warnings); BELOW ZERO restates the printed sign.
const TAG_LOW := "LOW"
const TAG_BELOW_ZERO := "BELOW ZERO"
const LOW_MONEY := 20000.0
const REP_AMBER := 30.0
const REP_WARN := 20.0


static func shown_amount(raw: float) -> float:
	"""sign(raw) * round_half_away(abs(raw)): the amount format_money / format_scalar print.
	-0.4 gives -0.0, which compares equal to 0 (tier 0, no BELOW ZERO tag), while the text
	still prints today's "-0"."""
	var r := floorf(absf(raw) + 0.5)
	return r if raw >= 0.0 else -r


static func tier(key: String, shown: float) -> int:
	"""The tier 0-4 of a shown amount. An unknown key draws tier 0."""
	var bounds: Array = TIERS.get(key, [])
	if bounds.is_empty():
		return 0
	for i in range(bounds.size()):
		if shown <= float(bounds[i]):
			return i
	return bounds.size()


static func tier_of_raw(key: String, raw: float) -> int:
	return tier(key, shown_amount(raw))


static func icon_path(key: String, t: int) -> String:
	return "%s%s-%d.png" % [ICON_DIR, String(FILE_PREFIX.get(key, key)), clampi(t, 0, 4)]


static func tag(key: String, shown: float) -> Dictionary:
	"""{"text", "tone"} with tone "warn" or "amber", or {} for no tag."""
	match key:
		"money":
			if shown <= LOW_MONEY:
				return {"text": TAG_LOW, "tone": "warn"}
		"reputation":
			if shown <= REP_WARN:
				return {"text": TAG_LOW, "tone": "warn"}
			if shown <= REP_AMBER:
				return {"text": TAG_LOW, "tone": "amber"}
		"research":
			if shown < 0.0:
				return {"text": TAG_BELOW_ZERO, "tone": "warn"}
	return {}

class_name GResourceHistory
extends RefCounted
## Trace history for the G top strip (fork/design/godot-g/spec.md 5.1.3-5.1.4, take b).
##
## Up to CAP samples {year, month, money, compute, research, papers, reputation} of the SHOWN
## amounts (GTiers.shown_amount: the numbers the strip printed), one per calendar month the desk
## has seen. GDesk._on_state calls note_state with every state it is given: a state whose
## (year, month) differs from the last sample's appends one sample, so the first state of a new
## game is month 1's sample, and the state that opens a new month is that month's sample.
##
## Static, so it survives the conference scene change and main.tscn re-entry (resume keeps
## it). main_ui._boot_game clears it before a new game or a load, so a loaded save starts with
## no history ("since <load month>").
##
## VIEW-ONLY: it records only what the strip showed, writes no game state, draws no random
## number and is never saved.

const CAP := 24
const KEYS := ["money", "compute", "research", "papers", "reputation"]

static var samples: Array = []


static func clear() -> void:
	samples = []


static func note_state(state: Dictionary) -> bool:
	"""Append one sample when the state's (year, month) differs from the last sample's.
	Returns true if it appended. A state with no calendar records nothing."""
	var ym := year_month(state)
	if ym.y < 1:
		return false
	if not samples.is_empty():
		var last: Dictionary = samples[samples.size() - 1]
		if int(last.year) == ym.x and int(last.month) == ym.y:
			return false
	var s := {"year": ym.x, "month": ym.y}
	for key in KEYS:
		s[key] = GTiers.shown_amount(float(state.get(key, 0)))
	samples.append(s)
	while samples.size() > CAP:
		samples.pop_front()
	return true


static func year_month(state: Dictionary) -> Vector2i:
	"""(year, month) of state["calendar"], or (0, 0) when there is none."""
	var cal = state.get("calendar", {})
	if not (cal is Dictionary):
		return Vector2i.ZERO
	var m := int(cal.get("month", 0))
	if m < 1 or m > 12:
		return Vector2i.ZERO
	return Vector2i(int(cal.get("year", 0)), m)


static func points(key: String, current_raw: float, current_ym: Vector2i = Vector2i.ZERO) -> Array:
	"""The window's line (spec 5.1.3): the shown amount at the start of each earlier month,
	then the current shown amount as the last point. No forecast. The current month's own
	sample is replaced by the current amount, so month 1 has one point."""
	var out: Array = []
	var n := samples.size()
	if n > 0:
		var last: Dictionary = samples[n - 1]
		if current_ym == Vector2i.ZERO or (int(last.year) == current_ym.x and int(last.month) == current_ym.y):
			n -= 1
	for i in range(n):
		out.append(float((samples[i] as Dictionary).get(key, 0.0)))
	out.append(GTiers.shown_amount(current_raw))
	return out


static func caption() -> String:
	"""The caption's second line (spec 5.1.3): "since <Mon YYYY>" (the first recorded month),
	or "no history yet" while there is only one point."""
	if samples.size() < 2:
		return "no history yet"
	var first: Dictionary = samples[0]
	return "since %s %d" % [String(Clock.MONTH_ABBR[clampi(int(first.month), 1, 12) - 1]),
		int(first.year)]

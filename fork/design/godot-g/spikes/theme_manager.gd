extends Node

# Font-sizing excerpt of the game ThemeManager.
const FONT_STEPS := {
	"small": -4,
	"body": 0,
	"header": 8,
	"title": 16,
}

# Fallback used ONLY if the project theme is missing or declares no size. It is
# Godot's own built-in default, i.e. exactly what the game rendered at before
# this SSOT existed, so a failure here degrades to the old behaviour rather than
# to something nobody has ever looked at.
const FONT_SSOT_FALLBACK := 16

## The one number. Read from the project theme so there is no second copy to
## drift; `push_error` rather than a silent default if it is not there.
func base_font_size() -> int:
	var project_theme := ThemeDB.get_project_theme()
	if project_theme == null or project_theme.default_font_size <= 0:
		push_error(
			"ThemeManager: no project theme default_font_size. The font-size "
			+ "SSOT (gui/theme/custom -> theme/base_theme.tres) is not loaded; "
			+ "falling back to Godot's built-in %d." % FONT_SSOT_FALLBACK
		)
		return FONT_SSOT_FALLBACK
	return project_theme.default_font_size
func get_font_size(size_name: String) -> int:
	var token := size_name.trim_suffix("_size")
	if not FONT_STEPS.has(token):
		push_error(
			"ThemeManager.get_font_size(%s): unknown size token. Known: %s. "
			% [size_name, ", ".join(FONT_STEPS.keys())]
			+ "Returning body size; fix the caller rather than the fallback."
		)
		return base_font_size()
	return base_font_size() + FONT_STEPS[token]

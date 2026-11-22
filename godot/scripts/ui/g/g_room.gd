class_name GRoom
extends Control
## The room and its doom layer (fork/design/godot-g/spec.md 5.14, upgrade 2). This node is
## GDesk/RoomLayers: a full-rect, mouse-transparent layer under every G panel that holds the
## two CRT glows, and the controller of today's Backdrop (main.tscn) while G is on.
##
## - Band: ThemeManager.get_doom_band_index(state.doom), never the month.
## - full: Backdrop gets g_room_doom.gdshader (tone, grade, window sky, smut, grain, vignette,
##   band 6 fire light) at modulate white; the scrim hides; the glows show.
## - simple: no shader; Backdrop modulate = the band's brightness x grade tint; glows kept; no
##   grain or sky.
## - off: today's room (modulate 0.35 and the scrim, as main.tscn sets them); no glows.
## - Band change: one `band` value (shader uniform, glow colour and strength) tweens from where
##   it is to the new band over 1.2 s, ease in-out; instant with reduced motion (spec 6.2).
## - Grain: `grain_offset` steps 12 times a second in _process, from a step counter (no random
##   number, no shader TIME). This node is pausable, so grain freezes in pause; static with
##   reduced motion.
## - Panels never change with the band: only the Backdrop and this layer do.
##
## VIEW-ONLY: reads the state dict GDesk passes in, writes no game state, draws no random
## number (spec 7.4) and creates no timer (spec 6.1).

const SHADER_PATH := "res://assets/shaders/g_room_doom.gdshader"
const WINDOW_MASK_PATH := "res://assets/textures/g/room_window_mask.png"
const NOISE_LO_PATH := "res://assets/textures/g/room_noise_lo.png"
const NOISE_HI_PATH := "res://assets/textures/g/room_noise_hi.png"

const MODES := ["full", "simple", "off"]
const TWEEN_S := 1.2
const GRAIN_STEPS_PER_S := 12.0

## Today's room (scenes/main.tscn: Backdrop modulate 0.35, BackdropScrim shown): `off`.
const OFF_MODULATE := Color(0.35, 0.35, 0.35, 1.0)

## The art the glows are measured on (office_wide_day.webp), in texture pixels.
const ART_SIZE := Vector2(1536.0, 1024.0)
## The two lit CRTs of office_wide_day: centre and radius in texture pixels. Centres are the
## lit screens' centroids (the left monitor's screen and the small one on the middle desk);
## radii are the G mock-up's (hifi3/G/concept.html, 230x170 and 110x90 stage pixels at its
## 1.25 cover scale). The glow fades to nothing at 70% of the radius, as the mock-up's.
const GLOWS := [
	{"name": "GlowLeft", "centre": Vector2(205.0, 606.0), "radius": Vector2(184.0, 136.0)},
	{"name": "GlowMiddle", "centre": Vector2(485.0, 498.0), "radius": Vector2(88.0, 72.0)},
]

## The band table's columns that live outside the shader (H spec 2.4), one row per band 0-6.
## BRIGHTNESS and GRADE are the shader's TONE.x and GRADE rows (simple mode uses them);
## GLOW is the glow colour and strength: amber, amber, orange, red-orange, red, violet, violet.
const BRIGHTNESS := [0.80, 0.70, 0.61, 0.50, 0.44, 0.38, 0.38]
const GRADE := [
	Color(96.0 / 255.0, 62.0 / 255.0, 20.0 / 255.0, 0.10),
	Color(76.0 / 255.0, 50.0 / 255.0, 24.0 / 255.0, 0.16),
	Color(40.0 / 255.0, 42.0 / 255.0, 48.0 / 255.0, 0.26),
	Color(30.0 / 255.0, 36.0 / 255.0, 52.0 / 255.0, 0.34),
	Color(62.0 / 255.0, 16.0 / 255.0, 24.0 / 255.0, 0.40),
	Color(80.0 / 255.0, 14.0 / 255.0, 24.0 / 255.0, 0.45),
	Color(54.0 / 255.0, 8.0 / 255.0, 16.0 / 255.0, 0.55),
]
const GLOW := [
	Color(240.0 / 255.0, 176.0 / 255.0, 70.0 / 255.0, 0.20),
	Color(230.0 / 255.0, 150.0 / 255.0, 64.0 / 255.0, 0.17),
	Color(220.0 / 255.0, 120.0 / 255.0, 62.0 / 255.0, 0.16),
	Color(200.0 / 255.0, 72.0 / 255.0, 56.0 / 255.0, 0.18),
	Color(170.0 / 255.0, 40.0 / 255.0, 40.0 / 255.0, 0.22),
	Color(110.0 / 255.0, 52.0 / 255.0, 130.0 / 255.0, 0.32),
	Color(150.0 / 255.0, 113.0 / 255.0, 143.0 / 255.0, 0.30),
]

var mode := "full"
var reduced_motion := false
## The band the room is drawn at right now (a float while a tween runs).
var shown_band := 0.0
## The band the room is heading to (an int band index).
var target_band := 0
var grain_step := 0
var grain_offset := Vector2.ZERO
var backdrop: TextureRect = null
var scrim: CanvasItem = null
var material_room: ShaderMaterial = null
var glows: Array = []            # TextureRect, one per GLOWS entry

var _tween: Tween = null
var _grain_clock := 0.0
var _forced := -1                 # debug-only band override (-1 = none)
var _attached := false
var _has_band := false          # true once the first state has set the band


func _init() -> void:
	name = "RoomLayers"
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	if glows.is_empty():
		_build()
	resized.connect(_layout_glows)


func _build() -> void:
	var grad := Gradient.new()
	grad.offsets = PackedFloat32Array([0.0, 0.45, 1.0])
	grad.colors = PackedColorArray([Color(1, 1, 1, 1), Color(1, 1, 1, 0.45), Color(1, 1, 1, 0)])
	var tex := GradientTexture2D.new()
	tex.gradient = grad
	tex.fill = GradientTexture2D.FILL_RADIAL
	tex.fill_from = Vector2(0.5, 0.5)
	tex.fill_to = Vector2(1.0, 0.5)
	tex.width = 128
	tex.height = 128
	var add := CanvasItemMaterial.new()
	add.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	for g in GLOWS:
		var r := TextureRect.new()
		r.name = String(g["name"])
		r.texture = tex
		r.material = add
		r.mouse_filter = Control.MOUSE_FILTER_IGNORE
		r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		r.stretch_mode = TextureRect.STRETCH_SCALE
		add_child(r)
		glows.append(r)


# --- attach / release (LayoutController, spec 2.2 step 3) ----------------------------------

func attach(p_backdrop: TextureRect, p_scrim: CanvasItem, p_mode: String = "", p_reduced = null) -> void:
	"""Take over the Backdrop and the scrim. LayoutController saved their values first and
	puts them back after release()."""
	if glows.is_empty():
		_build()
	backdrop = p_backdrop
	scrim = p_scrim
	mode = _valid_mode(p_mode if p_mode != "" else GPrefs.room_effects())
	reduced_motion = bool(p_reduced) if p_reduced != null else GPrefs.reduced_motion()
	_attached = true
	_apply_mode()
	_apply_band()
	_layout_glows()


func release() -> void:
	"""Stop driving the Backdrop (the caller restores today's values)."""
	_kill_tween()
	if backdrop != null and is_instance_valid(backdrop) and backdrop.material == material_room:
		backdrop.material = null
	_attached = false
	backdrop = null
	scrim = null


static func _valid_mode(m: String) -> String:
	return m if m in MODES else "full"


func set_mode(m: String) -> void:
	mode = _valid_mode(m)
	if _attached:
		_apply_mode()
		_apply_band()


func _apply_mode() -> void:
	var has_backdrop := backdrop != null and is_instance_valid(backdrop)
	var has_scrim := scrim != null and is_instance_valid(scrim)
	match mode:
		"full":
			if material_room == null:
				material_room = make_material()
			if has_backdrop:
				backdrop.material = material_room
				backdrop.modulate = Color.WHITE
			if has_scrim:
				scrim.visible = false
		"simple":
			if has_backdrop:
				backdrop.material = null
			if has_scrim:
				scrim.visible = false
		_:   # off: today's room
			if has_backdrop:
				backdrop.material = null
				backdrop.modulate = OFF_MODULATE
			if has_scrim:
				scrim.visible = true
	for r in glows:
		(r as CanvasItem).visible = mode != "off"
	set_process(mode == "full" and not reduced_motion)


static func make_material() -> ShaderMaterial:
	var m := ShaderMaterial.new()
	m.shader = load(SHADER_PATH)
	m.set_shader_parameter("window_mask", load(WINDOW_MASK_PATH))
	m.set_shader_parameter("noise_lo", load(NOISE_LO_PATH))
	m.set_shader_parameter("noise_hi", load(NOISE_HI_PATH))
	m.set_shader_parameter("effects", 1.0)
	m.set_shader_parameter("band", 0.0)
	m.set_shader_parameter("grain_offset", Vector2.ZERO)
	return m


# --- band ------------------------------------------------------------------------------------

static func band_for_doom(doom: float) -> int:
	return ThemeManager.get_doom_band_index(doom)


func update_from_state(state: Dictionary) -> void:
	"""GDesk passes every state it gets. Only the doom value is read."""
	if not state.has("doom"):
		return
	# The first state lands instantly: a freshly built room (a load, a resume, an F9 flip at
	# high doom) starts at the run's band instead of fading down from band 0 as if doom rose.
	set_band(band_for_doom(float(state.get("doom", 0.0))), not _has_band)
	_has_band = true


func set_band(b: int, instant: bool = false) -> void:
	if _forced >= 0:
		b = _forced
	b = clampi(b, 0, 6)
	if b == target_band and (_tween == null or not _tween.is_valid()) and is_equal_approx(shown_band, float(b)):
		return
	target_band = b
	_kill_tween()
	if instant or reduced_motion or not is_inside_tree():
		_set_shown_band(float(b))
		return
	# From the current value (a band change mid-tween starts from where the room is).
	_tween = create_tween()
	_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_tween.tween_method(_set_shown_band, shown_band, float(b), TWEEN_S)


func _kill_tween() -> void:
	if _tween != null and _tween.is_valid():
		_tween.kill()
	_tween = null


func _set_shown_band(v: float) -> void:
	shown_band = clampf(v, 0.0, 6.0)
	_apply_band()


func _apply_band() -> void:
	if material_room != null:
		material_room.set_shader_parameter("band", shown_band)
	if mode == "simple" and backdrop != null and is_instance_valid(backdrop):
		backdrop.modulate = simple_modulate(shown_band)
	var gc := glow_color(shown_band)
	for r in glows:
		(r as CanvasItem).self_modulate = gc


static func _row(table: Array, v: float):
	var s := clampf(v, 0.0, 6.0)
	var lo := int(floor(s))
	var hi := mini(lo + 1, 6)
	var f := s - float(lo)
	var a = table[lo]
	var b = table[hi]
	if a is Color:
		return (a as Color).lerp(b, f)
	return lerpf(float(a), float(b), f)


static func glow_color(v: float) -> Color:
	return _row(GLOW, v)


static func simple_modulate(v: float) -> Color:
	"""simple mode: brightness x grade tint, as the shader's own simple branch."""
	var bright: float = _row(BRIGHTNESS, v)
	var g: Color = _row(GRADE, v)
	var tint := Color(1, 1, 1).lerp(Color(g.r, g.g, g.b), g.a)
	return Color(tint.r * bright, tint.g * bright, tint.b * bright, 1.0)


# --- grain -------------------------------------------------------------------------------------

func _process(delta: float) -> void:
	if mode != "full" or reduced_motion:
		return
	_grain_clock += delta
	var step := int(floor(_grain_clock * GRAIN_STEPS_PER_S))
	if step != grain_step:
		set_grain_step(step)


func set_grain_step(step: int) -> void:
	"""The offset is a fixed function of the step counter (golden-ratio sequence): no random
	number is drawn."""
	grain_step = step
	grain_offset = Vector2(fposmod(float(step) * 0.6180339887, 1.0), fposmod(float(step) * 0.4142135624, 1.0))
	if material_room != null:
		material_room.set_shader_parameter("grain_offset", grain_offset)


# --- glows ---------------------------------------------------------------------------------------

func covered_rect() -> Rect2:
	"""The Backdrop texture's drawn rect (KEEP_ASPECT_COVERED), in this node's coordinates."""
	var area := Rect2(Vector2.ZERO, size)
	var tex_size := ART_SIZE
	if backdrop != null and is_instance_valid(backdrop):
		var gr := backdrop.get_global_rect()
		area = Rect2(get_global_transform().affine_inverse() * gr.position, gr.size)
		if backdrop.texture != null:
			tex_size = backdrop.texture.get_size()
	if tex_size.x <= 0.0 or tex_size.y <= 0.0 or area.size.x <= 0.0 or area.size.y <= 0.0:
		return area
	var k := maxf(area.size.x / tex_size.x, area.size.y / tex_size.y)
	var drawn := tex_size * k
	return Rect2(area.position + (area.size - drawn) * 0.5, drawn)


func _layout_glows() -> void:
	if glows.is_empty():
		return
	var cr := covered_rect()
	var k := cr.size.x / ART_SIZE.x if cr.size.x > 0.0 else 1.0
	for i in range(mini(glows.size(), GLOWS.size())):
		var g: Dictionary = GLOWS[i]
		var r: TextureRect = glows[i]
		# The gradient reaches zero at the texture's edge, which is 70% of the glow radius.
		var half: Vector2 = g["radius"] * 0.7 * k
		var c: Vector2 = cr.position + g["centre"] * k
		r.position = c - half
		r.size = half * 2.0


# --- debug-only band override (the mock-up's ?band=) ------------------------------------------

func debug_force_band(b: int) -> bool:
	"""Screenshots and tests only: hold the room at band b (instant), whatever doom is. Debug
	builds only (OS.is_debug_build()); a release build ignores it. Nothing in the game calls
	it: the capture harness and the unit tests do. b < 0 lets doom drive the room again."""
	if not OS.is_debug_build():
		return false
	_forced = clampi(b, -1, 6)
	if _forced >= 0:
		target_band = _forced
		_kill_tween()
		_set_shown_band(float(_forced))
	return true


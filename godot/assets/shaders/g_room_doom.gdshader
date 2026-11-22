shader_type canvas_item;
render_mode unshaded;

// G's room by doom band (fork/design/godot-g/spec.md 5.14). One CanvasItem material on today's
// Backdrop (office_wide_day.webp, KEEP_ASPECT_COVERED). UV is the texture's UV, so the window
// mask (authored at 1536x1024) lines up whatever the crop. Display only: it reads three
// uniforms that scripts/ui/g/g_room.gd sets and writes nothing back.
//
// `band` is a float 0.0-6.0: the shader blends the two table rows either side of it, so one
// tweened uniform steps the whole room (the spike's design, spikes/doom_layer.gdshader).
// No TIME: grain moves only when g_room.gd moves `grain_offset` (a pausable node), so the room
// freezes with the game (docs/design/PAUSE_SEMANTICS.md).

uniform float band : hint_range(0.0, 6.0) = 0.0;
uniform vec2 grain_offset = vec2(0.0);
// 1.0 = the full room; 0.0 = the `simple` look (brightness x grade tint only), for tests.
uniform float effects : hint_range(0.0, 1.0) = 1.0;
uniform sampler2D window_mask : hint_default_black, filter_linear;
uniform sampler2D noise_lo : hint_default_white, filter_linear, repeat_enable;
uniform sampler2D noise_hi : hint_default_white, filter_linear, repeat_enable;

// The band table, H spec 2.4 (fork/design/hifi3/spec.md, values from its DOOM_LAYER).
// TONE: brightness, saturation, contrast, vignette.
const vec4 TONE[7] = {
	vec4(.80, .70, 1.03, .18), vec4(.70, .58, 1.05, .28),
	vec4(.61, .46, 1.08, .38), vec4(.50, .38, 1.10, .46),
	vec4(.44, .32, 1.12, .54), vec4(.38, .28, 1.14, .62),
	vec4(.38, .26, 1.18, .72)
};
// GRADE: tint rgb (0-255) and amount (multiply).
const vec4 GRADE[7] = {
	vec4(96., 62., 20., .10), vec4(76., 50., 24., .16),
	vec4(40., 42., 48., .26), vec4(30., 36., 52., .34),
	vec4(62., 16., 24., .40), vec4(80., 14., 24., .45),
	vec4(54., 8., 16., .55)
};
// Window sky, top and bottom of the panes: rgb (0-255) and strength.
const vec4 SKY_TOP[7] = {
	vec4(210., 190., 150., .14), vec4(130., 136., 140., .10),
	vec4(100., 112., 128., .20), vec4(70., 90., 140., .26),
	vec4(130., 40., 40., .30), vec4(110., 52., 130., .45),
	vec4(221., 95., 76., .42)
};
const vec4 SKY_BOTTOM[7] = {
	vec4(170., 160., 130., .08), vec4(96., 100., 108., .06),
	vec4(70., 80., 96., .14), vec4(40., 50., 90., .22),
	vec4(70., 20., 40., .28), vec4(140., 18., 23., .35),
	vec4(110., 40., 90., .42)
};
// The sky's blend: 0 = soft light (bands 0-4), 1 = colour (bands 5-6, H's skyMode "color").
const float SKY_COLOR_MODE[7] = { 0., 0., 0., 0., 0., 1., 1. };
// Texture: grain (overlay) and smut (multiply) amounts.
const float GRAIN[7] = { .07, .10, .14, .17, .20, .23, .26 };
const float SMUT[7] = { 0., .04, .08, .12, .16, .20, .24 };
// The late layer (bands 5-6): violet multiply in the shadows; band 6: fire light from below.
const float LATE[7] = { 0., 0., 0., 0., 0., 1., 1. };
const float FIRE[7] = { 0., 0., 0., 0., 0., 0., 1. };

// The panes span texture rows 360-482 (the mask script's box); the sky gradient runs over them.
const float SKY_ROW_TOP = 360.0 / 1024.0;
const float SKY_ROW_SPAN = 122.0 / 1024.0;

float luma(vec3 c) {
	return dot(c, vec3(.2126, .7152, .0722));
}

vec3 soft_light(vec3 base, vec3 blend) {
	// W3C compositing soft-light.
	vec3 d = mix(sqrt(base), ((16.0 * base - 12.0) * base + 4.0) * base, step(base, vec3(.25)));
	vec3 lo = base - (1.0 - 2.0 * blend) * base * (1.0 - base);
	vec3 hi = base + (2.0 * blend - 1.0) * (d - base);
	return mix(lo, hi, step(vec3(.5), blend));
}

float w3c_lum(vec3 c) {
	return dot(c, vec3(.3, .59, .11));
}

vec3 color_blend(vec3 base, vec3 blend) {
	// W3C compositing "color": hue and saturation of `blend`, luminance of `base`
	// (SetLum with ClipColor, so a dark room stays dark under a coloured sky).
	vec3 c = blend + (w3c_lum(base) - w3c_lum(blend));
	float l = w3c_lum(c);
	float n = min(min(c.r, c.g), c.b);
	float x = max(max(c.r, c.g), c.b);
	if (n < 0.0) {
		c = l + (c - l) * l / max(l - n, 1e-5);
	}
	if (x > 1.0) {
		c = l + (c - l) * (1.0 - l) / max(x - l, 1e-5);
	}
	return clamp(c, 0.0, 1.0);
}

vec3 overlay(vec3 base, float n) {
	vec3 lo = 2.0 * base * n;
	vec3 hi = 1.0 - 2.0 * (1.0 - base) * (1.0 - n);
	return mix(lo, hi, step(vec3(.5), base));
}

void fragment() {
	vec4 art = texture(TEXTURE, UV);
	float s = clamp(band, 0.0, 6.0);
	int lo = int(floor(s));
	int hi = min(lo + 1, 6);
	float f = s - float(lo);
	vec4 tone = mix(TONE[lo], TONE[hi], f);
	vec4 grade = mix(GRADE[lo], GRADE[hi], f);
	vec3 tint = mix(vec3(1.0), grade.rgb / 255.0, grade.a);

	// 1. brightness, saturation, contrast.
	vec3 lit = art.rgb * tone.x;
	vec3 rgb = (mix(vec3(luma(lit)), lit, tone.y) - .5) * tone.z + .5;
	// 2. the grade (multiply toward the band's tint).
	rgb = clamp(rgb, 0.0, 1.0) * tint;
	vec3 simple_rgb = art.rgb * tone.x * tint;

	// 3. window sky, inside the mask.
	float pane = texture(window_mask, UV).r;
	float row = clamp((UV.y - SKY_ROW_TOP) / SKY_ROW_SPAN, 0.0, 1.0);
	vec4 sky = mix(mix(SKY_TOP[lo], SKY_BOTTOM[lo], row), mix(SKY_TOP[hi], SKY_BOTTOM[hi], row), f);
	vec3 sky_rgb = sky.rgb / 255.0;
	float sky_mode = mix(SKY_COLOR_MODE[lo], SKY_COLOR_MODE[hi], f);
	vec3 sky_blend = mix(soft_light(rgb, sky_rgb), color_blend(rgb, sky_rgb), sky_mode);
	rgb = mix(rgb, sky_blend, pane * sky.a);

	// 4. smut: low-frequency noise, multiplied in (texture-space, so it sits on the art).
	vec2 tex_px = UV * vec2(1536.0, 1024.0);
	float smut = mix(SMUT[lo], SMUT[hi], f);
	float n_lo = texture(noise_lo, tex_px / 512.0).r;
	rgb *= 1.0 - smut * (1.0 - n_lo) * 1.6;

	// 5. grain: overlay of fine noise on the shader's own colour (no screen read), one tile of
	// 256 screen pixels, moved by grain_offset.
	float grain = mix(GRAIN[lo], GRAIN[hi], f);
	float n_hi = texture(noise_hi, FRAGCOORD.xy / 256.0 + grain_offset).r;
	rgb = mix(rgb, overlay(clamp(rgb, 0.0, 1.0), n_hi), grain);

	// 6. vignette: soot closing in from the edges (screen space, H's ellipse 1150x720 at
	// 50% 46%); violet-black from band 5.
	float late = mix(LATE[lo], LATE[hi], f);
	vec2 vig_uv = (SCREEN_UV - vec2(.50, .46)) / vec2(.599, .667);
	float shadow = smoothstep(.38, 1.0, length(vig_uv)) * tone.w;
	vec3 soot = mix(vec3(6., 5., 4.), vec3(8., 3., 12.), late) / 255.0;
	rgb = mix(rgb, soot, shadow);
	// The late layer: violet multiply in the shadows, heavier at the top and the floor.
	float y = SCREEN_UV.y;
	vec4 violet = y < .4
		? mix(vec4(40., 12., 52., .22), vec4(10., 4., 14., 0.), y / .4)
		: mix(vec4(10., 4., 14., 0.), vec4(10., 4., 14., .35), (y - .4) / .6);
	rgb *= mix(vec3(1.0), violet.rgb / 255.0, violet.a * late);

	// 7. band 6 only: fire light, a warm glow rising from the bottom edge (screen blend).
	float fire = mix(FIRE[lo], FIRE[hi], f);
	vec2 fire_uv = (SCREEN_UV - vec2(.52, 1.04)) / vec2(1100.0 / 1920.0, 360.0 / 1080.0);
	float fire_a = .26 * (1.0 - smoothstep(0.0, .70, length(fire_uv))) * fire;
	vec3 fire_rgb = vec3(221., 95., 76.) / 255.0;
	rgb = 1.0 - (1.0 - rgb) * (1.0 - fire_rgb * fire_a);

	COLOR = vec4(mix(simple_rgb, clamp(rgb, 0.0, 1.0), effects), art.a);
}

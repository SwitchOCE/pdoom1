shader_type canvas_item;
render_mode unshaded;

uniform float band : hint_range(0.0, 6.0) = 0.0;

// H 2.4 in order: brightness, saturation, contrast, vignette.
const vec4 TONE[7] = {
	vec4(.80, .70, 1.03, .18), vec4(.70, .58, 1.05, .28),
	vec4(.61, .46, 1.08, .38), vec4(.50, .38, 1.10, .46),
	vec4(.44, .32, 1.12, .54), vec4(.38, .28, 1.14, .62),
	vec4(.31, .26, 1.18, .72)
};
const vec4 GRADE[7] = {
	vec4(96., 62., 20., .10), vec4(76., 50., 24., .16),
	vec4(40., 42., 48., .26), vec4(30., 36., 52., .34),
	vec4(62., 16., 24., .40), vec4(80., 14., 24., .45),
	vec4(54., 8., 16., .55)
};
const float GRAIN[7] = { .07, .10, .14, .17, .20, .23, .26 };

float noise_hash(vec2 point) {
	vec3 spread = fract(vec3(point.xyx) * .1031);
	spread += dot(spread, spread.yzx + 33.33);
	return fract((spread.x + spread.y) * spread.z);
}

void fragment() {
	vec4 art = texture(TEXTURE, UV);
	float step = clamp(band, 0.0, 6.0);
	int lo = int(floor(step));
	int hi = min(lo + 1, 6);
	vec4 tone = mix(TONE[lo], TONE[hi], fract(step));
	vec4 grade = mix(GRADE[lo], GRADE[hi], fract(step));
	float intensity = mix(GRAIN[lo], GRAIN[hi], fract(step));

	vec3 lit = art.rgb * tone.x;
	float luma = dot(lit, vec3(.213, .715, .072));
	vec3 rgb = (mix(vec3(luma), lit, tone.y) - .5) * tone.z + .5;
	rgb = clamp(rgb, 0.0, 1.0) * mix(vec3(1.0), grade.rgb / 255.0, grade.a);

	// Screen coordinates keep the vignette and grain independent of art cropping.
	vec2 vignette_uv = (SCREEN_UV - vec2(.50, .46)) / vec2(.599, .667);
	float shadow = smoothstep(.38, 1.0, length(vignette_uv)) * tone.w;
	float grain = noise_hash(floor(FRAGCOORD.xy) + floor(TIME * 12.0) * vec2(17., 31.));
	rgb = mix(rgb, vec3(.0235, .0196, .0157), shadow);
	rgb += (grain - .5) * intensity * min(rgb, 1.0 - rgb);
	COLOR = vec4(rgb, art.a);
}

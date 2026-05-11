shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float scanline_strength = 0.065;
uniform float grille_strength = 0.025;
uniform float vignette_strength = 0.18;
uniform float noise_strength = 0.011;
uniform vec4 tint : source_color = vec4(0.92, 1.0, 0.9, 1.0);

float hash(vec2 p) {
	return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453123);
}

void fragment() {
	vec2 uv = SCREEN_UV;
	vec2 centered = uv - vec2(0.5);

	// Soft barrel distortion: enough to feel like an old monitor, not enough to hurt playability.
	vec2 curved_uv = uv + centered * dot(centered, centered) * 0.025;
	vec3 color = textureLod(screen_texture, curved_uv, 0.0).rgb;

	float scanline = sin(curved_uv.y * 980.0) * 0.5 + 0.5;
	color *= 1.0 - scanline * scanline_strength;

	float grille = step(0.5, fract(curved_uv.x * 960.0));
	color *= mix(1.0 - grille_strength, 1.0 + grille_strength, grille);

	float vignette = smoothstep(0.86, 0.24, length(centered));
	color = mix(color * tint.rgb, vec3(0.015, 0.04, 0.025), (1.0 - vignette) * vignette_strength);

	float grain = hash(floor(curved_uv * vec2(640.0, 360.0)) + floor(TIME * 24.0));
	color += (grain - 0.5) * noise_strength;

	COLOR = vec4(color, 0.52);
}

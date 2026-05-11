shader_type canvas_item;

uniform float scanline_strength = 0.055;
uniform float grille_strength = 0.018;
uniform float vignette_strength = 0.13;
uniform float noise_strength = 0.009;
uniform vec4 tint : source_color = vec4(0.45, 1.0, 0.38, 1.0);

float hash(vec2 p) {
	return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453123);
}

void fragment() {
	vec2 uv = UV;
	vec2 centered = uv - vec2(0.5);

	float scanline = sin(uv.y * 980.0) * 0.5 + 0.5;
	float grille = step(0.5, fract(uv.x * 960.0));
	float vignette = 1.0 - smoothstep(0.24, 0.86, length(centered));
	float grain = hash(floor(uv * vec2(640.0, 360.0)) + floor(TIME * 24.0));

	float alpha = scanline * scanline_strength;
	alpha += grille * grille_strength;
	alpha += vignette * vignette_strength;
	alpha += grain * noise_strength;

	vec3 color = mix(vec3(0.0, 0.025, 0.012), tint.rgb, 0.18);
	COLOR = vec4(color, alpha);
}

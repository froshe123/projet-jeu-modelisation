shader_type canvas_item;

uniform float intensite_lignes = 0.055;
uniform float intensite_grille = 0.018;
uniform float intensite_vignette = 0.13;
uniform float intensite_bruit = 0.009;
uniform vec4 teinte : source_color = vec4(0.45, 1.0, 0.38, 1.0);

float aleatoire(vec2 point) {
	return fract(sin(dot(point, vec2(12.9898, 78.233))) * 43758.5453123);
}

void fragment() {
	vec2 uv = UV;
	vec2 centre = uv - vec2(0.5);

	float ligne = sin(uv.y * 980.0) * 0.5 + 0.5;
	float grille = step(0.5, fract(uv.x * 960.0));
	float vignette = 1.0 - smoothstep(0.24, 0.86, length(centre));
	float grain = aleatoire(floor(uv * vec2(640.0, 360.0)) + floor(TIME * 24.0));

	float transparence = ligne * intensite_lignes;
	transparence += grille * intensite_grille;
	transparence += vignette * intensite_vignette;
	transparence += grain * intensite_bruit;

	vec3 couleur = mix(vec3(0.0, 0.025, 0.012), teinte.rgb, 0.18);
	COLOR = vec4(couleur, transparence);
}

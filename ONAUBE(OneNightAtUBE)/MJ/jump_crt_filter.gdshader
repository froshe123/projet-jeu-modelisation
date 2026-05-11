shader_type canvas_item;

uniform sampler2D texture_ecran : hint_screen_texture, repeat_disable, filter_nearest;
uniform float intensite_lignes = 0.065;
uniform float intensite_grille = 0.025;
uniform float intensite_vignette = 0.18;
uniform float intensite_bruit = 0.011;
uniform vec4 teinte : source_color = vec4(0.92, 1.0, 0.9, 1.0);

float aleatoire(vec2 point) {
	return fract(sin(dot(point, vec2(12.9898, 78.233))) * 43758.5453123);
}

void fragment() {
	vec2 uv = SCREEN_UV;
	vec2 centre = uv - vec2(0.5);

	// Legere deformation de l'image pour rappeler un vieux moniteur, sans gener le jeu.
	vec2 uv_courbe = uv + centre * dot(centre, centre) * 0.025;
	vec3 couleur = textureLod(texture_ecran, uv_courbe, 0.0).rgb;

	float ligne = sin(uv_courbe.y * 980.0) * 0.5 + 0.5;
	couleur *= 1.0 - ligne * intensite_lignes;

	float grille = step(0.5, fract(uv_courbe.x * 960.0));
	couleur *= mix(1.0 - intensite_grille, 1.0 + intensite_grille, grille);

	float vignette = smoothstep(0.86, 0.24, length(centre));
	couleur = mix(couleur * teinte.rgb, vec3(0.015, 0.04, 0.025), (1.0 - vignette) * intensite_vignette);

	float grain = aleatoire(floor(uv_courbe * vec2(640.0, 360.0)) + floor(TIME * 24.0));
	couleur += (grain - 0.5) * intensite_bruit;

	COLOR = vec4(couleur, 0.52);
}

shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform vec3 offsets = vec3(0.002, -0.002, 0.001);
uniform vec2 direction = vec2(0.5, -0.5);
uniform float vingette_strength = 0.98;
uniform float brighten_amount = 0.00;

void fragment() {
	// Called for every pixel the material is visible on.
	float cornerness = distance(SCREEN_UV, vec2(0.5, 0.5)) / (sqrt(2.0) / 2.0);
	float vingette = 1.0 - exp(-vingette_strength * cornerness);
	
	float r = texture(screen_texture, SCREEN_UV + direction * offsets.r).r;
	float g = texture(screen_texture, SCREEN_UV + direction * offsets.g).g;
	float b = texture(screen_texture, SCREEN_UV + direction * offsets.b).b;
	
	COLOR = vec4(vec3(r, g, b), 1.0);
	COLOR = mix(COLOR, vec4(0.0, 0.0, 0.0, 1.0), vingette);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}

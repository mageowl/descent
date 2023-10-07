shader_type canvas_item;

uniform sampler2D SCREEN : hint_screen_texture;

float check(vec2 uv) {
	return textureLod(SCREEN, uv, 0).a;
}

void fragment() {
	vec4 color = textureLod(SCREEN, SCREEN_UV, 0);
	float brightness = 0.0;
	
	brightness += check(SCREEN_UV + vec2(0.005, 0)) / 8.0;
	brightness += check(SCREEN_UV + vec2(-0.005, 0)) / 8.0;
	brightness += check(SCREEN_UV + vec2(0, 0.005)) / 8.0;
	brightness += check(SCREEN_UV + vec2(0, -0.005)) / 8.0;
	brightness += check(SCREEN_UV + vec2(0.005, 0.005)) / 9.0;
	brightness += check(SCREEN_UV + vec2(-0.005, 0.005)) / 9.0;
	brightness += check(SCREEN_UV + vec2(-0.005, 0.005)) / 9.0;
	brightness += check(SCREEN_UV + vec2(-0.005, -0.005)) / 9.0;
	
	COLOR = mix(color, vec4(1), brightness);
	COLOR.a = color.a;
}

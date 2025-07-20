shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec2 shadow_size = vec2(3);
uniform vec4 shadow_color : source_color = vec4(0, 0, 0, 0.5);

void fragment() {
	vec4 c = textureLod(screen_texture, SCREEN_UV, 0.0);
	vec4 s = textureLod(screen_texture, SCREEN_UV - shadow_size * SCREEN_PIXEL_SIZE, 0.0);

	if (c.a > 0.0001) {
		c.rgb /= c.a;
		COLOR *= c;
	} else if (s.a > 0.0001) {
		COLOR = shadow_color;
	} else COLOR = vec4(0);
}


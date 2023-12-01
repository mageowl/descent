shader_type canvas_item;

uniform bool flash = false;

void fragment() {
	vec3 color = COLOR.rgb;
	if (flash) {
		color = vec3(1, 1, 1);
	}
	COLOR = vec4(color, COLOR.a);
}

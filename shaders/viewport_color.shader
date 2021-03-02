shader_type canvas_item;

uniform vec4 base_color1 : hint_color;
uniform vec4 base_color2 : hint_color;

uniform vec4 custom_color1 : hint_color;
uniform vec4 custom_color2 : hint_color;

bool compare(vec3 color1, vec3 color2){
	return abs(distance(color1, color2)) < 0.2;
}

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	if (compare(color.rgb, base_color1.rgb)) {
		color = custom_color1;
	} else if (compare(color.rgb, base_color2.rgb)) {
		color = custom_color2;
	}
	COLOR = color;
}
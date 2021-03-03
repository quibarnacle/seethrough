shader_type canvas_item;

uniform sampler2D mask_texture;
uniform float scale : hint_range(1, 30) = 1;
uniform vec2 pivot = vec2(0.5);

void fragment() {
	COLOR = texture(TEXTURE,UV);
	COLOR.a = texture(mask_texture, (UV - pivot) / scale + pivot).r;
}
shader_type canvas_item;

uniform sampler2D mask_texture;
uniform float scale = 1;

void fragment() {
	COLOR = texture(TEXTURE,UV);
	COLOR.a = texture(mask_texture, UV).r;
}
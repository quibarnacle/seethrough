shader_type canvas_item;

uniform float scale : hint_range(1, 20) = 1;

uniform sampler2D mask_texture;
uniform vec2 pivot = vec2(0.5);

uniform sampler2D mask_texture2;
uniform vec2 pivot2 = vec2(0.5);

void fragment() {
	COLOR = texture(TEXTURE,UV);
	COLOR.a = min(
		texture(mask_texture, (UV - pivot) / scale + pivot).r,
		texture(mask_texture2, (UV - pivot2) / scale + pivot2).r
		);
}
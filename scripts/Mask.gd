extends Sprite

export var SCALE := 10
export var MEMORY := 70
export(Texture) var EMPTY_TEXTURE


var radius
var maskEdit : Image
var maskTexture : ImageTexture
var player
var previous_positions := []


func _ready():
	visible = true
	set_shader_texture(EMPTY_TEXTURE)
	maskEdit = Image.new()
	maskEdit.create(texture.get_size().x / SCALE, 
		texture.get_size().y / SCALE, 
		false, Image.FORMAT_RGBAF)
	maskEdit.fill(Color(1.0,1.0,1.0,1.0))
	maskTexture = ImageTexture.new()
	maskTexture.create_from_image(maskEdit, 0)

func set_shader_texture(new_texture : ImageTexture):
	material.set_shader_param("mask_texture", new_texture)

func reset_mask():
	previous_positions = []

func _process(delta):
	_add_position(player.position)
	maskEdit.lock()
	maskEdit.fill(Color(1.0,1.0,1.0,1.0))
	maskEdit.unlock()
	maskEdit.lock()
	for x in range(0,maskEdit.get_size().x):
		for y in range(0,maskEdit.get_size().y):
			if _check(x,y):
				maskEdit.set_pixel(
					x, y, 
					Color(0.0, 0.0, 0.0, 1.0))
	maskEdit.resize(texture.get_size().x, texture.get_size().y)
	maskEdit.unlock()
	maskTexture.set_data(maskEdit)
	set_shader_texture(maskTexture)

func _check(x : int, y : int) -> bool:
	var vec = Vector2(x, y)
	for v in previous_positions:
		if v.distance_to(vec) < radius / SCALE:
			return true
	return false

func _add_position(last_pos : Vector2):
	previous_positions.push_front(last_pos  / SCALE)
	while previous_positions.size() > MEMORY:
		previous_positions.pop_back()

extends Sprite

class_name BigPulsar

export(Texture) var texture_alt
var _texture_base : Texture
var _alt_active := false


func _ready():
	_texture_base = texture

func switch():
	_alt_active = not _alt_active
	if _alt_active:
		texture = texture_alt
	else:
		texture = _texture_base

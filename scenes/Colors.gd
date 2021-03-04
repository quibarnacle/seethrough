extends Node

var _color_catalogue = [
	[Color("caf0f8"), Color("03045e")],
	[Color("ffae85"), Color("fc766a")],
	#[Color("fcfc18e1"), Color("a418fc")],
	[Color.white, Color.black],
	[Color("2d6a4f"), Color("d8f3dc")],
	[Color("d90429"), Color("2b2d42")],
]
var _current_color_index = 0;

onready var shader_material : Material = $"../ViewportContainer".material;

func _ready():
	_set_color(_current_color_index)

func _process(delta):
	var new_index = -1
	if Input.is_action_just_pressed("color_next"):
		new_index = _current_color_index + 1
		if new_index >= len(_color_catalogue):
			new_index = 0
	elif Input.is_action_just_pressed("color_previous"):
		new_index = _current_color_index - 1
		if new_index < 0:
			new_index = len(_color_catalogue) - 1
	
	if new_index != -1:
		_set_color(new_index)

func _set_color(color_index : int):
	_current_color_index = color_index
	shader_material.set_shader_param("custom_color1", _color_catalogue[_current_color_index][0])
	shader_material.set_shader_param("custom_color2", _color_catalogue[_current_color_index][1])


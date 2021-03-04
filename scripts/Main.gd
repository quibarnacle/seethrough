extends Node2D

export var start_menu : PackedScene
export var level_a : PackedScene
export var level_b : PackedScene
export var level_c : PackedScene

var _current := 0

onready var container = $ViewportContainer/Viewport

func _ready():
	_install(start_menu)

func _install(_scene : PackedScene):
	var _instance = _scene.instance()
	_instance.connect("finished", self, "_on_Level_finished")
	container.add_child(_instance, true)

func _clean_current():
	for child in container.get_children():
		child.queue_free()

func _on_Level_finished():
	_current = _next()

func _next():
	_clean_current()
	_current += 1
	match _current:
		1:
			_install(level_a)
		2:
			_install(level_b)
		3:
			_install(level_c)
		_:
			_current = 0
			_install(start_menu)
	return _current

extends Node2D

export(Array, PackedScene) var levels

var _current := 0

onready var container = $ViewportContainer/Viewport

func _ready():
	_install(_current)

func _install(_index : int):
	var _instance = levels[_index].instance()
	_instance.connect("finished", self, "_on_Level_finished")
	container.add_child(_instance, true)

func _next():
	_clean_current()
	_current += 1
	if _current >= len(levels):
		_current = 0
	_install(_current)

func _clean_current():
	for child in container.get_children():
		child.queue_free()

func _on_Level_finished():
	_next()

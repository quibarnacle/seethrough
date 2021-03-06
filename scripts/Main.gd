extends Node2D

var _levels = []

var _current := 0

onready var container = $ViewportContainer/Viewport

func _ready():
	_find_levels()
	_install(_current)


func _find_levels():
	var _base_name = "res://scenes/levels/Level0"
	for i in range(0, 5):
		var _level = ResourceLoader.load(_base_name + str(i) + ".tscn")
		if _level != null:
			_levels.append(_level)
		var _interstice = ResourceLoader.load(_base_name + str(i) + "Interstice.tscn")
		if _interstice != null:
			_levels.append(_interstice)


func _install(_index : int):
	var _instance = _levels[_index].instance()
	_instance.connect("finished", self, "_on_Level_finished")
	container.add_child(_instance, true)


func _next():
	_clean_current()
	_current += 1
	if _current >= len(_levels):
		_current = 0
	_install(_current)


func _clean_current():
	for child in container.get_children():
		child.queue_free()


func _on_Level_finished():
	_next()

extends Node2D

export var level_a : PackedScene

onready var container = $ViewportContainer/Viewport

func _ready():
	container.add_child(level_a.instance(), true)

extends Node2D

export var level_a : PackedScene

func _ready():
	add_child(level_a.instance(), true)

extends Node2D


export var RADIUS := 20

var mask
var player
var collision_shape

var _nb_expected : int
var _nb_active := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	mask = $Mask
	player = $Player
	collision_shape = $Player/CollisionShape2D
	_set_radius(RADIUS)
	mask.player = player
	var limits = mask.texture.get_size()
	player.limits = limits
	$Player/Camera2D.limit_top=0
	$Player/Camera2D.limit_bottom = limits.y
	$Player/Camera2D.limit_left=0
	$Player/Camera2D.limit_right = limits.x
	
	_nb_expected = 0
	for child in get_children():
		if child.has_signal("pulsar_group_activated"):
			child.connect("pulsar_group_activated", self, "_on_PulsarManager_activated")
			child.connect("pulsar_group_desactivated", self, "_on_PulsarManager_desactivated")
			_nb_expected += 1

func _on_PulsarManager_activated():
	_nb_active += 1
	print(_nb_active)
	if _nb_active == _nb_expected:
		_finish()

func _on_PulsarManager_desactivated():
	_nb_active -= 1

func _finish():
	mask.visible = false
	var finishMask= $FinishMask
	finishMask.play()
	
func _set_radius(new_radius : float):
	mask.radius = new_radius
	collision_shape.shape.radius = new_radius
	player.size = Vector2(new_radius, new_radius)
	

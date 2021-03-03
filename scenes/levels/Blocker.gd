extends Node2D

export var MAX_SPEED = 100
export var ACCELERATION = 10

enum Rotation {TOP_RIGHT, BOTTOM_RIGHT, BOTTOM_LEFT, TOP_LEFT}
export(Rotation) var start_rotation := Rotation.TOP_RIGHT

var _speed := 0.0

var _rotations := {
	Rotation.TOP_RIGHT : 0.0,
	Rotation.BOTTOM_RIGHT : 90.0,
	Rotation.BOTTOM_LEFT : 180.0,
	Rotation.TOP_LEFT : 270.0,
	}

var _current_rotation

func _ready():
	_current_rotation = start_rotation
	set_rotation_degrees(_rotations[_current_rotation])

func _physics_process(delta):
	if not _is_in_position():
		var _expected_rotation = _rotations[_current_rotation]
		var _real_rotation = rotation_degrees
		if _current_rotation == Rotation.TOP_RIGHT and _real_rotation > 180.0:
			_expected_rotation += 360.0
		elif _current_rotation == Rotation.TOP_LEFT and _real_rotation < 180.0:
			_real_rotation += 360.0
		var _direction = sign(_expected_rotation - _real_rotation)
		var new_acceleration = _direction * ACCELERATION * delta
		_speed = (_direction * 
			min(abs(MAX_SPEED * delta), abs(_speed + new_acceleration))
			)
		rotate(deg2rad(_speed))
	else:
		set_rotation_degrees(_rotations[_current_rotation])
		_speed = 0

func _is_in_position() -> bool :
	var _real_rotation = rotation_degrees;
	if _real_rotation > 360.0:
		_real_rotation -= 360.0
	elif _real_rotation < 0.0:
		_real_rotation += 360.0
	return abs(_real_rotation - _rotations[_current_rotation]) < 2


func _on_ButtonClockwise_body_entered(body):
	if _is_in_position():
		_current_rotation += 1
		if _current_rotation > 3:
			_current_rotation = 0


func _on_ButtonCounterClockwise_body_entered(body):
	if _is_in_position():
		_current_rotation -= 1
		if _current_rotation < 0:
			_current_rotation = 3

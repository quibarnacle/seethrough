extends KinematicBody2D

export var MAX_SPEED = 10000
export var ACCELERATION = 1000

var speed := Vector2.ZERO
var input_movement : Vector2
var velocity : Vector2
var limits := Vector2.ZERO
var size := Vector2.ZERO


func _ready():
	velocity = Vector2.ZERO
	

func _physics_process(delta):	
	# X movement
	if input_movement.x != 0:
		var new_acceleration = input_movement.x * ACCELERATION * delta
		speed.x = (input_movement.x * 
			min(abs(MAX_SPEED * delta), abs(speed.x + new_acceleration))
			)
	else:
		speed.x = 0		
	velocity.x = speed.x
	
	# Y movement 
	if input_movement.y != 0:
		var new_acceleration = input_movement.y * ACCELERATION * delta
		speed.y = (input_movement.y * 
			min(abs(MAX_SPEED * delta), abs(speed.y + new_acceleration))
			)
	else:
		speed.y = 0
	velocity.y = speed.y
	
	move_and_slide(velocity, Vector2.UP)

	var half_width = size.x / 2.0
	var half_height = size.y / 2.0
	if position.x - half_width > limits.x:
		position.x -= limits.x
	elif position.x + half_width < 0:
		position.x += limits.x
		
	if position.y - half_height > limits.y:
		position.y -= limits.y
	elif position.y + half_height < 0:
		position.y += limits.y
		
	
func _process(delta):	
	input_movement = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		input_movement.x = 1
	elif Input.is_action_pressed("ui_left"):
		input_movement.x = -1

	if Input.is_action_pressed("ui_up"):
		input_movement.y = -1
	elif Input.is_action_pressed("ui_down"):
		input_movement.y = 1

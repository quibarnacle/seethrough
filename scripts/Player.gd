extends KinematicBody2D

export var MAX_SPEED = 10000
export var ACCELERATION = 1000
export var LOOP_XY = true

var speed := Vector2.ZERO
var input_movement : Vector2
var velocity : Vector2
var limits := Vector2.ZERO
var size := Vector2.ZERO

var _active : bool

func _ready():
	_active = false
	visible = false
	velocity = Vector2.ZERO

func start():
	visible = true
	_active = true
	$Sprite/AnimationPlayer.play("spin")

func _physics_process(delta):
	if not _active:
		return
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
	
	if velocity != Vector2.ZERO:
		move_and_slide(velocity, Vector2.UP)

	var half_width = size.x / 2.0
	var half_height = size.y / 2.0
	if LOOP_XY:
		if position.x - half_width > limits.x:
			position.x -= limits.x
		elif position.x + half_width < 0:
			position.x += limits.x	
		if position.y - half_height > limits.y:
			position.y -= limits.y
		elif position.y + half_height < 0:
			position.y += limits.y
	else:
		if position.x - half_width > limits.x:
			position.x = limits.x + half_width
		elif position.x + half_width < 0:
			position.x = limits.x - half_width	
		if position.y - half_height > limits.y:
			position.y = limits.y + half_height
		elif position.y + half_height < 0:
			position.y = limits.y - half_height
	
	if velocity.x != 0 or velocity.y != 0:
		if not $MoveAudio.playing:
			$MoveAudio.play()
	else:
		$MoveAudio.stop()
	
func _process(delta):	
	input_movement = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		input_movement.x = 1
	elif Input.is_action_pressed("move_left"):
		input_movement.x = -1

	if Input.is_action_pressed("move_up"):
		input_movement.y = -1
	elif Input.is_action_pressed("move_down"):
		input_movement.y = 1

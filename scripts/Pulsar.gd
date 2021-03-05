extends Area2D

class_name Pulsar

signal activation_requested
signal activated
signal desactivated

export var active := false setget _set_active
export var pulse_time := 5
export(AudioStream) var pickup_sound
export(Texture) var texture_active
var texture_inactive : Texture

var _group_active := false

onready var audio : = $AudioStreamPlayer2D

func _ready():
	texture_inactive = $Sprite.texture
	if pickup_sound != null:
		audio.stream = pickup_sound

func turn_on():
	if !active:
		active = true
		z_index = 2
		$AnimationPlayer.play("Pulse")
		$Sprite.texture = texture_active
		$PulseTimeout.start(pulse_time)
		$AudioStreamPlayer2D.play()
		emit_signal("activated")

func turn_off():
	if active:
		active = false
		emit_signal("desactivated")
		z_index = 0
		$PulseTimeout.stop()
		$Sprite.texture = texture_inactive

func _set_active(new_active : bool):
	if new_active == active:
		return
	if new_active:
		turn_on()
	else:
		$AnimationPlayer.play("pulse_out")
		yield($AnimationPlayer, "animation_finished")
		if !_group_active:
			turn_off()


func _on_Pulsar_body_shape_entered(body_id, body, body_shape, area_shape):
	if !active:
		emit_signal("activation_requested", self)
	
func activate():
	_set_active(true)

func _on_PulseTimeout_timeout():
	if !_group_active:
		_set_active(false)

func _on_PulsarManagar_pulsar_group_activated(type):
	_group_active = true
	$AnimationPlayer.stop(true)
	$Sprite.scale = Vector2(1,1)

func _on_PulsarManagar_pulsar_group_desactivated(type):
	_group_active = false

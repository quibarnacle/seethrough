extends Area2D

class_name Pulsar

signal activation_requested
signal activated
signal desactivated

export var active := false setget _set_active
export var pulse_time := 5

var _group_active := false

func turn_on():
	if !active:
		active = true
		z_index = 2
		$AnimationPlayer.play("Pulse")
		$PulseTimeout.start(pulse_time)
		emit_signal("activated")

func turn_off():
	if active:
		active = false
		emit_signal("desactivated")
		z_index = 0
		$PulseTimeout.stop()

func _set_active(new_active : bool):
	if new_active == active:
		return
	if new_active:
		turn_on()
	else:
		$AnimationPlayer.play_backwards("Pulse")
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

func _on_PulsarManagar_pulsar_group_desactivated(type):
	_group_active = false

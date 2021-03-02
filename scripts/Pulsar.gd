extends Area2D

signal activated
signal desactivated

export var active := false setget _set_active
export var pulse_time := 5

var _group_active := false

func _set_active(new_active : bool):
	if new_active == active:
		return
	if new_active:
		z_index = 2
		$AnimationPlayer.play("Pulse")
		$PulseTimeout.start(pulse_time)
		emit_signal("activated")
	else:
		$AnimationPlayer.play_backwards("Pulse")
		yield($AnimationPlayer, "animation_finished")
		emit_signal("desactivated")
		z_index = 0
	active = new_active


func _on_Pulsar_body_shape_entered(body_id, body, body_shape, area_shape):
	_set_active(true)

func _on_PulseTimeout_timeout():
	if !_group_active:
		_set_active(false)

func _on_PulsarManagar_pulsar_group_activated():
	_group_active = true

func _on_PulsarManagar_pulsar_group_desactivated():
	_group_active = false
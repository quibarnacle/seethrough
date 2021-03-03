extends Sprite

signal finished

func _ready():
	visible = false

func play():
	visible = true
	$AnimationPlayer.play("finish_animation")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("finished")

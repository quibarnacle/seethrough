extends Sprite

class_name LevelStart

signal finished

func start():
	$AnimationPlayer.play("fade_out")

func _on_AnimationPlayer_animation_finished(anim_name):
	visible = false
	emit_signal("finished")

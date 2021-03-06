extends Path2D

class_name LevelStart

signal finished

func start():
	$AnimationPlayer.play("follow_path")

func follower() -> Node:
	return $PathFollow2D

func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("finished")

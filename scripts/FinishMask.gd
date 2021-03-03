extends Sprite

signal finished

var title : FinishTitle

func _ready():
	visible = false
	title = get_node("FinishTitle")

func play():
	visible = true
	if title != null:
		title.display()
	$AnimationPlayer.play("finish_animation")
	yield($AnimationPlayer, "animation_finished")
	if title != null:
		title.play()
		yield(title, "finished")
	emit_signal("finished")

extends Sprite

class_name FinishTitle

signal finished

export var text_texture : Texture
export var display_time := 2.0 

func _ready():
	visible = false
	texture = text_texture

func display():
	visible = true

func play():
	var timer := $Timer
	timer.start(display_time)


func _on_Timer_timeout():
	emit_signal("finished")

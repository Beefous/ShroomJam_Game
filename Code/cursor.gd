extends AnimatedSprite2D

func _process(_delta):
	if Engine.time_scale > 0:
		global_position = get_global_mouse_position()

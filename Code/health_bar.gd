extends ProgressBar

@onready var parent = get_parent()

func _process(delta):
	max_value = parent.health_max
	value = parent.health_current
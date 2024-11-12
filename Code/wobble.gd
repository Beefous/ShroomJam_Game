extends ColorRect

func _ready():
	visible = true

func _process(_delta):
	var value = CorruptionStats.get_corruption_progress()
	material.set('shader_parameter/ghost', max(value - .2, 0))
	material.set('shader_parameter/giggle', value * 2)
	material.set('shader_parameter/amplitude', value / 5)

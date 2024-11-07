extends TextureRect

func _process(delta):
	material.set('shader_parameter/progress', CorruptionStats.get_corruption_progress())

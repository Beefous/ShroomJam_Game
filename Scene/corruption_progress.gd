extends TextureProgressBar

func _process(delta):
	max_value = CorruptionStats.enemy_threshold
	value = CorruptionStats.enemies

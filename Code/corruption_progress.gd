extends TextureProgressBar

func _process(_delta):
	max_value = CorruptionStats.enemy_threshold
	value = CorruptionStats.enemies

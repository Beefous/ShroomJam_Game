extends Node

var enemy_threshold = 3.0
var enemies = 0.0

func get_corruption_progress():
	return enemies / enemy_threshold if enemies > 0 else 0

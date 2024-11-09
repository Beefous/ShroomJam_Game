extends Node

var base_threshold = 5.0
var enemy_threshold = 5.0
var enemies = 0.0

func _ready():
	enemy_threshold = base_threshold
	enemies = 0.0

func get_corruption_progress():
	if enemies > 0:
		return enemies / enemy_threshold
	return 0

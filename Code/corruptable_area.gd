extends Area2D


func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		if body.effects_corruption:
			CorruptionStats.enemies += 1


func _on_body_exited(body):
	if body.is_in_group("Enemy"):
		if body.effects_corruption:
			CorruptionStats.enemies -= 1

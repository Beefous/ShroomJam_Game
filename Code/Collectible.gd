extends Area2D

@onready var absolute_parent = get_parent().get_node(".")

func _on_body_entered(body):
	if body.is_in_group("Player"):
		absolute_parent.Coin += 1
		#CorruptionStats.enemy_threshold += .1
		body.health_max += 1
		body.health_current = min(body.health_current + (body.health_max * .075), body.health_max)
		self.queue_free()

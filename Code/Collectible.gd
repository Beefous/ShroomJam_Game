extends Area2D

@onready var absolute_parent = get_parent().get_node(".")

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.health_max += 1
		body.health_current = min(body.health_current + 5, body.health_max)
		self.queue_free()

extends Area2D

func _ready():
	$AnimatedSprite2D.play("new_animation")

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.bits += 1
		self.queue_free()

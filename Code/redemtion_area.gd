extends Area2D


func _on_body_entered(body:Node2D):
	if body.is_in_group("Player"):
		body.is_redeeming = true


func _on_body_exited(body):
	if body.is_in_group("Player"):
		body.is_redeeming = false

extends TextureRect

@export var player: Node

func _process(delta):
	material.set('shader_parameter/progress', float(player.bits) / float(player.max_bits))

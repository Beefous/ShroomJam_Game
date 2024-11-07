extends ColorRect

func _ready():
	get_viewport().connect("size_changed", _on_size_changed)

func _on_size_changed():
	size = get_viewport().size
	position = get_viewport().size / 4

extends CanvasLayer

var debounce = false

func _ready():
	Engine.time_scale = 0

func _input(event):
	if event is InputEventMouseMotion:
		return
	if debounce:
		return
	
	debounce = true
	
	$select.play()
	hide()
	Engine.time_scale = 1

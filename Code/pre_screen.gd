extends CanvasLayer

var debounce = false

signal game_start()

func _ready():
	show()
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
	game_start.emit()

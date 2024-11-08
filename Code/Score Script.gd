extends Node2D

@onready var Background = get_node("Background")

var Score = 0
var Coin = 0
@onready var retry_label = $BlueScreen/Retry/Label
@onready var retry_label_2 = $BlueScreen/Retry/Label2

func _ready():
	#Hide Retry UI on Start
	$BlueScreen/Retry.hide()
	#Get "Respawn" mapping name
	var respawn_events = InputMap.action_get_events("Respawn")
	var respawn_event = respawn_events[0]
	var button_name = OS.get_keycode_string(respawn_event.physical_keycode)
	#Update Label to use mapping name
	retry_label.text = "Press " + button_name + " to retry"

func _process(_delta):
	# This can always be changed.
	retry_label_2.text = "Error: " + str(Score) + "Virus : " + str(Coin) + "RAM"

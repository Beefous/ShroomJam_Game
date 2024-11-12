extends Node

@onready var audio_stream_player = $AudioStreamPlayer
@onready var audio_stream_player_2 = $AudioStreamPlayer2
@onready var audio_stream_player_3 = $AudioStreamPlayer3
@onready var audio_stream_player_4 = $AudioStreamPlayer4
@onready var audio_stream_player_intro = $AudioStreamPlayerIntro

var active: AudioStreamPlayer
var last_active: AudioStreamPlayer

func _ready():
	audio_stream_player_intro.play()
	
	await $"../pre-screen".game_start
	
	audio_stream_player_intro.stop()
	audio_stream_player.play()
	last_active = audio_stream_player

func _process(delta):
	check_corruption()
	
	await $"../pre-screen".game_start
	
	if active != last_active:
		active.play(last_active.get_playback_position() + AudioServer.get_time_since_last_mix())
		last_active.stop()
	
	last_active = active

func check_corruption():
	var prog = CorruptionStats.get_corruption_progress()
	if prog >= 0 and prog < .25:
		active = audio_stream_player
		return
	if prog >= .25 and prog < .5:
		active = audio_stream_player_2
		return
	if prog >= .5 and prog < .75:
		active = audio_stream_player_3
		return
	if prog >= .75:
		active = audio_stream_player_4
		return

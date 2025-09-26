extends Node

@onready var player = AudioStreamPlayer.new()

var musicLevel = 100
var sfxLevel = 100

func _ready():
	add_child(player)

var sound = load("res://sfx/click.wav")
func click():
	player.stream = sound
	player.volume_db = getSFXLevel()
	player.play()

func getSFXLevel():
	sfxLevel = clamp(sfxLevel, 0, 100)
	if sfxLevel == 0:
		return -80
	else:
		return linear_to_db(sfxLevel / 100.0)

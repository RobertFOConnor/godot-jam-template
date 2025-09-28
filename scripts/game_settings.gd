extends Node

@onready var player = AudioStreamPlayer.new()

var musicLevel = 100
var sfxLevel = 100
var showSubtitles = true

func _ready():
	add_child(player)

var sound = load("res://sound/sfx/click.wav")
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

func _process(delta):
	var window = get_window()
	if Input.is_key_pressed(Key.KEY_ALT) && Input.is_action_just_pressed("submit"):
		var current_mode = DisplayServer.window_get_mode()
		if current_mode != DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)

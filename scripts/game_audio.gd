extends Node2D

@onready var music_player: AudioStreamPlayer2D = $MusicAudioStreamPlayer2D

func changeMusicLevel(value):
	value = clamp(value, 0, 100)
	if value == 0:
		music_player.volume_db = -80
	else:
		music_player.volume_db = linear_to_db(value / 100.0)

func _on_ready() -> void:
	changeMusicLevel(GameSettings.musicLevel)
	for emitter in get_tree().get_nodes_in_group("music_emitters"):
		emitter.connect("music_level_change", Callable(self, "changeMusicLevel"))

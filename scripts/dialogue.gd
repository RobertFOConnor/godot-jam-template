extends Node

@onready var subtitle_label: RichTextLabel = $subtitle
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

var subtitles = []  # Array of {time: float, text: String}
var current_index = 0

func _ready():
	load_subtitles("res://sound/voice/test.txt")
	audio_player.play()

func load_subtitles(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	while not file.eof_reached():
		var line = file.get_line().strip_edges()
		if line == "":
			continue
		var parts = line.split("\t")
		if parts.size() >= 3:
			var start_time = parts[0].to_float()
			var text = parts[2]
			subtitles.append({ "time": start_time, "text": text })
	file.close()

func _process(_delta):
	if audio_player.playing and current_index < subtitles.size():
		var t = audio_player.get_playback_position()
		var next_sub = subtitles[current_index]
		if t >= next_sub["time"]:
			subtitle_label.text = next_sub["text"]
			current_index += 1
			
	if !audio_player.playing:
		subtitle_label.text = ""

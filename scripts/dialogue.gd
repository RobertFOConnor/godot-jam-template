extends Node

@onready var subtitle_label: RichTextLabel = $subtitle
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

var subtitles = []  # Array of {time: float, text: String}
var current_index = 0

func _ready():
	playVoiceLine("test")

func playVoiceLine(fileName):
	audio_player.stream = load("res://sound/voice/"+fileName+".ogg")
	audio_player.play()
	if GameSettings.showSubtitles:
		load_subtitles("res://sound/voice/"+fileName+".txt")

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
	if GameManager.isPaused:
		audio_player.stream_paused = true
	
	if audio_player.stream_paused && !GameManager.isPaused:
		audio_player.stream_paused = false
	
	if !GameSettings.showSubtitles: 
		subtitle_label.text = ""
		return

	if audio_player.playing and current_index < subtitles.size():
		var t = audio_player.get_playback_position()
		var next_sub = subtitles[current_index]
		if t >= next_sub["time"]:
			subtitle_label.text = next_sub["text"]
			current_index += 1
			
	if !audio_player.playing && !audio_player.stream_paused:
		subtitle_label.text = ""

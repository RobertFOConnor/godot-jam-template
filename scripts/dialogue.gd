extends Node

@onready var subtitle_label: RichTextLabel = $subtitle
@onready var audio_player: AudioStreamPlayer2D = $"../Audio/VoiceAudioStreamPlayer2D"

var subtitles = []  # Array of {time: float, text: String}
var subtitle_timers: Array = []  # Keep track to clear them if needed

func _ready():
	playVoiceLine("test")

func playVoiceLine(fileName):
	# Stop previous audio & timers
	audio_player.stop()
	_clear_subtitle_timers()
	subtitles.clear()

	# Load audio
	audio_player.stream = load("res://sound/voice/"+fileName+".ogg")
	audio_player.play()

	# Load subtitles
	if GameSettings.showSubtitles:
		load_subtitles("res://sound/voice/"+fileName+".txt")
		_schedule_subtitles()

func load_subtitles(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Failed to open subtitle file: %s" % path)
		return

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

func _schedule_subtitles():
	for sub in subtitles:
		var t = Timer.new()
		# Ensure wait_time > 0
		t.wait_time = max(sub["time"], 0.001)  # 1ms minimum
		t.one_shot = true
		add_child(t)
		t.timeout.connect(Callable(self, "_show_subtitle").bind(sub["text"]))
		t.start()
		subtitle_timers.append(t)

	# Schedule clearing subtitles when audio ends
	var clear_timer = Timer.new()
	clear_timer.wait_time = max(audio_player.stream.get_length(), 0.001)
	clear_timer.one_shot = true
	add_child(clear_timer)
	clear_timer.timeout.connect(Callable(self, "_clear_subtitle"))
	clear_timer.start()
	subtitle_timers.append(clear_timer)


func _show_subtitle(text: String):
	subtitle_label.text = text

func _clear_subtitle():
	subtitle_label.text = ""
	_clear_subtitle_timers()

func _clear_subtitle_timers():
	for t in subtitle_timers:
		if is_instance_valid(t):
			t.queue_free()
	subtitle_timers.clear()

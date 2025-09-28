extends Node2D

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var control_menu: VBoxContainer = $CanvasLayer/Panel/control_menu
@onready var sound_menu: VBoxContainer = $CanvasLayer/Panel/sound_menu
@onready var display_menu: VBoxContainer = $CanvasLayer/Panel/display_menu
@onready var language_menu: VBoxContainer = $CanvasLayer/Panel/language_menu
@onready var controls: Button = $CanvasLayer/Panel/top_tabs/controls
@onready var fullscreen_label: RichTextLabel = $CanvasLayer/Panel/display_menu/HBoxContainer2/fullscreen_label
@onready var vsync_label: RichTextLabel = $CanvasLayer/Panel/display_menu/HBoxContainer3/vsync_label

# Audio Settings
@onready var music: HSlider = $CanvasLayer/Panel/sound_menu/VBoxContainer/music
@onready var sfx: HSlider = $CanvasLayer/Panel/sound_menu/VBoxContainer2/sfx
@onready var subtitles_label: RichTextLabel = $CanvasLayer/Panel/sound_menu/HBoxContainer/subtitles_label


signal music_level_change(value)

var inGame = false

func _on_ready() -> void:
	var window = get_window()
	fullscreen_label.text = "OFF" if window.mode != Window.MODE_FULLSCREEN else "ON"
	controls.grab_focus()
	add_to_group("music_emitters")
	
	music.value = GameSettings.musicLevel
	sfx.value = GameSettings.sfxLevel
	
	subtitles_label.text = "ON" if GameSettings.showSubtitles else "OFF"
	
	var vsync_mode = DisplayServer.window_get_vsync_mode()
	if vsync_mode == DisplayServer.VSYNC_ENABLED:
		vsync_label.text = "ON"
	else:
		vsync_label.text = "OFF"

func _input(event):
	if event.is_action_pressed("menu_back") && !inGame:
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_controls_pressed() -> void:
	showMenu(control_menu)

func _on_sound_pressed() -> void:
	showMenu(sound_menu)

func _on_display_pressed() -> void:
	showMenu(display_menu)

func _on_language_pressed() -> void:
	showMenu(language_menu)

func showMenu(menu):
	control_menu.visible = false
	sound_menu.visible = false
	display_menu.visible = false
	language_menu.visible = false
	menu.visible = true

func _on_fullscreen_pressed() -> void:
	var window = get_window()
	window.mode = Window.MODE_FULLSCREEN if window.mode != Window.MODE_FULLSCREEN else Window.MODE_WINDOWED
	fullscreen_label.text = "OFF" if window.mode != Window.MODE_FULLSCREEN else "ON"

func hideSettings():
	inGame = true
	canvas_layer.visible = false
	
func showSettings():
	canvas_layer.visible = true
	controls.grab_focus()
	
var res_index := 0

func cycle_resolution():
	var resolutions = [
		Vector2i(1280, 720),   # 720p
		Vector2i(1600, 900),   # HD+
		Vector2i(1920, 1080),  # 1080p
		Vector2i(2560, 1440),  # 1440p
		Vector2i(3840, 2160)   # 4K
	]
	res_index = (res_index + 1) % resolutions.size()
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_size(resolutions[res_index])

func _on_resolution_pressed() -> void:
	cycle_resolution()

func _on_music_value_changed(value: float) -> void:
	emit_signal("music_level_change", value)
	GameSettings.musicLevel = value
	GameSettings.click()

func _on_sfx_value_changed(value: float) -> void:
	GameSettings.sfxLevel = value
	GameSettings.click()

func toggle_vsync(enable: bool):
	if !enable:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)

func _on_vsync_pressed() -> void:
	updateVsyncLabel()

func updateVsyncLabel():
	var vsync_mode = DisplayServer.window_get_vsync_mode()
	if vsync_mode == DisplayServer.VSYNC_ENABLED:
		vsync_label.text = "OFF"
		toggle_vsync(false)
	else:
		vsync_label.text = "ON"
		toggle_vsync(true)

func _on_subtitles_pressed() -> void:
	GameSettings.showSubtitles = !GameSettings.showSubtitles
	subtitles_label.text = "ON" if GameSettings.showSubtitles else "OFF"

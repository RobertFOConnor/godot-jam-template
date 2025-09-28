extends CanvasLayer

@onready var panel: Panel = $Panel
@onready var resume: Button = $Panel/VBoxContainer/resume
@onready var settings: Button = $Panel/VBoxContainer/settings

@onready var settingsUI: Node2D = $settings

var showingSettings = false

func _input(event):
	
	if event.is_action_pressed("pause"):
		
		if showingSettings:
			showingSettings = false
			panel.visible = true
			settingsUI.hideSettings()
			settings.grab_focus()
			return
		
		panel.visible = !panel.visible
		if(panel.visible):
			GameManager.isPaused = true
			resume.grab_focus()
		else:
			GameManager.isPaused = false
			settingsUI.hideSettings()
			
		Engine.time_scale = 0.0 if panel.visible else 1.0



func _on_resume_pressed() -> void:
	resume.release_focus()
	Engine.time_scale = 1.0
	panel.visible = false
	GameManager.isPaused = false


func _on_settings_pressed() -> void:
	showingSettings = true
	settingsUI.showSettings()
	panel.visible = false


func _on_exittomenu_pressed() -> void:
	changeScene("main_menu")
	GameManager.isPaused = false


func _on_exitgame_pressed() -> void:
	get_tree().quit()
	GameManager.isPaused = false
	
func changeScene(name):
	Engine.time_scale = 1.0
	get_tree().change_scene_to_file("res://scenes/"+name+".tscn")


func _on_ready() -> void:
	settingsUI.hideSettings()


func _on_restart_pressed() -> void:
	changeScene("game")
	GameManager.isPaused = false

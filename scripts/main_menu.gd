extends Node2D

@onready var start: Button = $CanvasLayer/VBoxContainer/start

func _on_ready() -> void:
	start.grab_focus()

func _on_start_pressed() -> void:
	changeScene("game")

func _on_settings_pressed() -> void:
	changeScene("settings")

func _on_credits_pressed() -> void:
	changeScene("credits")

func _on_exit_pressed() -> void:
	get_tree().quit()

func changeScene(name):
	get_tree().change_scene_to_file("res://scenes/"+name+".tscn")

func _on_start_focus_exited() -> void:
	GameSettings.click()

func _on_settings_focus_exited() -> void:
	GameSettings.click()

func _on_credits_focus_exited() -> void:
	GameSettings.click()
	
func _on_exit_focus_exited() -> void:
	GameSettings.click()

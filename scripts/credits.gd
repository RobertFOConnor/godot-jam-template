extends Node2D

func _input(event):
	if event.is_action_pressed("menu_back"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

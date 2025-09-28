extends Node3D

var isPaused = false

func _ready():
	_add_players(self)

func _add_players(node: Node):
	if node is AudioStreamPlayer or node is AudioStreamPlayer2D or node is AudioStreamPlayer3D:
		node.add_to_group("audio_players")
	for child in node.get_children():
		_add_players(child)
		
func pauseGame():
	isPaused = true
	for n in get_tree().get_nodes_in_group("audio_players"):
		n.stream_paused = true

func unpauseGame():
	isPaused = false
	for n in get_tree().get_nodes_in_group("audio_players"):
		n.stream_paused = false

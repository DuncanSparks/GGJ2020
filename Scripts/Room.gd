extends Node2D

signal room_is_cleared
signal fountains_cleared

func _ready():
	if filename in Controller.rooms_cleared:
		emit_signal("room_is_cleared")
	if Controller.fountains_purified.size() >= 5:
		emit_signal("fountains_cleared")
		
	if filename == "res://Scenes/Castle/Castle_1.tscn":
		Controller.stop_music()
	
	if filename == "res://Scenes/Overworld/Overworld_4.tscn" and not Controller.music_is_playing():
		Controller.play_music()


func clear_room():
	var cleared := true
	for node in get_tree().get_nodes_in_group('Enemy'):
		if not node.healed:
			cleared = false
	if cleared:
		Controller.rooms_cleared.push_back(filename)
		if filename != "res://Scenes/Overworld/Overworld_1.tscn":
			emit_signal("room_is_cleared")

extends Node2D

signal room_is_cleared

func _ready():
	if filename in Controller.rooms_cleared:
		emit_signal("room_is_cleared")


func clear_room():
	var cleared := true
	for node in get_tree().get_nodes_in_group('Enemy'):
		if not node.healed:
			cleared = false
	if cleared:
		Controller.rooms_cleared.push_back(filename)
		emit_signal("room_is_cleared")

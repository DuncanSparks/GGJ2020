extends Node2D

signal room_is_cleared

func _ready():
	if filename in Controller.rooms_cleared:
		emit_signal("room_is_cleared")


func clear_room():
	Controller.rooms_cleared.push_back(filename)

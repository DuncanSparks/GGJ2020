extends Node2D

func _ready():
	Player.hide()
	Player.set_lock_movement(true)
	Controller.show_ui(false)

func start():
	get_tree().change_scene("res://Scenes/Title.tscn")

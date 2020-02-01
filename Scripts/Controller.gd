extends Node

var current_enemy_requirement: int = -1
var current_enemies_healed: int = 0

func _ready():
	OS.center_window()


func set_current_enemy_requirement(value: int):
	current_enemy_requirement = value
	
	
func add_enemy_healed():
	current_enemies_healed += 1

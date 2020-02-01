extends Node

var current_enemy_requirement: int = -1
var num_enemies_healed: int = 0

var rooms_cleared := []
var enemies_healed := {}


func _ready():
	OS.center_window()


func set_current_enemy_requirement(value: int):
	current_enemy_requirement = value
	
	
func add_enemy_healed():
	num_enemies_healed += 1


func after_load():
	$TimerWait.set_wait_time(0.2)
	$TimerWait.start()
	yield($TimerWait, "timeout")
	Player.set_loading(false)

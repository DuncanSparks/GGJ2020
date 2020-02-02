extends Node

var current_enemy_requirement: int = -1
var num_enemies_healed: int = 0

var rooms_cleared := []
var enemies_healed := {}

onready var text_healed := $CanvasLayer/Label as Label
onready var healthbar := $CanvasLayer/Health as ProgressBar


func _ready():
	OS.center_window()


func _process(delta):
	text_healed.set_text("Healed: %d" % num_enemies_healed)
	healthbar.set_value(Player.get_health())
	
	if Input.is_action_just_pressed("sys_fullscreen"):
		OS.set_window_fullscreen(not OS.is_window_fullscreen())


func set_current_enemy_requirement(value: int):
	current_enemy_requirement = value
	
	
func add_enemy_healed():
	num_enemies_healed += 1
	
	
func show_ui(show: bool):
	for child in $CanvasLayer.get_children():
		child.set_visible(show)


func after_load():
	$TimerWait.set_wait_time(0.2)
	$TimerWait.start()
	yield($TimerWait, "timeout")
	Player.set_loading(false)

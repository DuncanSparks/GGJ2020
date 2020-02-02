extends Node

var current_enemy_requirement: int = -1
var num_enemies_healed: int = 0

var rooms_cleared := []
var enemies_healed := {}
var health_collected := {}

var speedrun_timer := false
var timer: float = 0

onready var text_healed := $CanvasLayer/Label as Label
onready var healthbar := $CanvasLayer/Health as TextureProgress
onready var timer_text := $CanvasLayer2/Timer as Label


func _ready():
	OS.center_window()


func _process(delta):
	if speedrun_timer:
		timer += delta
	
	timer_text.set_text(str(floor(timer / 60)).pad_zeros(2) + ":" + str(stepify(timer, 0.001)).pad_zeros(2))
	
	text_healed.set_text("Healed: %d" % num_enemies_healed)
	healthbar.set_value(Player.get_health())
	
	if Input.is_action_just_pressed("sys_fullscreen"):
		OS.set_window_fullscreen(not OS.is_window_fullscreen())


func set_current_enemy_requirement(value: int):
	current_enemy_requirement = value
	
	
func set_speedrun_timer(value: bool):
	speedrun_timer = value
	
	
func reset():
	rooms_cleared.clear()
	enemies_healed.clear()
	health_collected.clear()
	num_enemies_healed = 0
	timer = 0
	
	
func add_enemy_healed():
	num_enemies_healed += 1
	
	
func show_ui(show: bool):
	for child in $CanvasLayer.get_children():
		child.set_visible(show)
	if speedrun_timer:
		for child in $CanvasLayer2.get_children():
			child.set_visible(show)
		
		
func play_music():
	$MusicDistorted.play()


func stop_music():
	$MusicDistorted.stop()


func after_load():
	$TimerWait.set_wait_time(0.2)
	$TimerWait.start()
	yield($TimerWait, "timeout")
	Player.set_loading(false)

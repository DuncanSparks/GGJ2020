extends Node

var current_enemy_requirement: int = -1
var num_enemies_healed: int = 0

var rooms_cleared := []
var enemies_healed := {}
var health_collected := {}
var fountains_purified := {}

var speedrun_timer := false
var timer: float = 0

var quit := false

const sound_oneshot_ref := preload("res://Prefabs/SoundOneShot.tscn")

onready var text_healed := $CanvasLayer/Label as Label
onready var healthbar := $CanvasLayer/Health as TextureProgress
onready var timer_text := $CanvasLayer2/Timer as Label


func _ready():
	randomize()
	OS.center_window()
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _process(delta):
	if speedrun_timer:
		timer += delta
	
	timer_text.set_text(str(floor(timer / 60)).pad_zeros(2) + ":" + str(stepify(timer, 0.001)).pad_zeros(2))
	
	text_healed.set_text("Healed: %d" % num_enemies_healed)
	healthbar.set_value(Player.get_health())
	
	if Input.is_action_just_pressed("sys_fullscreen"):
		OS.set_window_fullscreen(not OS.is_window_fullscreen())
		
	if Input.is_action_just_pressed("sys_quit"):
		if not quit:
			quit = true
			$CanvasLayer3/Label.show()
			$TimerQuit.start()
		else:
			get_tree().quit()
		
	#if Input.is_action_just_pressed("debug"):
	#	for i in range(5):
	#		fountains_purified[str(i)] = true


func set_current_enemy_requirement(value: int):
	current_enemy_requirement = value
	
	
func set_speedrun_timer(value: bool):
	speedrun_timer = value
	
	
func reset():
	rooms_cleared.clear()
	enemies_healed.clear()
	health_collected.clear()
	fountains_purified.clear()
	num_enemies_healed = 0
	timer = 0
	
	
func add_enemy_healed():
	num_enemies_healed += 1
	
	
func stop_timer():
	speedrun_timer = false
	
	
func show_ui(show: bool):
	for child in $CanvasLayer.get_children():
		child.set_visible(show)
	if speedrun_timer:
		for child in $CanvasLayer2.get_children():
			child.set_visible(show)
		
		
func play_music():
	$MusicDistorted.play()
	
	
func music_is_playing() -> bool:
	return $MusicDistorted.is_playing()


func stop_music():
	$MusicDistorted.stop()
	
	
func play_sound_oneshot(sound: AudioStream, volume: int = 0):
	var sb := sound_oneshot_ref.instance() as AudioStreamPlayer
	sb.set_stream(sound)
	sb.set_volume_db(volume)
	get_tree().get_root().add_child(sb)
	sb.play()


func after_load():
	$TimerWait.set_wait_time(0.2)
	$TimerWait.start()
	yield($TimerWait, "timeout")
	Player.set_loading(false)


func _on_TimerQuit_timeout():
	quit = false
	$CanvasLayer3/Label.hide()

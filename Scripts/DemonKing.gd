extends KinematicBody2D

export(AudioStream) var sound_bullet
export(AudioStream) var sound_healed
export(AudioStream) var sound_teleport

var health: int = 24
var phase: int = 0

const bullet_ref := preload("res://Prefabs/Bullet.tscn")

const parts_healed := preload("res://Prefabs/Particles/PartsHealed.tscn")
const parts_teleport := preload("res://Prefabs/Particles/PartsTeleport.tscn")

onready var timer_teleport := $TimerTeleport as Timer
onready var timer_teleport2 := $TimerTeleport2 as Timer
onready var timer_attack := $TimerAttack as Timer

func _ready():
	timer_attack.set_wait_time(rand_range(2.5, 4))
	timer_attack.start()
	
	
func _process(delta):
	set_z_index(int(get_position().y))
	
	
func hit():
	Controller.play_sound_oneshot(sound_healed, 6)
	var parts := parts_healed.instance()
	parts.set_position(get_position())
	get_tree().get_current_scene().add_child(parts)
	parts.set_emitting(true)
	health -= 1
	if health <= 0:
		print("YOU WON")
		
		
func is_healed():
	return false
	
	
func attack():
	#var num: int = int(round(rand_range(0, 2) if phase == 0 else rand_range(0, 3) if phase == 1 else rand_range(0, 4)))
	var num := 0
	match num:
		0: # Bullets
			for i in range(3):
				Controller.play_sound_oneshot(sound_bullet, 6)
				var bullet := bullet_ref.instance()
				bullet.set_position(get_position())
				bullet.set_global_rotation(get_angle_to(Player.position))
				get_tree().get_current_scene().add_child(bullet)
				
				var timer := Timer.new()
				timer.set_wait_time(rand_range(0.5, 1))
				timer.set_autostart(true)
				timer.connect("timeout", timer, "queue_free")
				get_tree().get_root().call_deferred("add_child", timer)
				yield(timer, "timeout")
		1:
			pass
		2:
			pass
		3:
			pass
		4:
			pass
			
	timer_teleport.set_wait_time(rand_range(0.5, 1))
	timer_teleport.start()


func tele_out():
	Controller.play_sound_oneshot(sound_teleport, 8)
	var parts := parts_teleport.instance()
	parts.set_position(get_position())
	get_tree().get_current_scene().add_child(parts)
	parts.set_emitting(true)
	$Sprite.hide()
	$CollisionShape2D.set_disabled(true)
	timer_teleport2.set_wait_time(rand_range(1, 2))
	timer_teleport2.start()


func tele_in():
	Controller.play_sound_oneshot(sound_teleport, 8)
	set_position(Vector2(rand_range(52, 268), rand_range(52, 140)))
	var parts := parts_teleport.instance()
	parts.set_position(get_position())
	get_tree().get_current_scene().add_child(parts)
	parts.set_emitting(true)
	$Sprite.show()
	$CollisionShape2D.set_disabled(false)
	timer_attack.set_wait_time(rand_range(0.5, 1))
	timer_attack.start()
	

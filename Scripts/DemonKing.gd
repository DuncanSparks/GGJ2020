extends KinematicBody2D

export(AudioStream) var sound_bullet
export(AudioStream) var sound_healed
export(AudioStream) var sound_teleport
export(AudioStream) var sound_kick
export(AudioStream) var sound_heal

var health: int = 15
var healed := false

var enemies := []

export(NodePath) var navigator

const bullet_ref := preload("res://Prefabs/Bullet.tscn")
const obstacle_ref := preload("res://Prefabs/Obstacle.tscn")
const enemy_ref := preload("res://Prefabs/Enemy.tscn")
const ball_ref := preload("res://Prefabs/BossBullet.tscn")

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
		Controller.play_sound_oneshot(sound_healed, 8)
		Controller.stop_timer()
		Player.invincible = true
		Player.set_lock_movement(true)
		$Sprite.play("healed")
		get_tree().get_current_scene().get_node("MusicBoss").stop()
		timer_attack.stop()
		timer_teleport.stop()
		timer_teleport2.stop()
		healed = true
		#for enemy in enemies:
		#	if enemy != null:
		#		enemy.heal()
		get_tree().get_current_scene().get_node("AnimationPlayer").play("Fade")
		get_tree().get_current_scene().get_node("TimerEnd1").start()
		get_tree().get_current_scene().get_node("TimerEnd2").start()
		
		
func is_healed():
	return healed
	
	
func attack():
	var num: int = int(round(rand_range(0, 4)))
	if num == 0 or num == 3: # Bullets
		for i in range(5):
			Controller.play_sound_oneshot(sound_bullet, 6)
			var bullet := bullet_ref.instance()
			bullet.set_position(get_position())
			bullet.set_global_rotation(get_angle_to(Player.position))
			get_tree().get_current_scene().add_child(bullet)
			
			yield(wait(rand_range(0.35, 0.55)), "timeout")
	elif num == 1: # Spawn enemies
		Controller.play_sound_oneshot(sound_teleport, 4)
		for i in range(int(round(rand_range(1, 2)))):
			var pos := Vector2(rand_range(30, 290), rand_range(30, 150))
			
			var parts := parts_teleport.instance()
			parts.set_position(pos)
			parts.set_emitting(true)
			get_tree().get_current_scene().add_child(parts)
			
			var enemy := enemy_ref.instance()
			enemy.set_position(pos)
			#enemy.disappear = true
			enemy.speed = rand_range(40, 60)
			enemy.navigator = navigator
			get_tree().get_current_scene().add_child(enemy)
			enemies.push_back(enemy)
	else: # Evil orb
		Controller.play_sound_oneshot(sound_kick)
		var inst := ball_ref.instance()
		inst.set_position(get_position())
		inst.set_global_rotation(get_position().direction_to(Player.get_position()).angle())
		get_tree().get_current_scene().add_child(inst)
			
	timer_teleport.set_wait_time(rand_range(0.5, 1))
	timer_teleport.start()
	
	
func wait(time: float) -> Timer:
	var timer := Timer.new()
	timer.set_wait_time(time)
	timer.set_autostart(true)
	timer.connect("timeout", timer, "queue_free")
	get_tree().get_root().call_deferred("add_child", timer)
	return timer


func tele_out():
	Controller.play_sound_oneshot(sound_teleport, 4)
	var parts := parts_teleport.instance()
	parts.set_position(get_position())
	get_tree().get_current_scene().add_child(parts)
	parts.set_emitting(true)
	$Sprite.hide()
	$CollisionShape2D.set_disabled(true)
	timer_teleport2.set_wait_time(rand_range(1, 2))
	timer_teleport2.start()


func tele_in():
	Controller.play_sound_oneshot(sound_teleport, 4)
	set_position(Vector2(rand_range(52, 268), rand_range(52, 140)))
	var parts := parts_teleport.instance()
	parts.set_position(get_position())
	get_tree().get_current_scene().add_child(parts)
	parts.set_emitting(true)
	$Sprite.show()
	$CollisionShape2D.set_disabled(false)
	timer_attack.set_wait_time(rand_range(0.5, 1))
	timer_attack.start()
	
func end_game():
	get_tree().quit()

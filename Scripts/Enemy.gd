extends KinematicBody2D

signal healed

export(float) var speed := 25.0

var velocity := Vector2.ZERO

enum Direction {Up, Down, Left, Right}
var face: int = Direction.Up
var walking := false

export(int) var health := 2

var healed := false
var in_area := false

export(bool) var follow := true
export(bool) var shoot := true
#export(bool) var bullet_goes_through_walls := false
export(bool) var fast_fire := false
export(NodePath) var navigator = null

export(bool) var ground_attack := false

var nav_path: PoolVector2Array = []

export(String, MULTILINE) var healed_text

const bullet_ref := preload("res://Prefabs/Bullet.tscn")

onready var timer := $Timer as Timer
onready var timer_gt := $TimerGroundAttack as Timer
onready var spr := $Sprite as AnimatedSprite
onready var text := $Text as RichTextLabel
onready var timer_shoot := $TimerShoot as Timer
var nav_node: Navigation2D = null

#onready var Player = get_tree().get_current_scene().get_node("Player")

# ======================================================

func _ready():
	if navigator != null:
		nav_node = get_node(navigator) as Navigation2D
		
	face = Direction.Down
	
	timer.set_wait_time(rand_range(2, 4))
	set_text(healed_text)
	if shoot:
		timer_shoot.set_wait_time(rand_range(0.8, 1.5) if fast_fire else rand_range(1.5, 3))
		timer_shoot.start()
	
	var id: String = get_tree().get_current_scene().filename + "--" + get_path()
	if id in Controller.enemies_healed:
		heal(true)
		set_position(Controller.enemies_healed[id])
		
	if follow:
		nav_path = nav_node.get_simple_path(get_global_position(), Player.get_global_position(), false)
		$TimerNav.start()
	
	
func _process(delta):
	set_z_index(int(get_position().y))
	
	if in_area:
		text.visible_characters += 1
	
	if follow and not healed:
#		if Player.position.x < position.x:
#			velocity.x = -1
#			face = Direction.Left
#		else:
#			velocity.x = 1
#			face = Direction.Right
#
#		if Player.position.y < position.y:
#			velocity.y = -1
#			#face = Direction.Up
#		else:
#			velocity.y = 1
#			#face = Direction.Down

		
		move_along_path(speed * delta)
		
#		nav_path = nav_node.get_simple_path(get_global_position() + Vector2(0, 4), Player.get_global_position(), false)
#		var angle = get_angle_to(nav_path[1])
#		#var angle = get_angle_to(nav_node.get_closest_point(Player.get_global_position()))
#		velocity = Vector2(cos(angle), sin(angle))
		
			
		walking = velocity != Vector2.ZERO
		
	if not healed:
		direction_management()
		sprite_management()
	
	if healed:
		velocity = Vector2.ZERO
		spr.play("healed")

	if follow and nav_node != null:
		print()


func _physics_process(delta):
	move_and_slide(velocity * speed)
	
# ======================================================
	
func hit():
	$SoundHit.play()
	$PartsHealed.set_emitting(true)
	health -= 1
	if health <= 0:
		heal()
		
		
func move_along_path(distance: float):
	var start_point := get_global_position()
	for i in range(nav_path.size()):
		var dist := start_point.distance_to(nav_path[0])
		if distance <= dist and dist >= 0:
			var angle = get_angle_to(nav_path[0])
			velocity = Vector2(cos(angle), sin(angle))
			break
		distance -= dist
		start_point = nav_path[0]
		nav_path.remove(0)


func heal(room_start: bool = false):
	$PartsDust.set_emitting(false)
	healed = true
	set_collision_mask_bit(4, false)
	$CollisionShape2D.call_deferred("set_disabled", true)
	if not room_start:
		$SoundHeal.play()
		Controller.add_enemy_healed()
		Controller.enemies_healed[get_tree().get_current_scene().filename + "--" + get_path()] = get_position()
		emit_signal("healed")


func is_healed() -> bool:
	return healed
	
	
func set_text(value: String):
	$Text.set_bbcode("[wave amp=30 freq=4][center]" + value)

# ======================================================

func direction_management():
	var prev_face := face
	
	if velocity.x == 0:
		match velocity.y:
			-1.0:
				face = Direction.Up
			1.0:
				face = Direction.Down
	elif velocity.y == 0:
		match velocity.x:
			-1.0:
				face = Direction.Left
			1.0:
				face = Direction.Right
				
				
func sprite_management():
	var anim: String
	match face:
		Direction.Up:
			anim = "up"
		Direction.Down:
			anim = "down"
		Direction.Left:
			anim = "left"
		Direction.Right:
			anim = "right"
			
	if walking:
		anim += "_walk"
		
	spr.play(anim)



func _on_AreaText_body_entered(body):
	if body.is_in_group("Player") and healed:
		in_area = true
		text.set_visible_characters(0)
		text.show()


func _on_AreaText_body_exited(body):
	if body.is_in_group("Player"):
		in_area = false
		text.hide()


func _on_TimerShoot_timeout():
	if not healed:
		$SoundShoot.play()
		var bullet := bullet_ref.instance()
		bullet.set_position(get_position())
		bullet.set_global_rotation(get_angle_to(Player.position))
		get_tree().get_current_scene().add_child(bullet)
		timer_shoot.set_wait_time(rand_range(0.8, 1.5) if fast_fire else rand_range(1.5, 3))


func _on_TimerNav_timeout():
	nav_path = nav_node.get_simple_path(get_global_position(), Player.get_global_position(), false)

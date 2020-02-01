extends KinematicBody2D

const Speed: float = 25.0

var velocity := Vector2.ZERO

enum Direction {Up, Down, Left, Right}
var face: int = Direction.Up
var walking := false

export(int) var health := 2

var healed := false

onready var timer := $Timer as Timer
onready var spr := $Sprite as AnimatedSprite

onready var Player = get_tree().get_current_scene().get_node("Player")


func _ready():
	timer.set_wait_time(rand_range(2, 4))
	
func _process(delta):
	set_z_index(int(get_position().y))
	
	if not healed:
		if Player.position.x < position.x:
			velocity.x = -1
			face = Direction.Left
		else:
			velocity.x = 1
			face = Direction.Right
		
		if Player.position.y < position.y:
			velocity.y = -1
			#face = Direction.Up
		else:
			velocity.y = 1
			#face = Direction.Down
			
		walking = velocity != Vector2.ZERO
		
		direction_management()
		sprite_management()
	else:
		velocity = Vector2.ZERO
		spr.play("healed")


func _physics_process(delta):
	move_and_slide(velocity * Speed)
	
	
func hit():
	$SoundHit.play()
	$PartsHealed.set_emitting(true)
	health -= 1
	if health <= 0:
		$SoundHeal.play()
		#$PartsHealed.set_emitting(true)
		healed = true


func is_healed() -> bool:
	return healed


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

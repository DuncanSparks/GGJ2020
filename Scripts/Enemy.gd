extends KinematicBody2D

const Speed: float = 100.0

var velocity := Vector2.ZERO

enum Direction {Up, Down, Left, Right}
var face: int = Direction.Up

onready var timer := $Timer as Timer
onready var spr := $Sprite as AnimatedSprite

onready var Player = get_tree().get_current_scene().get_node("Player")


func _ready():
	timer.set_wait_time(rand_range(2, 4))
	
func _process(delta):
	
	if Player.position.x < position.x:
		velocity.x = -1
	else:
		velocity.x = 1
	
	if Player.position.y < position.y:
		velocity.y = -1
	else:
		velocity.y = 1
	
	
	#velocity
	
	direction_management()
	sprite_management()


func _physics_process(delta):
	move_and_slide(velocity * Speed)


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
	match face:
		Direction.Up:
			spr.play("up")
		Direction.Down:
			spr.play("down")
		Direction.Left:
			spr.play("left")
		Direction.Right:
			spr.play("right")

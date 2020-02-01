extends KinematicBody2D

const Speed: float = 100.0

var velocity := Vector2.ZERO

enum Direction {Up, Down, Left, Right}
var face: int = Direction.Up

var bullet_available := true

const bullet_ref := preload("res://Prefabs/PlayerBullet.tscn")

onready var spr := $Sprite as AnimatedSprite

# ======================================================

func _ready():
	pass


func _process(delta):
	var xx := int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	var yy := int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
	velocity.x = xx
	velocity.y = yy
	
	direction_management()
	sprite_management()
	
	if Input.is_action_just_pressed("attack") and bullet_available:
		throw_bullet()
		bullet_available = false


func _physics_process(delta):
	move_and_slide(velocity * Speed)

# ======================================================

func set_bullet_available(value: bool):
	bullet_available = value

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
	match face:
		Direction.Up:
			spr.play("up")
		Direction.Down:
			spr.play("down")
		Direction.Left:
			spr.play("left")
		Direction.Right:
			spr.play("right")
			
			
func throw_bullet():
	var bullet := bullet_ref.instance()
	bullet.set_position(get_position())
	bullet.set_global_rotation(get_position().direction_to(get_global_mouse_position()).angle())
	get_tree().get_root().add_child(bullet)

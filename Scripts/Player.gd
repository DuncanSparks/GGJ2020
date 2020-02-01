extends KinematicBody2D

const Speed: float = 100.0

var velocity := Vector2.ZERO

enum Direction {Up, Down, Left, Right}
var face: int = Direction.Down
var walking := false

var health: int = 5

var bullet_available := true

const bullet_ref := preload("res://Prefabs/PlayerBullet.tscn")

#export(AudioStream) var kick_sound

onready var spr := $Sprite as AnimatedSprite
onready var sound_kick := $SoundKick as AudioStreamPlayer
onready var healthbar := $Healthbar as TextureProgress

# ======================================================

func _ready():
	pass


func _process(delta):
	var xx := int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	var yy := int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
	velocity.x = xx
	velocity.y = yy
	
	walking = velocity != Vector2.ZERO
	
	direction_management()
	sprite_management()
	
	if Input.is_action_just_pressed("attack") and bullet_available:
		throw_bullet()
		bullet_available = false
	
	healthbar.set_value(health)


func _physics_process(delta):
	move_and_slide(velocity * Speed)

# ======================================================

func set_bullet_available(value: bool):
	bullet_available = value
	
	
func damage(amount: int):
	health -= amount

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
			
			
func throw_bullet():
	var bullet := bullet_ref.instance()
	bullet.set_position(get_position())
	bullet.set_global_rotation(get_position().direction_to(get_global_mouse_position()).angle())
	get_tree().get_root().add_child(bullet)
	sound_kick.play()

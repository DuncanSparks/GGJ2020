extends KinematicBody2D

const Speed: float = 25.0

var velocity := Vector2.ZERO

enum Direction {Up, Down, Left, Right}
var face: int = Direction.Up
var walking := false

export(int) var health := 2

var healed := false
var in_area := false

export(bool) var follow := true
export(String, MULTILINE) var healed_text

onready var timer := $Timer as Timer
onready var spr := $Sprite as AnimatedSprite
onready var text := $Text as RichTextLabel

onready var Player = get_tree().get_current_scene().get_node("Player")

# ======================================================

func _ready():
	timer.set_wait_time(rand_range(2, 4))
	set_text(healed_text)
	
	
func _process(delta):
	set_z_index(int(get_position().y))
	
	if in_area:
		text.visible_characters += 1
	
	if follow and not healed:
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
	
	if healed:
		velocity = Vector2.ZERO
		spr.play("healed")


func _physics_process(delta):
	move_and_slide(velocity * Speed)
	
# ======================================================
	
func hit():
	$SoundHit.play()
	$PartsHealed.set_emitting(true)
	health -= 1
	if health <= 0:
		$SoundHeal.play()
		#$PartsHealed.set_emitting(true)
		healed = true
		Controller.add_enemy_healed()


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

extends KinematicBody2D

const Speed: float = 100.0

var velocity := Vector2.ZERO

func _ready():
	pass


func _process(delta):
	var xx := int(Input.is_action_just_pressed("move_right")) - int(Input.is_action_just_pressed("move_left"))
	var yy := int(Input.is_action_just_pressed("move_down")) - int(Input.is_action_just_pressed("move_up"))
	
	velocity.x = xx
	velocity.y = yy


func _physics_process(delta):
	move_and_slide(velocity * Speed)

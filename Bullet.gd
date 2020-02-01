extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed: int = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	linear_velocity = Vector2(speed, 0).rotated(global_rotation)

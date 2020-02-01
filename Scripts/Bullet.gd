extends RigidBody2D

#Speed
export var speed: int = 5
export var damage: int = 5

func _ready():
	linear_velocity = Vector2(speed, 0).rotated(global_rotation)

func damage(body):
	if body.is_in_group("enemy"):
		body.health -= damage

func collide(body):
	damage(body)
	get_node('AnimatedSprite').play('die')


func _animation_finished(animation):
	if animation == 'die':
		queue_free()

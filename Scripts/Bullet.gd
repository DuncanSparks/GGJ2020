extends RigidBody2D

#Speed
export var speed := 5
export var min_speed := 5
export var damage := 5

onready var animated_sprite := $AnimatedSprite as AnimatedSprite

func _ready():
	linear_velocity = Vector2(speed, 0).rotated(global_rotation)


func _process(delta):
	if linear_velocity.length() < min_speed or offscreen():
		delete()


func damage(body):
	if body.is_in_group("enemy"):
		body.health -= damage


func collide(body):
	damage(body)
	animated_sprite.play('die')


func delete():
	animated_sprite.play('die')


func _animation_finished(animation):
	if animation == 'die':
		queue_free()


func offscreen() -> bool:
	return global_position.x < -64 or global_position.x > 384 or global_position.y < -64 or global_position.y > 224

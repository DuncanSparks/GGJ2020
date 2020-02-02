extends RigidBody2D

#Speed
export var speed := 5
export var min_speed := 5
#export var damage := 5


onready var sprite := $Sprite as Sprite

func _ready():
	linear_velocity = Vector2(speed, 0).rotated(global_rotation)
	if randi() > 0.5:
		sprite.set_flip_v(true)


func _process(delta):
	if linear_velocity.length() < min_speed or offscreen():
		delete()


#func damage(body):#
#	if body.is_in_group("enemy"):
#		body.health -= damage


func collide(body):
	if body.is_in_group("Player") and not Player.is_in_iframes():
		body.damage(1)
	#animated_sprite.play('die')
	delete()


func delete():
	queue_free()
#
#
#func _animation_finished():
#	queue_free()


func offscreen() -> bool:
	return global_position.x < -64 or global_position.x > 384 or global_position.y < -64 or global_position.y > 224

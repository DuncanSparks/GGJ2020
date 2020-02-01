extends RigidBody2D

#Speed
export var speed: int = 5
export var damage: int = 5

var can_pick_up := false

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


func _on_AreaPickUp_body_entered(body: Node):
	if body.is_in_group("Player") and can_pick_up:
		body.set_bullet_available(true)
		queue_free()


func _on_TimerPickUp_timeout():
	can_pick_up = true

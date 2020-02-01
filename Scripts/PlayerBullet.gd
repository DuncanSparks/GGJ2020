extends RigidBody2D

#Speed
export var speed: int = 5
export var damage: int = 5

var can_pick_up := false
var can_hit := true

func _ready():
	linear_velocity = Vector2(speed, 0).rotated(global_rotation)
	set_bounce(0.8)


func _process(delta):
	set_z_index(int(get_position().y))


func damage(body):
	if can_hit and body.is_in_group("enemy"):
		body.health -= damage


func _on_AreaPickUp_body_entered(body: Node):
	if body.is_in_group("Player") and can_pick_up:
		$SoundPickUp.play()
		body.set_bullet_available(true)
		$Sprite.hide()
		$PartsIdle.set_emitting(false)
		$PartsPickUp.set_emitting(true)
		$TimerDestroy.start()
		can_pick_up = false


func _on_TimerPickUp_timeout():
	#can_hit = false
	can_pick_up = true
	#$CollisionShape2D.set_disabled(true)


func _on_PlayerBullet_body_entered(body):
	if can_hit and body.is_in_group("Enemy") and not body.is_healed():
		body.hit()


func _on_TimerStopHitting_timeout():
	can_hit = false

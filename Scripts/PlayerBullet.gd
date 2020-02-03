extends RigidBody2D

signal picked_up

#Speed
export var speed: int = 5
export var damage: int = 5
export(bool) var stopped := false

var can_pick_up := false
var can_hit := true

func _ready():
	if not stopped:
		linear_velocity = Vector2(speed, 0).rotated(global_rotation)
		set_bounce(0.8)
	else:
		angular_velocity = 0


func _process(delta):
	set_z_index(int(get_position().y))
	
	if position.x < -10 or position.x > 330 or position.y < -10 or position.y > 190:
		queue_free()
		Player.set_bullet_available(true)


func _on_AreaPickUp_body_entered(body: Node):
	if body.is_in_group("Player") and can_pick_up:
		$SoundPickUp.play()
		body.set_bullet_available(true)
		$Sprite.hide()
		$PartsIdle.set_emitting(false)
		$PartsPickUp.set_emitting(true)
		$TimerDestroy.start()
		can_pick_up = false
		can_hit = false
		emit_signal("picked_up")


func _on_TimerPickUp_timeout():
	#can_hit = false
	can_pick_up = true
	#$CollisionShape2D.set_disabled(true)


func _on_PlayerBullet_body_entered(body):
	if can_hit and body.is_in_group("Enemy") and not body.is_healed():
		body.hit()
		
	if can_hit and body.is_in_group("Fountain") and not body.is_purified():
		body.purify()


func _on_TimerStopHitting_timeout():
	can_hit = false

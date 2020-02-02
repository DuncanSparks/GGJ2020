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


func _on_TimerStopHitting_timeout():
	can_hit = false


func _on_BossBullet_body_entered(body):
	if can_hit and body.is_in_group("Player") and not Player.is_in_iframes():
		Player.damage(2)

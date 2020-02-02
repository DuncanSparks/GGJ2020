extends Area2D

var in_area := false


func attack():
	$SoundFire.play()
	if in_area:
		Player.damage(2)


func _on_GroundAttack_body_entered(body):
	if body.is_in_group("Player"):
		in_area = true


func _on_GroundAttack_body_exited(body):
	if body.is_in_group("Player"):
		in_area = false


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()

extends Area2D

var can_pick_up := true


func _on_HealthPickup_body_entered(body):
	if body.is_in_group("Player") and can_pick_up:
		Player.heal(2)
		$SoundHeal.play()
		$PartsHeal.set_emitting(true)
		can_pick_up = false
		$TimerDestroy.start()

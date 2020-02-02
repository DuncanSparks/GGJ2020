extends Area2D

var can_pick_up := true


func _ready():
	if Controller.health_collected[get_tree().get_current_scene().filename + "--" + get_path()]:
		queue_free()


func _on_HealthPickup_body_entered(body):
	if body.is_in_group("Player") and can_pick_up:
		Player.heal(2)
		$SoundHeal.play()
		$PartsHeal.set_emitting(true)
		$Sprite.hide()
		can_pick_up = false
		Controller.health_collected[get_tree().get_current_scene().filename + "--" + get_path()] = true
		$TimerDestroy.start()

extends Node2D

var credits_open := false


func _process(delta):
	if Input.is_action_just_pressed("attack") and credits_open:
		credits_open = false
		$AnimationPlayer.play("Fadeout Credits")
		yield($AnimationPlayer, "animation_finished")
		$AnimationPlayer.play("Fadein")
		yield($AnimationPlayer, "animation_finished")
		set_buttons_active(true)


func _on_ButtonStart_pressed():
	set_buttons_active(false)
	$SoundClick.play()
	$AnimationPlayer.play("Fadeout")
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene("res://Scenes/Overworld/Overworld_1.tscn")
	Player.set_lock_movement(false)
	Controller.show_ui(true)
	Player.show()
	Controller.play_music()
	Controller.start_timer()


func _on_ButtonCredits_pressed():
	set_buttons_active(false)
	$SoundClick.play()
	$AnimationPlayer.play("Fadeout Keep Music")
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("Fadein Credits")
	yield($AnimationPlayer, "animation_finished")
	credits_open = true


func _on_ButtonExit_pressed():
	set_buttons_active(false)
	$SoundClick.play()
	$AnimationPlayer.play("Fadeout")
	yield($AnimationPlayer, "animation_finished")
	get_tree().quit()


func set_buttons_active(active: bool):
	$ButtonStart.set_disabled(not active)
	$ButtonCredits.set_disabled(not active)
	$ButtonExit.set_disabled(not active)


func _on_ButtonSpeedrunTimer_pressed():
	$SoundClick2.play()
	Controller.set_speedrun_timer(not Controller.speedrun_timer)
	$ButtonSpeedrunTimer.set_text("Speedrun Timer On" if Controller.speedrun_timer else "Speedrun Timer Off")

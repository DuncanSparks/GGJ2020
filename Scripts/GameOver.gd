extends Node2D

func _on_Timer_timeout():
	get_tree().change_scene("res://Scenes/Title.tscn")


func _on_Timer2_timeout():
	$AnimationPlayer.play("Fadein")
	$MusicGameOver.play()

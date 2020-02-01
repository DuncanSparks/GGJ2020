extends Area2D

export(String, FILE, "*.tscn") var target_scene
export(int, "Up,Down,Left,Right") var direction


func _on_LoadingZone_body_entered(body):
	if body.is_in_group("Player") and not Player.is_loading():
		Player.set_loading(true)
		Player.set_face(direction)
		match direction:
			0: # Up
				Player.position.y = 160
			1: # Down
				Player.position.y = 20
			2: # Left
				Player.position.x = 300
			3: # Right
				Player.position.x = 20
		get_tree().change_scene(target_scene)
				
		Player.set_bullet_available(true)
		
		Controller.after_load()
		#Player.call_deferred("set_loading", false)

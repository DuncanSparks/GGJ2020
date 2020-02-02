extends StaticBody2D

var purified := false

func _ready():
	set_z_index(int(get_position().y))
	if get_tree().get_current_scene().filename + "--" + get_path() in Controller.fountains_purified:
		purify(true)


func purify(room_start: bool = false):
	$AnimationPlayer.play("Purified")
	if not room_start:
		$SoundPurify.play()
		$PartsPurify.set_emitting(true)
		Player.heal(5)
	$PartsFountain.set_emitting(true)
	purified = true
	Controller.fountains_purified[get_tree().get_current_scene().filename + "--" + get_path()] = true
	
	
func is_purified() -> bool:
	return purified
	

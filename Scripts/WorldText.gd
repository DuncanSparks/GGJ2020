extends RichTextLabel

export(String, MULTILINE) var text_to_display

var display := false


func _ready():
	bbcode_text = "[center][wave amp=20 freq=3.5]" + text_to_display
	visible_characters = 0


func _process(delta):
	if display:
		visible_characters += 1


func set_display(value: bool):
	display = value

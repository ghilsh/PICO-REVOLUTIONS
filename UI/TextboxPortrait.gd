extends Sprite

export var character_portrait := 1

func _ready():
	add_to_group("portrait")

func match_character(Character,new_character,current_portrait):
	if current_portrait == character_portrait:
		match new_character:
			Character.PICO:
				owner.get_node("Voiceblips").pitch_scale = 1.1
				texture = load("res://Assets/Images/pico.png")
			Character.DARNELL:
				owner.get_node("Voiceblips").pitch_scale = 0.95
				texture = load("res://Assets/Images/darnell.png")
			Character.UBERKID:
				owner.get_node("Voiceblips").pitch_scale = 0.75
				texture = load("res://Assets/Images/uberkid.png")
			Character.NONE:
				owner.get_node("Voiceblips").pitch_scale = 0.00000001
				texture = null
		
		if new_character == Character.NONE:
			owner.get_node("NameContainer").visible = false
		else: owner.get_node("NameContainer").visible = true

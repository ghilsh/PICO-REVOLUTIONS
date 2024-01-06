extends Node2D

var new_position = Vector2.ZERO

func _ready():
	set_new_position()

func set_new_position():
	new_position = Vector2((randi() % 860 + 240),(randi() % 510 + 150))

func _on_Timer_timeout():
	set_new_position()
	
	var scene_medikit = preload("res://Enviroment/Medikit.tscn")
	var medikit = scene_medikit.instance()
	get_parent().add_child(medikit)
	medikit.position = new_position

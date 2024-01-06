extends "res://Entities/State.gd"

var active = false

func enter():
	owner.get_node("AnimationPlayer").play("fall")
	
	var scene_gameover = preload("res://UI/GameOver.tscn")
	var gameover = scene_gameover.instance()
	get_tree().get_root().add_child(gameover)

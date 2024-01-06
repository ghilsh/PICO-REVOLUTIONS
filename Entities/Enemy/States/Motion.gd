extends "res://Entities/State.gd"

func hit(damage):
	owner.stats.health -= damage
	
	owner.get_node("RedFlash").interpolate_property(owner.get_node("Sprite"), "modulate", Color.crimson, Color(1,1,1,1), 0.5)
	owner.get_node("RedFlash").start()
	
	var scene_blood = preload("res://Entities/Enemy/EnemyBlood.tscn")
	var blood = scene_blood.instance()
	owner.get_parent().add_child(blood)
	blood.position = owner.position
	blood.get_node("Timer").connect("timeout",blood,"queue_free")
	blood.get_node("Particles2D").emitting = true
	
	owner.get_node("Sounds/Hit").pitch_scale = (randi() % 5 + 8) * 0.1
	owner.get_node("Sounds/Hit").play()

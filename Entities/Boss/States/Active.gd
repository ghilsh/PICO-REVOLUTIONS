extends "res://Entities/State.gd"

func hit(damage):
	owner.stats.health -= damage
	
	owner.get_node("Tween").interpolate_property(owner.get_node("Sprite"), "modulate", Color.crimson, Color(1,1,1,1), 0.5)
	owner.get_node("Tween").start()
	
	"""
	owner.get_node("Sounds/Hit").pitch_scale = (randi() % 5 + 8) * 0.1
	owner.get_node("Sounds/Hit").play()
	"""

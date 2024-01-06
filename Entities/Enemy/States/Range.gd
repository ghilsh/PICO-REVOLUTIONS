extends "res://Entities/Enemy/States/Motion.gd"

func enter():
	owner.get_node("AnimationPlayer").play("idle")
	spawn_fireball()

func update():
	if owner.get_node("Timers/FireballTimer").time_left == 0:
		spawn_fireball()
	
	if owner.player_nearby == true:
		emit_signal("finished", "chase")

func spawn_fireball():
	var scene_fireball = preload("res://Entities/Enemy/Fireball.tscn")
	var fireball = scene_fireball.instance()
	owner.get_parent().add_child(fireball)
	fireball.position = owner.position
	
	owner.get_node("Timers/FireballTimer").start()

func process_movement():
	var direction = owner.global_position.direction_to(owner.agent.get_next_location())
	owner.move_and_slide(direction * owner.SPEED)

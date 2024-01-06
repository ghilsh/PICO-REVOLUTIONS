extends "res://Entities/Boss/States/Active.gd"

var fireball_count = 1
var fireballs_used = 0

func enter():
	spawn_fireball()
	
	if owner.stats.health <= (owner.stats.max_health / 3):
		fireball_count = 3
		owner.get_node("Timers/RangeTimer").wait_time = 0.5

func update():
	if owner.get_node("Timers/RangeTimer").time_left == 0:
		fireballs_used += 1
		if fireballs_used == fireball_count:
			emit_signal("finished", "teleport")
			fireballs_used = 0
		else: spawn_fireball()

func spawn_fireball():
	owner.get_node("Timers/RangeTimer").start()
	var scene_fireball = preload("res://Entities/Enemy/Fireball.tscn")
	var fireball = scene_fireball.instance()
	owner.get_parent().add_child(fireball)
	fireball.position = owner.position
	fireball.scale = Vector2(3,3)
	
	owner.get_node("Timers/FireballTimer").start()

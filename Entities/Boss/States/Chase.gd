extends "res://Entities/Boss/States/Active.gd"

var state_points = 0

func enter():
	owner.get_node("AnimationPlayer").play("chase")
	owner.get_node("Timers/ChaseTimer").start()

func update():
	if owner.agent.is_navigation_finished():
		return
	
	var direction = owner.global_position.direction_to(owner.agent.get_next_location())
	owner.move_and_slide(direction * owner.SPEED)
	
	if owner.get_node("Timers/ChaseTimer").time_left == 0:
		randomize()
		
		var randint = randi() % 2
		if randint == 0:
			if state_points != 2:
				emit_signal("finished", "teleport")
				state_points += 1
			else:
				emit_signal("finished", "slidecharging")
				state_points = 0

extends "res://Entities/Enemy/States/Motion.gd"

func enter():
	owner.get_node("AnimationPlayer").play("lunge")

func update():
	if owner.agent.is_navigation_finished():
		return
	
	var direction = owner.global_position.direction_to(owner.agent.get_next_location())
	owner.move_and_slide(direction * owner.SPEED)
	
	if owner.player_nearby == false:
		emit_signal("finished", "range")

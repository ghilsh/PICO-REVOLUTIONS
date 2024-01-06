extends "res://Entities/Player/States/Grounded.gd"

func enter():
	owner.get_node("AnimationPlayer").play("walk")

func update():
	input_direction = get_input_direction()
	if input_direction == Vector2.ZERO:
		emit_signal("finished", "idle")
	else: idle_direction = input_direction
	
	owner.speed += owner.ACCELERATION
	owner.speed = clamp(owner.speed, 0, owner.MAXSPEED)
	
	var _err = owner.move_and_slide(input_direction * owner.speed)
	
	check_ground_status()
	check_jump_status()

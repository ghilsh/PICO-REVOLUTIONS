extends "res://Entities/Player/States/Grounded.gd"

var direction = Vector2.ZERO

func initialize(idle_direction):
	direction = idle_direction

func enter():
	owner.get_node("AnimationPlayer").play("idle")

func update():
	var input_direction = get_input_direction()
	if input_direction != Vector2.ZERO:
		emit_signal("finished", "move")
	
	if owner.speed <= 0:
		owner.speed = 0
	else: owner.speed -= owner.DECELERATION
	
	if owner.speed > 0:
		var _err = owner.move_and_slide(direction * owner.speed)
	
	check_ground_status()
	check_jump_status()

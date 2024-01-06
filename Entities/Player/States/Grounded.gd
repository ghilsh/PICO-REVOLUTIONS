extends "res://Entities/Player/States/Motion.gd"

func check_ground_status():
	if owner.on_ground == false:
		emit_signal("finished", "fall")
		owner.get_node("Sounds/Fall").play()

func conveyor_movement(direction):
	owner.position += direction * owner.CONVEYORSPEED

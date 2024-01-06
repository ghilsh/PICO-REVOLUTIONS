extends "res://Entities/Boss/States/Active.gd"

var direction = Vector2.ZERO
var speed = 500
var speed_increasing = true

func enter():
	speed = 500
	speed_increasing = true
	direction = (owner.get_node("PlayerPointer/Position2D").global_position - owner.get_node("PlayerPointer").global_position).normalized()
	owner.get_node("AnimationPlayer").play("charged")
	
	if owner.stats.health <= (owner.stats.max_health / 3):
		owner.get_node("Timers/SlideTimer").wait_time = 6

func update():
	direction = direction.normalized()
	owner.move_and_slide(direction * speed)
	
	if (owner.position.x >= 1135 && direction.x > 0) or (owner.position.x <= 211 && direction.x < 0):
		change_angle("x")
	if (owner.position.y >= 686 && direction.y > 0) or (owner.position.y <= 120 && direction.y < 0):
		change_angle("y")
	
	if speed_increasing:
		speed += 5
	elif speed_increasing == false && owner.get_node("Timers/SlideTimer").time_left == 0.0: speed -= 5
	
	if speed >= 900 && speed_increasing:
		speed_increasing = false
		owner.get_node("Timers/SlideTimer").start()
	elif speed <= 300 && speed_increasing == false: emit_signal("finished","chase")

func change_angle(axis):
	var previous_direction = direction
	var randint_x = (randi() % 8 + 8) * 0.1
	var randint_y = (randi() % 8 + 8) * 0.1
	owner.get_node("AnimationPlayer").play("charged")
	owner.get_node("Sounds/Stomp").play()
	
	direction.x = randint_x
	if owner.position.x > 600 && axis == "x" or previous_direction.x < 0 && axis != "x":
		direction.x *= -1
	
	direction.y = randint_y
	if owner.position.y > 300 && axis == "y" or previous_direction.y < 0 && axis != "y":
		direction.y *= -1

extends "res://Entities/Player/States/Motion.gd"

var horizontal_speed
var enter_velocity
var jump_velocity
var delta_time

var idle_jump_direction = Vector2.ZERO
var target_velocity = Vector2.ZERO
var horizontal_velocity = Vector2()
var conveyor_physics_active = true

func _process(delta):
	delta_time = delta

func enter():
	owner.get_node("AnimationPlayer").play("jump")
	horizontal_speed = owner.MAXSPEED
	enter_velocity = get_input_direction()
	target_velocity = enter_velocity * horizontal_speed
	horizontal_velocity = target_velocity
	conveyor_physics_active = true

func update():
	input_direction = get_input_direction()
	
	if input_direction.x == 0:
		horizontal_velocity.x -= sign(horizontal_velocity.x) * owner.JUMPDECELERATION
	if input_direction.y == 0:
		horizontal_velocity.y -= sign(horizontal_velocity.y) * owner.JUMPDECELERATION
	
	if input_direction.x > 0:
		horizontal_velocity.x += owner.AIRSTEERINGPOWER
	elif input_direction.x < 0:
		horizontal_velocity.x -= owner.AIRSTEERINGPOWER
	
	if input_direction.y > 0:
		horizontal_velocity.y += owner.AIRSTEERINGPOWER
	elif input_direction.y < 0:
		horizontal_velocity.y -= owner.AIRSTEERINGPOWER
	
	horizontal_velocity.x = clamp(horizontal_velocity.x,-owner.MAXSPEED,owner.MAXSPEED)
	horizontal_velocity.y = clamp(horizontal_velocity.y,-owner.MAXSPEED,owner.MAXSPEED)
	
	var _err = owner.move_and_slide(horizontal_velocity)
	
	conveyor_physics_active = false

func _on_animation_finished(anim_name):
	if anim_name == "jump":
		if input_direction == Vector2.ZERO:
			emit_signal("finished", "idle")
		else: emit_signal("finished", "move")
		
		check_jump_status()
		
		if owner.on_ground:
			owner.get_node("Sounds/Land").pitch_scale = (randi() % 5 + 8) * 0.1
			owner.get_node("Sounds/Land").play()
		else: owner.get_node("Sounds/Fall").play()

func handle_input(event):
	if event.is_action_pressed("jump"):
		owner.get_node("Timers/JumpTimer").start()

func conveyor_movement(conveyor_knockback):
	if conveyor_physics_active:
		owner.knockback = (conveyor_knockback * 1200)
		print(delta_time)
		conveyor_physics_active = false

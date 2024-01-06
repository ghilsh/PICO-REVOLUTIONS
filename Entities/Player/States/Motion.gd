extends "res://Entities/State.gd"

var input_direction = Vector2.ZERO
var idle_direction = Vector2.ZERO

func get_input_direction():
	input_direction = Vector2()
	input_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_direction = input_direction.normalized()
	return input_direction

func handle_input(event):
	if event.is_action_pressed("jump"):
		owner.get_node("Timers/JumpTimer").start()
	
	if event.is_action_pressed("shoot") && owner.get_node("Timers/GunTimer").time_left == 0.0:
		if owner.get_node("Gun/RayCast2D").is_colliding():
			if owner.get_node("Gun/RayCast2D").get_collider() != null:
				 # ^ it crashed once because it said this was a "null instance" so i'm just adding this to stay safe
				var target = owner.get_node("Gun/RayCast2D").get_collider().get_parent()
				if target.is_in_group("enemy"):
					target.hit(owner.GUNPOWER)
		owner.get_node("Sounds/Shot").pitch_scale = (randi() % 5 + 8) * 0.1
		owner.get_node("Sounds/Shot").play()
		owner.get_node("Timers/GunTimer").start()

func check_jump_status():
	if owner.get_node("Timers/JumpTimer").time_left != 0.0:
		if owner.on_ground == true:
			emit_signal("finished", "jump")
			owner.get_node("Sounds/Jump").pitch_scale = (randi() % 5 + 8) * 0.1
			owner.get_node("Sounds/Jump").play()
		else: emit_signal("finished", "fall")

func hit(damage):
	owner.stats.health -= damage
	
	owner.get_node("Tween").interpolate_property(owner.get_node("Sprite"), "modulate", Color.crimson, Color(1,1,1,1), 0.5)
	owner.get_node("Tween").start()
	
	var scene_blood = preload("res://Entities/Player/PlayerBlood.tscn")
	var blood = scene_blood.instance()
	owner.get_parent().add_child(blood)
	blood.position = owner.position
	blood.get_node("Timer").connect("timeout",blood,"queue_free")
	blood.get_node("Particles2D").emitting = true
	
	owner.get_node("Sounds/Hit").pitch_scale = (randi() % 5 + 8) * 0.1
	owner.get_node("Sounds/Hit").play()

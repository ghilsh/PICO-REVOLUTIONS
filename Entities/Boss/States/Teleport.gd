extends "res://Entities/Boss/States/Active.gd"

var fireball_count = 0
var max_fireballs = 0

func enter():
	owner.get_node("AnimationPlayer").play("teleport_away")
	
	if max_fireballs == 0:
		randomize_fireballs()

func get_position():
	randomize()
	return Vector2((randi() % 860 + 240),(randi() % 510 + 150))

func teleport():
	var new_pos = get_position()
	if (new_pos - owner.player.global_position).length() <= 350:
		teleport()
	else:
		owner.position = new_pos
		owner.get_node("AnimationPlayer").play("teleport_back")

func _on_animation_finished(anim_name):
	if anim_name == "teleport_away":
		teleport()
	if anim_name == "teleport_back":
		if fireball_count == max_fireballs:
			emit_signal("finished", "chase")
			randomize_fireballs()
		else: 
			emit_signal("finished", "range")
			fireball_count += 1

func randomize_fireballs():
	fireball_count = 0
	randomize()
	max_fireballs = (randi() % 3) + 5

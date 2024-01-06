extends "res://Entities/State.gd"

func enter():
	if owner.stats.health <= 1:
		owner.stats.health = 0
	else: owner.get_node("AnimationPlayer").play("fall")
	
	owner.knockback = Vector2.ZERO

func exit():
	owner.get_node("Timers/InvincibleTimer").start()
	owner.invincible = true

func _on_animation_finished(anim_name):
	match anim_name:
		"fall":
			var respawn_pos = owner.start_pos
			if owner.stats.entrance_tag != 0:
				respawn_pos = get_tree().get_nodes_in_group(str(owner.stats.entrance_tag)).front().position
			
			owner.position = respawn_pos
			
			owner.get_node("Tween").interpolate_property(owner.get_node("Sprite"), "modulate", Color(1,1,1,0), Color(1,1,1,1), 0.25)
			owner.get_node("Tween").start()
			owner.get_node("AnimationPlayer").play("RESET")
			
			owner.on_ground = true
			owner.stats.health -= 1
		"RESET":
			emit_signal("finished", "idle")
			owner.speed = 0

extends "res://Entities/Enemy/States/Motion.gd"

func enter():
	owner.get_node("AnimationPlayer").play("alert")

func _on_animation_finished(anim_name):
	if anim_name == "alert":
		if owner.player_nearby == true:
			emit_signal("finished", "chase")
		else: emit_signal("finished", "range")

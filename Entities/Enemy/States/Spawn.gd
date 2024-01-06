extends "res://Entities/State.gd"

func enter():
	owner.get_node("AnimationPlayer").play("spawn")

func _on_animation_finished(_anim_name):
	emit_signal("finished","chase")

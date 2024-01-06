extends "res://Entities/Boss/States/Active.gd"

func enter():
	owner.get_node("AnimationPlayer").play("charging")
	owner.get_node("Sounds/Charging").play()

func _on_animation_finished(anim_name):
	if anim_name == "charging":
		emit_signal("finished","slide")

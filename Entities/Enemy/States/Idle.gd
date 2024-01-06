extends "res://Entities/Enemy/States/Motion.gd"

func enter():
	owner.get_node("AnimationPlayer").play("idle")

func _on_SearchArea_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("finished", "alert")

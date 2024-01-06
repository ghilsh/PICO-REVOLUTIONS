extends "res://Entities/State.gd"

var direction := Vector2.ZERO

func enter():
	if owner.get_node("AnimationPlayer").current_animation != "jump" or direction != Vector2.ZERO:
		owner.get_node("AnimationPlayer").play("walk")

func update():
	owner.speed += owner.ACCELERATION
	owner.speed = clamp(owner.speed, 0, owner.MAXSPEED)
	
	var _err = owner.move_and_slide(direction * owner.speed)
	owner.get_node("Gun").visible = false

func _on_animation_finished(anim_name):
	if anim_name == "jump":
		owner.get_node("AnimationPlayer").play("walk")

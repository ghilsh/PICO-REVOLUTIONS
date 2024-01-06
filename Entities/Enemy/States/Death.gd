extends "res://Entities/State.gd"

func enter():
	owner.dead = true
	owner.get_node("AnimationPlayer").play("fall")
	owner.get_node("Hitbox").queue_free()
	owner.get_node("HurtBox").queue_free()
	owner.get_node("CollisionBox").queue_free()

func _on_animation_finished(_anim_name):
	owner.queue_free()

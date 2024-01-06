extends "res://Entities/Boss/States/Active.gd"

func enter():
	owner.get_node("AnimationPlayer").play("charged")

func _on_animation_finished(anim_name):
	if anim_name == "charged":
		summon_enemies()

func summon_enemies():
	var scene_enemy = preload("res://Entities/Enemy/Enemy.tscn")
	var enemy = scene_enemy.instance()
	enemy.path_to_player = "../Player"
	enemy.alert_zone = owner.alert_zone
	owner.get_parent().add_child(enemy)
	enemy.position = Vector2(800,400)
	enemy.change_state("spawn")
	emit_signal("finished","chase")

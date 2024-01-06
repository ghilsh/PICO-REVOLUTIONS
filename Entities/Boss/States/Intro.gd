extends "res://Entities/State.gd"

func _ready():
	owner.get_node("Sprite").visible = false

func exit():
#	get_tree().call_group("music","change_music","boss")
	pass

func _on_animation_finished(anim_name):
	if anim_name == "intro":
		owner.get_node("AnimationPlayer").play("roar")
		get_tree().call_group("roomcutscene","camera_zoom")
	if anim_name == "roar":
		emit_signal("finished", "chase")
		get_tree().call_group("player","change_state","idle")

extends Node2D

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "descend":
		var scene_transition = preload("res://UI/TransitionScreen.tscn")
		var transition = scene_transition.instance()
		get_tree().get_root().add_child(transition)
		transition.new_screen = NodePath("res://Screens/Rooms/RoomBoss.tscn")

extends Node2D

var active = false

func _ready():
	if !PlayerStats.first_time:
		var _err = get_tree().change_scene("res://Screens/Rooms/Room1.tscn")

func _input(event):
	if event.is_action_pressed("shoot") && $Timer.time_left == 0 && !active:
		var scene_transition = preload("res://UI/TransitionScreen.tscn")
		var transition = scene_transition.instance()
		get_tree().get_root().add_child(transition)
		transition.new_screen = NodePath("res://Screens/Rooms/Room1.tscn")
		PlayerStats.first_time = false
		active = true

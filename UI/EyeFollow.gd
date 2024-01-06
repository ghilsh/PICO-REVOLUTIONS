extends Node2D

onready var child = get_children()[1]

export (float) var max_distance = 2.0

func _process(_delta):
	var mouse_pos = get_local_mouse_position()
	var dir = Vector2.ZERO.direction_to(mouse_pos)
	var dist = mouse_pos.length()
	child.position = dir * min(dist,max_distance)

extends Node2D

func _process(_delta):
	var mouse_pos = get_local_mouse_position()
	rotation += mouse_pos.angle()
	
	if rotation_degrees <= 150:
		z_index = 1
	else: z_index = 0
	
	if rotation_degrees > 360:
		rotation_degrees = 0
	elif rotation_degrees < 0:
		rotation_degrees = 360
	
	update()

func _draw():
	var line_colour = Color("8eff0000")
	var end_point = Vector2(position.x + 800,0)
	
	if $RayCast2D.is_colliding():
		var offset =  $RayCast2D.get_collision_point() - get_global_transform().origin
		end_point = Vector2.RIGHT * offset.length()
	
	if end_point.x > 60:
		draw_line($ColorRect.rect_position + Vector2(0,4), end_point, line_colour)

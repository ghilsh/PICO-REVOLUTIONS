extends "res://Enviroment/Door.gd"

var camera

func _ready():
	camera = get_tree().get_nodes_in_group("camera").front()

func _on_body_entered(body):
	if body.is_in_group("player"):
		get_tree().call_group("player","change_state","blocked",direction)
		get_tree().call_group("music","fade_volume",2)
		body.stats.entrance_tag = entrance_tag
		$Timers/CloseTimer.start()
		camera_zoom(1)

func _on_CloseTimer_timeout():
	$AnimationPlayer.play("closed")
	$CloseSound.play()
	$Timers/CinematicTimer.start()
	
	$Timers/ShakeTimer.start()

func _on_CinematicTimer_timeout():
	var scene_transition = preload("res://UI/TransitionScreen.tscn")
	var transition = scene_transition.instance()
	get_tree().get_root().add_child(transition)
	transition.new_screen = NodePath(new_room)

func camera_zoom(speed):
	$Tween.interpolate_property(camera,"zoom",Vector2(1,1),Vector2(0.8,0.8),speed,Tween.EASE_OUT)
	$Tween.interpolate_property(camera,"offset",Vector2(0,0),Vector2(0,-40),speed,Tween.EASE_OUT)
	$Tween.start()

func camera_shake(base_pos): # unused
	if $Timers/ShakeTimer.time_left != 0.0:
		camera.smoothing_enabled = false
		var randint_x = randi() % 3 - 1
		var randint_y = randi() % 3 - 1
		var shake_intensity = 5
		var new_pos = base_pos + (Vector2(randint_x,randint_y) * shake_intensity)
		
		camera.position = new_pos

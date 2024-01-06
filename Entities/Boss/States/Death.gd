extends "res://Entities/State.gd"

var base_pos
var transitioning = false

func enter():
	get_tree().call_group("fireball", "queue_free")
	owner.get_node("AnimationPlayer").play("death")
	owner.get_node("Timers/DeathTimer").start()
	owner.player.change_state("blocked")
	get_tree().call_group("player","play_animation","idle_no_gun")
	camera_zoom()
	base_pos = owner.position
	owner.get_node("Sounds/Static").play()
	PlayerStats.timer_on = false
	Ngio.request("ScoreBoard.postScore", {"id": 13363, "value": (PlayerStats.time_spent * 1000)})
	get_tree().call_group("music","fade_volume",4)
	
	if PlayerStats.time_spent <= 300:
		Ngio.request("Medal.unlock", {"id": 76568})

func update():
	shaking_animation()
	
	if owner.get_node("Timers/DeathTimer").time_left == 0.0 && transitioning == false:
		scene_transition()
		transitioning = true

func scene_transition():
	var scene_transition = preload("res://UI/TransitionScreen.tscn")
	var transition = scene_transition.instance()
	transition.white = true
	get_tree().get_root().add_child(transition)
	transition.new_screen = NodePath("res://Screens/Cutscenes/EndCutscene.tscn")

func camera_zoom():
	var camera = get_tree().get_nodes_in_group("camera").front()
	var new_pos = owner.position - owner.player.position
	new_pos.y -= 200
	
	owner.get_node("Tween").interpolate_property(camera,"zoom",Vector2(1,1),Vector2(0.7,0.7),5,Tween.EASE_OUT)
	owner.get_node("Tween").interpolate_property(camera,"offset",Vector2(0,0),new_pos,1,Tween.EASE_OUT)
	owner.get_node("Tween").interpolate_property(owner.get_node("Healthbar").get_node("Health"),"modulate", Color(1,1,1,1), Color(1,1,1,0),2,Tween.EASE_OUT)
	owner.get_node("Tween").interpolate_property(owner.get_node("Healthbar").get_node("Label"),"modulate", Color(1,1,1,1), Color(1,1,1,0),2,Tween.EASE_OUT)
	owner.get_node("Tween").start()

func shaking_animation():
	var pos_x = randi() % 2 - 1
	var pos_y = randi() % 2 - 1
	var shake_power = 15
	
	owner.position = base_pos + (Vector2(pos_x,pos_y) * shake_power)

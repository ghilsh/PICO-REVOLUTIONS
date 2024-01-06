extends CanvasLayer

var active = false

func _ready():
	$AnimationPlayer.play("open")

func _input(event):
	if event.is_action_pressed("restart") && active:
		var scene_transition = preload("res://UI/TransitionScreen.tscn")
		var transition = scene_transition.instance()
		get_tree().get_root().add_child(transition)
		
		transition.new_screen = PlayerStats.checkpoint
		PlayerStats.entrance_tag = PlayerStats.checkpoint_tag
		transition.connect("scene_changed",self,"_on_scene_changed")
		transition.layer = 2
		
		active = false
		
		PlayerStats.keys_pickedup = []
		for id in PlayerStats.keys_pickedup_saved:
			PlayerStats.keys_pickedup.append(id)
		
		PlayerStats.doors_opened = []
		for id in PlayerStats.doors_opened_saved:
			PlayerStats.doors_opened.append(id)
		
		PlayerStats.keys = PlayerStats.keys_saved

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "open":
		active = true

func _on_scene_changed():
	PlayerStats.deaths += 1
	queue_free()

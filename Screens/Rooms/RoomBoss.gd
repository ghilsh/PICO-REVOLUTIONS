extends "res://Screens/Rooms/Room.gd"

func _ready():
	get_tree().call_group("player","change_state","blocked")
	get_tree().call_group("player","play_animation","preboss_intro")
	PlayerStats.checkpoint = "res://Screens/Rooms/RoomBoss.tscn"

func _on_CutsceneTimer_timeout():
	$Cutscene.play("boss_intro")

func _on_Cutscene_animation_finished(anim_name):
	if anim_name == "boss_intro":
		get_tree().call_group("enemy","play_animation","intro")

func camera_zoom():
	$Cutscene.play("zoom")

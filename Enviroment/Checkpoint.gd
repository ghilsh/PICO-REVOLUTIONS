extends StaticBody2D

export(String, FILE, "*.tscn") var destination = "res://Screens/Rooms/Room1.tscn"
export(int) var entrance_tag = 3

var active = false

func _ready():
	if destination == PlayerStats.checkpoint:
		active = true
		$Sprite.frame = 0
	else: $Sprite.frame = 1

func _on_ProximityChecker_body_entered(body):
	if body.is_in_group("player") && active == false:
		$SavedText/AnimationPlayer.play("reveal")
		$AnimationPlayer.play("touched")
		active = true
		set_checkpoint()

func set_checkpoint():
	PlayerStats.checkpoint = destination
	PlayerStats.checkpoint_tag = entrance_tag
	PlayerStats.entrance_tag = entrance_tag
	
	for id in PlayerStats.keys_pickedup:
		PlayerStats.keys_pickedup_saved.append(id)
	for id in PlayerStats.doors_opened:
		PlayerStats.doors_opened_saved.append(id)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "touched":
		$AnimationPlayer.play("idle")

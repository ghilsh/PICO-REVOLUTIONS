extends CanvasLayer

var new_screen := NodePath()
var wait_time := 0
var white := false

signal scene_changed

func _ready():
	if white:
		$AnimationPlayer.play("fade_in_white")
		$Swoosh.play()
	else: $AnimationPlayer.play("fade_in")

func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"fade_in":
			$AnimationPlayer.play("fade_out")
			set_new_screen()
		"fade_in_white":
			$AnimationPlayer.play("fade_out_white")
			set_new_screen()
		"fade_out":
			queue_free()
		"fade_out_white":
			queue_free()

func set_new_screen():
	var _err = get_tree().change_scene(new_screen)
	emit_signal("scene_changed")

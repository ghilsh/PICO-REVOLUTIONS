extends CanvasLayer

var skipping = true

func _ready():
	var _err0 = $Tween.connect("tween_completed",self,"_on_tween_completed")
	$AnimationPlayer.play("initiate")
	$Tween.interpolate_property($Label, "modulate", Color("00ffffff"), Color("ffffff"), 0.25)
	if !$Tween.is_active():
		$Tween.start()

func _input(event):
	if event.is_action_released("pause"):
		skipping = false
		$AnimationPlayer.stop()
		
		$Tween.interpolate_property($Label, "modulate", Color("ffffff"), Color("00ffffff"), 0.25)
		if !$Tween.is_active():
			$Tween.start()

func _on_tween_completed(_object,_key):
	if skipping == false:
		queue_free()

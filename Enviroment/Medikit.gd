extends Area2D

func _ready():
	$AnimationPlayer.play("idle")

func _on_Medikit_body_entered(body):
	if body.is_in_group("player") && body.state_name != "death":
		var audio = AudioStreamPlayer.new()
		get_tree().get_root().add_child(audio)
		audio.stream = load("res://Assets/Audio/Sounds/snd_heal.wav")
		audio.connect("finished",audio,"queue_free")
		audio.play()
		
		PlayerStats.health += 2
		if PlayerStats.health >= PlayerStats.max_health:
			PlayerStats.health = PlayerStats.max_health
		
		queue_free()

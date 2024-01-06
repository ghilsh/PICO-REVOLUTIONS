extends Area2D

export var id = 999

func _ready():
	if PlayerStats.keys_pickedup.has(id):
		queue_free()

func _physics_process(delta):
	if get_parent() is PathFollow2D:
		get_parent().set_offset(get_parent().get_offset() + 250 * delta)

func _on_Key_body_entered(body):
	if body.is_in_group("player"):
		var audio = AudioStreamPlayer.new()
		get_tree().get_root().add_child(audio)
		audio.stream = load("res://Assets/Audio/Sounds/snd_key.wav")
		audio.connect("finished",audio,"queue_free")
		audio.play()
		
		PlayerStats.keys += 1
		PlayerStats.keys_pickedup.append(id)
		queue_free()

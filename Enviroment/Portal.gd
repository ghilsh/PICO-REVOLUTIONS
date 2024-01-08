extends Area2D

export var path_to_destination := NodePath()
onready var destination = get_node(path_to_destination)

export var direction = 0

var player

func _ready():
	player = get_tree().get_nodes_in_group("player").front()
	$AnimationPlayer.play("idle")
	
	$PlayerPointer.rotation_degrees = direction

func _process(_delta):
	pass
#	destination.get_node("PlayerPointer").look_at(player.position)

func _on_Portal_body_entered(body):
	if body.is_in_group("player"):
#		body.position = get_destination()
		destination.set_destination(body)
		warp_noise()
		$Tween.interpolate_property(self, "modulate", Color(1,1,1,0), Color(1,1,1,1), 0.25)
		$Tween.start()

func get_destination():
#	destination.get_node("Tween").interpolate_property(destination, "modulate", Color(1,1,1,0), Color(1,1,1,1), 0.25)
#	destination.get_node("Tween").start()
	
#	var destination_vector = ($PlayerPointer.global_position - $PlayerPointer/DestinationPoint.global_position).normalized()
#	return destination.global_position + (destination_vector * 55)
	var destination_vector = ($PlayerPointer.global_position - $PlayerPointer/DestinationPoint.global_position).normalized()
	return destination.global_position + (destination_vector * 55)

func set_destination(player_node):
	player = player_node
	player.position = $PlayerPointer/DestinationPoint.global_position

func warp_noise():
	$WarpNoise.pitch_scale = (randi() % 5 + 8) * 0.1
	$WarpNoise.play()

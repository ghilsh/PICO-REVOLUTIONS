extends Position2D

export(int) var tag = 1

func _ready():
	var player = get_tree().get_nodes_in_group("player").front()
	if tag == player.stats.entrance_tag:
		player.position = position
	
	add_to_group(str(tag))

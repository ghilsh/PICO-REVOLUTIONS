extends Area2D

func _ready():
	var _err0 = connect("body_entered", self, "_on_body_entered")
	var _err1 = connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.on_ground = true
		add_to_group("tiles_active")

func _on_body_exited(body):
	if body.is_in_group("player") or body.is_in_group("enemy"):
		if self.is_in_group("tiles_active"):
			remove_from_group("tiles_active")
		
		if get_tree().get_nodes_in_group("tiles_active") == []:
			body.on_ground = false

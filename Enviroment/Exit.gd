extends Area2D

export(String, FILE, "*.tscn") var new_room = ""
export(Vector2) var direction = Vector2.ZERO
export(int) var entrance_tag = 0

func _ready():
	var _err = connect("body_entered",self,"_on_body_entered")

func _on_body_entered(body):
	if body.is_in_group("player") && body.stats.health > 0:
		var scene_transition = preload("res://UI/TransitionScreen.tscn")
		var transition = scene_transition.instance()
		get_tree().get_root().add_child(transition)
		transition.new_screen = NodePath(new_room)
		
		get_tree().call_group("player","change_state","blocked",direction)
		body.stats.entrance_tag = entrance_tag

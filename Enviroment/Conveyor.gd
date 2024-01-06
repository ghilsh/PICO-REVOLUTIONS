extends "res://Enviroment/WalkableTiles.gd"

var active = false

export var direction = Vector2(1,0)

func _ready():
	var _err0 = connect("body_entered", self, "on_conveyor")
	var _err1 = connect("body_exited", self, "off_conveyor")

func _process(_delta):
	if active:
		get_tree().call_group("player","conveyor_movement", direction)

func on_conveyor(body):
	if body.is_in_group("player"):
		active = true

func off_conveyor(body):
	if body.is_in_group("player") or body.is_in_group("enemy"):
		active = false

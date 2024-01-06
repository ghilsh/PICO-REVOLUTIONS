extends "res://Enviroment/Exit.gd"

export (int) var keys_needed
export (int) var id = 999
var active = false
var is_open = false

export var path_to_player := NodePath()
onready var player = get_node(path_to_player)

func _ready():
	var _err = connect("body_entered",self,"player_entered")
	
	var _err2 = $InteractBox.connect("body_entered", self, "_on_InteractBox_body_entered")
	var _err3 = $InteractBox.connect("body_exited", self, "_on_InteractBox_body_exited")
	
	if PlayerStats.doors_opened.has(id):
		door_open_auto()
	else: $AnimationPlayer.play("closed")

func _process(_delta):
	$Label.text = str(PlayerStats.keys) + "/" + str(keys_needed)

func _input(event):
	if event.is_action_pressed("interact") && active:
		if PlayerStats.keys >= keys_needed:
			door_open()
			PlayerStats.doors_opened.append(id)
		else:
			locked_dialog()

func _on_InteractBox_body_entered(body):
	if body.is_in_group("player") && is_open == false:
		active = true
		player.get_node("Interact").visible = true

func _on_InteractBox_body_exited(body):
	if body.is_in_group("player"):
		active = false
		player.get_node("Interact").visible = false

func door_open():
	active = false
	player.get_node("Interact").visible = false
	$AnimationPlayer.play("open")
	$ColliderClosed.queue_free()
	is_open = true
	PlayerStats.keys -= keys_needed

func door_open_auto():
	active = false
	player.get_node("Interact").visible = false
	$Sprite.frame = 1
	$Label.visible = false
	$ColliderClosed.queue_free()
	is_open = true

func locked_dialog():
	var scene_textbox = preload("res://UI/Textbox.tscn")
	var textbox = scene_textbox.instance()
	add_child(textbox)
	textbox.read_file("res://Dialog/locked.json")
	
	textbox.character1 = 3
	textbox.character2 = 3
	textbox.match_character(textbox.character1,3)
	textbox.match_character(textbox.character2,3)
	textbox.get_node("NameContainer").visible = false

func player_entered(body):
	if body.is_in_group("player"):
		player.get_node("Tween").interpolate_property(player, "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.25)
		player.get_node("Tween").start()

extends StaticBody2D

export var path_to_player := NodePath()
export var dialog = "test"

onready var player = get_node(path_to_player)
onready var dialog_path = "res://Dialog/"+String(dialog)+".json"

var active = false

func _ready():
	$AnimationPlayer.play("idle")
	
	var _err = $InteractBox.connect("body_entered", self, "_on_InteractBox_body_entered")
	var _err2 = $InteractBox.connect("body_exited", self, "_on_InteractBox_body_exited")

func _process(_delta):
	if player.position.x < position.x:
		$Sprite.scale.x *= -1

func _input(event):
	if event.is_action_pressed("interact") && active:
		var scene_textbox = preload("res://UI/Textbox.tscn")
		var textbox = scene_textbox.instance()
		get_tree().get_root().add_child(textbox)
		
		textbox.read_file(dialog_path)
		
		get_tree().call_group("music","decrease_volume")
		if get_tree().get_nodes_in_group("music") != []:
			var music = get_tree().get_nodes_in_group("music").front()
			textbox.connect("dialog_closing",music,"increase_volume")
		
		textbox.match_character(textbox.character1,1)
		textbox.match_character(textbox.character2,2)

func _on_InteractBox_body_entered(body):
	if body.is_in_group("player"):
		active = true
		player.get_node("Interact").visible = true

func _on_InteractBox_body_exited(body):
	if body.is_in_group("player"):
		active = false
		player.get_node("Interact").visible = false

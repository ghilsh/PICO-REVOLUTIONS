extends Node

export var dialog := ""
export(String, FILE, "*.tscn") var destination = ""
export var music := ""
export var medal := 0

export var character1 := 0
export var character2 := 1

func _ready():
	pause_mode = PAUSE_MODE_PROCESS
	
	var scene_textbox = preload("res://UI/Textbox.tscn")
	var textbox = scene_textbox.instance()
	add_child(textbox)
	textbox.read_file("res://Dialog/"+dialog+".json")
	
	textbox.character1 = character1
	textbox.character2 = character2
	textbox.match_character(textbox.character1,1)
	textbox.match_character(textbox.character2,2)
	
	for transition in get_tree().get_nodes_in_group("transition"):
		transition.pause_mode = PAUSE_MODE_PROCESS
	
	get_tree().call_group("overlay", "queue_free")
	if music != "":
		get_tree().call_group("music", "change_music", music)
	else: get_tree().call_group("music", "stop_music")
	
	if medal != 0:
		Ngio.request("Medal.unlock", {"id": medal})
	
	add_to_group("cutscene")

func _input(event):
	if event.is_action_pressed("pause") && get_tree().get_nodes_in_group("skip") == []:
		var scene_skip = preload("res://UI/SkipCutscene.tscn")
		var skip = scene_skip.instance()
		add_child(skip)
		skip.get_node("AnimationPlayer").connect("animation_finished",self,"_on_animation_finished")

func on_dialog_closed():
	var scene_transition = preload("res://UI/TransitionScreen.tscn")
	var transition = scene_transition.instance()
	get_tree().get_root().add_child(transition)
	
	transition.new_screen = NodePath(destination)
	get_tree().paused = false

func _on_animation_finished(anim_name):
	if anim_name == "initiate":
		on_dialog_closed()

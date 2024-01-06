extends Node2D

enum State {MAIN, OPTIONS}
var current_state = State.MAIN

func _ready():
	if get_tree().get_nodes_in_group("music") == []:
		var scene_music = preload("res://Music/MusicController.tscn")
		var music = scene_music.instance()
		get_tree().get_root().call_deferred("add_child",music)
	get_tree().call_deferred("call_group", "music", "change_music", "title")
	get_tree().paused = false
	
	get_tree().call_group("pause","queue_free")
	get_tree().call_group("overlay","queue_free")
	get_tree().call_group("transition","queue_free")
	get_tree().call_group("gameover","queue_free")
	
	for button in get_tree().get_nodes_in_group("button"):
		button.connect("mouse_entered",self,"_on_mouse_entered")
		button.disabled = false
	for animator in get_tree().get_nodes_in_group("title_animator"):
		animator.play("idle")
	
	var _err0 = $Overlay/MainMenu/Start.connect("pressed",self,"_on_Start_pressed")
	var _err1 = $Overlay/MainMenu/Options.connect("pressed",self,"_on_Options_pressed")
	var _err2 = $Overlay/MainMenu/Quit.connect("pressed",self,"_on_Quit_pressed")
	
	PlayerStats.reset()

func _process(_delta):
	for button in get_tree().get_nodes_in_group("button"):
		button.disabled = $Tween.is_active()

func _on_mouse_entered():
	$Sounds/HoverSound.play()

func _on_Start_pressed():
	var scene_transition = preload("res://UI/TransitionScreen.tscn")
	var transition = scene_transition.instance()
	add_child(transition)
	
	transition.new_screen = NodePath("res://Screens/Cutscenes/IntroCutscene.tscn")

func _on_Options_pressed():
	$Tween.interpolate_property($Overlay/MainMenu, "modulate", Color("ffffff"), Color("00ffffff"), 0.2)
	if !$Tween.is_active():
		$Tween.start()

func _on_Quit_pressed():
	if OS.has_feature("web"):
		$Sounds/DenySound.play()
	else: get_tree().quit()

func _on_Back_pressed():
	$Tween.interpolate_property($Overlay/OptionsMenu, "modulate", Color("ffffff"), Color("00ffffff"), 0.2)
	if !$Tween.is_active():
		$Tween.start()

func _on_Tween_tween_completed(object, _key):
	if object == $Overlay/MainMenu:
		match current_state:
			State.MAIN:
				$Tween.interpolate_property($Overlay/OptionsMenu, "modulate", Color("00ffffff"), Color("ffffff"), 0.2)
				$Overlay/OptionsMenu.visible = true
			State.OPTIONS:
				current_state = State.MAIN
	elif object == $Overlay/OptionsMenu:
		match current_state:
			State.MAIN:
				current_state = State.OPTIONS
			State.OPTIONS:
				$Tween.interpolate_property($Overlay/MainMenu, "modulate", Color("00ffffff"), Color("ffffff"), 0.2)
				$Overlay/OptionsMenu.visible = false

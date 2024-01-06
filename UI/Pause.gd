extends CanvasLayer

enum State {TRANSITION, MAIN, OPTIONS}
var current_state = State.TRANSITION

const SCROLL_SPEED = 0.75

func _ready():
	$Pause/AnimationPlayer.play("open")
	for node in get_tree().get_nodes_in_group("pause_animator"):
		node.play("idle")
	for button in get_tree().get_nodes_in_group("button"):
		button.connect("mouse_entered",self,"_on_mouse_entered")
	get_tree().paused = true
	
	var _err1 = $Pause/Buttons/Resume.connect("pressed",self,"_on_Resume_pressed")
	var _err2 = $Pause/Buttons/Options.connect("pressed",self,"_on_Options_pressed")
	var _err3 = $Pause/Buttons/Quit.connect("pressed",self,"_on_Quit_pressed")
	
	get_tree().call_group("music","decrease_volume")

func _process(_delta):
	for button in get_tree().get_nodes_in_group("button"):
		if current_state != State.TRANSITION:
			button.disabled = $Tween.is_active()
		else: button.disabled = true

func _input(event):
	if event.is_action_pressed("pause") && !$Tween.is_active():
		match current_state:
			State.MAIN:
				_on_Resume_pressed()
			State.OPTIONS:
				_on_Back_pressed()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "open":
		current_state = State.MAIN
	if anim_name == "close":
		queue_free()
		get_tree().paused = false

func _on_mouse_entered():
	if !$Tween.is_active():
		$HoverSound.play()

func _on_Resume_pressed():
	$Pause/AnimationPlayer.play("close")
	get_tree().call_group("music","increase_volume")

func _on_Options_pressed():
	$Tween.interpolate_property($Pause,"position",$Pause.position,Vector2(1075,0),SCROLL_SPEED,Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	if !$Tween.is_active():
		$Tween.start()
		
		$WooshSound.stream = load("res://Assets/Audio/Sounds/snd_woosh1.wav")
		$WooshSound.play()
	current_state = State.OPTIONS

func _on_Quit_pressed():
	var scene_transition = preload("res://UI/TransitionScreen.tscn")
	var transition = scene_transition.instance()
	get_tree().get_root().add_child(transition)
	transition.new_screen = NodePath("res://Screens/Title.tscn")
	transition.pause_mode = Node.PAUSE_MODE_PROCESS
	transition.layer = 4
	current_state = State.TRANSITION
	
	if get_tree().get_nodes_in_group("music") != []:
		var music = get_tree().get_nodes_in_group("music").front()
		transition.connect("scene_changed",music,"increase_volume")

func _on_Back_pressed():
	$Tween.interpolate_property($Pause,"position",$Pause.position,Vector2.ZERO,SCROLL_SPEED,Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	if !$Tween.is_active():
		$Tween.start()
		
		$WooshSound.stream = load("res://Assets/Audio/Sounds/snd_woosh2.wav")
		$WooshSound.play()
	current_state = State.MAIN

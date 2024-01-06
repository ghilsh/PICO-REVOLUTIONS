extends CanvasLayer

onready var label := $TextboxContainer/MarginContainer/RichTextLabel
onready var name_label := $NameContainer/MarginContainer/Label

enum State {OPENING, READY, READING, FINISHED, CLOSING}
var current_state = State.OPENING

enum Character {PICO, DARNELL, UBERKID, NONE}
var character1 = Character.PICO
var character2 =  Character.DARNELL
var current_character = character1

const SCROLLSPEED = 0.025
var current_portrait = 1
var text_queue = []

signal dialog_closing

func _ready():
	$AnimationPlayer.play("open")
	get_tree().paused = true

func _process(_delta):
	match current_state:
		State.READY:
			display_text()
			$TextboxContainer/Cursor/AnimationPlayer.play("reset")
		State.READING:
			$AnimationPlayer.play("talk-"+String(current_portrait))
			if Input.is_action_just_pressed("progress_dialog") or label.percent_visible == 1:
				label.percent_visible = 1
				$Tween.stop_all()
				change_state(State.FINISHED)
				$AnimationPlayer.play("idle")
		State.FINISHED:
			$TextboxContainer/Cursor.visible = true
			if Input.is_action_just_pressed("progress_dialog"):
				$TextboxContainer/Cursor.visible = false
				if text_queue.empty():
					change_state(State.CLOSING)
					$AnimationPlayer.play("close")
					emit_signal("dialog_closing")
				else: change_state(State.READY)
			$TextboxContainer/Cursor/AnimationPlayer.play("idle")

func _on_Voiceblips_finished():
	play_voiceblip()

func play_voiceblip():
	if current_state == State.READING:
		var stream: AudioStream
		var randint = randi() % 9 + 1
		stream = load("res://Assets/Audio/Sounds/Voiceblips/voiceblip-"+String(randint)+".wav")
		$Voiceblips.set_stream(stream)
		$Voiceblips.play()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "open":
		play_voiceblip()
		change_state(State.READY)
	elif anim_name == "close":
		get_tree().paused = false
		get_tree().call_group("cutscene", "on_dialog_closed")
		queue_free()

func change_state(new_state):
	current_state = new_state

func queue_text(next_text):
	text_queue.push_back(next_text)

func read_file(dialog_path):
	var f = File.new()
	assert(f.file_exists(dialog_path), "OOPSIE: File path for dialog not found sorry!!!!")
	
	f.open(dialog_path, File.READ)
	var json = f.get_as_text()
	
	var output = parse_json(json)
	
	if typeof(output) == TYPE_ARRAY:
		for line in output:
			queue_text(line)
	current_portrait = text_queue[0]["Portrait"]
#	name_label.text = str(Character.keys()[match_current()])

func display_text():
	var next_text = text_queue.pop_front()
	label.bbcode_text = next_text["Text"]
	current_portrait = next_text["Portrait"]
	label.percent_visible = 0.0
	change_state(State.READING)
	$Tween.interpolate_property(label, "percent_visible", 0.0, 1.0, len(label.text) * SCROLLSPEED, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	play_voiceblip()
	current_character = match_current()
	match_character(current_character,current_portrait)

func match_character(new_character,portrait):
	if str(Character.keys()[current_character]) != "NONE":
		$NameContainer.visible = true
	else: $NameContainer.visible = false
	
	get_tree().call_group("portrait","match_character",Character,new_character,portrait)
	
	name_label.text = str(Character.keys()[current_character])

func match_current():
	if current_portrait == 1:
		return character1
	else: return character2

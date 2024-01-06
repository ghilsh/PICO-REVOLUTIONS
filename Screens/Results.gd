extends Node2D

var health_lost = PlayerStats.health_lost
var lives_lost = PlayerStats.deaths
var time_taken = PlayerStats.time_spent

onready var results_list = [$Results/Health,$Results/Life,$Results/Time]
var current_result = 0

enum State {WAITING, READY, REVEAL, COUNTING, FINISHED, RANK, PROGRESS}
var current_state = State.WAITING

var finished_counting = false
var time_display = 0

var rank_points = 5
var rank_color = "ff0000"
onready var rank_noise = $Sounds/Cheer
var rank = "N/A"

var finished = false

func _ready():
	get_tree().call_group("overlay","queue_free")
	get_tree().call_group("music", "change_music", "cutscene")
	$Spotlight/AnimationPlayer.play("idle")
	
	decide_rank()

func decide_rank():
	rank_points = (health_lost / 12) + (lives_lost * 1.5) + (time_taken / 270)
#	print(rank_points)
	
	if rank_points < 1:
		rank = "S"
		rank_color = "00ffff"
		Ngio.request("Medal.unlock", {"id": 76398})
	elif rank_points < 5:
		rank = "A"
		rank_color = "ffff00"
	elif rank_points < 10:
		rank = "B"
		rank_color = "ffff00"
	elif rank_points < 15:
		rank = "C"
		rank_color = "ff0000"
		rank_noise = $Sounds/Fart
	else:
		rank = "D"
		rank_color = "ff0000"
		rank_noise = $Sounds/Fart

func _process(_delta):
	var current_value = set_current_value()
	match current_state:
		State.READY:
			$Sounds/Appear.play()
			reveal_result(results_list[current_result])
			current_state = State.REVEAL
		State.REVEAL:
			if results_list[current_result].modulate == Color(1,1,1,1):
				current_state = State.COUNTING
		State.COUNTING:
			if finished_counting:
				if current_result != 2: results_list[current_result].get_node("Value").text = str(current_value)
				$Timers/StateTimer.start()
				current_state = State.FINISHED
				finished_counting = false
			else: result_count(results_list[current_result].get_node("Value"), current_value)
		State.FINISHED:
			if $Timers/StateTimer.time_left == 0:
				if current_result < (results_list.size() - 1):
					current_result += 1
					current_state = State.READY
				else:
					$Timers/RankTimer.start()
					$Sounds/DrumRoll.play()
					reveal_result($Rank/Label)
					current_state = State.RANK
		State.RANK:
			if $Timers/RankTimer.time_left == 0.0:
				$Timers/ProgressTimer.start()
				rank_noise.play()
				$Rank/Rank.text = rank
				reveal_result($Rank/Rank,rank_color)
				current_state = State.PROGRESS
		State.PROGRESS:
			if $Timers/ProgressTimer.time_left == 0.0:
				reveal_result($Progress)
				finished = true
				current_state = State.WAITING

func _input(event):
	if event.is_action_pressed("shoot") && finished:
		var scene_transition = preload("res://UI/TransitionScreen.tscn")
		var transition = scene_transition.instance()
		get_tree().get_root().add_child(transition)
		transition.new_screen = NodePath("res://Screens/Title.tscn")
		
		finished = false

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "intro":
		$Pico/AnimationPlayer.play("idle")
		current_state = State.READY

func reveal_result(result, color := "ffffff"):
	$Tween.interpolate_property(result, "modulate", Color("00ffffff"), Color(color), 0.5)
	$Tween.start()

func result_count(label, current_value):
	if current_result == 2 && time_count() != null:
		label.text = time_count()
	else:
		if int(results_list[current_result].get_node("Value").text) >= current_value:
			finished_counting = true
			return
		var new_value = int(label.text) + 1
		label.text = str(new_value)
		
	$Sounds/Count.play()

func time_count():
	time_display += 1.23
	
	if time_display >= time_taken: 
		time_display = time_taken
		finished_counting = true
	var time_displayed = time_display
	
	var mils = fmod(time_displayed,1)*1000
	var secs = fmod(time_displayed,60)
	var mins = fmod(time_displayed, 60*60)/60
	
	var time_calculated = "%02d:%02d:%03d" % [mins, secs, mils]
	return str(time_calculated)

func set_current_value():
	match current_result:
		0: return health_lost
		1: return lives_lost
		2: return time_taken

func _on_IntroTimer_timeout():
	$Pico/AnimationPlayer.play("intro")

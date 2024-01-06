extends VBoxContainer

func _ready():
	var _err96 = $Music.connect("pressed",self,"_on_Music_pressed")
	var _err97 = $Fullscreen.connect("pressed",self,"_on_Fullscreen_pressed")
	var _err98 = $Timer.connect("pressed",self,"_on_Timer_pressed")
	var _err99 = $Back.connect("pressed",self,"_on_Back_pressed")

func _process(_delta):
	var music_text = "N/A"
	match Config.music_enabled:
		true:
			music_text = "ON"
		false:
			music_text = "OFF"
	$Music.text = "MUSIC: "+String(music_text)
	
	var fullscreen_text = "N/A"
	match OS.window_fullscreen:
		true:
			fullscreen_text = "ON"
		false:
			fullscreen_text = "OFF"
	$Fullscreen.text = "FULLSCREEN: "+String(fullscreen_text)
	
	var timer_text = "N/A"
	match Config.timer_enabled:
		true:
			timer_text = "ON"
		false:
			timer_text = "OFF"
	$Timer.text = "TIMER: "+String(timer_text)

func _on_Music_pressed():
	Config.music_enabled = !Config.music_enabled

func _on_Fullscreen_pressed():
	OS.window_fullscreen = !OS.window_fullscreen

func _on_Timer_pressed():
	Config.timer_enabled = !Config.timer_enabled

func _on_Back_pressed():
	get_tree().call_group("menu", "_on_Back_pressed")

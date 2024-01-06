extends Node

var current_music := ""
var normal_volume = 0
var decreased_volume = -20
var music_volume = 0

func _process(_delta):
	if Config.music_enabled:
		$MusicPlayer.volume_db = music_volume
	else: $MusicPlayer.volume_db = -80

func change_music(new_music: String):
	var stream: AudioStreamSample
	stream = load("res://Assets/Audio/Music/mus_"+new_music+".wav")
	if new_music != current_music:
		$MusicPlayer.set_stream(stream)
		$MusicPlayer.play()
		current_music = new_music
	if music_volume < -20:
		music_volume = 0

func stop_music():
	$MusicPlayer.set_stream(null)

func decrease_volume():
	$Tween.interpolate_property(self,"music_volume",normal_volume,decreased_volume,0.3)
	$Tween.start()

func increase_volume():
	$Tween.interpolate_property(self,"music_volume",decreased_volume,normal_volume,0.3)
	$Tween.start()

func fade_volume(time_taken):
	$Tween.interpolate_property(self,"music_volume",normal_volume,-80,time_taken)
	$Tween.start()
	
	$Timer.wait_time = time_taken
	$Timer.start()

func _on_Timer_timeout():
	music_volume = 0
	stop_music()

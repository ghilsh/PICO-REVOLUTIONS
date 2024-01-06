extends Node

export (String) var song = "main"

func _ready():
	if get_tree().get_nodes_in_group("music") == []:
		var scene_music = preload("res://Music/MusicController.tscn")
		var music = scene_music.instance()
		get_tree().get_root().call_deferred("add_child",music)
	
	if song != "":
		get_tree().call_group("music","change_music",song)
	else: get_tree().call_group("music","queue_free")

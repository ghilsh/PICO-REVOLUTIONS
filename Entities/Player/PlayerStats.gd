extends "res://Entities/Stats.gd"

var entrance_tag = 0
var deaths = 0 setget set_deaths
export(String, FILE, "*.tscn") var checkpoint = ""
var checkpoint_tag = 0
var time_spent = 0.0
var timer_on = false
var first_time = true

var keys = 0
var keys_saved = 0
var keys_pickedup = []
var keys_pickedup_saved = []
var doors_opened = []
var doors_opened_saved = []

signal deaths_changed

func _process(delta):
	if timer_on:
		time_spent += delta

func reset():
	health = max_health
	entrance_tag = 0
	deaths = 0
	time_spent = 0.0
	timer_on = false
	health_lost = 0
	checkpoint = "res://Screens/Rooms/Room1.tscn"
	checkpoint_tag = 0
	keys = 0
	keys_saved = 0
	keys_pickedup = []
	keys_pickedup_saved = []
	doors_opened = []
	doors_opened_saved = []

func set_deaths(value):
	deaths = value
	emit_signal("deaths_changed", deaths)

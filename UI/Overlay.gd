extends CanvasLayer

var hearts = 4 setget set_hearts
var max_hearts = 4

onready var full = $Hearts/Full
onready var empty = $Hearts/Empty
onready var deaths = $Deaths/Label
onready var timer = $Timer/Label

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if full != null:
		full.rect_size.x = hearts * 64
	if empty != null:
		empty.rect_size.x = max_hearts * 64

func set_deaths(value):
	if value >= 10:
		deaths.text = "x"+str(value)
	else: deaths.text = "x0"+str(value)

func set_timer():
	var time = PlayerStats.time_spent
	
	var mils = fmod(time,1)*1000
	var secs = fmod(time,60)
	var mins = fmod(time, 60*60)/60
	
	var time_passed = "%02d:%02d:%03d" % [mins, secs, mils]
	timer.text = time_passed

func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
# warning-ignore:return_value_discarded
	PlayerStats.connect("health_changed", self, "set_hearts")
# warning-ignore:return_value_discarded
	PlayerStats.connect("deaths_changed", self, "set_deaths")

func _process(_delta):
	$Timer.visible = Config.timer_enabled
	set_timer()

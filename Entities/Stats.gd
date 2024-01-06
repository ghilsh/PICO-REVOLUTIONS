extends Node

export(int) var max_health = 1
var health = max_health setget set_health
var health_lost = 0

signal no_health
signal health_changed

func set_health(value):
	if health > value && max_health >= health:
		health_lost += 1
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")

func _ready():
	self.health = max_health

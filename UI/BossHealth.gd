extends CanvasLayer

func _process(_delta):
	$Health.value = owner.stats.health
	$Health.max_value = owner.stats.max_health

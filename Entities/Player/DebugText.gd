extends Node2D

func _process(_delta):
	$Stats.text = "HEALTH: "+str(owner.stats.health)+"\nSPEED: "+str(owner.speed)+"\nSTATE: "+str(owner.current_state)

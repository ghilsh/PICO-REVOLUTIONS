extends StaticBody2D

var current_target
var active = false

const BEAMPOWER = 1
const KNOCKBACKPOWER = 1000

export(float) var idle_time = 1.0
export(float) var active_time = 1.0

func _ready():
	$AnimationPlayer.play("active")
	
	if idle_time > 0.0:
		$Timers/IdleTimer.wait_time = idle_time
		$Timers/ActiveTimer.wait_time = active_time
		
		$Timers/ActiveTimer.start()

func _physics_process(delta):
	if get_parent() is PathFollow2D:
		get_parent().set_offset(get_parent().get_offset() + 500 * delta)

func _on_HurtBox_body_entered(body):
	if body.is_in_group("player"):
		if current_target != body:
			body.connect("new_name",self,"player_hit_check")
			current_target = body
			active = true
			player_hit_check(current_target.state_name)

func _on_HurtBox_body_exited(body):
	if body.is_in_group("player"):
		body.disconnect("new_name",self,"player_hit_check")
		current_target = null
		active = false

func player_hit_check(new_state):
	if active && new_state != "jump" && new_state != "death" && new_state != "fall":
		var knockback_direction = Vector2.LEFT
		if current_target.position.x > position.x:
			knockback_direction = Vector2.RIGHT
		
		current_target.set_knockback(knockback_direction * KNOCKBACKPOWER)
		current_target.hit(BEAMPOWER)

func _on_IdleTimer_timeout():
	$AnimationPlayer.play("active")
	$Timers/ActiveTimer.start()

func _on_ActiveTimer_timeout():
	$AnimationPlayer.play("idle")
	$Timers/IdleTimer.start()

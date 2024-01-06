extends KinematicBody2D

export var path_to_player := NodePath()
export var alert_zone := NodePath()

onready var player := get_node(path_to_player)
onready var agent := get_node("NavigationAgent2D")
onready var stats := $Stats

var states_stack = []
var current_state = null

var player_nearby = false
var player_onscreen = false
var on_ground = true
var dead = false

onready var states_map = {
	"idle": $States/Idle,
	"alert": $States/Alert,
	"chase": $States/Chase,
	"range": $States/Range,
	"death": $States/Death,
	"spawn": $States/Spawn
}

const SPEED = 350
const FRICTION = 75
const COLLIDEPOWER = 1

var knockback := Vector2.ZERO

func _ready():
	for state_node in $States.get_children():
		state_node.connect("finished", self, "change_state")
	
	states_stack.push_front($States/Idle)
	current_state = states_stack[0]
	change_state("idle")
	
	var _err2 = get_node(alert_zone).connect("body_entered", self, "_on_AlertZone_body_entered")
	var _err3 = get_node(alert_zone).connect("body_exited", self, "_on_AlertZone_body_exited")
	var _err4 = stats.connect("no_health", self, "_on_Stats_no_health")
	var _err5 = $Timers/PathfindingTimer.connect("timeout", self, "_on_PathfindingTimer_timeout")

func _physics_process(_delta):
	var state_name = current_state.update()
	if state_name:
		change_state(states_stack)
	
	$PlayerPointer.look_at(player.position)
	
	process_knockback()

func _input(_event):
	current_state.handle_input(_event)

func change_state(state_name):
	current_state.exit()
	
	if state_name == "previous":
		states_stack.pop_front()
	elif state_name in ["jump"]:
		states_stack.push_front(states_map[state_name])
	else:
		var new_state = states_map[state_name]
		states_stack[0] = new_state
	
	if state_name == "jump" && not current_state.get("speed") == null:
		$States/Jump.initialize(current_state.speed, current_state.input_direction)
	
	current_state = states_stack[0]
	if state_name != "previous":
		current_state.enter()

func hit(damage):
	if current_state.has_method("hit"):
		current_state.hit(damage)
	var knockback_vector = player.get_knockback_vector()
	knockback = knockback_vector * 1000

func process_knockback():
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION)
	if on_ground == false && $Stats.health != 0:
		$Stats.health = 0
#		knockback = Vector2.ZERO
	knockback = move_and_slide(knockback)

func _on_AnimationPlayer_animation_finished(anim_name):
	current_state._on_animation_finished(anim_name)

func _on_PathfindingTimer_timeout():
	agent.set_target_location(player.global_position)

func _on_HurtBox_body_entered(body):
	if body.is_in_group("player"):
		if $Timers/CooldownTimer.time_left == 0.0:
			get_tree().call_group("player", "hit", COLLIDEPOWER)
			var knockback_vector = ($PlayerPointer/Position2D.global_position - $PlayerPointer.global_position).normalized()
			body.set_knockback(knockback_vector * 750)
			$Timers/CooldownTimer.start()

func _on_AlertZone_body_entered(body):
	if body.is_in_group("player"):
		player_nearby = true

func _on_AlertZone_body_exited(body):
	if body.is_in_group("player"):
		player_nearby = false

func _on_Stats_no_health():
	current_state.emit_signal("finished", "death")

func _on_VisibilityNotifier2D_screen_entered():
	if dead == false:
		player_onscreen = true
		current_state.emit_signal("finished", "alert")

func _on_VisibilityNotifier2D_screen_exited():
	if dead == false:
		player_onscreen = false
		current_state.emit_signal("finished", "idle")

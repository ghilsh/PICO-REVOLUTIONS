extends KinematicBody2D

var knockback := Vector2.ZERO
var on_ground := true
var player

const SPEED = 250
const FRICTION = 75
const COLLIDEPOWER = 1

var states_stack = []
var current_state = null

onready var agent := get_node("NavigationAgent2D")
onready var stats := get_node("Stats")
onready var states_map = {
	"intro": $States/Intro,
	"chase": $States/Chase,
	"teleport": $States/Teleport,
	"range": $States/Range,
	"slidecharging": $States/SlideCharging,
	"slide": $States/Slide,
	"summon": $States/Summon,
	"death": $States/Death
}

func _ready():
	for state_node in $States.get_children():
		state_node.connect("finished", self, "change_state")
	
	states_stack.push_front($States/Intro)
	current_state = states_stack[0]
	change_state("intro")
	
	player = get_tree().get_nodes_in_group("player").front()
	
	var _err0 = stats.connect("no_health", self, "_on_Stats_no_health")

func _physics_process(_delta):
	var state_name = current_state.update()
	if state_name:
		change_state(states_stack)
	
	$PlayerPointer.look_at(player.position)

func _on_AnimationPlayer_animation_finished(anim_name):
	current_state._on_animation_finished(anim_name)

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
	knockback = knockback_vector * 500

func process_knockback(): # UNUSED, TOO EASY TO CHEESE
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION)
	knockback = move_and_slide(knockback)

func play_animation(anim):
	$AnimationPlayer.play(anim)

func _on_PathfindingTimer_timeout():
	agent.set_target_location(player.global_position)

func _on_Stats_no_health():
	current_state.emit_signal("finished", "death")

func _on_HurtBox_body_entered(body):
	if body.is_in_group("player"):
		if $Timers/CooldownTimer.time_left == 0.0:
			get_tree().call_group("player", "hit", COLLIDEPOWER)
			var knockback_vector = ($PlayerPointer/Position2D.global_position - $PlayerPointer.global_position).normalized()
			body.set_knockback(knockback_vector * 750)
			$Timers/CooldownTimer.start()

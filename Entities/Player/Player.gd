extends KinematicBody2D

var speed = 0.0
var jumpspeed_x = 0
var jumpspeed_y = 0
var on_ground = true
var invincible = false

const MAXSPEED = 400
const ACCELERATION = 40
const DECELERATION = 30
const JUMPACCELERATION = 20
const JUMPDECELERATION = 10
const AIRSTEERINGPOWER = 25
const CONVEYORSPEED = 6

const MAXHEALTH = 50
const GUNPOWER = 1
const FRICTION = 75

var states_stack = []
var current_state = null
var state_name = "idle"
var start_pos := Vector2.ZERO
var knockback := Vector2.ZERO

signal new_name

onready var stats = PlayerStats
onready var states_map = {
	"idle": $States/Idle,
	"move": $States/Move,
	"jump": $States/Jump,
	"fall": $States/Fall,
	"death": $States/Death,
	"blocked": $States/Blocked
}

func _ready():
	var _err0 = stats.connect("no_health", self, "_on_Stats_no_health")
	
	for state_node in $States.get_children():
		state_node.connect("finished", self, "change_state")
	
	if get_tree().get_nodes_in_group("overlay") == []:
		var scene_overlay = preload("res://UI/Overlay.tscn")
		var overlay = scene_overlay.instance()
		owner.get_tree().get_root().call_deferred("add_child",overlay)
	
	states_stack.push_front($States/Idle)
	current_state = states_stack[0]
	change_state("idle")
	
	if stats.health <= 0:
		stats.health = stats.max_health
		stats.entrance_tag = PlayerStats.checkpoint_tag
	
	PlayerStats.timer_on = true
	
	start_pos = position

func _physics_process(_delta):
	var new_state = current_state.update()
	if new_state:
		change_state(states_stack)
	
	if state_name != "blocked":
		if ($Gun.rotation_degrees < 90 or $Gun.rotation_degrees > 270):
			$Sprite.scale.x = 1
		else: $Sprite.scale.x = -1
	
	get_tree().call_group("fireball", "follow", position)
	
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION)
	knockback = move_and_slide(knockback)
	
	if state_name == "move":
		if $Sounds/Walk.playing == false:
			$Sounds/Walk.play()
	else: $Sounds/Walk.stop()

func _input(_event):
	current_state.handle_input(_event)
	if _event.is_action_pressed("pause"):
		var scene_pause = preload("res://UI/Pause.tscn")
		var pause = scene_pause.instance()
		get_tree().get_root().add_child(pause)

func change_state(new_name, new_direction := Vector2.ZERO):
	current_state.exit()
	new_state_name(new_name)
	
	if new_name == "previous":
		states_stack.pop_front()
	elif new_name in ["jump"]:
		states_stack.push_front(states_map[new_name])
	else:
		var new_state = states_map[new_name]
		states_stack[0] = new_state
	
	if new_name == "idle" && not current_state.get("idle_direction") == null:
		$States/Idle.initialize(current_state.idle_direction)
	
	current_state = states_stack[0]
	if new_name != "previous":
		current_state.enter()
	if new_name == "blocked":
		current_state.direction = new_direction

func _on_AnimationPlayer_animation_finished(anim_name):
	current_state._on_animation_finished(anim_name)

func hit(damage):
	if current_state.has_method("hit") and !invincible:
		current_state.hit(damage)
		$Timers/InvincibleTimer.start()
		invincible = true

func play_animation(anim):
	$AnimationPlayer.play(anim)

func conveyor_movement(direction):
	if current_state.has_method("conveyor_movement"):
		current_state.conveyor_movement(direction)
		position += direction * CONVEYORSPEED # this being here also is an oversight but it ended up feeling better with it anyway

func _on_Stats_no_health():
	current_state.call_deferred("emit_signal","finished", "death")

func new_state_name(new_state): # USED IN FIREBALL CODE
	state_name = new_state
	emit_signal("new_name",new_state)

func get_knockback_vector():
	if $Gun/RayCast2D.is_colliding():
		return ($Gun/RayCast2D.get_collision_point() - $Gun/RayCast2D.global_position).normalized()

func set_knockback(new_knockback): # CALL BEFORE HIT(), OTHERWISE INVINCIBLE WILL BE TRUE
	if !invincible:
		knockback = new_knockback

func _on_InvincibleTimer_timeout():
	invincible = false

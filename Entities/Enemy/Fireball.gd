extends KinematicBody2D

onready var time_following = $Timers/TimeFollowing
onready var time_active = $Timers/TimeActive

var target_pos := Vector2.ZERO
var following := true
var active := false
var current_target

const SPEED = 5
const FIREBALLPOWER = 1

func _ready():
	$AnimationPlayer.play("begin")

func _process(_delta):
	if rotation_degrees > 360:
		rotation_degrees = 0
	elif rotation_degrees < 0:
		rotation_degrees = 360

func follow(pos):
	if following:
		var player_pos = pos
		look_at(player_pos)
		position = position.move_toward(player_pos, SPEED)
		target_pos = $Pointer.global_position
	else: position = position.move_toward(target_pos, SPEED)
	
	if time_active.time_left == 0:
		$AnimationPlayer.play("end")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "end":
		queue_free()

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		if current_target != body:
			body.connect("new_name",self,"player_hit_check")
			current_target = body
			active = true
			player_hit_check(current_target.state_name)

func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		body.disconnect("new_name",self,"player_hit_check")
		current_target = null
		active = false

func _on_TimeFollowing_timeout():
	following = false

func player_hit_check(new_state):
	if active && new_state != "jump" && new_state != "death" && new_state != "fall":
		var audio = AudioStreamPlayer.new()
		current_target.get_parent().add_child(audio)
		audio.stream = load("res://Assets/Audio/Sounds/snd_flame.wav")
		audio.connect("finished",audio,"queue_free")
		audio.play()
		
		var scene_particles = preload("res://Entities/Enemy/FireballParticles.tscn")
		var particles = scene_particles.instance()
		current_target.get_parent().add_child(particles)
		particles.position = position
		particles.get_node("Timer").connect("timeout",particles,"queue_free")
		particles.get_node("Particles2D").emitting = true
		
		current_target.set_knockback((($Pointer.global_position - position).normalized()) * 750)
		current_target.hit(FIREBALLPOWER)
		queue_free()
	else: following = false

class_name ChasePlayer
extends Node

@export var max_speed: float = 250.0
@export var acceleration: float = 500.0
@export var preferred_distance: float = 300.0
@export var orbit_speed_multiplier: float = 0.7
@export var max_distance: float = 800.0

@export_group("Natural Movement & Anti-Swarm")
@export var separation_distance: float = 90.0
@export var separation_weight: float = 250.0
@export var weave_amplitude: float = 100.0
@export var weave_frequency: float = 4.0

@onready var player: Node2D = get_tree().get_first_node_in_group("Player")
@onready var body: CharacterBody2D = get_parent() as CharacterBody2D

var orbit_direction: int = 1
var time_offset: float = 0.0

func _ready() -> void:
	if not body:
		push_warning("ChasePlayer component must be a child of a CharacterBody2D!")
	
	orbit_direction = 1 if randf() > 0.5 else -1
	time_offset = randf() * 50.0

func _physics_process(delta: float) -> void:
	if not player or not body: 
		return
	
	var to_player = player.global_position - body.global_position
	var distance = to_player.length()
	var dir_to_player = to_player.normalized()
	var tangent = Vector2(-dir_to_player.y, dir_to_player.x) * orbit_direction
	
	var target_velocity = Vector2.ZERO
	
	if distance > max_distance:
		body.global_position = player.global_position - dir_to_player * max_distance
	elif distance > preferred_distance + 40.0:
		# Too far
		target_velocity = dir_to_player * max_speed
	elif distance < preferred_distance - 40.0:
		# Too close
		target_velocity = -dir_to_player * max_speed
	else:
		target_velocity = tangent * (max_speed * orbit_speed_multiplier)
	
	# Add organic dodging/weaving via a perpendicular sine wave offset
	var time = Time.get_ticks_msec() / 1000.0 + time_offset
	var weave = tangent * sin(time * weave_frequency) * weave_amplitude
	target_velocity += weave
	
	# Add separation force to prevent enemies from stacking on top of each other
	var separation = _get_separation_force()
	target_velocity += separation * separation_weight
	
	# Smoothly steer current velocity towards the target velocity
	body.velocity = body.velocity.move_toward(target_velocity, acceleration * delta)
	
	# Always keep weapons/nose pointed at the player while hovering or chasing
	body.look_at(player.global_position)
	body.move_and_slide()

func _get_separation_force() -> Vector2:
	var separation = Vector2.ZERO
	var enemies = get_tree().get_nodes_in_group("Enemy")
	
	for other in enemies:
		if other == body or not is_instance_valid(other):
			continue
		
		var d = body.global_position.distance_to(other.global_position)
		if d < separation_distance and d > 0:
			var push_dir = (body.global_position - other.global_position).normalized()
			separation += push_dir * (1.0 - (d / separation_distance))
			
	return separation

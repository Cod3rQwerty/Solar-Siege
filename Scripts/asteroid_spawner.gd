extends Node2D

@export var AsteroidPrefab: PackedScene = preload("res://Scenes/Big-Asteroid.tscn")
@export var seconds_per_asteroid: float = 0.9:
	set(value):
		seconds_per_asteroid = value
		# If the timer exists, update its wait time immediately when this variable changes
		if timer:
			timer.wait_time = seconds_per_asteroid
@export var max_asteroid_speed: float = 200.0
@export var min_asteroid_speed: float = 50.0
@export var angle_variance: float = 15.0
@export var max_angular_velocity: float = 10.0

@onready var timer: Timer = $Timer
@onready var player: CharacterBody2D = %Player

func get_random_point_at_distance(center: Vector2, z: float) -> Vector2:
	return center + Vector2.from_angle(randf_range(0, TAU)) * z

func _ready() -> void:
	timer.wait_time = seconds_per_asteroid
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
	spawn_asteroid()

func spawn_asteroid() -> void:
	var asteroid_instance: Area2D = AsteroidPrefab.instantiate()
	
	# Spawn at a random point around the player
	asteroid_instance.global_position = get_random_point_at_distance(
		player.global_position,
		800
	)
	
	
	# Get the angle pointing from the asteroid to the player (in RADIANS)
	var angle_to_player = asteroid_instance.global_position.angle_to_point(player.global_position)
	
	asteroid_instance.rotation = angle_to_player
	
	# Make them fly towards the player
	asteroid_instance.velocity = Vector2.from_angle(angle_to_player + deg_to_rad(randf_range(0 - angle_variance, angle_variance))) * randf_range(min_asteroid_speed, max_asteroid_speed)
	
	# Give random spin
	asteroid_instance.rotation_speed = randf_range(0 - max_angular_velocity, max_angular_velocity)
	
	get_tree().current_scene.add_child(asteroid_instance)

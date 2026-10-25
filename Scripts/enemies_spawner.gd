extends Node2D

@export var EnemyPrefab: PackedScene = preload("res://Scenes/BaseEnemy.tscn")
@export var max_seconds_per_enemy: float = 10:
	set(value):
		max_seconds_per_enemy = value
		# If the timer exists, update its wait time immediately when this variable changes
		if timer:
			timer.wait_time = max_seconds_per_enemy
@export var min_seconds_per_enemy: float = 2

@onready var timer: Timer = $Timer
@onready var player: CharacterBody2D = %Player

func get_random_point_at_distance(center: Vector2, z: float) -> Vector2:
	return center + Vector2.from_angle(randf_range(0, TAU)) * z

func _ready() -> void:
	timer.wait_time = max_seconds_per_enemy
	timer.timeout.connect(_on_timer_timeout)

func _process(delta: float) -> void:
	timer.wait_time = clamp(5000.0 / GameManager.Score, min_seconds_per_enemy, max_seconds_per_enemy)
	print(timer.wait_time)
	print(randi_range(1, 2))

func _on_timer_timeout() -> void:
	var together: bool = randf() > 0.5
	var pos: Vector2 = get_random_point_at_distance(
		player.global_position,
		800
		)
	for i in range(randi_range(1, 1 + ceil(GameManager.Score / 1000.0))):

		spawn_enemy(pos if together else Vector2(0, 0))

func spawn_enemy(pos: Vector2 = Vector2(0, 0)) -> void:
	var enemy_instance: CharacterBody2D = EnemyPrefab.instantiate()
	
	if pos:
		enemy_instance.global_position = pos
	else:
		enemy_instance.global_position = get_random_point_at_distance(
			player.global_position,
			800
		)

	get_tree().current_scene.add_child(enemy_instance)

class_name Asteroid
extends Area2D

@export var starting_health: int = 100
@export var velocity: Vector2 = Vector2(50, 20)
@export var rotation_speed: float = 1.5
@export var damage: int = 50

@onready var health_component: HealthComponent = $HealthComponent
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var death_sound: AudioStreamPlayer2D = $DeathSound

@onready var current_animation_name = Array(animated_sprite_2d.sprite_frames.get_animation_names()).pick_random()
@onready var frame_count = animated_sprite_2d.sprite_frames.get_frame_count(current_animation_name)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_component.max_health = starting_health
	
	animated_sprite_2d.play(current_animation_name)
	animated_sprite_2d.stop()
	
func _on_died() -> void:
	death_sound.play()
	GameManager.Score += 20
	for child in get_children():
		if !child == death_sound:
			child.queue_free()
	await death_sound.finished
	
	queue_free()
	
func _physics_process(delta: float) -> void:
	position += velocity * delta
	rotation += rotation_speed * delta

func _on_health_component_damaged(amount: int) -> void:
	var health_percentage: float = (health_component.current_health / float(starting_health)) * 100
	var animation_frame: int = frame_count - floor(health_percentage / (100.0 / frame_count)) - 1
	
	animated_sprite_2d.frame = animation_frame

extends CharacterBody2D

@export var acceleration: float = 50.0
@export var max_speed: float = 600.0
@export var air_resistance: float = 20.0

@onready var laser_shooter: LaserShooter = $LaserShooter
@onready var fire_rate_timer: Timer = $FireRateTimer
@onready var health_component: HealthComponent = $HealthComponent
@onready var camera_2d: Camera2D = $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	print(health_component.current_health)
	if Input.is_action_pressed("shoot"):
		if fire_rate_timer.is_stopped():
			laser_shooter.shoot_laser()
			fire_rate_timer.start()
	
func _physics_process(delta: float) -> void:
	var direction_x: float = Input.get_axis("move-left", "move-right")
	var direction_y: float = Input.get_axis("move-up", "move-down")
	
	var new_velocity_x: float
	var new_velocity_y: float
	
	if direction_x:
		new_velocity_x = clamp(velocity.x + direction_x * acceleration, 0-max_speed, max_speed)
	else :
		new_velocity_x = move_toward(velocity.x, 0, air_resistance) 
	
	if direction_y:
		new_velocity_y = clamp(velocity.y + direction_y * acceleration, 0-max_speed, max_speed)
	else :
		new_velocity_y = move_toward(velocity.y, 0, air_resistance) 
	
	
	velocity = Vector2(new_velocity_x, new_velocity_y)
	
	look_at(get_global_mouse_position())
	
	move_and_slide()

func heal(amount: int):
	health_component.heal(amount)

func _on_health_component_died() -> void:
	GameManager.game_over()

func _on_damage_component_on_damage_taken(damage_taken: float) -> void:
	camera_2d.apply_shake(damage_taken * 3)

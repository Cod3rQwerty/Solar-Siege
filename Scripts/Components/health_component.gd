class_name HealthComponent
extends Node

signal died
signal health_changed(current_health: int, max_health: int)
signal damaged(amount: int)
signal healed(amount: int)

@export var max_health: int = 100
@export var delete_on_death: bool = false

@onready var current_health: int = max_health
@onready var parent_node: Node = get_parent()

func _ready() -> void:
	current_health = max_health

func take_damage(amount: int) -> void:
	if current_health <= 0 or amount <= 0:
		return
		
	current_health = maxi(0, current_health - amount)
	damaged.emit(amount)
	health_changed.emit(current_health, max_health)
	
	if current_health == 0:
		died.emit()
		if delete_on_death:
			get_parent().queue_free()

func heal(amount: int) -> void:
	if current_health <= 0 or amount <= 0:
		return
		
	current_health = mini(max_health, current_health + amount)
	healed.emit(amount)
	health_changed.emit(current_health, max_health)

func is_dead() -> bool:
	return current_health <= 0

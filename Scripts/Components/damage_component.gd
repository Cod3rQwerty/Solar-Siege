class_name DamageComponent
extends Area2D

@export var Health_Component: HealthComponent

signal on_damage_taken(damage_taken: float)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_area_entered)

func _area_entered(area: Area2D):
	if !(area is Asteroid or area is Laser):
		return
	
	var damage_taken = area.damage
	on_damage_taken.emit(damage_taken)
	Health_Component.take_damage(damage_taken)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

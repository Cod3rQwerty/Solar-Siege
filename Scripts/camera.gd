extends Camera2D

@export var default_shake_strength: float = 30.0
@export var shake_fade: float = 5.0

var shake_strength: float = 0.0

func apply_shake(strength: float = -1.0) -> void:
	if strength > 0:
		shake_strength = strength
	else:
		shake_strength = default_shake_strength

func _process(delta: float) -> void:
	if shake_strength > 0:
		shake_strength = lerp(shake_strength, 0.0, shake_fade * delta)
		offset = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)
	else:
		offset = Vector2.ZERO
		

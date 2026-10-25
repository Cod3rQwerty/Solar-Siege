class_name HitAnimationComponent
extends Node

@export var damage_component: DamageComponent
@export var target_node: Node2D ## The node to animate (owner if left blank)
@export var hit_scale_multiplier: float = 0.75 ## How small it shrinks (0.75 = 75% of original size)
@export var flash_duration: float = 0.15

var _original_scale: Vector2
var _tween: Tween

func _ready() -> void:
	if not damage_component:
		damage_component = owner.get_node_or_null("DamageComponent")
		if not damage_component:
			push_error("HitFlashComponent: No DamageComponent found on owner!")
			return

	if not target_node:
		if owner is Node2D:
			target_node = owner as Node2D
		else:
			target_node = owner.find_child("*Sprite*", true, false) as Node2D
			
	if target_node:
		_original_scale = target_node.scale
	else:
		push_warning("HitFlashComponent: No Node2D target found to scale.")

	damage_component.on_damage_taken.connect(_on_damage_taken)

func _on_damage_taken(_damage_taken: float) -> void:
	if not target_node:
		return

	if _tween and _tween.is_valid():
		_tween.kill()

	_tween = create_tween().set_parallel(false)
	
	_tween.tween_property(target_node, "scale", _original_scale * hit_scale_multiplier, flash_duration * 0.3)\
		.set_ease(Tween.EASE_OUT)
		
	_tween.tween_property(target_node, "scale", _original_scale, flash_duration * 0.7)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_SPRING)

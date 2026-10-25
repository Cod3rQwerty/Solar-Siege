class_name HealthBarComponent
extends Node2D

@export var always_horizontal: bool = true
@export var health_component: HealthComponent
@export var health_bar_sprite: AnimatedSprite2D

var number_of_health_bar_sprites: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not health_bar_sprite:
		if has_node("AnimatedSprite2D"): health_bar_sprite = $AnimatedSprite2D
	
	var anim_name: String = health_bar_sprite.sprite_frames.get_animation_names()[0]
	number_of_health_bar_sprites = health_bar_sprite.sprite_frames.get_frame_count(anim_name)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if always_horizontal:
		global_rotation = 0
	
	var health_proportion = health_component.current_health / float(health_component.max_health)
	health_bar_sprite.frame = number_of_health_bar_sprites - floor(number_of_health_bar_sprites * health_proportion)

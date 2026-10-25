class_name LaserShooter
extends Node2D

@export var LaserNode: PackedScene
@export var SpreadDegrees: float = 0
@export var ShootAudio: AudioStreamPlayer2D

signal laser_shot

func shoot_laser():
	if not LaserNode:
		push_warning(get_parent().name, " LaserShooter: No LaserNode provided!")
		return
	
	laser_shot.emit()
	
	if ShootAudio:
		ShootAudio.play()
	
	var new_laser: Area2D = LaserNode.instantiate()
	
	new_laser.global_position = global_position
	new_laser.global_rotation = global_rotation + deg_to_rad(randf_range(0 - SpreadDegrees, SpreadDegrees/2))
	
	get_tree().current_scene.add_child(new_laser)
	

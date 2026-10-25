extends CharacterBody2D

@onready var laser_shooter: LaserShooter = $LaserShooter
@onready var death_sound: AudioStreamPlayer2D = $DeathSound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

var time_since_last: float = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_since_last += delta
	
	if time_since_last > 0.3 and laser_shooter:
		laser_shooter.shoot_laser()
		time_since_last = 0


func _on_died() -> void:
	death_sound.play()
	GameManager.Score += 40
	GameManager.heal_player(10)
	for child in get_children():
		if !child == death_sound:
			child.queue_free()
	await death_sound.finished
	
	queue_free()

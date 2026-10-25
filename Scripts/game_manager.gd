extends Node

const HS_SAVE_PATH = "user://highscore.save"
var Score: int = 0
var HighScore: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var file := FileAccess.open(HS_SAVE_PATH, FileAccess.READ)
	if file:
		HighScore = file.get_64()
		print("Saved highscore:", HighScore)

func game_over():
	if Score > HighScore:
		HighScore = Score
		var file := FileAccess.open(HS_SAVE_PATH, FileAccess.WRITE)
		if file:
			file.store_64(Score)
			file.close()
	
	get_tree().change_scene_to_file("res://death_screen.tscn")
		
func restart():
	Score = 0
	get_tree().change_scene_to_file("res://Game.tscn")

func heal_player(amount: int):
	var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
	if player:
		player.heal(amount)

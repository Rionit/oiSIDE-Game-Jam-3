extends Node3D

const HALLWAY_LEVEL = preload("uid://c582tbim68s0a")

@onready var buddy_player: AnimationPlayer = $buddy/AnimationPlayer

var money_picked: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buddy_player.play("stealing")
	AudioManager.play_sfx("hallway")
	AudioManager.play_bgm("heist_music_calm", 0.0)

func on_money_picked(interactable: Interactable):
	money_picked += 1
	interactable.queue_free()
	AudioManager.play_sfx("cash")
	
	if money_picked > 45:
		AudioManager.stop_bgm(0.0)
		get_tree().change_scene_to_packed(HALLWAY_LEVEL)
		

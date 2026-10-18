extends Node3D

const VAULT_PLOT_TWIST_LEVEL = preload("uid://uxuu4xa1ct14")

@onready var buddy_player: AnimationPlayer = $buddy/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buddy_player.play("come")
	AudioManager.play_sfx("roof")
	AudioManager.play_bgm("heist_music_intense", 0.0)

func _on_exit_area_body_entered(body: Node3D) -> void:
	if body is PlayerController:
		AudioManager.stop_bgm(0.0)
		get_tree().change_scene_to_packed.call_deferred(VAULT_PLOT_TWIST_LEVEL)

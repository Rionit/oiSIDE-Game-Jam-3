extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	AudioManager.play_sfx("gun")
	animation_player.play("end_credits")

func music():
	AudioManager.play_bgm("end_credits", 0.0)

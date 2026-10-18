extends Node3D

const VAULT_STEAL_MONEY_LEVEL = preload("uid://vi7rxhvt1kwi")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var buddy_movement_player: AnimationPlayer = $BuddyMovementPlayer
@onready var buddy_player: AnimationPlayer = $buddy/AnimationPlayer
@onready var first_person_player: PlayerController = $FirstPersonPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buddy_movement_player.play("buddy_movement")
	buddy_player.play("crawling")
	animation_player.animation_finished.connect(finish_scene)
	AudioManager.play_sfx("scene_vent")
	AudioManager.play_sfx("crawling")
	AudioManager.play_bgm("cyberpunk_heist_music", 0.0)

func start_bullet_holes_animation(body):
	if body is PlayerController:
		AudioManager.stop_bgm(0.0)
		first_person_player.can_walk = false
		animation_player.play("bullets")
		
func finish_scene(_whatevr):
	get_tree().change_scene_to_packed(VAULT_STEAL_MONEY_LEVEL)
	
func bullet():
	AudioManager.play_sfx("gun")

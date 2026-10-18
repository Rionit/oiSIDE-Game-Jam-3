extends Node3D

const WIFE_LEVEL = preload("uid://bo6ljgi40lqcs")

@onready var duffle_bag_flipped: Node3D = $duffle_bag_flipped
@onready var buddy_player: AnimationPlayer = $buddy/AnimationPlayer
@export var node_3d: Node3D
@export var animation_player_2: AnimationPlayer

var money_picked: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_bgm("heist_music_intense", 0.0)
	AudioManager.play_sfx_at_3d("police", node_3d.global_position)
	AudioManager.play_sfx("hallway")
	AudioManager.play_sfx("alarm")
	animation_player_2.play("uzi_sound")
	
	get_tree().create_timer(20.0).timeout.connect(end_scene)
	buddy_player.play("shooting")

func on_money_picked(interactable: Interactable):
	money_picked += 1
	interactable.queue_free()
	AudioManager.play_sfx("cash")
	
	if money_picked > 7 and duffle_bag_flipped.visible:
		end_scene()

# Flip the dufflebag back
func on_dufflebag_interacted(interactable: Interactable) -> void:
	interactable.queue_free()
	duffle_bag_flipped.visible = true
	AudioManager.play_sfx("bag")
	
func uzi_sound():
	AudioManager.play_sfx("uzi")

func end_scene():
	AudioManager.stop_bgm(0.0)
	get_tree().change_scene_to_packed(WIFE_LEVEL)

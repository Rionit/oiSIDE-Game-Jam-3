extends Node3D

const FOOD_FLASHBACK_LEVEL = preload("uid://brf04vyupjui8")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var first_person_player: PlayerController = $FirstPersonPlayer
@onready var buddy: AnimationPlayer = $buddy/AnimationPlayer

@onready var dialogue_manager: CanvasLayer = $DialogueManager
@export var dialogue_lines: Array[DialogueLine] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	first_person_player.crosshair.visible = false
	animation_player.animation_finished.connect(wake_up_finished)
	animation_player.play("wake_up")
	buddy.play("idle")
	AudioManager.play_sfx("scene_start")
	
	dialogue_manager.all_dialogue_finished.connect(_on_all_dialogue_finished)
	
func wake_up_finished(_whatever) -> void:
	dialogue_manager.start_dialogue(dialogue_lines)
	
func _on_all_dialogue_finished() -> void:
	first_person_player.can_move = true
	first_person_player.crosshair.visible = true
	await get_tree().create_timer(6.0).timeout
	get_tree().change_scene_to_packed(FOOD_FLASHBACK_LEVEL)

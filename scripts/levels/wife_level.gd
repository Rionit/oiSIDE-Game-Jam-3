extends Node3D

const ROOFTOP_ENTRY_LEVEL = preload("uid://c8loqlr2xc8el")

@onready var dialogue_manager: CanvasLayer = $DialogueManager
@export var dialogue_lines: Array[DialogueLine] = []

@onready var wife_player: AnimationPlayer = $woman/AnimationPlayer
@onready var first_person_player: PlayerController = $FirstPersonPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wife_player.play("sitting")
	AudioManager.play_sfx("morning")
	dialogue_manager.all_dialogue_finished.connect(next_scene)

func _on_start_dialogue(interactable: Interactable) -> void:
	interactable.unhighlight()
	interactable.queue_free()
	first_person_player.can_move = false
	first_person_player.crosshair.visible = false
	dialogue_manager.start_dialogue(dialogue_lines)

func next_scene():
	get_tree().change_scene_to_packed(ROOFTOP_ENTRY_LEVEL)

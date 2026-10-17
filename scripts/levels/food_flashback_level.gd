extends Node3D

const VAULT_EXIT_LEVEL = preload("uid://21mv8jqgngke")

@onready var pizza_interact: Interactable = $PizzaInteract
@onready var first_person_player: PlayerController = $FirstPersonPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var dialogue_manager: CanvasLayer = $DialogueManager
@export var dialogue_lines: Array[DialogueLine] = []
@onready var fridge: MeshInstance3D = $room/fridge

var dialogue_finished: bool = false
var animation_finished: bool = false

func _ready() -> void:
	pizza_interact.interacted.connect(start_cutscene)
	dialogue_manager.all_dialogue_finished.connect(func(): dialogue_finished = true)
	animation_player.animation_finished.connect(func(x): animation_finished = true)
	AudioManager.play_sfx("night")
	AudioManager.play_sfx_at_3d("fridge", fridge.global_position)

func start_cutscene(interactable):
	pizza_interact.interacted.disconnect(start_cutscene)
	first_person_player.can_move = false
	first_person_player.crosshair.visible = false
	first_person_player.current_interaction.unhighlight()
	dialogue_manager.start_dialogue(dialogue_lines)
	animation_player.play("cutscene")

func _process(delta: float) -> void:
	if animation_finished and dialogue_finished:
		get_tree().change_scene_to_packed(VAULT_EXIT_LEVEL)
		
func zvuk(name: String):
	AudioManager.play_sfx(name)

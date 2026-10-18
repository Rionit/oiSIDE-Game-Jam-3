extends Node3D

const END_CREDITS = preload("uid://kfgfesj1q3mm")

@onready var cutscene: AnimationPlayer = $Cutscene
@export var dialogue_lines: Array[DialogueLine] = []
@onready var dialogue_manager: CanvasLayer = $DialogueManager
@onready var first_person_player: PlayerController = $FirstPersonPlayer
@onready var end_scene_interact: Interactable = $EndSceneInteract

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cutscene.play("cutscene")
	dialogue_manager.all_dialogue_finished.connect(prep_for_end)
	AudioManager.play_sfx("end")
	AudioManager.play_sfx("heart")

func start_dialogue():
	dialogue_manager.start_dialogue(dialogue_lines)
	
func prep_for_end():
	await get_tree().create_timer(0.5).timeout
	end_scene_interact.process_mode = Node.PROCESS_MODE_INHERIT

func end_scene(interactable: Interactable) -> void:

	get_tree().change_scene_to_packed(END_CREDITS)
	
func boom():
	AudioManager.play_sfx("boom")

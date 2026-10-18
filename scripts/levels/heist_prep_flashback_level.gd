extends Node3D

const VENT_EXIT_LEVEL = preload("uid://c1e4v7uov14gj")

@onready var buddy_player: AnimationPlayer = %buddy/AnimationPlayer
@onready var first_person_player: PlayerController = $FirstPersonPlayer

@export var dialogue_lines: Array[DialogueLine] = []
@export var gear_line: DialogueLine
@onready var dialogue_manager: CanvasLayer = $DialogueManager

var gear_count: int = 0
var dialogue_finished: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	first_person_player.can_move = false
	get_tree().create_timer(0.3).timeout.connect(func(): first_person_player.can_move = true)
	
	AudioManager.play_sfx("basement")
	buddy_player.play("explaining")
	dialogue_manager.all_dialogue_finished.connect(on_dialogue_finished)

func on_weapon_picked(interactable: Interactable):
	interactable.mesh_instance.queue_free()
	interactable.queue_free()
	gear_count += 1
	AudioManager.play_sfx("gun_pick")

func on_ammo_picked(interactable: Interactable):
	interactable.mesh_instance.queue_free()
	interactable.queue_free()
	gear_count += 1
	AudioManager.play_sfx("ammo")
	
func on_buddy_interacted(interactable: Interactable):
	interactable.unhighlight()
	interactable.queue_free()
	first_person_player.can_move = false
	first_person_player.crosshair.visible = false
	if gear_count < 4:
		dialogue_lines.append(gear_line)
	dialogue_manager.start_dialogue(dialogue_lines)

func on_dialogue_finished():
	first_person_player.can_move = true
	first_person_player.crosshair.visible = true
	dialogue_finished = true

func _process(delta: float) -> void:
	if gear_count >= 4 and dialogue_finished:
		get_tree().change_scene_to_packed(VENT_EXIT_LEVEL)

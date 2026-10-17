extends Node3D

const HEIST_PREP_FLASHBACK_LEVEL = preload("uid://cr28nuedfrje2")

@onready var duffle_bag: Interactable = $Interactable
@onready var first_person_player: PlayerController = $FirstPersonPlayer
@onready var buddy: AnimationPlayer = $buddy/AnimationPlayer

var duffle_picked: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	duffle_bag.interacted.connect(on_duffle_picked)
	buddy.play("pointing")

func on_duffle_picked() -> void:
	duffle_bag.queue_free()
	duffle_picked = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is PlayerController and duffle_picked:
		get_tree().change_scene_to_packed.call_deferred(HEIST_PREP_FLASHBACK_LEVEL)

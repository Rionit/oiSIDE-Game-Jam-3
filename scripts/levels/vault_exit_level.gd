extends Node3D

const HEIST_PREP_FLASHBACK_LEVEL = preload("uid://cr28nuedfrje2")

@onready var duffle_bag: Interactable = $Interactable
@onready var first_person_player: PlayerController = $FirstPersonPlayer
@onready var buddy_player: AnimationPlayer = $buddy/AnimationPlayer
@onready var buddy: Node3D = $buddy

var duffle_picked: bool = false

var first_pos: Vector3 = Vector3(0.138, 0.061, 8.041)
var second_pos: Vector3 = Vector3(0.675, 0.245, 8.747)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	duffle_bag.interacted.connect(on_duffle_picked)
	buddy.position = first_pos
	buddy_player.play("pointing")

func on_duffle_picked() -> void:
	buddy.position = second_pos
	buddy_player.play("come")
	duffle_bag.queue_free()
	duffle_picked = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is PlayerController and duffle_picked:
		get_tree().change_scene_to_packed.call_deferred(HEIST_PREP_FLASHBACK_LEVEL)

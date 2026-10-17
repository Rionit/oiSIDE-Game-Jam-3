extends Node3D

@onready var buddy_player: AnimationPlayer = %buddy/AnimationPlayer
@onready var first_person_player: PlayerController = $FirstPersonPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buddy_player.play("explaining")

func on_weapon_picked(interactable: Interactable):
	interactable.mesh_instance.queue_free()
	interactable.queue_free()

func on_ammo_picked(interactable: Interactable):
	interactable.mesh_instance.queue_free()
	interactable.queue_free()

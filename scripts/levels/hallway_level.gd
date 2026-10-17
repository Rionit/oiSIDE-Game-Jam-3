extends Node3D

const WIFE_LEVEL = preload("uid://bo6ljgi40lqcs")

@onready var duffle_bag_flipped: Node3D = $duffle_bag_flipped
@onready var buddy_player: AnimationPlayer = $buddy/AnimationPlayer

var money_picked: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().create_timer(20.0).timeout.connect(end_scene)
	buddy_player.play("shooting")

func on_money_picked(interactable: Interactable):
	money_picked += 1
	interactable.queue_free()
	
	if money_picked == 8 and duffle_bag_flipped.visible:
		end_scene()

# Flip the dufflebag back
func on_dufflebag_interacted(interactable: Interactable) -> void:
	interactable.queue_free()
	duffle_bag_flipped.visible = true

func end_scene():
	get_tree().change_scene_to_packed(WIFE_LEVEL)

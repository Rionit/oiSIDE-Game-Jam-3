extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var first_person_player: PlayerController = $FirstPersonPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.animation_finished.connect(wake_up_finished)
	animation_player.play("wake_up")
	
func wake_up_finished(_whatever):
	# first_person_player.can_move = true
	pass

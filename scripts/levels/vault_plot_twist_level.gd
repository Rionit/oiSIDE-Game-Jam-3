extends Node3D

@onready var buddy_player: AnimationPlayer = $buddy/AnimationPlayer
@onready var first_person_player: PlayerController = $FirstPersonPlayer
@onready var camera_3d: Camera3D = $FirstPersonPlayer/Camera/Camera3D
@onready var marker_3d: Marker3D = $Marker3D

var money_picked = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buddy_player.play("stealing")
	get_tree().create_timer(20.0).timeout.connect(end_scene)

func on_money_picked(interactable: Interactable) -> void:
	interactable.queue_free()
	money_picked += 1
	if money_picked > 6:
		end_scene()

func end_scene():
	first_person_player.can_move = false
	first_person_player.crosshair.visible = false
	
	var start_quat = Quaternion(camera_3d.global_transform.basis)
	camera_3d.look_at(marker_3d.global_position, Vector3.UP)
	var end_quat = Quaternion(camera_3d.global_transform.basis)
	camera_3d.global_transform.basis = Basis(start_quat)
	
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_method(func(w: float) -> void:
		camera_3d.global_transform.basis = Basis(start_quat.slerp(end_quat, w))
	, 0.0, 1.0, 1.0)

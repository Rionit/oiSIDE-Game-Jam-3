extends Node3D

const BLACK_TRANSITION_LEVEL = preload("uid://cflygqipcx06i")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var wife_player: AnimationPlayer = $woman/AnimationPlayer
@onready var buddy_player: AnimationPlayer = $buddy/AnimationPlayer
@onready var first_person_player: PlayerController = $FirstPersonPlayer
@onready var camera_3d: Camera3D = $FirstPersonPlayer/Camera/Camera3D
@onready var marker_3d: Marker3D = $Marker3D
@export var vault_door: MeshInstance3D


var money_picked = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buddy_player.play("stealing")
	wife_player.play("female_standing")
	get_tree().create_timer(20.0).timeout.connect(end_scene)
	AudioManager.play_sfx("hallway")
	

func on_money_picked(interactable: Interactable) -> void:
	interactable.queue_free()
	money_picked += 1
	AudioManager.play_sfx("cash")
	if money_picked > 6:
		end_scene()
		
func vault_sound():
		AudioManager.play_sfx_at_3d("vault", vault_door.global_position)
		
func end_scene():
	first_person_player.can_move = false
	first_person_player.crosshair.visible = false
	
	var start_quat = Quaternion(camera_3d.global_transform.basis)
	camera_3d.look_at(marker_3d.global_position, Vector3.UP)
	var end_quat = Quaternion(camera_3d.global_transform.basis)
	camera_3d.global_transform.basis = Basis(start_quat)
	
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_method(func(w: float) -> void:
		camera_3d.global_transform.basis = Basis(start_quat.slerp(end_quat, w))
	, 0.0, 1.0, 1.0)
	
	await tween.finished
	
	animation_player.play("vault_door_open")
	
	var tween2 = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween2.tween_property(camera_3d, "fov", 50.0, 8.0)
	
	await tween2.finished
	
	get_tree().change_scene_to_packed(BLACK_TRANSITION_LEVEL)
	

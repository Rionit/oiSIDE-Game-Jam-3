extends Control

const ROOFTOP_ENDING_LEVEL = preload("uid://uqtc7p8wx3sj")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().create_timer(5.0).timeout.connect(end_scene)


func end_scene():
	get_tree().change_scene_to_packed(ROOFTOP_ENDING_LEVEL)

extends Area3D

@export var open_anim: String = "open"
@export var door_anim: AnimationPlayer

var _is_open: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	print("body: ", body.name, " is in group player: ", body.is_in_group("player"))
	if not body.is_in_group("player"):
		return
	if _is_open:
		return
	_is_open = true
	door_anim.play(open_anim)
	pass # Replace with function body.

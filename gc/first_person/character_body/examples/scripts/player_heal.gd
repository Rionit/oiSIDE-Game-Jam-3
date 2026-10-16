extends Node3D

@export var instance_item: Node3D
@export var heal_item: PackedScene

@onready var _timer: Timer = $Timer

var _can_instantiate = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if instance_item == null and _timer.is_stopped() and _can_instantiate:
		_timer.start(2)
		_can_instantiate = false
	pass


func _on_timer_timeout() -> void:
	var h = heal_item.instantiate()
	add_child(h)
	var hi = h as Node3D
	hi.global_position.y = 1.0
	instance_item = hi
	_can_instantiate = true
	pass # Replace with function body.

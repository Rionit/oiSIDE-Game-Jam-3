class_name CureItem

extends Node3D

@export var heal_quantity: int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("CureItem")
	pass # Replace with function body.


func _on_body_entered(body: Node3D) -> void:
	if body == null:
		return
	
	var health: HealthComponent = body.get_node("HealthComponent")
	if health == null:
		return
	health.heal(heal_quantity)
	queue_free()
	pass # Replace with function body.

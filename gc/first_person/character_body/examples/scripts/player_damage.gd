extends Area3D

@export var damage_quantity: int = 10
@onready var timer: Timer = $Timer

var _can_damage: bool = true
var _health: HealthComponent

func _on_body_entered(body: Node3D) -> void:
	if body == null:
		return
	
	if not _can_damage:
		return
	
	var health: HealthComponent = body.get_node("HealthComponent")
	
	if health == null:
		return
	
	_health = health	
	_health.receive_damage(damage_quantity)
	
	_can_damage = false
	
	timer.start(2)
	
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	_can_damage = true
	if _health == null:
		return
	
	_health.receive_damage(damage_quantity)
	_can_damage = false
	
	timer.start(2)
	pass # Replace with function body.


func _on_body_exited(_body: Node3D) -> void:
	_health = null
	timer.stop()
	_can_damage = true
	pass # Replace with function body.

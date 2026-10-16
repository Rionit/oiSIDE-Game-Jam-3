class_name HealthComponent

extends Node

#region Signals

signal on_receive_damage(damage: int)
signal on_life_change(amount: int)
signal is_dead()

#endregion

#region Variables

@export_category("Health")
@export var max_health: int = 100

@export_category("UI")
@export var damage_control: Control

var _current_health: int = max_health

#endregion

func _ready() -> void:
	if (_current_health != max_health): 
		_current_health = max_health
		pass
	emit_signal("on_life_change", _current_health)
	pass

func receive_damage(damage: int):
	_current_health = _current_health - damage if (_current_health - damage) >= 0 else 0
	print("damage: ", damage, "current health: ", _current_health)
	
	var anim: AnimationPlayer = damage_control.get_node("AnimationPlayer")
	if anim != null:
		anim.play("damage")
		pass
	
	emit_signal("on_receive_damage", damage)
	emit_signal("on_life_change", _current_health)
	
	if _current_health == 0:
		emit_signal("is_dead")
		pass
	pass

func heal(amount: int):
	_current_health = _current_health + amount if (_current_health + amount) <= max_health else max_health
	print("Heal: ", amount, "current health: ", _current_health)
	emit_signal("on_life_change", _current_health)
	pass

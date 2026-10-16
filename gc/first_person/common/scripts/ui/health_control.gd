class_name HealthControl

extends Control

@onready var healthLabel: Label = $HealthLabel


func update_health_label(value: int):
	var t: String = "LIFE: " + str(value)
	if not healthLabel:
		healthLabel = $HealthLabel
	healthLabel.text = t

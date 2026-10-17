extends StaticBody3D
class_name Interactable

signal interacted

@export var outline_material: Material 
@export var mesh_instance: MeshInstance3D

func interact() -> void:
	interacted.emit()

func highlight() -> void:
	if mesh_instance and outline_material:
		mesh_instance.material_overlay = outline_material

func unhighlight() -> void:
	if mesh_instance:
		mesh_instance.material_overlay = null

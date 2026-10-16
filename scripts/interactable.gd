extends StaticBody3D
class_name Interactable

@export var outline_material: Material 

@onready var mesh_instance: MeshInstance3D = _find_mesh_instance(self)

func interact() -> void:
	print("hello")

func highlight() -> void:
	if mesh_instance and outline_material:
		mesh_instance.material_overlay = outline_material

func unhighlight() -> void:
	if mesh_instance:
		mesh_instance.material_overlay = null

# Helper function to automatically locate the MeshInstance3D child
func _find_mesh_instance(node: Node) -> MeshInstance3D:
	if node is MeshInstance3D:
		return node
	for child in node.get_children():
		var result = _find_mesh_instance(child)
		if result:
			return result
	return null

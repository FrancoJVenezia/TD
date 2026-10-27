class_name BuildSlot extends Node3D

var occupant: Tower

@onready var _visual: MeshInstance3D = $Visual


func _ready() -> void:
	var material := _visual.material_override as StandardMaterial3D
	if material != null:
		_visual.material_override = material.duplicate()


func is_free() -> bool:
	return occupant == null or not is_instance_valid(occupant)


func place_tower(tower: Tower) -> void:
	if tower == null or not is_free():
		return
	add_child(tower)
	tower.position = Vector3.ZERO
	occupant = tower


func clear() -> void:
	if is_instance_valid(occupant):
		occupant.queue_free()
	occupant = null


func set_highlight(on: bool) -> void:
	var material := _visual.material_override as StandardMaterial3D
	if material == null:
		return
	material.albedo_color = Color(0.25, 0.9, 0.35, 0.55) if on else Color(0.2, 0.65, 1.0, 0.4)


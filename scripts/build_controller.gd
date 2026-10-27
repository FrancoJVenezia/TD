extends Node

signal slot_selected(slot: BuildSlot)
signal slot_hover_changed(slot: BuildSlot)

const SLOT_COLLISION_MASK: int = 1 << 4
const RAY_LENGTH: float = 1000.0

var _hovered: BuildSlot
var _selected: BuildSlot


func _physics_process(_delta: float) -> void:
	_update_hovered_slot()


func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	var mouse_event := event as InputEventMouseButton
	if not mouse_event.pressed or mouse_event.button_index != MOUSE_BUTTON_LEFT:
		return
	if _hovered == null:
		return

	_selected = _hovered
	slot_selected.emit(_selected)
	get_viewport().set_input_as_handled()


func _update_hovered_slot() -> void:
	var camera := get_viewport().get_camera_3d()
	if camera == null:
		_set_hovered_slot(null)
		return

	var mouse := get_viewport().get_mouse_position()
	var ray_origin := camera.project_ray_origin(mouse)
	var ray_end := ray_origin + camera.project_ray_normal(mouse) * RAY_LENGTH
	var query := PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.collision_mask = SLOT_COLLISION_MASK

	var hit := camera.get_world_3d().direct_space_state.intersect_ray(query)
	var slot: BuildSlot
	if not hit.is_empty():
		var collider := hit["collider"] as Node
		if collider is Area3D:
			slot = collider.get_parent() as BuildSlot
	_set_hovered_slot(slot)


func _set_hovered_slot(slot: BuildSlot) -> void:
	if slot == _hovered:
		return
	if is_instance_valid(_hovered):
		_hovered.set_highlight(false)
	_hovered = slot
	if is_instance_valid(_hovered):
		_hovered.set_highlight(true)
	slot_hover_changed.emit(_hovered)


func _on_slot_selected(slot: BuildSlot) -> void:
	print("Slot seleccionado: ", slot.name)

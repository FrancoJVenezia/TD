class_name Level extends Node3D

@onready var path: Path3D = $EnemyPath
@onready var base: Node3D = $Base
@onready var build_slots: Node3D = $BuildSlots

func get_spawn_position() -> Vector3:
	return path.to_global(path.curve.get_point_position(0))

func get_build_slots() -> Array:
	return build_slots.get_children()

func get_base() -> Node3D:
	return base

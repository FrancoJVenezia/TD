class_name Tower extends Node3D

var data: TowerData
var stats := StatBlock.new()
var _in_range: Array[Enemy] = []
var _current_target: Enemy

@onready var _range_area: Area3D = $RangeArea
@onready var _range_shape: CollisionShape3D = $RangeArea/CollisionShape3D
@onready var projectiles_root: Node3D = $"../Projectiles Root"


func _ready() -> void:
	if _range_shape.shape is SphereShape3D:
		_range_shape.shape = _range_shape.shape.duplicate()
	_range_area.area_entered.connect(_on_range_area_entered)
	_range_area.area_exited.connect(_on_range_area_exited)
	stats.stat_changed.connect(_on_stat_changed)
	if data != null:
		_refresh_range()


func setup(tower_data: TowerData) -> void:
	data = tower_data
	stats.set_base(StatId.DAMAGE, data.damage)
	stats.set_base(StatId.FIRE_RATE, data.fire_rate)
	stats.set_base(StatId.RANGE, data.attack_range)
	stats.set_base(StatId.PROJECTILE_SPEED, data.projectile_speed)

	if data.model_scene != null:
		$Model.add_child(data.model_scene.instantiate())
	if is_node_ready():
		_refresh_range()


func get_enemies_in_range() -> Array[Enemy]:
	_prune_invalid_enemies()
	return _in_range.duplicate()


## Se elige al pedir un disparo, no cada frame. La caché evita repetir una
## búsqueda si el sistema de ataque consulta más de una vez durante el mismo disparo.
func get_target_for_shot() -> Enemy:
	_prune_invalid_enemies()
	if _is_target_valid(_current_target):
		return _current_target
	if data == null:
		_current_target = null
		return null
	_current_target = Targeting.pick(_in_range, data.target_mode, global_position)
	return _current_target


func notify_shot_fired() -> void:
	_current_target = null


func _is_target_valid(enemy: Enemy) -> bool:
	return is_instance_valid(enemy) and enemy.is_inside_tree() and _in_range.has(enemy) \
		and is_instance_valid(enemy.health) and enemy.health.is_alive()


func _refresh_range() -> void:
	var sphere := _range_shape.shape as SphereShape3D
	if sphere == null:
		push_error("RangeArea/CollisionShape3D debe usar SphereShape3D.")
		return
	sphere.radius = stats.get_stat(StatId.RANGE)


func _on_stat_changed(stat: int, _value: float) -> void:
	if stat == StatId.RANGE and is_node_ready():
		_refresh_range()


func _on_range_area_entered(area: Area3D) -> void:
	var enemy := _enemy_from_area(area)
	if enemy == null or _in_range.has(enemy):
		return
	_in_range.append(enemy)
	var exit_callback := _on_enemy_tree_exiting.bind(enemy)
	if not enemy.tree_exiting.is_connected(exit_callback):
		enemy.tree_exiting.connect(exit_callback, CONNECT_ONE_SHOT)
	print("Torre: enemigo entró en rango (%d)." % _in_range.size())
	shot_once()
	await get_tree().create_timer(1.0).timeout
	shot_once()
	await get_tree().create_timer(1.0).timeout
	shot_once()


func _on_range_area_exited(area: Area3D) -> void:
	var enemy := _enemy_from_area(area)
	if enemy == null:
		_prune_invalid_enemies()
		return
	if _in_range.has(enemy):
		_in_range.erase(enemy)
		if _current_target == enemy:
			_current_target = null
		print("Torre: enemigo salió de rango (%d)." % _in_range.size())


func _on_enemy_tree_exiting(enemy: Enemy) -> void:
	_in_range.erase(enemy)
	if _current_target == enemy:
		_current_target = null


func _enemy_from_area(area: Area3D) -> Enemy:
	return area.get_parent() as Enemy


func _prune_invalid_enemies() -> void:
	for index in range(_in_range.size() - 1, -1, -1):
		if not is_instance_valid(_in_range[index]) or not _in_range[index].is_inside_tree():
			if _current_target == _in_range[index]:
				_current_target = null
			_in_range.remove_at(index)

func shot_once() -> void:
	var target := get_target_for_shot()
	if target == null:
		return
	if data.projectile_scene == null:
		push_error("TowerData no tiene una escena de proyectil asignada.")
		return
	var projectile = data.projectile_scene.instantiate()
	var damage_info := DamageInfo.new()
	damage_info.amount = data.damage
	damage_info.splash_radius = data.splash_radius
	projectiles_root.add_child(projectile)
	projectile.global_position = $Muzzle.global_position
	projectile.setup(target, stats.get_stat(StatId.PROJECTILE_SPEED), damage_info)

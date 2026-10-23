class_name Tower extends Node3D

const MODIFIER_TICK_INTERVAL: float = 0.1

var data: TowerData
var stats := StatBlock.new()
var _in_range: Array[Enemy] = []
var _current_target: Enemy
var _cooldown: float = 0.0
var _modifier_tick_elapsed: float = 0.0

@onready var _model: Node3D = $Model
@onready var _range_area: Area3D = $RangeArea
@onready var _range_shape: CollisionShape3D = $RangeArea/CollisionShape3D
@onready var _projectiles_root: Node3D = $"../Projectiles Root"


func _ready() -> void:
	if _range_shape.shape is SphereShape3D:
		_range_shape.shape = _range_shape.shape.duplicate()
	_range_area.area_entered.connect(_on_range_area_entered)
	_range_area.area_exited.connect(_on_range_area_exited)
	stats.stat_changed.connect(_on_stat_changed)
	if data != null:
		_refresh_range()


func _physics_process(delta: float) -> void:
	_modifier_tick_elapsed += delta
	while _modifier_tick_elapsed >= MODIFIER_TICK_INTERVAL:
		stats.tick(MODIFIER_TICK_INTERVAL)
		_modifier_tick_elapsed -= MODIFIER_TICK_INTERVAL
	_cooldown -= delta
	_validate_target()

	if _current_target == null:
		if data == null:
			return
		_current_target = Targeting.pick(_in_range, data.target_mode, global_position)
	if _current_target == null:
		return

	_aim_at(_current_target)
	if _cooldown <= 0.0:
		_fire()
		_cooldown = 1.0 / maxf(0.05, stats.get_stat(StatId.FIRE_RATE))


func setup(tower_data: TowerData) -> void:
	data = tower_data
	stats.set_base(StatId.DAMAGE, data.damage)
	stats.set_base(StatId.FIRE_RATE, data.fire_rate)
	stats.set_base(StatId.RANGE, data.attack_range)
	stats.set_base(StatId.PROJECTILE_SPEED, data.projectile_speed)

	if data.model_scene != null:
		_model.add_child(data.model_scene.instantiate())
	if is_node_ready():
		_refresh_range()


func _validate_target() -> void:
	if _current_target != null and not _is_target_valid(_current_target):
		_current_target = null


func _is_target_valid(enemy: Enemy) -> bool:
	return is_instance_valid(enemy) and enemy.is_inside_tree() \
		and _in_range.has(enemy) and is_instance_valid(enemy.health) \
		and enemy.health.is_alive()


func _aim_at(enemy: Enemy) -> void:
	var flat_target := Vector3(
		enemy.global_position.x,
		_model.global_position.y,
		enemy.global_position.z
	)
	if not _model.global_position.is_equal_approx(flat_target):
		_model.look_at(flat_target, Vector3.UP)


func _fire() -> void:
	if data == null:
		return
	var info := _build_damage()
	match data.delivery:
		TowerData.Delivery.PROJECTILE:
			if data.projectile_scene == null:
				push_error("TowerData no tiene una escena de proyectil asignada.")
				return
			var projectile := data.projectile_scene.instantiate() as Projectile
			if projectile == null:
				push_error("La escena de proyectil no tiene un nodo raíz Projectile.")
				return
			_projectiles_root.add_child(projectile)
			projectile.global_position = $Muzzle.global_position
			projectile.setup(_current_target, stats.get_stat(StatId.PROJECTILE_SPEED), info)
		TowerData.Delivery.INSTANT:
			pass # F4
		TowerData.Delivery.AREA_PULSE:
			pass # F4


func _build_damage() -> DamageInfo:
	var info := DamageInfo.new()
	info.amount = stats.get_stat(StatId.DAMAGE)
	info.source_tags = data.tags
	info.splash_radius = data.splash_radius
	return info


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


func _on_range_area_exited(area: Area3D) -> void:
	var enemy := _enemy_from_area(area)
	if enemy == null:
		_prune_invalid_enemies()
		return
	if _in_range.has(enemy):
		_in_range.erase(enemy)
		if _current_target == enemy:
			_current_target = null


func _on_enemy_tree_exiting(enemy: Enemy) -> void:
	_in_range.erase(enemy)
	if _current_target == enemy:
		_current_target = null


func _enemy_from_area(area: Area3D) -> Enemy:
	return area.get_parent() as Enemy


func _prune_invalid_enemies() -> void:
	for index in range(_in_range.size() - 1, -1, -1):
		var enemy := _in_range[index]
		if not is_instance_valid(enemy) or not enemy.is_inside_tree():
			if _current_target == enemy:
				_current_target = null
			_in_range.remove_at(index)

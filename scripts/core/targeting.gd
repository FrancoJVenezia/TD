class_name Targeting
extends RefCounted


static func pick(candidates: Array, mode: int, origin: Vector3) -> Enemy:
	var selected: Enemy
	var best_value: float
	var has_selected := false

	for candidate: Variant in candidates:
		if not candidate is Enemy:
			continue
		var enemy := candidate as Enemy
		if not is_instance_valid(enemy) or not enemy.is_inside_tree():
			continue
		if not is_instance_valid(enemy.health) or not enemy.health.is_alive():
			continue

		var value: float
		match mode:
			TowerData.TargetMode.FIRST:
				value = enemy.progress_ratio
				if not has_selected or value > best_value:
					selected = enemy
					best_value = value
					has_selected = true
			TowerData.TargetMode.LAST:
				value = enemy.progress_ratio
				if not has_selected or value < best_value:
					selected = enemy
					best_value = value
					has_selected = true
			TowerData.TargetMode.CLOSEST:
				value = origin.distance_squared_to(enemy.global_position)
				if not has_selected or value < best_value:
					selected = enemy
					best_value = value
					has_selected = true
			TowerData.TargetMode.STRONGEST:
				value = enemy.health.current
				if not has_selected or value > best_value:
					selected = enemy
					best_value = value
					has_selected = true
			_:
				if not has_selected:
					selected = enemy
					has_selected = true

	return selected

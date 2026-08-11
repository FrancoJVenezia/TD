class_name Health extends Node

signal damaged(amount: float, current: float)
signal healed(amount: float, current: float)
signal died()

@export var max_health: float = 100.0
var current: float

func _ready() -> void:
	current = max_health

func take_damage(info: DamageInfo) -> void:
	if current <= 0.0:
		return
	var amount = max(1.0, info.amount)
	current = max(0.0, current - amount)
	damaged.emit(amount, current)
	
	if current <= 0.0: 
		died.emit()

func heal(amount: float) -> void:
	if current <= 0:
		return
	
	current = min(max_health, current + amount)
	healed.emit(amount, current)

func set_max_health(new_value: float, keep_ratio: bool = true) -> void:
	if keep_ratio:
		var prev_max_health = max_health
		var health_ratio = current / prev_max_health
		
		max_health = new_value
		current = new_value * health_ratio
	else:
		max_health = new_value

func is_alive() -> bool:
	return current > 0.0

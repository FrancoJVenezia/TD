class_name Projectile extends Node3D

const HIT_DISTANCE := 0.4

var target: Enemy
var speed: float
var damage_info: DamageInfo

func setup(p_target: Enemy, p_speed: float, p_info: DamageInfo) -> void:
	target = p_target
	speed = p_speed
	damage_info = p_info

func _physics_process(delta: float) -> void:
	if not is_instance_valid(target):
		queue_free()          # el target murió antes de que llegaras
		return
	var to_target := target.global_position - global_position
	if to_target.length() <= HIT_DISTANCE:
		_hit()
		return
	global_position += to_target.normalized() * speed * delta

func _hit() -> void:
	if damage_info.splash_radius > 0.0:
		pass   # F4: buscar todos los enemigos en el radio
	else:
		target.health.take_damage(damage_info)
	queue_free()

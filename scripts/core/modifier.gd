class_name Modifier extends RefCounted

enum Mode { FLAT, PCT_ADD, PCT_MULT }

var stat: int
var mode: Mode
var value: float
var source: StringName      # ej: &"slow_tower_3", &"level_1", &"meta_dmg"
var duration: float = -1.0  # -1 = permanente
var _remaining: float = 0.0

func _init(p_stat, p_mode, p_value, p_source = &"", p_duration = -1.0):
	stat = p_stat
	mode = p_mode
	value = p_value
	source = p_source
	duration = p_duration
	_remaining = p_duration

# Descuenta tiempo. Devuelve true si el modifier se venció.
func advance(delta: float) -> bool:
	if duration <= 0.0:
		return false
	_remaining -= delta
	return _remaining <= 0.0

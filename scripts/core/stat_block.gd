class_name StatBlock extends RefCounted

signal stat_changed(stat: int, value: float)

# Piso de seguridad: MOVE_SPEED y FIRE_RATE nunca por debajo de este % del base.
const MIN_RATIO := 0.1

var _base: Dictionary = {}
var _mods: Array[Modifier] = []
var _cache: Dictionary = {}
var _dirty: bool = true

func set_base(stat: int, value: float) -> void:
	_base[stat] = value
	_dirty = true
	stat_changed.emit(stat, get_stat(stat))

func get_stat(stat: int) -> float:
	if _dirty:
		_cache.clear()
		_dirty = false
	if not _cache.has(stat):
		_cache[stat] = _compute(stat)
	return _cache[stat]

func add_modifier(m: Modifier) -> void:
	_mods.append(m)
	_dirty = true
	stat_changed.emit(m.stat, get_stat(m.stat))

func remove_by_source(source: StringName) -> void:
	var touched: Array[int] = []
	for i in range(_mods.size() - 1, -1, -1):
		if _mods[i].source == source:
			if not touched.has(_mods[i].stat):
				touched.append(_mods[i].stat)
			_mods.remove_at(i)

	if touched.is_empty():
		return

	_dirty = true
	for stat in touched:
		stat_changed.emit(stat, get_stat(stat))

func has_source(source: StringName) -> bool:
	for m in _mods:
		if m.source == source:
			return true
	return false

func tick(delta: float) -> void:
	var expired: Array[int] = []
	for i in range(_mods.size() - 1, -1, -1):
		if _mods[i].advance(delta):
			if not expired.has(_mods[i].stat):
				expired.append(_mods[i].stat)
			_mods.remove_at(i)

	if expired.is_empty():
		return

	_dirty = true
	for stat in expired:
		stat_changed.emit(stat, get_stat(stat))

func _compute(stat: int) -> float:
	var flat := 0.0
	var pct_add := 0.0
	var pct_mult := 1.0
	for m in _mods:
		if m.stat != stat: continue
		match m.mode:
			Modifier.Mode.FLAT:     flat += m.value
			Modifier.Mode.PCT_ADD:  pct_add += m.value
			Modifier.Mode.PCT_MULT: pct_mult *= (1.0 + m.value)

	var base: float = _base.get(stat, 0.0)
	var result := (base + flat) * (1.0 + pct_add) * pct_mult

	if stat == StatId.MOVE_SPEED or stat == StatId.FIRE_RATE:
		result = maxf(result, base * MIN_RATIO)

	return result

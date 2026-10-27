extends Node

const GOLD: StringName = &"gold"
const GEMS: StringName = &"gems"

signal balance_changed(currency: StringName, value: int)

var _balances: Dictionary = {
	GOLD: 0,
	GEMS: 0,
}


func get_balance(currency: StringName) -> int:
	return _balances.get(currency, 0)


func can_afford(currency: StringName, amount: int) -> bool:
	return _is_supported_currency(currency) and amount >= 0 and get_balance(currency) >= amount


func add(currency: StringName, amount: int) -> void:
	if not _is_supported_currency(currency) or amount <= 0:
		return
	_set_balance(currency, get_balance(currency) + amount)


func try_spend(currency: StringName, amount: int) -> bool:
	if amount < 0 or not can_afford(currency, amount):
		return false
	if amount == 0:
		return true
	_set_balance(currency, get_balance(currency) - amount)
	return true


func set_balance(currency: StringName, value: int) -> void:
	if not _is_supported_currency(currency):
		return
	_set_balance(currency, maxi(value, 0))


func reset_run_currency(starting_gold: int) -> void:
	set_balance(GOLD, starting_gold)


func _is_supported_currency(currency: StringName) -> bool:
	return currency == GOLD or currency == GEMS


func _set_balance(currency: StringName, value: int) -> void:
	if get_balance(currency) == value:
		return
	_balances[currency] = value
	balance_changed.emit(currency, value)
	EventBus.balance_changed.emit(currency, value)

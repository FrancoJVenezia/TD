extends Node

const ENEMY = preload("uid://dcrlrjiiupykg")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#var health := Health.new()
	#
	#add_child(health)
	#
	#health.damaged.connect(_on_damaged)
	#health.died.connect(_on_died)
	#
	#var dmg := DamageInfo.new()
	#dmg.amount = 30
	#
	#health.take_damage(dmg)
	#await wait(1)
	#health.take_damage(dmg)
	#await wait(1)
	#health.take_damage(dmg)
	#await wait(1)
	#health.take_damage(dmg)
	#await wait(1)
	#health.take_damage(dmg)

func _on_damaged(amount: float, current: float):
	print("amount: " + str(amount))
	print("current: " + str(current))

func _on_died():
	print("MURIO")

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

class_name Level extends Node3D


const ENEMY = preload("uid://dcrlrjiiupykg")

@onready var enemy_path: Path3D = $EnemyPath
@onready var base: Node3D = $Base
@onready var build_slots: Node3D = $BuildSlots
@onready var health: Health = $Base/Health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.enemy_reached_base.connect(on_enemy_reached_base)
	var e := ENEMY.instantiate()
	
	$EnemyPath.add_child(e)     # ⚠️ hijo del Path3D, NO del Level
	e.setup(load("res://data/enemies/grunt.tres"))
	e.progress = 0.0
	print('Vida actual: ', health.current)


func get_spawn_position() -> Vector3:
	return enemy_path.to_global(enemy_path.curve.get_point_position(0))

func get_build_slots() -> Array:
	return build_slots.get_children()

func get_base() -> Node3D:
	return base


func on_enemy_reached_base(enemy: Enemy):
	var dmg = DamageInfo.new()
	dmg.amount = enemy.data.damage_to_base
	health.take_damage(dmg)
	print('llego :', enemy)
	print('el daño que se hace es: ', dmg.amount)
	print('la vida actual es: ', health.current)

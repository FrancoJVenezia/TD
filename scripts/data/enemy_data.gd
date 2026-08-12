class_name EnemyData extends Resource

@export var id: StringName = &"grunt"
@export var display_name: String = "Grunt"
@export var tags: Array[String] = ["ground", "normal"]

@export_group("Stats")
@export var max_health: float = 100.0
@export var move_speed: float = 3.0     # unidades/segundo sobre el path
@export var armor: float = 0.0

@export_group("Recompensa")
@export var gold_reward: int = 10
@export var gems_reward: int = 0        # solo el boss > 0

@export_group("Presentación")
@export var model_scene: PackedScene
@export var scale_multiplier: float = 1.0

@export_group("Base")
@export var damage_to_base: int = 1

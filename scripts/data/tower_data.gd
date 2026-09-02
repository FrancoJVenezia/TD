class_name TowerData extends Resource

enum Delivery { PROJECTILE, INSTANT, AREA_PULSE }
enum TargetMode { FIRST, LAST, CLOSEST, STRONGEST }

@export var id: StringName = &"arrow"
@export var display_name: String = "Torre Básica"
@export_multiline var description: String = ""
@export var tags: Array[String] = ["basic", "single_target", "physical"]

@export_group("Stats base")
@export var damage: float = 10.0
@export var fire_rate: float = 1.0        # ⚠️ DISPAROS POR SEGUNDO
@export var attack_range: float = 6.0
@export var projectile_speed: float = 20.0

@export_group("Combate")
@export var delivery: Delivery = Delivery.PROJECTILE
@export var target_mode: TargetMode = TargetMode.FIRST
@export var splash_radius: float = 0.0    # 0 = sin área

@export_group("Economía")
@export var cost: int = 50
@export var upgrade_levels: Array[TowerLevelData] = []

@export_group("Presentación")
@export var model_scene: PackedScene
@export var projectile_scene: PackedScene
@export var icon: Texture2D

@export_group("Desbloqueo")
@export var unlocked_by_default: bool = true
@export var gems_cost: int = 0

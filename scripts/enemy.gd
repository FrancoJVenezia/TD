class_name Enemy extends PathFollow3D

var data: EnemyData
var speed: float = 3.0        # en F1 pasa a ser stats.get_stat(MOVE_SPEED)
@onready var health: Health = $Health

func setup(enemy_data: EnemyData) -> void:
	data = enemy_data
	speed = data.move_speed
	health.max_health = data.max_health
	health.died.connect(_on_died)
	var m := data.model_scene.instantiate()
	$Model.add_child(m)

func _physics_process(delta: float) -> void:
	progress += speed * delta
	if progress_ratio >= 1.0:
		_reach_base()

func _reach_base() -> void:
	EventBus.enemy_reached_base.emit(self)
	queue_free()

func _on_died() -> void:
	EventBus.enemy_died.emit(self, [])
	queue_free()

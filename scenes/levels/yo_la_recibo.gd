extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.enemy_died.connect(_on_enemy_died)


func _on_enemy_died(enemy, killer_tags):
	print('llego el enemy died: "', enemy, '"')

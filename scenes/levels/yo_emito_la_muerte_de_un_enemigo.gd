extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await wait(3)
	EventBus.enemy_died.emit(self, [])


func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

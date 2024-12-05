extends Marker2D

@export var enemy_scene: PackedScene

func _ready():
	for enemy_name in WorldState.active_enemies:
		var enemy = enemy_scene.instantiate()
		get_tree().root.add_child(enemy)
		enemy.global_position = global_position
		enemy.load_data(enemy_name)
		await get_tree().create_timer(1).timeout

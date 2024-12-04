extends Node2D

@export var enemy_scene: PackedScene

var colliding_areas = [false, false, false, false]

var isClosed: bool = true
var playerInArea: bool = false

func _ready():
	var i = 0
	for node in $SpawnPoints.get_children():
		node.get_child(0).body_entered.connect(player_entered_spawn.bind(i))
		node.get_child(0).body_exited.connect(player_exited_spawn.bind(i))
		i += 1

func _process(delta: float) -> void:
	if isClosed:
		$AnimatedSprite2D.play("closed")
		if playerInArea:
			if Input.is_action_just_pressed("interact"):
				isClosed = false
				spawn_enemy()
				$SpawnPoints.queue_free()
	else:
		$AnimatedSprite2D.play("open")

func spawn_enemy():
	var indices = []
	var i = 0
	for area_colliding in colliding_areas:
		if !area_colliding:
			indices.append(i)
		i += 1
	var spawn_index = indices.pick_random()
	var spawn_marker = $SpawnPoints.get_child(spawn_index).get_child(1)
	
	var enemy_name = WorldState.spawn_enemy()
	var enemy = enemy_scene.instantiate()
	get_tree().root.add_child(enemy)
	enemy.global_position = spawn_marker.global_position
	enemy.load_data(enemy_name)

func _on_interactable_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		playerInArea = true

func _on_interactable_area_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		playerInArea = false

func player_entered_spawn(body: Node2D, index):
	if body.has_method("player"):
		colliding_areas[index] = true

func player_exited_spawn(body: Node2D, index: int):
	if body.has_method("player"):
		colliding_areas[index] = false

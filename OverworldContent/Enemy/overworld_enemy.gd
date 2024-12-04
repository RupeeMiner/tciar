extends CharacterBody2D

var enemy = "Bacon"

var battle_ready = false

var health = 0

var sight_range = 100
var walk_speed = 90
var run_speed = 100

var direction
var directions = [Vector2(0,-1), Vector2(0, 1), Vector2(-1, 0), Vector2(1,0)]
var interest_direction = 0
var old_safe = [0,1,2,3]
var player

func _ready():
	WorldState.battle_ended.connect(update_health)
	player = get_tree().get_first_node_in_group("Player")
	set_physics_process(false)
	await get_tree().create_timer(1).timeout
	set_physics_process(true)
	await get_tree().create_timer(3)
	battle_ready = true

func _physics_process(delta):
	var contexts = [0,0,0,0]
	var speed = walk_speed
	
	var player_dir = global_position - player.global_position
	if (player_dir.length() < 80):
		speed = run_speed
		for i in range(directions.size()):
			contexts[i] += directions[i].dot(player_dir.normalized())
	
	var i = 0
	var safe = []
	for raycast in $ContextMap/Orthogonal.get_children():
		if (raycast.is_colliding()):
			contexts[i] -= 5
		else:
			safe.append(i)
		i += 1
	
	if safe != old_safe:
		interest_direction = safe.pick_random()
	
	old_safe = safe
	
	contexts[interest_direction] += 2
	
	direction = contexts.find(contexts.max())
	velocity = directions[direction] * speed
	
	move_and_slide()
	play_anim()

func play_anim():
	var anim = $AnimatedSprite2D
	
	if (direction == 0): # up
		anim.flip_h = false
		anim.play("up_move")
	if (direction == 1): #down
		anim.flip_h = false
		anim.play("down_move")
	if (direction == 2): #left
		anim.flip_h = false
		anim.play("side_move")
	elif (direction == 3): #right
		anim.flip_h = true
		anim.play("side_move")

func _on_battle_area_body_entered(body: Node2D) -> void:
	if (body.has_method("player")):
		if (battle_ready):
			WorldState.start_battle(enemy, health)

func update_health(new_health):
	if (new_health <= 0):
		queue_free()
	else:
		health = new_health

func load_data(name):
	enemy = name
	$AnimatedSprite2D.sprite_frames = load("res://Resources/OverworldEnemies/" + name + "Frames.tres")
	
	var enemy_data = load("res://Resources/BattleEnemies/" + name + ".tres")
	health = enemy_data.health
	sight_range = enemy_data.sight_range
	walk_speed = enemy_data.walk_speed
	run_speed = enemy_data.run_speed

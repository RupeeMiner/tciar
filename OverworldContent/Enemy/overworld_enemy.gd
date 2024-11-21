extends CharacterBody2D

var speed = 80
var directions = [Vector2(0,-1), Vector2(0, 1), Vector2(-1, 0), Vector2(1,0)]
var player

func _ready():
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta):
	var player_dir = position - player.position
	var player_dot_prods = []
	for dir in directions:
		player_dot_prods.append(dir.dot(player_dir.normalized()))
	
	var contexts = player_dot_prods
	var index = contexts.find(contexts.max())
	
	print(directions[index])
	velocity.x = directions[index][0] * speed
	velocity.y = directions[index][1] * speed
	
	move_and_slide()

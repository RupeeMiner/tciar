extends CharacterBody2D

var sight_range = 100
var speed = 80
var directions = [Vector2(0,-1), Vector2(0, 1), Vector2(-1, 0), Vector2(1,0)]
var player

func _ready():
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta):
	var contexts = [0,0,0,0]
	
	var player_dir = global_position - player.global_position
	if (player_dir.length() < 60):
		for i in range(directions.size()):
			contexts[i] += directions[i].dot(player_dir.normalized())
	
	var i = 0
	for raycast in $ContextMap/Orthogonal.get_children():
		if (raycast.is_colliding()):
			contexts[i] -= 5
		i +=1
	
	var index
	if (contexts.count(contexts.max() == contexts.size() - 1)):
		if (contexts.find(contexts.min()) in [0, 3]):
			index = contexts.find(contexts.min()) + 1
		else:
			index = contexts.find(contexts.min()) - 1
	elif (contexts.count(contexts.max() == contexts.size())):
		index = contexts.find(contexts.max())
	velocity.x = directions[index][0] * speed - (velocity.x * .9)
	velocity.y = directions[index][1] * speed - (velocity.y * .9)
	
	move_and_slide()

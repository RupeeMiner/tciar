extends CharacterBody2D

var sight_range = 100
var walk_speed = 30
var run_speed = 35

var direction
var directions = [Vector2(0,-1), Vector2(0, 1), Vector2(-1, 0), Vector2(1,0)]
var interest_direction = 0
var old_safe = [0,1,2,3]
var player

func _ready():
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta):
	var contexts = [0,0,0,0]
	var speed = walk_speed
	
	var player_dir = global_position - player.global_position
	if (player_dir.length() < 80):
		speed = run_speed
		for i in range(directions.size()):
			contexts[i] += 2 * directions[i].dot(player_dir.normalized())
	
	var i = 0
	var safe = []
	for raycast in $ContextMap/Orthogonal.get_children():
		if (raycast.is_colliding()):
			contexts[i] -= 5
		else:
			safe.append(i)
		i +=1
	
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
	
	if (direction == 2): #left
		anim.flip_h = false
		anim.play("horizontal_move")
	elif (direction == 3): #right
		anim.flip_h = true
		anim.play("horizontal_move")
	else: #up and down
		anim.flip_h = false
		anim.play("vertical_move")

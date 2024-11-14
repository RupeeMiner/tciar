extends CharacterBody2D

const speed = 100
var current_dir = "none"
var quipped = false

func _ready():
	$AnimatedSprite2D.play("front_idle")
	WorldState.battle_started.connect(play_quip)
	WorldState.recipe_ready.connect(play_ready_quip)
	update_self()

func _physics_process(delta):
	player_movement(delta)

func player_movement(delta):
	if Input.is_action_pressed("right"):
		current_dir = "right"
		play_anim(true)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("left"):
		current_dir = "left"
		play_anim(true)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("down"):
		current_dir = "down"
		play_anim(true)
		velocity.x = 0
		velocity.y = speed
	elif Input.is_action_pressed("up"):
		current_dir = "up"
		play_anim(true)
		velocity.x = 0
		velocity.y = -speed
	else:
		play_anim(false)
		velocity.x = 0
		velocity.y = 0
	
	move_and_slide()

func play_anim(isMoving):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if isMoving:
			anim.play("side_walk")
		else:
			anim.play("side_idle")
	elif dir == "left":
		anim.flip_h = true
		if isMoving:
			anim.play("side_walk")
		else:
			anim.play("side_idle")
	elif dir == "down":
		anim.flip_h = false
		if isMoving:
			anim.play("front_walk")
		else:
			anim.play("front_idle")
	elif dir == "up":
		anim.flip_h = false
		if isMoving:
			anim.play("back_walk")
		else:
			anim.play("back_idle")

func update_self():
	pass
	if (WorldState.current_scene == "Diner"):
		if(WorldState.first_loaded["Diner"]):
			self.position = WorldState.diner_intro_pos
		else:
			self.position = WorldState.diner_door_pos
	else:
		if(WorldState.first_loaded[WorldState.current_scene]):
			self.position = WorldState.dungeon_entrance_pos[WorldState.current_scene]
			await self.is_node_ready()
			play_dialogue(WorldState.current_recipe + "Start")
		else:
			self.position = WorldState.dungeon_rest_pos[WorldState.current_scene]

func play_quip(enemy):
	var enemy_name = load(enemy).name
	play_dialogue(enemy_name + "Quip")

func ended_dialogue():
	Dialogic.timeline_ended.disconnect(ended_dialogue)
	set_physics_process(true)

func play_dialogue(timeline_name):
	Dialogic.timeline_ended.connect(ended_dialogue)
	set_physics_process(false)
	var layout = Dialogic.Styles.load_style("QuipStyle")
	layout.register_character(load("res://DialogicContent/TonyCharacter.dch"), $".")
	Dialogic.start(timeline_name)

func play_ready_quip(current_recipe):
	if (!quipped):
		play_dialogue(current_recipe + "Ready")
		quipped = true

func player():
	pass

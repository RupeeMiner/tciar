extends CharacterBody2D

const speed = 100
var current_dir = "none"

func _ready():
	$AnimatedSprite2D.play("front_idle")

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

func player():
	pass

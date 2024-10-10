extends Node2D

@export var Enemy = "a"

var isClosed = true
var playerInArea = false

func _process(delta: float) -> void:
	if isClosed:
		$AnimatedSprite2D.play("closed")
		if playerInArea:
			if Input.is_action_just_pressed("interact"):
				WorldState.start_battle()
				isClosed = false
	else:
		$AnimatedSprite2D.play("open")

func _on_interactable_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		playerInArea = true

func _on_interactable_area_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		playerInArea = false

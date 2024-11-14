extends Node2D

var playerInArea = false

func _process(delta: float) -> void:
	if playerInArea:
		if Input.is_action_just_pressed("interact"):
			var layout = Dialogic.start("RestStopPopup")
			layout.register_character(load("res://DialogicContent/PopupCharacter.dch"), $".")

func _on_interactable_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		playerInArea = true


func _on_interactable_area_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		playerInArea = false

extends Node2D

var in_reset_area: bool = false

func _on_exit_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		var layout = Dialogic.start("RestroomExit")
		layout.register_character(load("res://DialogicContent/PopupCharacter.dch"), $".")


func _on_level_reset_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		in_reset_area = true


func _on_level_reset_area_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		in_reset_area = false

func _process(delta: float) -> void:
	if in_reset_area:
		if Input.is_action_just_pressed("interact"):
			var layout = Dialogic.start("RestroomReset")
			layout.register_character(load("res://DialogicContent/PopupCharacter.dch"), $".")

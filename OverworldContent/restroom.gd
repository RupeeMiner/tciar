extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		var layout = Dialogic.start("RestroomExit")
		layout.register_character(load("res://DialogicContent/PopupCharacter.dch"), $".")

extends Node2D

var transition_scene = false

func _on_exit_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		change_scene()

func change_scene():
	var layout
	if (WorldState.ingredients_missing()):
		layout = Dialogic.start("IngredientsMissing")
	else:
		layout = Dialogic.start("LeaveDungeon")
	layout.register_character(load("res://DialogicContent/PopupCharacter.dch"), $".")
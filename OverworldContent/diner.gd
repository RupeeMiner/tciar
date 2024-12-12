extends Node2D

var game_over = false



func _ready() -> void:
	if (WorldState.level < WorldState.recipes.size()):
		WorldState.load_level_data()
	else: 
		game_over = true
	
	if (WorldState.first_loaded["Diner"]):
		WorldState.first_loaded["Diner"] = false
		Dialogic.start("IntroScene")
	else:
		Dialogic.Styles.load_style("ConversationStyle")
		await get_tree().create_timer(.1).timeout
		if (!game_over):
			Dialogic.start(WorldState.current_recipe + "Order")
		else:
			Dialogic.start("EndScene")

func _on_exit_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		Dialogic.start("EnterDungeon")

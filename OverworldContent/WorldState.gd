extends Node

signal battle_started(current_enemy)
signal battle_ended()
signal recipe_ready(current_recipe)

var current_recipe = "Burger"
var current_ingredients = ["Beef Patty", "Hamburger Bun", "Cheese Slice"]
var current_enemies = ["res://Resources/Beefy.tres", "res://Resources/Bun.tres", "res://Resources/Cheese.tres"]

func start_battle():
	var index = randi() % current_enemies.size()
	emit_signal("battle_started", current_enemies.pop_at(index))

func ingredients_missing():
	var ingredients_collected = false
	for ingredient in WorldState.current_ingredients:
		if !(ingredient in PlayerState.items):
			ingredients_collected = true
	return ingredients_collected

func list_missing_ingredients():
	var list = []
	for ingredient in WorldState.current_ingredients:
		if !(ingredient in PlayerState.items):
			list.append(ingredient)
	var list_str = list[0]
	if (list.size() == 2):
		list_str += " and " + list[1]
	elif (list.size() > 2):
		for i in list.size() - 2:
			list_str += ", " + list[i + 1]
		list_str += ", and " + list[list.size() - 1]
	return list_str

func check_recipe_ready():
	print("Checking readiness")
	if !ingredients_missing():
		print("It's ready")
		emit_signal("recipe_ready", current_recipe)

func load_scene(scene_name):
	get_tree().change_scene_to_file("res://OverworldContent/" + scene_name + ".tscn")

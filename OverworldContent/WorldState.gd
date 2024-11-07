extends Node

signal battle_started(current_enemy)
signal battle_ended()
signal recipe_ready(current_recipe)

var first_loaded = {"Diner": true, "BurgerDungeon": true, "SpagDungeon": true, "SlamDungeon": true}

var diner_intro_pos = Vector2(80, 140)
var diner_door_pos = Vector2(49, 208)

var dungeon_entrance_pos = {"BurgerDungeon": Vector2(880, 784), "SpagDungeon": Vector2(1232,1229), "SlamDungeon": Vector2(80,74)}
var dungeon_rest_pos = {"BurgerDungeon": Vector2(1541,229), "SpagDungeon": Vector2(160,266), "SlamDungeon": Vector2(168,76)}

var level = 0
var recipes = ["Burger", "Spag", "Slam"]
var ingredients = [["Beef Patty", "Hamburger Bun", "Cheese Slice"], ["Noodles", "Meatballs", "Tomato"], ["Egg", "Bacon", "Potato"]]
var story_enemies = [["res://Resources/Beefy.tres", "res://Resources/Bun.tres", "res://Resources/Cheese.tres"], ["res://Resources/Meatballs.tres", "res://Resources/Noodles.tres", "res://Resources/Tomato.tres"], ["res://Resources/Bacon.tres", "res://Resources/Egg.tres", "res://Resources/Potato.tres"]]
var extra_enemies = ["res://Resources/Lettuce.tres","res://Resources/Cuce.tres"]
var moves = {"BurgerDungeon": ["Toast","Smash","Melt"], "SpagDungeon": ["Blend","Boil","Sear"], "SlamDungeon": ["Beat","Fry","Shred"]}

var current_recipe = ""
var current_ingredients = []
var current_enemies = []

var current_scene = "Diner"

func load_level_data():
	current_recipe = recipes[level]
	current_enemies = story_enemies[level].duplicate(true)
	current_ingredients = ingredients[level]
	PlayerState.moves = moves[current_recipe + "Dungeon"]
	level += 1

func start_battle():
	var index = randi() % current_enemies.size()
	var enemy = current_enemies.pop_at(index)
	emit_signal("battle_started", enemy)

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
	if !ingredients_missing():
		emit_signal("recipe_ready", current_recipe)

func load_scene(scene_name):
	current_scene = scene_name
	get_tree().change_scene_to_file("res://OverworldContent/" + scene_name + ".tscn")

func load_next_level():
	PlayerState.current_health = PlayerState.max_health
	load_scene(current_recipe + "Dungeon")
	await get_tree().create_timer(1).timeout
	first_loaded[current_recipe + "Dungeon"] = false

func reset_level():
	current_enemies = []
	for enemy in story_enemies[level - 1]:
		var ingredient = load(enemy).ingredient
		var ingredient_needed = true
		for item in PlayerState.items:
			if (item == ingredient):
				ingredient_needed = false
		if (ingredient_needed):
			current_enemies.append(enemy)
	while current_enemies.size() < story_enemies[level - 1].size():
		current_enemies.append(extra_enemies[randi() % extra_enemies.size()])
	load_next_level()

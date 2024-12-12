extends Node

signal battle_started(enemy, enemy_health)
signal battle_ended(enemy_health)
signal recipe_ready(current_recipe)
signal enemy_spawned(enemy)
signal player_died(enemy)

var first_loaded = {"Diner": true, "BurgerDungeon": true, "SpagDungeon": true, "SlamDungeon": true}

var diner_intro_pos = Vector2(80, 140)
var diner_door_pos = Vector2(49, 208)

var dungeon_entrance_pos = {"BurgerDungeon": Vector2(880, 784), "SpagDungeon": Vector2(1232,1229), "SlamDungeon": Vector2(76,79)}
var dungeon_rest_pos = {"BurgerDungeon": Vector2(1552, 210), "SpagDungeon": Vector2(110, 240), "SlamDungeon": Vector2(1936,179)}

var level = 0
var recipes = ["Burger", "Spag", "Slam"]
var ingredients = [["Beef Patty", "Hamburger Bun", "Cheese Slice"], ["Noodles", "Meatballs", "Tomato"], ["Egg", "Bacon", "Potato"]]
var story_enemies = [["Beefy", "Bun", "Cheese"], ["Meatballs", "Noodles", "Tomato"], ["Bacon", "Egg", "Tater"]]
var extra_enemies = ["Lettuce","Cuce"]
var moves = {"BurgerDungeon": ["Toast","Smash","Melt"], "SpagDungeon": ["Blend","Boil","Sear"], "SlamDungeon": ["Beat","Fry","Shred"]}
var move_texts = {"BurgerDungeon": ["It's getting toasty in here!","Smaaaash!","You're melting, you're  meeeeeeeelting!"],"SpagDungeon":["Pull out the blender and turn to max speed!","Crank up the heat!","Sear off the competition!"],"SlamDungeon":["Get scrambled!","Rev up those fryers!","Shred it up!"]}

var current_recipe = ""
var current_ingredients = []
var current_enemies = []
var coolers_closed = [true, true, true]
var active_enemies = []

var level_reset = false

var current_scene = "Diner"

func load_level_data():
	current_recipe = recipes[level]
	current_enemies = story_enemies[level].duplicate(true)
	current_ingredients = ingredients[level]
	PlayerState.moves = moves[current_recipe + "Dungeon"]
	PlayerState.move_texts = move_texts[current_recipe + "Dungeon"]
	level += 1

func spawn_enemy():
	var index = randi() % current_enemies.size()
	var enemy = current_enemies.pop_at(index)
	emit_signal("enemy_spawned", enemy)
	return enemy

func start_battle(enemy, enemy_health):
	emit_signal("battle_started", enemy, enemy_health)

func end_battle(enemy_health):
	emit_signal("battle_ended", enemy_health)

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
	SceneTransition.change_scene("res://OverworldContent/" + scene_name + ".tscn")
	AudioManager.update_music(scene_name)

func load_next_level():
	PlayerState.current_health = PlayerState.max_health
	coolers_closed = [true, true, true]
	active_enemies = []
	load_scene(current_recipe + "Dungeon")
	await get_tree().create_timer(6).timeout
	first_loaded[current_recipe + "Dungeon"] = false

func reset_level():
	current_enemies = []
	for enemy in story_enemies[level - 1]:
		var ingredient = load("res://Resources/BattleEnemies/" + enemy + ".tres").ingredient
		var ingredient_needed = true
		for item in PlayerState.items:
			if (item == ingredient):
				ingredient_needed = false
		if (ingredient_needed):
			current_enemies.append(enemy)
	while current_enemies.size() < story_enemies[level - 1].size():
		current_enemies.append(extra_enemies[randi() % extra_enemies.size()])
	load_next_level()

func return_to_dungeon():
	if(level_reset):
		reset_level()
	else:
		load_scene(current_recipe + "Dungeon")

func kill_player(enemy: String):
	emit_signal("player_died", enemy)

func respawn_player():
	load_scene("Restroom")
	level_reset = true

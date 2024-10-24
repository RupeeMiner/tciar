extends Node

signal battle_started(current_enemy)
signal battle_ended()

var current_ingredients = ["Beef Patty", "Hamburger Bun", "Cheese Slice"]
var current_enemies = ["res://Resources/Beefy.tres", "res://Resources/Bun.tres", "res://Resources/Cheese.tres"]

func start_battle():
	var index = randi() % current_enemies.size()
	emit_signal("battle_started", current_enemies.pop_at(index))

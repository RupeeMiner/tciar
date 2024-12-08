extends Control

signal textbox_closed

@export var enemy: Resource

var current_enemy_health = 0
var current_player_health = 0

func _ready() -> void:
	visible = false
	WorldState.battle_started.connect(init)

func init(current_enemy, enemy_health):
	enemy = load("res://Resources/BattleEnemies/" + current_enemy + ".tres")
	get_tree().paused = true
	
	visible = true
	
	$Textbox.hide()
	$Actions.hide()
	
	$EnemyTexture.texture = enemy.texture
	
	$Actions/MovesMenu/Move1.text = PlayerState.moves[0]
	$Actions/MovesMenu/Move2.text = PlayerState.moves[1]
	$Actions/MovesMenu/Move3.text = PlayerState.moves[2]
	
	set_health(PlayerState.current_health, PlayerState.max_health, $PlayerHealth)
	set_health(enemy_health, enemy.health, $EnemyHealth)
	
	current_enemy_health = enemy_health
	current_player_health = PlayerState.current_health
	
	display_text("%s appeared!" % enemy.name)
	await textbox_closed
	
	if (enemy.speed > PlayerState.speed):
		enemy_turn()
	else:
		$Actions.show()
		$Actions/MovesMenu.hide()

func _input(event):
	if (Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and $Textbox.is_visible_in_tree():
		$Textbox.hide()
		emit_signal("textbox_closed")

func display_text(text):
	$Actions.hide()
	$Textbox/Label.text = text
	$Textbox.show()

func set_health(health, max_health, health_label):
	health_label.text = "HP: %d/%d" % [health, max_health]

func enemy_turn():
	var move_num = randi() % enemy.moves.size()
	display_text("%s attacks!" % enemy.name)
	await textbox_closed
	
	var damage = enemy.attack - PlayerState.defense
	
	current_player_health = max(0, current_player_health - damage)
	set_health(current_player_health, PlayerState.max_health, $PlayerHealth)
	
	display_text("%s dealt %d damage" % [enemy.name, damage])
	await textbox_closed
	
	if (current_player_health == 0):
		display_text("You were defeated! :(")
		await textbox_closed
		
		#todo: game over
		get_tree().paused = false
		get_tree().reload_current_scene()
		visible = false
	
	$Actions.show()
	$Actions/ActionMenu.show()
	$Actions/MovesMenu.hide()

func player_attack(move_num):
	display_text("You used %s!" % PlayerState.moves[move_num])
	await textbox_closed
	
	var damage = PlayerState.attack - enemy.defense
	if (PlayerState.moves[move_num] == enemy.weakness):
		display_text("It was super effective!")
		await textbox_closed
		damage = damage + 2
	
	current_enemy_health = max(0, current_enemy_health - damage)
	set_health(current_enemy_health, enemy.health, $EnemyHealth)
	
	display_text("You dealt %d damage" % damage)
	await textbox_closed
	
	if (current_enemy_health == 0):
		display_text("%s was defeated!" % enemy.name)
		await textbox_closed
		PlayerState.items.append(enemy.ingredient)
		end_battle()
		WorldState.check_recipe_ready()
	
	enemy_turn()

func _on_run_pressed() -> void:
	## todo -- calculate run possibility using player's speed value
	display_text("You ran away.")
	await textbox_closed
	end_battle()

func end_battle():
	PlayerState.current_health = current_player_health
	get_tree().paused = false
	WorldState.end_battle(current_enemy_health)
	visible = false

func _on_moves_pressed() -> void:
	$Actions/ActionMenu.hide()
	$Actions/MovesMenu.show()

func _on_move_back_pressed() -> void:
	$Actions/MovesMenu.hide()
	$Actions/ActionMenu.show()

func _on_move_1_pressed() -> void:
	player_attack(0)

func _on_move_2_pressed() -> void:
	player_attack(1)

func _on_move_3_pressed() -> void:
	player_attack(2)

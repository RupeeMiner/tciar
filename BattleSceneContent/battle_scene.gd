extends Control

signal textbox_closed

@export var enemy: Resource

var current_enemy_health = 0
var current_player_health = 0

func _ready() -> void:
	visible = false
	WorldState.battle_started.connect(init)

func init(current_enemy, enemy_health):
	$AnimatedSprite2D.play("default")
	SceneTransition.fade_out()
	enemy = load("res://Resources/BattleEnemies/" + current_enemy + ".tres")
	get_tree().paused = true
	await get_tree().create_timer(2).timeout
	
	visible = true
	
	$AspectRatioContainer/BattleBox.hide()
	$AspectRatioContainer/FlavorText.hide()
	$AspectRatioContainer/HpBox.hide()
	$Moves.hide()
	
	$EnemySprite.texture = enemy.texture
	
	$Moves/Move1.texture_normal = load("res://Resources/battleUI/buttons/" + PlayerState.moves[0].to_upper() + ".png")
	$Moves/Move2.texture_normal = load("res://Resources/battleUI/buttons/" + PlayerState.moves[1].to_upper() + ".png")
	$Moves/Move3.texture_normal = load("res://Resources/battleUI/buttons/" + PlayerState.moves[2].to_upper() + ".png")
	
	set_health(PlayerState.current_health, PlayerState.max_health, $AspectRatioContainer/HpBox/Label)
	
	current_enemy_health = enemy_health
	current_player_health = PlayerState.current_health
	
	AudioManager.update_music("Battle")
	SceneTransition.fade_in()
	$AspectRatioContainer/BattleTextBox.show()
	display_text("%s appeared!" % enemy.name)
	await textbox_closed
	
	$AspectRatioContainer/HpBox.show()
	if (enemy.speed > PlayerState.speed):
		enemy_turn()
	else:
		$Moves.show()
		$AspectRatioContainer/BattleTextBox.hide()

func _input(event):
	if (Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and $AspectRatioContainer/BattleTextBox/Label.is_visible_in_tree():
		$AspectRatioContainer/BattleTextBox.hide()
		emit_signal("textbox_closed")

func display_text(text):
	$Moves.hide()
	$AspectRatioContainer/BattleBox.hide()
	$AspectRatioContainer/FlavorText.hide()
	$AspectRatioContainer/BattleTextBox/Label.text = text
	$AspectRatioContainer/BattleTextBox.show()

func set_health(health, max_health, health_label):
	health_label.text = "HP: %d/%d" % [health, max_health]

func enemy_turn():
	var move_num = randi() % enemy.moves.size()
	display_text("You get %s!" % enemy.moves[0])
	await textbox_closed
	
	var damage = enemy.attack - PlayerState.defense
	
	current_player_health = max(0, current_player_health - damage)
	set_health(current_player_health, PlayerState.max_health, $AspectRatioContainer/HpBox/Label)
	
	display_text("%s dealt %d damage." % [enemy.name, damage])
	await textbox_closed
	
	if (current_player_health == 0):
		display_text("You were defeated!")
		await textbox_closed
		
		end_battle()
	
	$Moves.show()

func player_attack(move_num):
	display_text(PlayerState.move_texts[move_num])
	await textbox_closed
	
	var damage = PlayerState.attack - enemy.defense
	if (PlayerState.moves[move_num] == enemy.weakness):
		display_text("It was super effective!")
		await textbox_closed
		damage = damage + 2
	
	current_enemy_health = max(0, current_enemy_health - damage)
	
	display_text("You dealt %d damage." % damage)
	await textbox_closed
	
	if (current_enemy_health == 0):
		display_text("%s was defeated!" % enemy.name)
		await textbox_closed
		PlayerState.items.append(enemy.ingredient)
		end_battle()
		WorldState.check_recipe_ready()
	else:
		enemy_turn()

func _on_run_pressed() -> void:
	display_text("You ran away.")
	await textbox_closed
	end_battle()

func end_battle():
	SceneTransition.fade_out()
	PlayerState.current_health = current_player_health
	if (current_player_health > 0):
		get_tree().paused = false
		WorldState.end_battle(current_enemy_health)
		await get_tree().create_timer(2).timeout
		AudioManager.update_music("Dungeon")
	else:
		WorldState.kill_player(enemy.name)
		await get_tree().create_timer(2).timeout
		AudioManager.update_music("Dead")
	visible = false
	SceneTransition.fade_in()

func _on_move_1_pressed() -> void:
	player_attack(0)

func _on_move_2_pressed() -> void:
	player_attack(1)

func _on_move_3_pressed() -> void:
	player_attack(2)

extends Control

signal textbox_closed

@export var enemy: Resource

var current_enemy_health = 0
var current_player_health = 0

func _ready() -> void:
	$Textbox.hide()
	$Actions.hide()
	
	$EnemyTexture.texture = enemy.texture
	
	set_health(PlayerState.current_health, PlayerState.max_health, $PlayerHealth)
	set_health(enemy.health, enemy.health, $EnemyHealth)
	
	current_enemy_health = enemy.health
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
	## todo -- implement different moves that deal different amounts of damage/have differing accuracy
	## todo -- incorporate enemy attack and defense stats into calculation
	display_text("Enemy turn")
	await textbox_closed
	
	current_player_health = max(0, current_player_health - enemy.attack)
	set_health(current_player_health, PlayerState.max_health, $PlayerHealth)
	
	display_text("%s dealt %d damage" % [enemy.name, enemy.attack])
	await textbox_closed
	
	if (current_player_health == 0):
		display_text("You were defeated! :(")
		await textbox_closed
		
		await get_tree().create_timer(.5).timeout
		get_tree().quit()
	
	$Actions.show()
	$Actions/ActionMenu.show()
	$Actions/MovesMenu.hide()
	
func player_attack():
	## todo -- implement different moves that deal different amounts of damage/have differing accuracy
	## todo -- incorporate player attack and defense stats into calculation
	display_text("Attack successful")
	await textbox_closed
	
	current_enemy_health = max(0, current_enemy_health - PlayerState.attack)
	set_health(current_enemy_health, enemy.health, $EnemyHealth)
	
	display_text("You dealt %d damage" % PlayerState.attack)
	await textbox_closed
	
	if (current_enemy_health == 0):
		display_text("%s was defeated!" % enemy.name)
		await textbox_closed
		
		await get_tree().create_timer(.5).timeout
		get_tree().quit()
		
	
	enemy_turn()

func _on_run_pressed() -> void:
	## todo -- calculate run possibility using player's speed value
	display_text("You ran away.")
	await textbox_closed
	await get_tree().create_timer(.5).timeout
	get_tree().quit()

func _on_moves_pressed() -> void:
	$Actions/ActionMenu.hide()
	$Actions/MovesMenu.show()

func _on_move_back_pressed() -> void:
	$Actions/MovesMenu.hide()
	$Actions/ActionMenu.show()

func _on_move_1_pressed() -> void:
	player_attack()

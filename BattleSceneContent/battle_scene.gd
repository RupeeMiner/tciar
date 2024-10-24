extends Control

signal textbox_closed

@export var enemy: Resource

var current_enemy_health = 0
var current_player_health = 0

var moves = []

func _ready() -> void:
	visible = false
	WorldState.battle_started.connect(cooler_opened)

func cooler_opened(current_enemy):
	enemy = load(current_enemy)
	Dialogic.timeline_ended.connect(init)

func init():
	Dialogic.timeline_ended.disconnect(init)
	get_tree().paused = true
	
	visible = true
	
	$Textbox.hide()
	$Actions.hide()
	
	$EnemyTexture.texture = enemy.texture
	
	for item in PlayerState.moves:
		moves.append(load(item))
	
	$Actions/MovesMenu/Move1.text = moves[0].name
	$Actions/MovesMenu/Move2.text = moves[1].name
	$Actions/MovesMenu/Move3.text = moves[2].name
	
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
	## todo -- incorporate enemy attack and defense stats into calculation
	var move_num = randi() % enemy.moves.size()
	display_text("%s uses %s!" % [enemy.name, enemy.moves[move_num].name])
	await textbox_closed
	
	var damage = enemy.moves[move_num].damage_scalar
	
	current_player_health = max(0, current_player_health - damage)
	set_health(current_player_health, PlayerState.max_health, $PlayerHealth)
	
	display_text("%s dealt %d damage" % [enemy.name, damage])
	await textbox_closed
	
	if (current_player_health == 0):
		display_text("You were defeated! :(")
		await textbox_closed
		
		get_tree().paused = false
		get_tree().reload_current_scene()
		visible = false
	
	$Actions.show()
	$Actions/ActionMenu.show()
	$Actions/MovesMenu.hide()

func player_attack(move_num):
	display_text("You used %s!" % moves[move_num].name)
	await textbox_closed
	
	if (randf() <= moves[move_num].accuracy):
		## todo -- incorporate player attack and defense stats into calculation
		var damage = moves[move_num].damage_scalar
		
		current_enemy_health = max(0, current_enemy_health - damage)
		set_health(current_enemy_health, enemy.health, $EnemyHealth)
		
		display_text("You dealt %d damage" % damage)
		await textbox_closed
		
		if (current_enemy_health == 0):
			display_text("%s was defeated!" % enemy.name)
			await textbox_closed
			
			PlayerState.items.append(enemy.ingredient)
			get_tree().paused = false
			visible = false
	else:
		display_text("You missed!")
		await textbox_closed
	
	enemy_turn()

func _on_run_pressed() -> void:
	## todo -- calculate run possibility using player's speed value
	display_text("You ran away.")
	await textbox_closed
	get_tree().paused = false
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

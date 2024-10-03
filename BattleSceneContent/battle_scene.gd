extends Control

signal textbox_closed

@export var enemy: Resource

func _ready() -> void:
	$Textbox.hide()
	$Actions.hide()
	
	$EnemyTexture.texture = enemy.texture
	
	set_health(PlayerState.current_health, PlayerState.max_health, $Actions/PlayerHealth)
	set_health(enemy.health, enemy.health, $Actions/EnemyHealth)
	
	display_text("%s appeared!" % enemy.name)
	await textbox_closed
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

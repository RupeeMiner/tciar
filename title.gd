extends Node2D


func _on_option_button_pressed() -> void:
	$Audio.stream = load("res://audio/sound effects/Menu/SFX_UI_OpenMenu.wav")
	$Audio.play()
	Options.visible = true

func _on_start_button_pressed() -> void:
	$Audio.stream = load("res://audio/sound effects/Menu/SFX_UI_Confirm.wav")
	$Audio.play()
	WorldState.load_scene("Diner")

func _on_exit_button_pressed() -> void:
	$Audio.stream = load("res://audio/sound effects/Menu/SFX_UI_Cancel.wav")
	$Audio.play()
	await get_tree().create_timer(.2).timeout
	get_tree().quit()

func _on_option_button_mouse_entered() -> void:
	$Audio.stream = load("res://audio/sound effects/Menu/SFX_UI_MenuSelections.wav")
	$Audio.play()

func _on_start_button_mouse_entered() -> void:
	$Audio.stream = load("res://audio/sound effects/Menu/SFX_UI_MenuSelections.wav")
	$Audio.play()

func _on_exit_button_mouse_entered() -> void:
	$Audio.stream = load("res://audio/sound effects/Menu/SFX_UI_MenuSelections.wav")
	$Audio.play()

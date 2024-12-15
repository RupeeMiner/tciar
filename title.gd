extends Node2D


func _on_option_button_pressed() -> void:
	Options.visible = true

func _on_start_button_pressed() -> void:
	WorldState.load_scene("Diner")


func _on_exit_button_pressed() -> void:
	get_tree().quit()

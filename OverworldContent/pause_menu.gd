extends CanvasLayer

var paused = false
var temp_music = ""

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if (WorldState.current_scene != "Title"):
			if (paused):
				unpause()
				paused = false
			else:
				get_tree().paused = true
				visible = true
				temp_music = AudioManager.current_music
				AudioManager.update_music("Title")
				paused = true

func unpause():
	visible = false
	get_tree().paused = false
	AudioManager.update_music(temp_music)

func _on_resume_pressed() -> void:
	unpause()

func _on_options_pressed() -> void:
	Options.visible = true

func _on_exit_pressed() -> void:
	get_tree().quit()

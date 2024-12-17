extends CanvasLayer

var paused = false
var temp_music = ""

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if (WorldState.current_scene != "Title"):
			if (paused):
				$Audio.stream = load("res://audio/sound effects/Menu/SFX_UI_Pause.wav")
				$Audio.play()
				unpause()
				paused = false
			else:
				$Audio.stream = load("res://audio/sound effects/Menu/SFX_UI_CloseMenu.wav")
				$Audio.play()
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
	$Audio.stream = load("res://audio/sound effects/Menu/SFX_UI_CloseMenu.wav")
	$Audio.play()
	unpause()

func _on_options_pressed() -> void:
	$Audio.stream = load("res://audio/sound effects/Menu/SFX_UI_OpenMenu.wav")
	$Audio.play()
	Options.visible = true

func _on_exit_pressed() -> void:
	$Audio.stream = load("res://audio/sound effects/Menu/SFX_UI_Cancel.wav")
	$Audio.play()
	await get_tree().create_timer(.2).timeout
	get_tree().quit()


func _on_resume_mouse_entered() -> void:
	$Audio.stream = load("res://audio/sound effects/Menu/SFX_UI_MenuSelections.wav")
	$Audio.play()


func _on_options_mouse_entered() -> void:
	$Audio.stream = load("res://audio/sound effects/Menu/SFX_UI_MenuSelections.wav")
	$Audio.play()

func _on_exit_mouse_entered() -> void:
	$Audio.stream = load("res://audio/sound effects/Menu/SFX_UI_MenuSelections.wav")
	$Audio.play()

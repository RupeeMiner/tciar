extends CanvasLayer

func change_scene(target: String) -> void:
	$AnimatedSprite2D.play("fadeout" + str(randi() % 4))
	await ($AnimatedSprite2D.animation_finished)
	$AnimatedSprite2D.play("dark")
	get_tree().change_scene_to_file(target)
	$AnimatedSprite2D.play("fadein" + str(randi() % 3))
	await ($AnimatedSprite2D.animation_finished)
	$AnimatedSprite2D.play("blank")

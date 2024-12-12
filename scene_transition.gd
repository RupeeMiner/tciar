extends CanvasLayer

@onready var sprite = $AnimatedSprite2D

func change_scene(target: String) -> void:
	sprite.play("fadeout" + str(randi() % 4))
	await (sprite.animation_finished)
	sprite.play("dark")
	get_tree().change_scene_to_file(target)
	sprite.play("fadein" + str(randi() % 3))
	await (sprite.animation_finished)
	sprite.play("blank")

func fade_out():
	sprite.play("fadeoutbite")
	await (sprite.animation_finished)
	sprite.play("dark")

func fade_in():
	sprite.play("fadeinbite")
	await (sprite.animation_finished)
	sprite.play("blank")

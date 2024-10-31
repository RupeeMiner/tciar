extends Node2D

func _ready() -> void:
	if (WorldState.first_loaded):
		WorldState.first_loaded = false
		print("Intro cutscene")

extends ConfirmationDialog

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if AcceptDialog.confirmed() == True:
		get_tree().quit()
		


func _on_custom_action(action: StringName) -> void:
	pass # Replace with function body.

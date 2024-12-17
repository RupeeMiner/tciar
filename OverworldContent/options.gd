extends CanvasLayer

signal guide_toggled(value)

var guide_active = false

func _process(delta):
	volume_update()

func _on_back_pressed() -> void:
	visible = false

func volume_update():
	var music_vol = $Control/music.value
	var sfx_vol = $Control/sfx.value
	
	var music_index = AudioServer.get_bus_index("music")
	var sfx_index = AudioServer.get_bus_index("sfx")
	
	AudioServer.set_bus_volume_db(music_index, music_vol)
	AudioServer.set_bus_volume_db(sfx_index, sfx_vol)


func _on_guide_toggled(toggled_on: bool) -> void:
	guide_active = toggled_on
	print(toggled_on)
	emit_signal("guide_toggled", toggled_on)

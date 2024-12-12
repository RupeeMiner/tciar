extends AudioStreamPlayer

var music_volume: int
var sfx_volume: int

var current_music: String = "DinerMusic"

func _ready():
	playing = true
	get_stream_playback().switch_to_clip_by_name("DinerMusic")

func update_music(music_name: String):
	if (music_name.ends_with("Dungeon")):
		get_stream_playback().switch_to_clip_by_name("DungeonMusic")
	elif !(music_name == "Restroom"):
		get_stream_playback().switch_to_clip_by_name(music_name + "Music")

func play_sfx(sfx_name: String):
	if (sfx_name == "Door"):
		$SFXPlayer.play()

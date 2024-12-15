extends AudioStreamPlayer

var music_volume: int
var sfx_volume: int

var current_music: String = "Title"

func _ready():
	playing = true
	get_stream_playback().switch_to_clip_by_name("TitleMusic")

func update_music(music_name: String):
	if (music_name.ends_with("Dungeon")):
		get_stream_playback().switch_to_clip_by_name("DungeonMusic")
		current_music = "Dungeon"
	elif !(music_name == "Restroom"):
		get_stream_playback().switch_to_clip_by_name(music_name + "Music")
		current_music = music_name

func play_sfx(sfx_name: String):
	if (sfx_name == "Door"):
		$SFXPlayer.play()

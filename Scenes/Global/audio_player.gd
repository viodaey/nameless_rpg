extends AudioStreamPlayer


const fieldOverWorld = preload("res://musig/Field_-_Wide_World.ogg")
const battle01 = preload("res://musig/Battle_-_Steel_Soldiers.ogg")
# Called when the node enters the scene tree for the first time.
func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return
	
	stream = music
	volume_db = volume
	play()


func play_music_level(conv):
	if conv == "fieldOverworld":
		_play_music(fieldOverWorld)
	if conv == "battle01":
		_play_music(battle01)

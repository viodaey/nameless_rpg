extends AudioStreamPlayer


const fieldOverWorld = preload("res://musig/Field_-_Wide_World.ogg")
const dungeonCave1 = preload("res://musig/Dungeon_-_Catacomb_Crawler.ogg")
const battle01 = preload("res://musig/Battle_-_Steel_Soldiers.ogg")
const battleNoWayOut = preload("res://musig/Battle_-_No_Way_Out.ogg")
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
	if conv == "res://musig/Battle_-_No_Way_Out.ogg":
		_play_music(battleNoWayOut)
	if conv == "res://musig/Dungeon_-_Catacomb_Crawler.ogg":
		_play_music(dungeonCave1)

extends Node3D

const scene_type = 1
#1 = map, 2 = battle, 3 = village?
@onready var _player_body = $Player
@onready var _3dh1exitfront = $H1Exitfront
@onready var _3dh1exitback = $H1Exitback
var battle_bg: Texture
var spawn_request

func _ready() -> void:
	AudioPlayer.play_music_level("res://musig/Dungeon_-_Catacomb_Crawler.ogg")
	if player.last_exit == 'south':
		_player_body.position = _3dh1exitfront.position + Vector3()
	if player.last_exit == 'west':
		_player_body.position = _3dh1exitback.position + Vector3()
	$Player.disabled_spawn = true
	
func _on_3dh1exitfront_body_entered(body: Node3D) -> void:
	if body.name == _player_body.name:
		player.last_exit = 'south'
		sceneManager.goto_scene("res://Scenes/3dOverworld/3doverworld.tscn")

func _on_3dh1exitback_body_entered(body: Node3D) -> void:
	if body.name == _player_body.name:
		player.last_exit = 'west'
		sceneManager.goto_scene("res://Scenes/3dOverworld/3doverworld.tscn")

extends Node3D

const scene_type = 1
#1 = map, 2 = battle, 3 = village?
@onready var _player_body = $Player
@onready var _h1exitfront = $"3dH1Exitfront"
@onready var _h1exitback = $"3dH1Exitback"
var battle_bg: Texture
var spawn_request

func _ready() -> void:
	AudioPlayer.play_music_level("res://musig/Dungeon_-_Catacomb_Crawler.ogg")
	if player.last_exit == 'south':
		_player_body.position = _h1exitfront.position + Vector3(0,0,3)
	if player.last_exit == 'west':
		_player_body.position = _h1exitback.position + Vector3(0,0,0)
	$Player.disabled_spawn = true
	
func _on_H1Exitfront_body_entered(body: Node3D) -> void:
	if body.name == _player_body.name:
		player.last_exit = 'south'
		sceneManager.goto_scene("res://Scenes/3dOverworld/3doverworld.tscn")

func _on_H1Exitback_body_entered(body: Node3D) -> void:
	if body.name == _player_body.name:
		player.last_exit = 'west'
		sceneManager.goto_scene("res://Scenes/3dOverworld/3doverworld.tscn")

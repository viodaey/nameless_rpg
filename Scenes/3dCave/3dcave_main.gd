extends Node3D

const scene_type = 1
# 1 = map, 2 = battle, 3 = village?
@onready var _player_body = $Player
@onready var _cave_exit = $"CaveExit"
var battle_bg: Texture
var spawn_request

func _ready() -> void:
	AudioPlayer.play_music_level("res://musig/Dungeon_-_Catacomb_Crawler.ogg")
	if player.last_exit == 'cave':
		_player_body.position = _cave_exit.position + Vector3(0, 0, -5)

func _on_CaveExit_body_entered(body: Node3D) -> void:
	if body.name == _player_body.name:
		player.last_exit = 'cave'
		sceneManager.goto_scene("res://Scenes/3dOverworld/3doverworld.tscn")

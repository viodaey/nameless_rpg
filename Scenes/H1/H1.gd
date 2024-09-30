extends Node2D

const scene_type = 1
#1 = map, 2 = battle, 3 = village?
@onready var _player_body = $Player
@onready var _h1exitfront = $H1Exitfront
@onready var _h1exitback = $H1Exitback
var battle_bg: Texture
var spawn_request

func _ready() -> void:
	AudioPlayer.play_music_level("res://musig/Dungeon_-_Catacomb_Crawler.ogg")
	if player.last_exit == 'south':
		_player_body.position = _h1exitfront.position + Vector2(0,-20)
	if player.last_exit == 'west':
		_player_body.position = _h1exitback.position + Vector2(20,0)
	$Player.disabled_spawn = true
	
func _on_h1exitfront_body_entered(body: Node2D) -> void:
	if body.name == _player_body.name:
		player.last_exit = 'south'
		sceneManager.goto_scene("res://Scenes/Overworld/overworld.tscn")

func _on_h1exitback_body_entered(body: Node2D) -> void:
	if body.name == _player_body.name:
		player.last_exit = 'west'
		sceneManager.goto_scene("res://Scenes/Overworld/overworld.tscn")

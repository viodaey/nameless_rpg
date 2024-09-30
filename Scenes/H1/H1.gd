extends Node2D

const scene_type = 1
#1 = map, 2 = battle, 3 = village?
@onready var _player_body = $Player
@onready var _h1exitfront = $H1Exitfront
@onready var _h1exitback = $H1Exitback
var spawn_request

func _ready() -> void:
	AudioPlayer.play_music_level("res://musig/Dungeon_-_Catacomb_Crawler.ogg")
func _on_h1exitfront_body_entered(body: Node2D) -> void:
	if body.name == _player_body.name:
		_player_body.position = $H1Exitfront.position
func _on_h1exitback_body_entered(body: Node2D) -> void:
	if body.name == _player_body.name:
		_player_body.position = $H1Exitback.position

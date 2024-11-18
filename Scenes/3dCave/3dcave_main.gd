extends Node3D

const scene_type = 1
# 1 = map, 2 = battle, 3 = village?
@onready var _player_body = $Player
@onready var _cave_exit = $"CaveExit"
@export var min_lvl: int = 7
@export var max_lvl: int = 14
@export var world_enemies: Array [Enemy]
@export var battle_bg: Texture
@export var min_spawn_range: int = 60
@export var max_spawn_range: int = 90
@export var drops: Dictionary

var spawn_request

func _ready() -> void:
	inv.drops = drops
	AudioPlayer.play_music_level("res://musig/Dungeon_-_Catacomb_Crawler.ogg")
	if sceneManager.last_scene == "res://Scenes/Battle/battle.tscn":
		_player_body.position = player.position
	if player.last_exit == 'cave':
		_player_body.position = _cave_exit.position + Vector3(0, 0, -5)

func _on_CaveExit_body_entered(body: Node3D) -> void:
	if body.name == _player_body.name:
		player.last_exit = 'cave'
		sceneManager.goto_scene("res://Scenes/3dOverworld/3doverworld.tscn")

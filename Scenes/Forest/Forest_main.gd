extends Node2D

const scene_type = 1
#1 = map, 2 = battle, 3 = village?
@export var min_lvl: int = 7
@export var max_lvl: int = 14
@export var world_enemies: Array [Enemy]
@export var battle_bg: Texture
@onready var _player_body = $Player
var _spawned_npc  
var spawn_request

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioPlayer.play_music_level("res://musig/Dungeon_-_Catacomb_Crawler.ogg")
	if sceneManager.last_scene == "res://Scenes/Battle/battle.tscn":
		print(sceneManager.last_scene)
		_player_body.position = player.position
	if sceneManager.last_scene == "res://Scenes/Overworld/overworld.tscn":
		_player_body.position = $ForestExit.position + Vector2(-15,0)
		print(sceneManager.last_scene)


func _input(_event):
	pass

func _on_forest_exit_body_entered(body: Node2D) -> void:
	if body.name == _player_body.name:
		sceneManager.goto_scene("res://Scenes/Overworld/overworld.tscn")

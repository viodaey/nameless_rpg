extends Node2D

const scene_type = 1
#1 = map, 2 = battle, 3 = village?
@export var min_lvl: int = 1
@export var max_lvl: int = 8
@export var world_enemies: Array [Enemy]
@export var battle_bg: Texture
@export var drops: Dictionary
var spawn_npc = preload("res://Global/globalNPC.tscn")
var spawn = spawn_npc.instantiate()
@onready var _player_body = $Player
@onready var _cave_entrance = $CaveEntrance
@onready var _forest_entrance = $ForestEntrance
#@onready var _preload_npc = $NPC_1
var rng = RandomNumberGenerator.new()
var _spawned_npc  
var spawn_request
#var max_level = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inv.drops = drops
	AudioPlayer.play_music_level("fieldOverworld")
	if sceneManager.last_scene == "res://Scenes/Battle/battle.tscn":
		_player_body.position = player.position
	if sceneManager.last_scene == "res://Scenes/Cave/cave_001.tscn":
		_player_body.position = _cave_entrance.position + Vector2(0,20)
	if sceneManager.last_scene == "res://Scenes/Forest/Forest.tscn":
		_player_body.position = _forest_entrance.position + Vector2(20,0)

func _spawn_npc():
	if is_instance_valid($NPC_spawn):
		print("tried to spawn but valid instance found")
	else:
		var rng = RandomNumberGenerator.new()
		var enemy_select = rng.randi_range(1,len(world_enemies))
		var angle = rng.randi_range(0, TAU)
		var distance = rng.randi_range(80, 130)
		_player_body.get_node("RayCast2D").target_position += Vector2(distance*cos(angle), distance*sin(angle))
		if _player_body.get_node("RayCast2D") .is_colliding():
			_spawn_npc()

		else:
			spawn_request = load(world_enemies[enemy_select - 1].resource_path)
			add_child(spawn.duplicate())
			_spawned_npc = $NPC_spawn
			_spawned_npc.position = _player_body.position + Vector2(distance*cos(angle), distance*sin(angle))

func _despawn_npc():
	_spawned_npc.queue_free()


func _on_forest_entrance_body_entered(body: Node2D) -> void:
	if body.name == _player_body.name:
		sceneManager.goto_scene("res://Scenes/Forest/Forest.tscn")
		
func _on_cave_entrance_body_entered(body: Node2D) -> void:
	if body.name == _player_body.name:
		sceneManager.goto_scene("res://Scenes/Cave/cave_001.tscn")
extends Node2D

var spawn_npc = preload("res://Global/globalNPC.tscn")
var world_enemies = [
	preload("res://enemyResources/wolf_fire.tres"),
	preload("res://enemyResources/wolf_ice.tres"),
	preload("res://enemyResources/orc_baby.tres"),
	preload("res://enemyResources/orc_teen.tres"),
	preload("res://enemyResources/birdman_chick.tres")
	]
var spawn = spawn_npc.instantiate()
@onready var _player_body = $Player
@onready var _cave_entrance = $CaveEntrance
#@onready var _preload_npc = $NPC_1
var rng = RandomNumberGenerator.new()
var _spawned_npc  
var spawn_request

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioPlayer.play_music_level("fieldOverworld")
	if sceneManager.last_scene == "res://Scenes/Battle/battle.tscn":
		_player_body.position = player.position
	if sceneManager.last_scene == "res://Scenes/Cave/cave.tscn":
		_player_body.position.x = _cave_entrance.position.x
		_player_body.position.y = _cave_entrance.position.y + 15

	
func _spawn_npc():
	if is_instance_valid($NPC_spawn):
		print("tried to spawn but valid instance found")
	else:
		var enemy_select = rng.randi_range(1,len(world_enemies))
		var angle = rng.randi_range(0, TAU)
		var distance = rng.randi_range(80, 130)
		spawn_request = world_enemies[enemy_select - 1]
		add_child(spawn)
		_spawned_npc = $NPC_spawn
		_spawned_npc.position = _player_body.position + Vector2(distance*cos(angle), distance*sin(angle))
		##polar2cartesian
	

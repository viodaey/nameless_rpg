extends Node2D

@export var min_lvl: int = 1
@export var max_lvl: int = 12
@export var world_enemies: Array [Enemy]
var spawn_npc = preload("res://Global/globalNPC.tscn")
var spawn = spawn_npc.instantiate()
#var world_enemies = [
	#preload("res://enemyResources/wolf_fire.tres"),
	#preload("res://enemyResources/wolf_earth.tres"),
	#preload("res://enemyResources/orc_baby.tres"),
	#preload("res://enemyResources/orc_teen.tres"),
	#preload("res://enemyResources/birdman_chick.tres")
	#]
@onready var _player_body = $Player
@onready var _cave_entrance = $CaveEntrance
#@onready var _preload_npc = $NPC_1
var rng = RandomNumberGenerator.new()
var _spawned_npc  
var spawn_request
#var max_level = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioPlayer.play_music_level("fieldOverworld")
	if sceneManager.last_scene == "res://Scenes/Battle/battle.tscn":
		_player_body.position = player.position
	if sceneManager.last_scene == "res://Scenes/Cave/cave_001.tscn":
		_player_body.position.x = _cave_entrance.position.x
		_player_body.position.y = _cave_entrance.position.y + 15
	
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
	

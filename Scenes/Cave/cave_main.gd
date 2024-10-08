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
	if sceneManager.last_scene == "res://Scenes/Cave/cave_001.tscn":
		_player_body.position = $CaveExit.position + Vector2(15,0)
		print(sceneManager.last_scene)
	if sceneManager.last_scene == "res://Scenes/Cave/cave_00b.tscn":
		_player_body.position = $CaveRoyEntrance.position + Vector2(-15,0)
		print(sceneManager.last_scene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#func _spawn_npc():
	#if is_instance_valid($NPC_spawn):
		#print("tried to spawn but valid instance found")
	#else:
		#var rng = RandomNumberGenerator.new()
		#var enemy_select = rng.randi_range(1,len(world_enemies))
		#var angle = rng.randi_range(0, TAU)
		#var distance = rng.randi_range(80, 130)
		#_player_body.get_node("RayCast2D").target_position += Vector2(distance*cos(angle), distance*sin(angle))
		#if _player_body.get_node("RayCast2D") .is_colliding():
			#_spawn_npc()
		#else:
			#spawn_request = load(world_enemies[enemy_select - 1].resource_path)
			#add_child(spawn.duplicate())
			#_spawned_npc = $NPC_spawn
			#_spawned_npc.position = _player_body.position + Vector2(distance*cos(angle), distance*sin(angle))
#
#func _despawn_npc():
	#_spawned_npc.queue_free()

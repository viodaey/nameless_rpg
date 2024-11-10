extends Node3D

const scene_type = 1
#1 = map, 2 = battle, 3 = village?
@export var min_lvl: int = 7
@export var max_lvl: int = 14
@export var world_enemies: Array [Enemy]
@export var battle_bg: Texture
@export var drops: Dictionary
@export var min_spawn_range: int = 15
@export var max_spawn_range: int = 20
@onready var _player_body = $Player
@onready var _CaveExit = $"CaveExit"
var spawn_request


func _ready() -> void:
	AudioPlayer.play_music_level("res://musig/Dungeon_-_Catacomb_Crawler.ogg")
	if player.last_exit == '_CaveExit':
		_player_body.position = _CaveExit.position + Vector3(0,0.1,-5)
	
func _on_CaveExit_body_entered(body: Node3D) -> void:
	if body.name == _player_body.name:
		player.last_exit = '_CaveExit'
		sceneManager.goto_scene("res://Scenes/3dOverworld/3doverworld.tscn")


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
#func _on_Cave001Entrance_body_entered(body: Node3D) -> void:
	#if body.name == _player_body.name:
		#player.last_exit = 'overworld'
		#sceneManager.goto_scene("res://Scenes/3dCave/3dcave_001.tscn")
#
#func _on_H1Entrancefront_body_entered(body: Node3D) -> void:
	#if body.name == _player_body.name:
		#player.last_exit = 'south'
		#sceneManager.goto_scene("res://Scenes/3dH1/3dH1.tscn")
#
#func _on_H1Entranceback_body_entered(body: Node3D) -> void:
	#if body.name == _player_body.name:
		#player.last_exit = 'west'
		#sceneManager.goto_scene("res://Scenes/3dH1/3dH1.tscn")

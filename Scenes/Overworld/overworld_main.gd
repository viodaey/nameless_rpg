extends Node2D

const scene_type = 1
#1 = map, 2 = battle, 3 = village?
@export var min_lvl: int = 1
@export var max_lvl: int = 8
@export var world_enemies: Array [Enemy]
@export var battle_bg: Texture
@export var drops: Dictionary
@onready var _player_body = $Player
@onready var _cave_entrance = $CaveEntrance
@onready var _forest_entrance = $ForestEntrance
var rng = RandomNumberGenerator.new()
var _spawned_npc  
var spawn_request

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

func _input(_event):
	if Input.is_action_pressed("ui_cancel"):
		var monInvSc = load("res://Global/monManager.tscn").instantiate()
		get_node("Player").get_node("Camera2D").enabled = false
		add_child(monInvSc)
		get_tree().paused = true
	#pass

		

#func _spawn_npc():
	#if is_instance_valid($NPC_spawn):
		#print("tried to spawn but valid instance found")
	#else:
		#var rng = RandomNumberGenerator.new()
		#var enemy_select = rng.randi_range(1,len(world_enemies))
		#var angle = rng.randi_range(0, TAU)
		#var distance = rng.randi_range(80, 150)
		#_player_body.get_node("RayCast2D").target_position += Vector2(distance*cos(angle), distance*sin(angle))
		#if _player_body.get_node("RayCast2D") .is_colliding():
			#_spawn_npc()
#
		#else:
			#spawn_request = load(world_enemies[enemy_select - 1].resource_path)
			#add_child(spawn.duplicate())
			#var num = len(activeSpawns)
			#_spawned_npc = $NPC_spawn
			#_spawned_npc.name = "NPC_spawn" + "%d" %num
			#_spawned_npc.position = _player_body.position + Vector2(distance*cos(angle), distance*sin(angle))
			#activeSpawns.append(_spawned_npc.name)
#
#func _despawn_npc(npc):
	#get_node(npc).queue_free()
	#activeSpawns.erase(npc)

func _on_forest_entrance_body_entered(body: Node2D) -> void:
	if body.name == _player_body.name:
		sceneManager.goto_scene("res://Scenes/Forest/Forest.tscn")
		
func _on_cave_entrance_body_entered(body: Node2D) -> void:
	if body.name == _player_body.name:
		sceneManager.goto_scene("res://Scenes/Cave/cave_001.tscn")

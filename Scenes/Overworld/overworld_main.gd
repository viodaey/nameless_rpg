extends Node2D

const scene_type = 1
#1 = map, 2 = battle, 3 = village?
@export var min_lvl: int = 1
@export var max_lvl: int = 8
@export var world_enemies: Array [Enemy]
@export var battle_bg: Texture
@export var drops: Dictionary
@export var min_spawn_range: int = 350
@export var max_spawn_range: int = 450
@onready var _player_body = $Player
@onready var _cave_entrance = $CaveEntrance
@onready var _forest_entrance = $ForestEntrance
@onready var _h1entrancefront = $H1Entrancefront
@onready var _h1entranceback = $H1Entranceback

var spawn_request


func _ready() -> void:
	inv.drops = drops
	AudioPlayer.play_music_level("fieldOverworld")
	if sceneManager.last_scene == "res://Scenes/Battle/battle.tscn":
		_player_body.position = player.position
	if sceneManager.last_scene == "res://Scenes/Cave/cave_001.tscn":
		_player_body.position = _cave_entrance.position + Vector2(0,20)
	if sceneManager.last_scene == "res://Scenes/Forest/Forest.tscn":
		_player_body.position = _forest_entrance.position + Vector2(20,0)
	if sceneManager.last_scene == "res://Scenes/H1/H1.tscn":
		if player.last_exit == 'south':
			_player_body.position = _h1entrancefront.position + Vector2(0,20)
		if player.last_exit == 'west':
			_player_body.position = _h1entranceback.position + Vector2(-20,0)

func _on_forest_entrance_body_entered(body: Node2D) -> void:
	if body.name == _player_body.name:
		sceneManager.goto_scene("res://Scenes/Forest/Forest.tscn")
func _on_cave_entrance_body_entered(body: Node2D) -> void:
	if body.name == _player_body.name:
		sceneManager.goto_scene("res://Scenes/Cave/cave_001.tscn")
func _on_h1entrancefront_body_entered(body: Node2D) -> void:
	if body.name == _player_body.name:
		sceneManager.goto_scene("res://Scenes/H1/H1.tscn")
		player.last_exit = 'south'
func _on_h1entranceback_body_entered(body: Node2D) -> void:
	if body.name == _player_body.name:
		sceneManager.goto_scene("res://Scenes/H1/H1.tscn")
		player.last_exit = 'west'

#func _input(_event):
	#if Input.is_action_pressed("ui_cancel"):
		#await (get_tree().create_timer(0.1).timeout)
		#main_menu()

#func main_menu():
	#var mainMenuScene = load("res://Global/mainMenu.tscn").instantiate()
	#get_node("Player").get_node("Camera2D").enabled = false
	#get_parent().add_child(mainMenuScene)
	#get_tree().paused = true

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

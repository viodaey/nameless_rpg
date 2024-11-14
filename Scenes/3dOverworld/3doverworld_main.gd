extends Node3D

const scene_type = 1
#1 = map, 2 = battle, 3 = village?
@export var min_lvl: int = 1
@export var max_lvl: int = 8
@export var world_enemies: Array [Enemy]
@export var battle_bg: Texture
@export var drops: Dictionary
@export var min_spawn_range: int = 75
@export var max_spawn_range: int = 125
@onready var _player_body = $Player
@onready var _Cave_entrance = $CaveEntrance
@onready var _H1Entrancefront = $H1Entrancefront
@onready var _H1Entranceback = $H1Entranceback
@onready var _Forest_Entrance = $ForestEntrance

var spawn_request

func _ready() -> void:
	inv.drops = drops
	AudioPlayer.play_music_level("fieldOverworld")
	if sceneManager.last_scene == "res://Scenes/Battle/battle.tscn":
		_player_body.position = player.position
	if sceneManager.last_scene == "res://Scenes/3dCave/3dcave_001.tscn":
		_player_body.position = Vector3(_Cave_entrance.position.x, _player_body.position.y, _Cave_entrance.position.z + 3)
	if sceneManager.last_scene == "res://Scenes/3dForest/3dforest.tscn":
		_player_body.position = Vector3(_Forest_Entrance.position.x + 10, _player_body.position.y, _Forest_Entrance.position.z - 20)
	if sceneManager.last_scene == "res://Scenes/3dH1/3dh1.tscn":
		if player.last_exit == 'south':
			_player_body.position = Vector3(_H1Entrancefront.position.x, _player_body.position.y, _H1Entrancefront.position.z + 3)
		if player.last_exit == 'west':
			_player_body.position = Vector3(_H1Entranceback.position.x - 3, _player_body.position.y, _H1Entranceback.position.z)

func _on_CaveEntrance_body_entered(body: Node3D) -> void:
	if body.name == _player_body.name:
		player.last_exit = 'overworld'
		sceneManager.goto_scene("res://Scenes/3dCave/3dcave_001.tscn")

func _on_H1Entrancefront_body_entered(body: Node3D) -> void:
	if body.name == _player_body.name:
		player.last_exit = 'south'
		sceneManager.goto_scene("res://Scenes/3dH1/3dh1.tscn")

func _on_H1Entranceback_body_entered(body: Node3D) -> void:
	if body.name == _player_body.name:
		player.last_exit = 'west'
		sceneManager.goto_scene("res://Scenes/3dH1/3dh1.tscn")

func _on_ForestEntrance_body_entered(body: Node3D) -> void:
	if body.name == _player_body.name:
		player.last_exit = 'overworld'
		sceneManager.goto_scene("res://Scenes/3dForest/3dforest.tscn")

##func _input(_event):
	##if Input.is_action_pressed("ui_cancel"):
		##await (get_tree().create_timer(0.1).timeout)
		##main_menu()
#
##func main_menu():
	##var mainMenuScene = load("res://Global/mainMenu.tscn").instantiate()
	##get_node("Player").get_node("Camera2D").enabled = false
	##get_parent().add_child(mainMenuScene)
	##get_tree().paused = true
#
##func _spawn_npc():
	##if is_instance_valid($NPC_spawn):
		##print("tried to spawn but valid instance found")
	##else:
		##var rng = RandomNumberGenerator.new()
		##var enemy_select = rng.randi_range(1,len(world_enemies))
		##var angle = rng.randi_range(0, TAU)
		##var distance = rng.randi_range(80, 150)
		##_player_body.get_node("RayCast2D").target_position += Vector2(distance*cos(angle), distance*sin(angle))
		##if _player_body.get_node("RayCast2D") .is_colliding():
			##_spawn_npc()
##
		##else:
			##spawn_request = load(world_enemies[enemy_select - 1].resource_path)
			##add_child(spawn.duplicate())
			##var num = len(activeSpawns)
			##_spawned_npc = $NPC_spawn
			##_spawned_npc.name = "NPC_spawn" + "%d" %num
			##_spawned_npc.position = _player_body.position + Vector2(distance*cos(angle), distance*sin(angle))
			##activeSpawns.append(_spawned_npc.name)
##
##func _despawn_npc(npc):
	##get_node(npc).queue_free()
	##activeSpawns.erase(npc)

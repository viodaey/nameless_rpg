extends Node3D

const scene_type = 1
#1 = map, 2 = battle, 3 = village?
@export var min_lvl: int = 1
@export var max_lvl: int = 8
@export var world_enemies: Array [Enemy]
@export var battle_bg: Texture
@export var drops: Dictionary
@export var min_spawn_range: int = 60
@export var max_spawn_range: int = 90
@onready var _player_body = $Player
@onready var _Cave_entrance = $CaveEntrance
@onready var _H1Entrancefront = $H1Entrancefront
@onready var _H1Entranceback = $H1Entranceback
@onready var _Forest_Entrance = $ForestEntrance
var spawn_request
#var _spawned_npc 

func _ready() -> void:
	SimpleGrass.set_interactive(true)
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
	#if player._introscene1 == 0:
		#$Player.disabled_spawn = true
	#MainMenu.map_scene = get_tree().current_scene

#func _Introscene1():
	#var hold_speed = $Player.speed
	#$Player.speed = 0
	#$Player/Camera3D.enabled = false
	#$Intro_subscene1.visible = true
	#$Intro_subscene1/dialogue/diaCamera3D.enabled = true
	#$Intro_subscene1/dialogue/diaCamera3D/Fog.visible = true 
	#var dia1 = $Intro_subscene1/dialogue/dia_1
	#var dia2 = $Intro_subscene1/dialogue/dia_2
	#var dia1label = $Intro_subscene1/dialogue/dia_1/MarginContainer/txt
	#var dia2label = $Intro_subscene1/dialogue/dia_2/MarginContainer/txt
	#var HoodedFigureIntro = $Intro_subscene1/npcs/scen1HoodedFigureIntro
	#dia1label.text = "Hey, you there!\nover here, help me!"
	#dia2label.text = "Can't\nhold this\nout much\nlonger"
	#var fogtween = get_tree().create_tween()
	#var camtween = get_tree().create_tween()
	#fogtween.tween_property($Fo_subscene1/dialogue/diaCamera3D/Fog, "color:a", 0, 3.5)
	#camtween.tween_property($Intro_subscene1/dialogue/diaCamera3D, "position:x", $Intro_subscene1/dialogue/diaCamera3D.position.x + 80, 8)
	#await get_tree().create_timer(2.2).timeout
	#dia1.visible = true
	#dialog(dia1label,"Hey, you there!\nover here, help me!")
	#await get_tree().create_timer(2.0).timeout
	#var HoodedFiguretween = get_tree().create_tween()
	#HoodedFiguretween.tween_property(HoodedFigureIntro, "position:z", HoodedFigureIntro.position.z - 1.5, 0.08)
	#HoodedFiguretween.tween_property(HoodedFigureIntro, "position:z", HoodedFigureIntro.position.z + 1.5, 0.08)
	#HoodedFiguretween.set_loops(3)
	#await get_tree().create_timer(3).timeout
	#dia1.visible = false
	#dia2.visible = true
	#dialog(dia2label, "Can't\nhold this\nout much\nlonger.")
	#await(get_tree().create_timer(2.5).timeout)
	#player.Intro_scene1 = 1
	#await(get_tree().create_timer(2.5).timeout)
	#fogtween = get_tree().create_tween()
	#fogtween.tween_property($Intro_subscene1/dialogue/diaCamera3D/Fog, "color:a", 1, 3)
	#await(fogtween.finished)
	#$Intro_subscene1/dialogue/diaCamera3D/Fog.visible = false
	#dia2.visible = false
	#$Intro_subscene1/dialogue/diaCamera3D.enabled = false
	#$Player/Camera3D.enabled = true
	#$Player.speed = hold_speed
	#$Player.disabled_spawn = false
#
#func dialog(label, text):
	#var visible_characters = 0
	#label.visible_characters = visible_characters
	#label.text = text
	#for i in text: 
		#visible_characters = (visible_characters + 1)
		#label.visible_characters = visible_characters
		#await(get_tree().create_timer(0.07).timeout)
#
#func _on_subscene1_trigger_entered(body: Node3D) -> void:
	#if body.name == _player_body.name:
		#if player._introscene1 == 0:
			#_Introscene1()

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
	##get_node("Player").get_node("Camera3D").enabled = false
	##get_parent().add_child(mainMenuScene)
	##get_tree().paused = true
#
#func _spawn_npc():
	#if is_instance_valid($NPC_spawn):
		#print("tried to spawn but valid instance found")
	#else:
		#var rng = RandomNumberGenerator.new()
		#var enemy_select = rng.randi_range(1,len(world_enemies))
		#var angle = rng.randi_range(0, TAU)
		#var distance = rng.randi_range(80, 150)
		#_player_body.get_node("RayCast3D").target_position += Vector3((distance)*cos(angle),0, (distance)*sin(angle))
		#if _player_body.get_node("RayCast3D") .is_colliding():
			#_spawn_npc()
		#else:
			#spawn_request = load(world_enemies[enemy_select - 1].resource_path)
			#add_child(_spawned_npc.duplicate())
			#var num = len(activeSpawns)
			#_spawned_npc = $NPC_spawn
			#_spawned_npc.name = "NPC_spawn" + "%d" %num
			#_spawned_npc.position = _player_body.position + Vector3((distance)*cos(angle),0, (distance)*sin(angle))
			#activeSpawns.append(_spawned_npc.name)

#func _despawn_npc(npc):
	#get_node(npc).queue_free()
	#activeSpawns.erase(npc)

# EXAMPLE HOW TO USE GLOBAL DIALOG
	#var load_dialog = load("res://Global/dialog_scene.tscn")
	#add_child(load_dialog.instantiate())
	#var dialog = get_node("Dialog")
	#dialog.dia[0].position = get_node("Player").position + Vector3(-200,-200)
	#dialog.dia_decision.position = get_node("Player").position + Vector3(-200,-50)
	#dialog.set_text(0, "You wanna vibe?", 10)
	#dialog.set_color(0,"green")
	#var possible_answers = ["No","LETS GO"]
	#var answer = await dialog.decide(possible_answers)
	#if answer == 1:
		#dialog.set_text(0, "OKE BYE :(", 10)
	#if answer == 2:
		#dialog.set_text(0, "LETS DANCE!", 10)

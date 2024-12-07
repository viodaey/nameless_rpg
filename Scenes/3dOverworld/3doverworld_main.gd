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
		_player_body.position = Vector3(_Cave_entrance.position.x, _player_body.position.y, _Cave_entrance.position.z + 10)
	if sceneManager.last_scene == "res://Scenes/3dForest/3dforest.tscn":
		_player_body.position = Vector3(_Forest_Entrance.position.x + 10, _player_body.position.y, _Forest_Entrance.position.z - 20)
	if sceneManager.last_scene == "res://Scenes/3dH1/3dh1.tscn":
		if player.last_exit == 'south':
			_player_body.position = Vector3(_H1Entrancefront.position.x, _player_body.position.y, _H1Entrancefront.position.z + 10)
		if player.last_exit == 'west':
			_player_body.position = Vector3(_H1Entranceback.position.x - 10, _player_body.position.y +0.5, _H1Entranceback.position.z)
	if player.scene_progression["overworld"] < 2:
		_player_body.disabled_spawn = true
	else:
		$introScene.visible = false
	if player.scene_progression["overworld"] == 1:
		_introscene2()
	MainMenu.map_scene = get_tree().current_scene

func _introscene1():
	var dialog = preload("res://Global/dialog_scene.tscn")
	var introscene = $introScene
	var camera = $Player/Camera3D
	_player_body.in_scene = true
	introscene.visible = true
	add_child(dialog.instantiate())
	dialog = get_node("Dialog")
	dialog.set_color(0,"black")
	#_player_body.speed = 0
	_player_body.get_node("AnimatedSprite3D").play("idleup")
	dialog.set_center_offset(0,-0.75,-0.75)
	dialog.dia[0].scale = Vector2(1.3,1.3)
	dialog.set_diasize(0,"regular")
	await dialog.set_text(0,"Hey, you there!",2)
	#await dialog.set_text(0,"Let's see how you handle a very long text like this one to test if autowrapping does so correctly",2)
	## to do: look around
	await dialog.set_text(0,"Over here, help me!",0.5, false, true)
	var tween = get_tree().create_tween()
	tween.tween_property(camera, "position:x", camera.position.x - 30, 1.5)
	tween.parallel().tween_property(camera, "position:z", camera.position.z - 25, 1.5)
	await tween.finished
	await dialog.set_text(0,"I can't hold on for much longer...", 1.5, false, true)
	await get_tree().create_timer(1.5).timeout
	dialog.set_text(0,"")
	## move/rush player towards encounter, move camera back to player center
	tween = get_tree().create_tween()
	tween.tween_property(_player_body, "position:x", introscene.position.x, 4.2)
	tween.parallel().tween_property(_player_body, "position:z", introscene.position.z, 4.2)
	var cameratween = get_tree().create_tween()
	cameratween.tween_property(camera, "position:x", camera.position.x + 30, 0.5)
	cameratween.parallel().tween_property(camera, "position:z", camera.position.z + 25, 0.5)
	_player_body.get_node("AnimatedSprite3D").play("moveup")
	#await tween.finished
	## advance dialognumber
	player.scene_progression["overworld"] = 1
	await get_tree().create_timer(2.5).timeout
	## set custom encounter
	player.enemy_encounter = [
		"res://enemy_resources/enemy_identityfiles/wolfearth_evo1.tres", 
		"res://enemy_resources/enemy_identityfiles/wolfnature_evo1.tres"]
	## set custom monster level for encounter
	sceneManager.mon_min_lvl = 1
	sceneManager.mon_max_lvl = 2
	player.position = _player_body.position
	sceneManager.goto_scene("res://Scenes/Battle/battle.tscn")

func _introscene2():
	var dialog = preload("res://Global/dialog_scene.tscn")
	var introscene = $introScene
	_player_body.in_scene = true
	introscene.visible = true
	introscene.get_node("WolfIntro").visible = false
	introscene.get_node("WolfIntro2").visible = false
	add_child(dialog.instantiate())
	dialog = get_node("Dialog")
	var fog = dialog.get_node("Fog")
	dialog.set_color(0,"black")
	dialog.set_diasize(0,"regular")
	_player_body.get_node("AnimatedSprite3D").play("idleleft")
	dialog.set_center_offset(0,-0.65,-0.70)
	dialog.set_center_offset(3,0,0.70)
	dialog.dia[0].scale = Vector2(1.3,1.3)
	dialog.dia[3].scale = Vector2(1.3,1.3)
	fog.visible = true
	var fogtween = get_tree().create_tween()
	fogtween.tween_property(fog, "modulate:a", 0, 2.5)
	await fogtween.finished
	await dialog.set_text(0,"*panting* ..... that should be the last of them.",0,true)
	await dialog.set_text(0,"I usually have no issue with standing my own against the wildlife. But they seem to be more ferocious than ever.",1,true)
	await dialog.set_text(0,"and they just kept on coming...", 1,true)
	#await dialog.set_text(0,"I guess it also didnt help that i got myself hurt",1, true)
	await dialog.set_text(0,"Anyway, i'm glad that you showed up stranger. \nThank you",1,true)
	await dialog.set_text(0,"You seem to be able to stand your own. But i might be able to teach you a thing or two",1,true) 
	## class specific dialog? e.g. know how to handle a sword, throw a fireball, manage a bow etc
	await dialog.set_text(0,"... and we could really use someone like you.",1,true)
	await dialog.set_text(0,"You should come visit me at the dock when you have the time.",0,true)
	await dialog.set_text(0,"You can find the dock where the river and the mountains cross, northwest of here.",0,true)
	await dialog.set_text(0,"One last thing before you go. Let me see those wounds and take this.",1.5,true)
	dialog.set_diasize(3,"small")
	await dialog.set_text(3,"You are fully healed", 1)
	await dialog.set_text(3,"You obtained Potion (x2)", 1)
	inv.add_item(inv.item_id[0], 2)
	player.full_heal()
	fogtween = get_tree().create_tween()
	fogtween.tween_property(fog, "modulate:a", 1, 2)
	await fogtween.finished
	introscene.visible = false
	fogtween = get_tree().create_tween()
	fogtween.tween_property(fog, "modulate:a", 0, 2)
	await fogtween.finished
	_player_body.in_scene = false
	_player_body.disabled_spawn = false
	player.scene_progression["overworld"] = 2
	dialog.queue_free()

func _physics_process(delta: float) -> void:
	SimpleGrass.set_player_position(_player_body.global_position)

func _on_subscene1_trigger_entered(body: Node3D) -> void:
	if body.name == _player_body.name:
		if player.scene_progression["overworld"] == 0:
			_introscene1()

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

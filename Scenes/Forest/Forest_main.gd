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
		_player_body.position = player.position
	if sceneManager.last_scene == "res://Scenes/Overworld/overworld.tscn":
		_player_body.position = $ForestExit.position + Vector2(-15,0)
	if player.forest_scene1 == 0:
		$Player.disabled_spawn = true
	MainMenu.map_scene = get_tree().current_scene

func _input(_event):
	pass

func _on_forest_exit_body_entered(body: Node2D) -> void:
	if body.name == _player_body.name:
		sceneManager.goto_scene("res://Scenes/Overworld/overworld.tscn")

func _forestscene1():
	var hold_speed = $Player.speed
	$Player.speed = 0
	$Player/Camera2D.enabled = false
	$Forest_subscene1.visible = true
	$Forest_subscene1/dialogue/diaCamera2D.enabled = true
	$Forest_subscene1/dialogue/diaCamera2D/Fog.visible = true 
	var dia1 = $Forest_subscene1/dialogue/dia_1
	var dia2 = $Forest_subscene1/dialogue/dia_2
	var dia3 = $Forest_subscene1/dialogue/dia_3
	var dia1label = $Forest_subscene1/dialogue/dia_1/MarginContainer/txt
	var dia2label = $Forest_subscene1/dialogue/dia_2/MarginContainer/txt
	var dia3label = $Forest_subscene1/dialogue/dia_3/MarginContainer/txt
	var orcleader = $Forest_subscene1/npcs/scen1orcteen
	dia1label.text = ""
	dia2label.text = ""
	dia3label.text = ""
	var fogtween = get_tree().create_tween()
	var camtween = get_tree().create_tween()
	fogtween.tween_property($Forest_subscene1/dialogue/diaCamera2D/Fog, "color:a", 0, 3.5)
	camtween.tween_property($Forest_subscene1/dialogue/diaCamera2D, "position:x", $Forest_subscene1/dialogue/diaCamera2D.position.x + 80, 8)
	await get_tree().create_timer(2.2).timeout
	dia1.visible = true
	dialog(dia1label, "    You give us crystal, \n     NOW!")
	await get_tree().create_timer(2.0).timeout
	var orctween = get_tree().create_tween()
	orctween.tween_property(orcleader, "position:y", orcleader.position.y - 1.5, 0.08)
	orctween.tween_property(orcleader, "position:y", orcleader.position.y + 1.5, 0.08)
	orctween.set_loops(3)
	await get_tree().create_timer(3).timeout
	dia1.visible = false
	dia3.visible = true
	dialog(dia3label, "...never!")
	await(get_tree().create_timer(2.5).timeout)
	dia2.visible = true
	await(dialog(dia2label, "Stay away from us \n you creep! \n                  Help!!"))
	player.forest_scene1 = 1
	await(get_tree().create_timer(2.5).timeout)
	fogtween = get_tree().create_tween()
	fogtween.tween_property($Forest_subscene1/dialogue/diaCamera2D/Fog, "color:a", 1, 3)
	await(fogtween.finished)
	$Forest_subscene1/dialogue/diaCamera2D/Fog.visible = false
	dia2.visible = false
	dia3.visible = false
	$Forest_subscene1/dialogue/diaCamera2D.enabled = false
	$Player/Camera2D.enabled = true
	$Player.speed = hold_speed
	$Player.disabled_spawn = false
	

func _forestscene2():
	var hold_speed = $Player.speed
	$Player.speed = 0
	$Player/Camera2D.enabled = false
	$Forest_subscene1.visible = true
	$Forest_subscene1/dialogue/diaCamera2D.enabled = true
	$Forest_subscene1/dialogue/diaCamera2D/Fog.visible = true 
	var dia1 = $Forest_subscene1/dialogue/dia_1
	var dia2 = $Forest_subscene1/dialogue/dia_2
	var dia3 = $Forest_subscene1/dialogue/dia_3
	var dia1label = $Forest_subscene1/dialogue/dia_1/MarginContainer/txt
	var dia2label = $Forest_subscene1/dialogue/dia_2/MarginContainer/txt
	var dia3label = $Forest_subscene1/dialogue/dia_3/MarginContainer/txt
	var orcleader = $Forest_subscene1/npcs/scen1orcteen
	dia1label.text = ""
	dia2label.text = ""
	dia3label.text = ""
	var fogtween = get_tree().create_tween()
	var camtween = get_tree().create_tween()
	fogtween.tween_property($Forest_subscene1/dialogue/diaCamera2D/Fog, "color:a", 0, 3.5)
	camtween.tween_property($Forest_subscene1/dialogue/diaCamera2D, "position:x", $Forest_subscene1/dialogue/diaCamera2D.position.x + 80, 8)
	await get_tree().create_timer(2.2).timeout
	dia3.visible = true
	await dialog(dia3label, "Stop, please! \n The forest needs these!")
	await get_tree().create_timer(1.5).timeout
	dia3.visible = false
	dia1.visible = true
	await dialog(dia1label, "  ... NO GIVE CRYSTAL, I SMASH \n  KHAZ'KHE GRUB GRUB!")
	await get_tree().create_timer(2.0).timeout
	var orctween = get_tree().create_tween()
	orctween.tween_property(orcleader, "position:y", orcleader.position.y - 1.5, 0.08)
	orctween.tween_property(orcleader, "position:y", orcleader.position.y + 1.5, 0.08)
	orctween.set_loops(3)
	await get_tree().create_timer(1.5).timeout
	#orcleader.flip_h = false
	await(dialog(dia1label, "    ....... who dhere?!"))
	orctween = get_tree().create_tween()
	orctween.tween_property(orcleader, "position", orcleader.position + Vector2(3, 8), 0.9)
	await(get_tree().create_timer(3).timeout)
	dia1.visible = false
	dia3.visible = true
	dialog(dia3label, "...never!")
	await(get_tree().create_timer(2.5).timeout)
	dia2.visible = true
	await(dialog(dia2label, "Stay away from us \n you creep! \n                  Help!!"))
	player.forest_scene1 = 1
	await(get_tree().create_timer(2.5).timeout)
	fogtween = get_tree().create_tween()
	fogtween.tween_property($Forest_subscene1/dialogue/diaCamera2D/Fog, "color:a", 1, 3)
	await(fogtween.finished)
	$Forest_subscene1/dialogue/diaCamera2D/Fog.visible = false
	dia2.visible = false
	dia3.visible = false
	$Forest_subscene1/dialogue/diaCamera2D.enabled = false
	$Player/Camera2D.enabled = true
	$Player.speed = hold_speed
	$Player.disabled_spawn = false

func dialog(label, text):
	var visible_characters = 0
	label.visible_characters = visible_characters
	label.text = text
	for i in text: 
		visible_characters = (visible_characters + 1)
		label.visible_characters = visible_characters
		await(get_tree().create_timer(0.05).timeout)

func _on_subscene1_trigger_entered(body: Node2D) -> void:
	if body.name == _player_body.name:
		if player.forest_scene1 == 0:
			_forestscene1()
			

func _on_subscene1_trigger_2_body_entered(body: Node2D) -> void:
	if body.name == _player_body.name:
		if player.forest_scene1 == 1:
			_forestscene2()

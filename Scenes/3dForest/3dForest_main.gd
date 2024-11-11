extends Node3D

const scene_type = 1
#1 = map, 2 = battle, 3 = village?
@export var min_lvl: int = 7
@export var max_lvl: int = 14
@export var world_enemies: Array [Enemy]
@export var battle_bg: Texture
@export var min_spawn_range: int = 350
@export var max_spawn_range: int = 450
@onready var _player_body = $Player
@onready var Forest_Exit = $"ForestExit"
var spawn_request

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioPlayer.play_music_level("res://musig/Dungeon_-_Catacomb_Crawler.ogg")
	if sceneManager.last_scene == "res://Scenes/Battle/battle.tscn":
		_player_body.position = player.position
	if sceneManager.last_scene == "res://Scenes/3dOverworld/3doverworld.tscn":
		_player_body.position = $ForestExit.position + Vector3(0,0,0)
		
	#if player.forest_scene1 == 0:
		#$Player.disabled_spawn = true
	#MainMenu.map_scene = get_tree().current_scene
#
#func _input(_event):
	#pass

func _on_Forest_Exit_body_entered(body: Node3D) -> void:
	if body.name == _player_body.name:
		sceneManager.goto_scene("res://Scenes/3dOverworld/3doverworld.tscn")

#func _forestscene1():
	#var hold_speed = $Player.speed
	#$Player.speed = 0
	#$Player/Camera3D.enabled = false
	#$Forest_subscene1.visible = true
	#$Forest_subscene1/dialogue/diaCamera3D.enabled = true
	#$Forest_subscene1/dialogue/diaCamera3D/Fog.visible = true 
	#var dia1 = $Forest_subscene1/dialogue/dia_1
	#var dia2 = $Forest_subscene1/dialogue/dia_2
	#var dia3 = $Forest_subscene1/dialogue/dia_3
	#var dia1label = $Forest_subscene1/dialogue/dia_1/MarginContainer/txt
	#var dia2label = $Forest_subscene1/dialogue/dia_2/MarginContainer/txt
	#var dia3label = $Forest_subscene1/dialogue/dia_3/MarginContainer/txt
	#var orcleader = $Forest_subscene1/npcs/scen1orcteen
	#dia1label.text = ""
	#dia2label.text = ""
	#dia3label.text = ""
	#var fogtween = get_tree().create_tween()
	#var camtween = get_tree().create_tween()
	#fogtween.tween_property($Forest_subscene1/dialogue/diaCamera3D/Fog, "color:a", 0, 3.5)
	#camtween.tween_property($Forest_subscene1/dialogue/diaCamera3D, "position:x", $Forest_subscene1/dialogue/diaCamera3D.position.x + 80, 8)
	#await get_tree().create_timer(2.2).timeout
	#dia1.visible = true
	#dialog(dia1label, "    You give us crystal, \n     NOW!")
	#await get_tree().create_timer(2.0).timeout
	#var orctween = get_tree().create_tween()
	#orctween.tween_property(orcleader, "position:y", orcleader.position.y - 1.5, 0.08)
	#orctween.tween_property(orcleader, "position:y", orcleader.position.y + 1.5, 0.08)
	#orctween.set_loops(3)
	#await get_tree().create_timer(3).timeout
	#dia1.visible = false
	#dia3.visible = true
	#dialog(dia3label, "...never!")
	#await(get_tree().create_timer(2.5).timeout)
	#dia2.visible = true
	#await(dialog(dia2label, "Stay away from us \n you creep! \n                  Help!!"))
	#player.forest_scene1 = 1
	#await(get_tree().create_timer(2.5).timeout)
	#fogtween = get_tree().create_tween()
	#fogtween.tween_property($Forest_subscene1/dialogue/diaCamera3D/Fog, "color:a", 1, 3)
	#await(fogtween.finished)
	#$Forest_subscene1/dialogue/diaCamera3D/Fog.visible = false
	#dia2.visible = false
	#dia3.visible = false
	#$Forest_subscene1/dialogue/diaCamera3D.enabled = false
	#$Player/Camera3D.enabled = true
	#$Player.speed = hold_speed
	#$Player.disabled_spawn = false
	#
#
#func _forestscene2():
	#var hold_speed = $Player.speed
	#var dia1 = $Forest_subscene1/dialogue/dia_1
	#var dia2 = $Forest_subscene1/dialogue/dia_2
	#var dia3 = $Forest_subscene1/dialogue/dia_3
	#var dia1label = $Forest_subscene1/dialogue/dia_1/MarginContainer/txt
	#var dia2label = $Forest_subscene1/dialogue/dia_2/MarginContainer/txt
	#var dia3label = $Forest_subscene1/dialogue/dia_3/MarginContainer/txt
	#var orcleader = $Forest_subscene1/npcs/scen1orcteen
	#$Player.speed = 0
	#$Player/Camera3D.enabled = false
	#$Forest_subscene1.visible = true
	#$Forest_subscene1/dialogue/diaCamera3D.enabled = true
	#$Forest_subscene1/dialogue/diaCamera3D/Fog.visible = true 
	#$Forest_subscene1/dialogue/diaCamera3D.position = orcleader.position + Vector3(20,0,-10)
#
	#dia1label.text = ""
	#dia2label.text = ""
	#dia3label.text = ""
	#var fogtween = get_tree().create_tween()
	#fogtween.tween_property($Forest_subscene1/dialogue/diaCamera3D/Fog, "color:a", 0, 3.5)
	#await get_tree().create_timer(2.2).timeout
	#dia3.visible = true
	#await dialog(dia3label, "Just leave us alone!")
	#await get_tree().create_timer(2.5).timeout
	#dia3.visible = false
	#dia1.visible = true
	#dialog(dia1label, "... NO GIVE CRYSTAL \n .... I SMASH!!")
	#await get_tree().create_timer(2.5).timeout
	#var orctween = get_tree().create_tween()
	#orctween.tween_property(orcleader, "position:y", orcleader.position.y - 1.5, 0.08)
	#orctween.tween_property(orcleader, "position:y", orcleader.position.y + 1.5, 0.08)
	#orctween.set_loops(3)
	#await get_tree().create_timer(2.5).timeout
	#await dialog(dia1label, " KHAZ'KHE GRUB GRUB!!  ")
	#await get_tree().create_timer(2.5).timeout
#
	##orcleader.flip_h = false
	#await(dialog(dia1label, "....... who dhere?!"))
	#orctween = get_tree().create_tween()
	#orctween.tween_property(orcleader, "position", orcleader.position + Vector3(3,0, 8), 0.9)
	#var camtween = get_tree().create_tween()
	#camtween.tween_property($Forest_subscene1/dialogue/diaCamera3D, "position:y", $Forest_subscene1/dialogue/diaCamera3D.position.y + 10, 1)
	#await get_tree().create_timer(2).timeout
	#await dialog(dia1label, ".... \n ......HUMAN??!!" )
	#await get_tree().create_timer(3).timeout
	#dialog(dia1label,"....SMASH HUMAN!!")
	#await get_tree().create_timer(1.1).timeout
	#orctween = get_tree().create_tween()
	#orctween.tween_property(orcleader, "position:y", orcleader.position.y - 1.5, 0.08)
	#orctween.tween_property(orcleader, "position:y", orcleader.position.y + 1.5, 0.08)
	#orctween.set_loops(3)
	#await(get_tree().create_timer(3.5).timeout)
	#dia1.visible = false
	#dia3.visible = true
	#dialog(dia3label, "HAHA")
	#dia2.visible = true
	#await(dialog(dia2label, "GG"))
	#player.forest_scene1 = 2
	#var babytween = get_tree().create_tween()
	#babytween.tween_property($Forest_subscene1/npcs/scen1orcbaby3, "position", $Player.position - $Forest_subscene1.position, 4)
	#babytween = get_tree().create_tween()
	#babytween.tween_property($Forest_subscene1/npcs/scen1orcbaby4, "position", $Player.position - $Forest_subscene1.position, 4)
	#await(get_tree().create_timer(2.5).timeout)
	#fogtween = get_tree().create_tween()
	#fogtween.tween_property($Forest_subscene1/dialogue/diaCamera3D/Fog, "color:a", 1, 3)
	#await(fogtween.finished)
	#$Forest_subscene1/dialogue/diaCamera3D/Fog.visible = false
	#dia2.visible = false
	#dia3.visible = false
	#$Forest_subscene1/dialogue/diaCamera3D.enabled = false
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
		#if player.forest_scene1 == 0:
			#_forestscene1()
			#
#
#func _on_subscene1_trigger_2_body_entered(body: Node3D) -> void:
	#if body.name == _player_body.name:
		#if player.forest_scene1 == 1:
			#_forestscene2()
#
#
#func _on_button_pressed() -> void:
	#_forestscene2()
	 ## Replace with function body.

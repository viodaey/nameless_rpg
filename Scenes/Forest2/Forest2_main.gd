extends Node2D

const scene_type = 1
#1 = map, 2 = battle, 3 = village?
@export var min_lvl: int = 7
@export var max_lvl: int = 14
@export var world_enemies: Array [Enemy]
@export var battle_bg: Texture
@onready var _player_body = $Player
@export var drops: Dictionary
var _spawned_npc  
var spawn_request

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioPlayer.play_music_level("res://musig/Dungeon_-_Catacomb_Crawler.ogg")
	if sceneManager.last_scene == "res://Scenes/Battle/battle.tscn":
		_player_body.position = player.position
	if sceneManager.last_scene == "res://Scenes/Forest/Forest.tscn":
		_player_body.position = $Forest2Exit.position + Vector2(-15,0)
	MainMenu.map_scene = get_tree().current_scene
	for i in len(sceneManager.static_clear):
		get_node("%s" %sceneManager.static_clear[i-1]).queue_free()
		
	# EXAMPLE HOW TO USE GLOBAL DIALOG
	#var load_dialog = load("res://Global/dialog_scene.tscn")
	#add_child(load_dialog.instantiate())
	#var dialog = get_node("Dialog")
	#dialog.dia[0].position = get_node("Player").position + Vector2(-200,-200)
	#dialog.dia_decision.position = get_node("Player").position + Vector2(-200,-50)
	
	#dialog.set_text(0, "You wanna vibe?", 10)

	#dialog.set_color(0,"green")
	#var possible_answers = ["No","LETS GO"]
	#var answer = await dialog.decide(possible_answers)
	#if answer == 1:
		#dialog.set_text(0, "OKE BYE :(", 10)
	#if answer == 2:
		#dialog.set_text(0, "LETS DANCE!", 10)

func _input(_event):
	pass

func _on_forest2_exit_body_entered(body: Node2D) -> void:
	if body.name == _player_body.name:
		sceneManager.static_clear = []
		sceneManager.goto_scene("res://Scenes/Forest/Forest.tscn")

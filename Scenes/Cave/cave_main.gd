extends Node2D

var spawn_npc = preload("res://Global/globalNPC.tscn")
var world_enemies = [
	preload("res://enemyResources/golem.tres"),
	preload("res://enemyResources/shadow_wraith.tres")
	]
var spawn = spawn_npc.instantiate()
@onready var _player_body = $Player
@onready var _preload_npc = $NPC_1
var spawn_positions = [
	Vector2(90, -90), 
	Vector2(0, 80), 
	Vector2(-80,0), 
	Vector2(0,-80), 
	Vector2(30,-80), 
	Vector2(-60,70)
	]
	
var rng = RandomNumberGenerator.new()
var _spawned_npc = world_enemies[0]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioPlayer.play_music_level("res://musig/Dungeon_-_Catacomb_Crawler.ogg")
	if sceneManager.last_scene == "res://Scenes/Battle/battle.tscn":
		_player_body.position = player.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _spawn_npc():
	if not self.has_node("NPC_spawn"):
		var spawn_loc = rng.randi_range(1,len(spawn_positions))
		var enemy_select = rng.randi_range(1,len(world_enemies))
		_spawned_npc = world_enemies[enemy_select - 1]
		add_child(spawn)
		_spawned_npc = $NPC_spawn
		_spawned_npc.position = _player_body.position + spawn_positions[spawn_loc - 1]

		print("tried to spawn")
		print(enemy_select)
		

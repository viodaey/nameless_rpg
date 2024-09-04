extends Node2D

var spawn_npc = preload("res://Global/globalNPC.tscn")
var world_enemies = [
	preload("res://enemyResources/forest_wolf.tres")
	]
var spawn = spawn_npc.instantiate()
@onready var _player_body = $Player
@onready var _cave_entrance = $CaveEntrance
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
	AudioPlayer.play_music_level("fieldOverworld")
	if sceneManager.last_scene == "res://Scenes/Battle/battle.tscn":
		_preload_npc.queue_free()
		_player_body.position = player.position
	if sceneManager.last_scene == "res://Scenes/Cave/cave.tscn":
		_player_body.position.x = _cave_entrance.position.x
		_player_body.position.y = _cave_entrance.position.y + 15
		#player.last_exit = 'default'
	
func _spawn_npc():
	if is_instance_valid($NPC_spawn):
		print("tried to spawn but valid instance found")
		#pass
	else:
		var spawn_loc = rng.randi_range(1,len(spawn_positions))
		var enemy_select = rng.randi_range(1,len(world_enemies))
		add_child(spawn)
		_spawned_npc = $NPC_spawn
		_spawned_npc.position = _player_body.position + spawn_positions[spawn_loc - 1]
		_spawned_npc.enemy = world_enemies[enemy_select - 1]
		print("spawned")

	
	




	#pass # Replace with function body.
	


#func _on_body_entered(body):
	#_entered = true

#func _approach():
	#_player_body.position = target_position
	#



	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass



		

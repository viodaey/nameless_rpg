extends Node2D

var spawn_npc = preload("res://Global/globalNPC.tscn")
var world_enemies = [
	preload("res://enemyResources/golem.tres"),
	preload("res://enemyResources/shadow_wraith.tres")
	]
var spawn = spawn_npc.instantiate()
@onready var _player_body = $Player
	

var _spawned_npc  
var spawn_request


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioPlayer.play_music_level("res://musig/Dungeon_-_Catacomb_Crawler.ogg")
	if sceneManager.last_scene == "res://Scenes/Battle/battle.tscn":
		_player_body.position = player.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _spawn_npc():
	if is_instance_valid($NPC_spawn):
		print("tried to spawn but valid instance found")
	else:
		var rng = RandomNumberGenerator.new()
		var enemy_select = rng.randi_range(1,len(world_enemies))
		var angle = rng.randi_range(0, TAU)
		var distance = rng.randi_range(80, 130)
		_player_body.get_node("RayCast2D").target_position += Vector2(distance*cos(angle), distance*sin(angle))
		if _player_body.get_node("RayCast2D") .is_colliding():
			print(_player_body.get_node("RayCast2D").target_position)
			_spawn_npc()

		else:
			spawn_request = world_enemies[enemy_select - 1]
			add_child(spawn.duplicate())
			_spawned_npc = $NPC_spawn
			_spawned_npc.position = _player_body.position + Vector2(distance*cos(angle), distance*sin(angle))

func _despawn_npc():
	_spawned_npc.queue_free()

	

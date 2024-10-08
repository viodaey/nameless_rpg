extends Area2D

@export var enemy : Resource
@onready var _animated_sprite = $AnimatedSprite2D
@onready var _player_body = get_parent().get_node("Player")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if sceneManager.last_scene == "res://enemyResources/roy_the_terrible.tres":
		$Boss_R.queue_free()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	player.enemy_encounter = enemy.resource_path
	player.position = _player_body.position
	#AudioPlayer.play_music_level("res://musig/Battle_-_No_Way_Out.ogg")
	sceneManager.goto_scene("res://Scenes/Battle/battle.tscn")
	#pass # Replace with function body.

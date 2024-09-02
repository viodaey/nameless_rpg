extends Node2D

#@onready var enemy_resource = load(res://Scenes/Battle/roy_the_terrible.tres)
#@onready var enemy_resource = 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.last_exit = "cave"
	#player.enemy_encounter = "ROY THE TERRIBLE"
	AudioPlayer.play_music_level("res://musig/Dungeon_-_Catacomb_Crawler.ogg")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

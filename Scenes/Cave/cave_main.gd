extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.last_exit = "cave"
	player.enemy_encounter = "ROY THE TERRIBLE"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

extends CollisionShape2D
@onready var _entered = false
@onready var _player_body = $"/root/player"

#@onready var _cave_coll = $CollisionCave
#@onready var cave_entered = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _entered == true:
		print('entered_process')
		get_tree().change_scene_to_file("res://Scenes/Cave/cave.tscn")	

	#if _entered == true:
		#_player_body.position = target_position
		#move_and_slide() w

#func _on_cave_entrance_area_entered(area: Area2D):



func _on_body_entered(body: CharacterBody2D) -> void:
	if body == _player_body:
		_entered = true
		print('entered_function')
	else:
		print('detected, but no player')

extends Node2D

@onready var _player_body = $Player
#@onready var target_position = _player_body.position


var _entered = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioPlayer.play_music_level("fieldOverworld")
	pass # Replace with function body.

#func _on_body_entered(body):
	#_entered = true

#func _approach():
	#_player_body.position = target_position
	#
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#if _entered == true:
		#_player_body.position = target_position
		#move_and_slide() 

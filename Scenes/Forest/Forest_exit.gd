extends Area2D

@onready var _playerbody = get_parent().get_node("Player")

func _on_body_entered(body: Node2D) -> void:
	if body.name == _playerbody.name:
		sceneManager.goto_scene("res://Scenes/overworld/overworld.tscn")
		

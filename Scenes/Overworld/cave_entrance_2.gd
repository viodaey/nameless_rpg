extends Area2D

@onready var _playerbody = get_parent().get_node("Player")

func _on_body_entered(body: Node2D) -> void:
	if body.name == _playerbody.name:
		get_tree().change_scene_to_file("res://Scenes/Cave/cave.tscn")
		

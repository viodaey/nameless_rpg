extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _spawn_npc() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node3D) -> void:
	if body.name == 'Player':
		sceneManager.goto_scene("res://Scenes/3dCave/3dcave_00b.tscn")
	
	pass # Replace with function body.

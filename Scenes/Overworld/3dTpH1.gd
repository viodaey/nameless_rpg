extends Area3D

@export var target_position: Vector3
@onready var _player_body = $Player

func _ready():

	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body: Node3D):
	if body == _player_body:  # Compare the body directly
		teleport(body)

func teleport(body: Node3D):
	body.global_transform.origin = target_position
	print("Player teleported to: ", target_position)

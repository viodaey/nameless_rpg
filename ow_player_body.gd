extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D
@export var speed = 70

var last_input = "right"

# Called when the node enters the scene tree for the first time.
func get_input():
	var input_direction = Input.get_vector("left", "right", "up","down")
	velocity = input_direction * speed

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):

	if Input.is_anything_pressed() == false:
		_animated_sprite.play(("idle " + last_input))
	if Input.is_action_pressed("right"):
		_animated_sprite.play("move right")
		last_input = "right"
	if Input.is_action_pressed("left"):
		_animated_sprite.play("move left")
		last_input = "left"
	if Input.is_action_pressed("up"):
		_animated_sprite.play("move up")
		last_input = "up"
	if Input.is_action_pressed("down"):
		_animated_sprite.play("move down")
		last_input = "down"
	get_input()
	move_and_slide()
	

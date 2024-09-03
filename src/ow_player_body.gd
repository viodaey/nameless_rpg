extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D
@export var speed = 70

var last_input = "right"
var moved : float = 0
var spawnEnemy = CharacterBody2D.new()
var move_dice : int

# Called when the node enters the scene tree for the first time.
func get_input():
	var input_direction = Input.get_vector("left", "right", "up","down")
	velocity = input_direction * speed

func _ready() -> void:
	pass # Replace with function body.
	move_dice = rng.randi_range(30, 100)

var rng = RandomNumberGenerator.new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):

	if Input.is_anything_pressed() == false:
		_animated_sprite.play(("idle " + last_input))
	elif Input.is_action_pressed(last_input):
		_animated_sprite.play("move " + last_input)
		moved = moved + 0.1
	else:
		if Input.is_action_pressed("up"):
			_animated_sprite.play("move up")
			last_input = "up"
			moved = moved + 0.1
		if Input.is_action_pressed("down"):
			_animated_sprite.play("move down")
			last_input = "down"
			moved = moved + 0.1
		if Input.is_action_pressed("right"):
			_animated_sprite.play("move right")
			last_input = "right"
			moved = moved + 0.1
		if Input.is_action_pressed("left"):
			_animated_sprite.play("move left")
			last_input = "left"
			moved = moved + 0.1
	get_input()
	move_and_slide()

	if moved > move_dice:
		get_parent()._spawn_npc()
		moved = 0
		move_dice = rng.randi_range(30, 100)

	
	

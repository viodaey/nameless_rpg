extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _player_body = get_parent().get_node("Player")
var player_position
var target_position
var speed = 50
var _entered : bool

func _on_body_entered(body):
	_entered = true

#func _on_body_entered(body):
	#get_node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	player_position = _player_body.position
	if position.distance_to(player_position) < 90:
		target_position = (player_position - position).normalized()
		velocity = target_position * speed
		move_and_slide()
		_animated_sprite.play("run")
		if player_position[0] - position[0] > 0:
			_animated_sprite.flip_h = 1
		else:
			_animated_sprite.flip_h = 0
		player_position = _player_body.position
	else:
		_animated_sprite.play("canine idle")
		

		
#
#
#extends CharacterBody2D
#
#
#
#var last_input = "right"
#
## Called when the node enters the scene tree for the first time.
#func get_input():
	#var input_direction = Input.get_vector("left", "right", "up","down")
	#velocity = input_direction * speed
#
#func _ready() -> void:
	#pass # Replace with function body.
#
##func _process(delta):
	##if CollisionObject2D.dete
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta):
#
	#if Input.is_anything_pressed() == false:
		#_animated_sprite.play(("idle " + last_input))
	#if Input.is_action_pressed("right"):
		#_animated_sprite.play("move right")
		#last_input = "right"
	#if Input.is_action_pressed("left"):
		#_animated_sprite.play("move left")
		#last_input = "left"
	#if Input.is_action_pressed("up"):
		#_animated_sprite.play("move up")
		#last_input = "up"
	#if Input.is_action_pressed("down"):
		#_animated_sprite.play("move down")
		#last_input = "down"
	#get_input()
	#move_and_slide()
	#

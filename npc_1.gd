extends CharacterBody2D

@export var enemy : Resource
@onready var _animated_sprite = $AnimatedSprite2D
@onready var _player_body = get_parent().get_node("Player")
@onready var speed = enemy.speed

var player_position
var target_position


const detection_range : float = 90
@onready var neutral_pos = _animated_sprite.position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#pass
	enemy = get_parent()._spawned_npc
	_animated_sprite.sprite_frames = enemy.animatedSprite
	_animated_sprite.scale = Vector2(enemy.map_scale, enemy.map_scale)

	# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	var move_to_attack = move_and_collide(velocity * delta)
	player_position = _player_body.position
	if position.distance_to(player_position) < detection_range:
		if not move_to_attack:
			target_position = (player_position - position).normalized()
			velocity = target_position * speed
			#move_to_attack
			_animated_sprite.play("run")
			if player_position[0] - position[0] > 0:
				_animated_sprite.flip_h = 1
			else:
				_animated_sprite.flip_h = 0
			player_position = _player_body.position
		elif move_to_attack.get_collider() != _player_body:
			target_position = (player_position - position).normalized()
			velocity = target_position * speed
			#move_to_attack
			_animated_sprite.play("run")
			if player_position[0] - position[0] > 0:
				_animated_sprite.flip_h = 1
			else:
				_animated_sprite.flip_h = 0
			player_position = _player_body.position
		
		elif move_to_attack.get_collider() == _player_body:
		#move_to_attack.get_collider() == _player_body:
			position = neutral_pos
			player.enemy_encounter = enemy.resource_path
			player.position = player_position
			queue_free()
			sceneManager.goto_scene("res://Scenes/Battle/battle.tscn")
			move_to_attack = false

	else:
		_animated_sprite.play("idle")
		velocity = Vector2(0,0)
		

		
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

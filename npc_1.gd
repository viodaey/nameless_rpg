extends CharacterBody2D

@onready var enemy = get_parent().spawn_request
@onready var _animated_sprite = $AnimatedSprite2D
@onready var _player_body = get_parent().get_node("Player")
@onready var speed = enemy.speed

var player_position
var target_position
var move_to_attack
const detection_range : float = 90
@onready var neutral_pos = _animated_sprite.position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_animated_sprite.sprite_frames = enemy.animatedSprite
	self.scale = self.scale * enemy.map_scale
	#pass
	
	# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	move_to_attack = move_and_collide(velocity * delta)
	player_position = _player_body.position
	if position.distance_to(player_position) < detection_range:
		if not move_to_attack:
			target_position = (player_position - position).normalized()
			velocity = target_position * speed
			_animated_sprite.play("run")
			if player_position[0] - position[0] > 0:
				_animated_sprite.flip_h = 1
			else:
				_animated_sprite.flip_h = 0
			player_position = _player_body.position
		elif move_to_attack.get_collider() != _player_body:
			target_position = (player_position - position).normalized()
			velocity = target_position * speed
			_animated_sprite.play("run")
			if player_position[0] - position[0] > 0:
				_animated_sprite.flip_h = 1
			else:
				_animated_sprite.flip_h = 0
			player_position = _player_body.position
		
		elif move_to_attack.get_collider() == _player_body:
			initiate_battle()

	else:
		_animated_sprite.play("idle")
		velocity = Vector2(0,0)
	if position.distance_to(player_position) > 500:
		_player_body._despawn_npc(self.get_path())
		
func initiate_battle():
	position = neutral_pos
	player.enemy_encounter = enemy.resource_path
	player.position = player_position
	sceneManager.mon_min_lvl = get_parent().min_lvl
	sceneManager.mon_max_lvl = get_parent().max_lvl
	sceneManager.goto_scene("res://Scenes/Battle/battle.tscn")
	move_to_attack = false
	queue_free()	

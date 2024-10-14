extends CharacterBody2D

@export var enemy: Enemy
@export var detection_range : float = 140
@export var activation_chance: int = 100
@export var speed = 30
@onready var _animated_sprite = $AnimatedSprite2D
@onready var _player_body = get_parent().get_node("Player")
@onready var neutral_pos = _animated_sprite.position
var player_position
var target_position
var move_to_attack
var rng = RandomNumberGenerator.new()
var initiated: bool = false
signal initiation_done

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# roll to determine if active
	if rng.randi_range(1,100) > activation_chance:
		set_physics_process(false)

func _physics_process(delta: float):
	move_to_attack = move_and_collide(velocity * delta)
	player_position = _player_body.position
	if position.distance_to(player_position) > detection_range:
		if initiated == true:
			_animated_sprite.play("idle")	
			velocity = Vector2(0,0)
		return
	if not initiated:
		if not _animated_sprite.sprite_frames.get_animation_names().has("initiate"):
			initiated = true
		else:
			_animated_sprite.play("initiate")
			await initiation_done
			initiated = true
		return
	if not move_to_attack:
		target_position = (player_position - position).normalized()
		velocity = target_position * speed
		#look_at(_player_body.global_position)
		#self.rotate(4.71)
		_animated_sprite.play("run")
		player_position = _player_body.position
	elif move_to_attack.get_collider() == _player_body:
		initiate_battle()
func initiate_battle():
	position = neutral_pos
	player.enemy_encounter = enemy.get_path()
	player.position = player_position
	sceneManager.mon_min_lvl = get_parent().min_lvl
	sceneManager.mon_max_lvl = get_parent().max_lvl
	sceneManager.goto_scene("res://Scenes/Battle/battle.tscn")
	move_to_attack = false
	queue_free()	

func _on_animated_sprite_2d_animation_finished() -> void:
	initiation_done.emit()

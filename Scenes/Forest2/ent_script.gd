extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _player_body = get_parent().get_node("Player")
@onready var speed = 30

var player_position
var target_position
var move_to_attack
var rng = RandomNumberGenerator.new()
var has_fallen: bool = false
const detection_range : float = 150
@onready var neutral_pos = _animated_sprite.position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# roll to determine if active
	if rng.randi_range(1,100) < 1:
		set_physics_process(false)
		
	
	#pass
	
	# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	move_to_attack = move_and_collide(velocity * delta)
	player_position = _player_body.position
	if position.distance_to(player_position) > detection_range:
		if has_fallen == true:
			_animated_sprite.stop()	
			velocity = Vector2(0,0)
		return
	if has_fallen == false:
		_animated_sprite.play("fall")
		await get_tree().create_timer(4.0).timeout
		has_fallen = true
		return
	if not move_to_attack:
		target_position = (player_position - position).normalized()
		velocity = target_position * speed
		look_at(_player_body.global_position)
		self.rotate(4.71)
		_animated_sprite.play("crawl")
		player_position = _player_body.position
	elif move_to_attack.get_collider() == _player_body:
		initiate_battle()

		
func initiate_battle():
	position = neutral_pos
	player.enemy_encounter = "res://enemy_resources/enemy_identityfiles/Ent.tres"
	player.position = player_position
	sceneManager.mon_min_lvl = get_parent().min_lvl
	sceneManager.mon_max_lvl = get_parent().max_lvl
	sceneManager.goto_scene("res://Scenes/Battle/battle.tscn")
	move_to_attack = false
	queue_free()	

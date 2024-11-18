extends Area3D

@onready var enemy = get_parent().spawn_request
@onready var _animated_sprite = $AnimatedSprite3D
@onready var _player_body = get_parent().get_node("Player")
@onready var speed = enemy.speed
var rng = RandomNumberGenerator.new()
var player_position
var target_position
var move_to_attack
var wandering: bool = false
var time_wandering: float = 0
var time_not_wandering: float = 0
var time_to_wander: float
var time_to_not_wander: float 
var wander_vector: Vector3
const detection_range : float = 15
@onready var neutral_pos = _animated_sprite.position
var initiated: bool = false
signal initiation_done
var velocity: Vector3 = Vector3.ZERO
var direction: String = "nw"
var cc_status: int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_animated_sprite.sprite_frames = enemy.animatedSprite
	self.scale = self.scale * enemy.map_scale
	position.y = 0.2
	_animated_sprite.position.y += enemy.position_y_offset
	#pass
	
	# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	position += velocity * delta
	player_position = _player_body.position
	if position.distance_to(player_position) < detection_range:
		if not initiated:
			if not _animated_sprite.sprite_frames.get_animation_names().has("initiate"):
				initiated = true
			else:
				_animated_sprite.play("initiate")
				await initiation_done
				initiated = true
			return
		target_position = (player_position - position).normalized()
		velocity = target_position * speed * 0.75 # temp speed fix
		_animated_sprite.play("run")
		if player_position[0] - position[0] > 0:
			_animated_sprite.flip_h = 1
		else:
			_animated_sprite.flip_h = 0
		player_position = _player_body.position		
	elif enemy.can_wander:
		if wandering == true:
			velocity = wander_vector * (speed / 2)
			if time_wandering >= time_to_wander:
				rng = RandomNumberGenerator.new()
				velocity = Vector3.ZERO
				time_to_not_wander = rng.randf_range(0.4,4)
				wandering = false
				time_wandering = 0
				_animated_sprite.play("idle")
			time_wandering += delta
		if wandering == false:
			if time_not_wandering >= time_to_not_wander:
				rng = RandomNumberGenerator.new()
				var angle = rng.randf_range(0, TAU)
				wander_vector = (position - (position + Vector3(cos(angle),0, sin(angle)))).normalized()
				if wander_vector.x > 0:
					_animated_sprite.flip_h = 1
				else:
					_animated_sprite.flip_h = 0
				time_to_wander = rng.randf_range(0.5,3)
				wandering = true
				time_not_wandering = 0
				_animated_sprite.play("run")
			time_not_wandering += delta
	else:
		_animated_sprite.play("idle")
		velocity = Vector3.ZERO
	if position.distance_to(player_position) > 950:
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

func _on_animated_sprite_3d_animation_finished() -> void:
	initiation_done.emit()


func _on_body_entered(body: Node3D) -> void:
	if body == _player_body:
		player.engagement = 0
		if cc_status != 0:
			player.engagement = 1
		else:
			match body.last_input:
				"up":
					#direction_vector = Vector2(0,-1)
					if velocity.z < 0:
						player.engagement = -1
				"right":
					#direction_vector = Vector2(1,0)
					if velocity.x > 0:
						player.engagement = -1
				"down":
					#direction_vector = Vector2(0,1)
					if velocity.z > 0:
						player.engagement = -1
				"left":
					#direction_vector = Vector2(-1,0)
					if velocity.x < 0:
						player.engagement = -1
		initiate_battle()

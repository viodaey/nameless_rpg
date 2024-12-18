extends Area3D

@onready var enemy = get_parent().spawn_request
@onready var _animated_sprite = $AnimatedSprite3D
@onready var _player_body = get_parent().get_node("Player")
@onready var speed = enemy.speed
@onready var navigation_agent = $NavigationAgent3D
@onready var neutral_pos = _animated_sprite.position
var rng = RandomNumberGenerator.new()
var player_position
var target_position
var wandering: bool = false
var time_wandering: float = 0
var time_not_wandering: float = 0
var time_to_wander: float
var time_to_not_wander: float 
var wander_vector: Vector3
const detection_range : float = 55
var initiated: bool = false
signal initiation_done
var cc_status: int = 0
var velocity: Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_animated_sprite.sprite_frames = enemy.animatedSprite
	self.scale = self.scale * enemy.map_scale
	_animated_sprite.position.y += enemy.position_y_offset
	
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
		navigation_agent.target_position = player_position
		target_position = (navigation_agent.get_next_path_position() - position).normalized()
		#target_position = (player_position - position).normalized()
		velocity = target_position * speed * 0.75
		_animated_sprite.play("run")
		if target_position[0] > 0:
			_animated_sprite.flip_h = 1
		else:
			_animated_sprite.flip_h = 0
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
				var closest_nav_point = NavigationServer3D.map_get_closest_point(get_world_3d().get_navigation_map(), wander_vector * speed * time_to_wander)
				velocity = (closest_nav_point - position).normalized()
				navigation_agent.target_position = wander_vector
				wandering = true
				time_not_wandering = 0
				_animated_sprite.play("run")
			time_not_wandering += delta
			
	else:
		_animated_sprite.play("idle")
		velocity = Vector3.ZERO
	if position.distance_to(_player_body.position) > 450:
		_player_body._despawn_npc(self.get_path())

func initiate_battle():
	position = neutral_pos
	player.enemy_encounter = []
	player.enemy_encounter.append(enemy.resource_path)
	player.position = player_position
	sceneManager.mon_min_lvl = get_parent().min_lvl
	sceneManager.mon_max_lvl = get_parent().max_lvl
	sceneManager.goto_scene("res://Scenes/Battle/battle.tscn")
	_player_body.in_scene = true
	get_tree().call_group("spawned_npc","queue_free")

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
					if velocity.z < 0:
						player.engagement = -1
				"right":
					if velocity.x > 0:
						player.engagement = -1
				"down":
					if velocity.z > 0:
						player.engagement = -1
				"left":
					if velocity.x < 0:
						player.engagement = -1
		initiate_battle()
		

extends CharacterBody3D

@onready var _animated_sprite = $AnimatedSprite3D
@onready var map = get_parent()
@onready var raycast = $RayCast3D

@export var speed: float = 15.0          # Walking speed
@export var gravity: float = -9.8        # Gravity force

var spawn_npc = load("res://Global/globalNPC3D.tscn")
var last_input = "right"
var moved: float = 0
var move_dice: int
var disabled_spawn: bool = false
var activeSpawns: Array = []
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	# Initialize position, move dice, and reset vertical position
	move_dice = rng.randi_range(30, 100)
	position.y = 0.1

func get_input():
	# Get input direction and apply to horizontal velocity
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity.x = input_direction.x * speed
	velocity.z = input_direction.y * speed

func _physics_process(delta):
	# Apply gravity if the character is not on the floor
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0  # Reset vertical velocity when on the floor

	# Handle animations based on input
	if not Input.is_anything_pressed():
		_animated_sprite.play("idle" + last_input)
	else:
		handle_animation()

	# Update velocity based on input
	get_input()
	move_and_slide()

	# Spawn NPC if movement conditions are met
	if moved > move_dice and not disabled_spawn:
		spawn_npcs()

func handle_animation():
	# Update animation based on last input and movement direction
	if Input.is_action_pressed(last_input):
		_animated_sprite.play("move" + last_input)
		moved += 0.1
	else:
		if Input.is_action_pressed("up"):
			_animated_sprite.play("moveup")
			last_input = "up"
			moved += 0.1
		elif Input.is_action_pressed("down"):
			_animated_sprite.play("movedown")
			last_input = "down"
			moved += 0.1
		elif Input.is_action_pressed("right"):
			_animated_sprite.play("moveright")
			last_input = "right"
			moved += 0.1
		elif Input.is_action_pressed("left"):
			_animated_sprite.play("moveleft")
			last_input = "left"
			moved += 0.1

func spawn_npcs():
	print("passed check to spawn")
	var rng = RandomNumberGenerator.new()
	for i in rng.randi_range(1, 2):
		var vec_target = await _spawn_npc_loc()
		raycast.position = self.position
		raycast.target_position = raycast.position + vec_target
		raycast.force_raycast_update()
		if not raycast.is_colliding():
			moved = 0
			move_dice = rng.randi_range(25, 60)
			var enemy_select = rng.randi_range(1, len(map.world_enemies))
			map.spawn_request = load(map.world_enemies[enemy_select - 1].resource_path)
			var spawned_npc = spawn_npc.instantiate().duplicate()
			map.add_child(spawned_npc)

			# Assign unique name and position to spawned NPC
			var num = activeSpawns.size()
			spawned_npc.name = "NPC_spawn_%d" % num
			spawned_npc.position = self.position + vec_target
			activeSpawns.append(spawned_npc.name)
			print(spawned_npc)

func _spawn_npc_loc() -> Vector3:
	# Generate a random position within spawn range
	var angle = rng.randf_range(0, TAU)
	var min_spawn_range = map.min_spawn_range
	var max_spawn_range = map.max_spawn_range
	var distance = rng.randi_range(min_spawn_range, max_spawn_range)
	return Vector3(distance * cos(angle), 0, distance * sin(angle))

func _despawn_npc(npc_name: String):
	# Despawn NPC by name and remove from activeSpawns array
	if map.has_node(npc_name):
		map.get_node(npc_name).queue_free()
		activeSpawns.erase(npc_name)

func _on_area_3d_body_entered(body: Node3D) -> void:
	# Trigger battle if the body has 'initiate_battle' method
	if body.has_method("initiate_battle"):
		body.initiate_battle()
	else:
		print(body)

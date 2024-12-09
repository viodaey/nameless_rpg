extends CharacterBody3D

@onready var _animated_sprite = $AnimatedSprite3D
@export var speed = 22
var spawn_npc = load("res://Global/globalNPC3D.tscn")
var spawnCast = load("res://Global/spawnCast.scn")
var last_input = "right"
var moved : float = 0
var activeSpawns: Array = []
var move_dice : int
var disabled_spawn : bool = false
var rng = RandomNumberGenerator.new()
var can_interact : bool = true
var in_scene: bool = false
@onready var map = get_parent()
@onready var raycast = $RayCast3D
@onready var interactarea = $InteractArea
@onready var navigation_agent = $NavigationAgent3D # Add NavigationAgent3D to your player
var gravity: float = 0.0

# Handle input for movement
func get_input() -> Vector3:
	var _input_direction = Input.get_vector("left", "right", "up", "down")
	if not is_on_floor():
		gravity = -0.1
	else:
		gravity = 0
	return Vector3(_input_direction.x, gravity, _input_direction.y)

func _ready() -> void:
	move_dice = rng.randi_range(30, 100)
	position.y = 0.2
	navigation_agent.set_navigation_map(get_parent().get_node("NavigationRegion3D").get_navigation_map())

func _physics_process(delta):
	if in_scene:
		return
	if not is_on_floor():
		velocity = get_input() * speed
		move_and_slide()
		return
	var input_dir = get_input().normalized() * speed
	var target_position = global_transform.origin + (input_dir * delta)
	navigation_agent.target_position = target_position
	if navigation_agent.is_target_reachable():
		velocity = input_dir
		move_and_slide()
		if input_dir != Vector3(0,0,0):
			moved += 0.1
	else:
		return

	# Handle interactions
	handle_interactions()

	# Update Movement Animation
	update_animation()

	# Handle NPC Spawning
	if moved > move_dice and not disabled_spawn:
		rng = RandomNumberGenerator.new()
		for i in rng.randi_range(1, 2):
			var vec_target = _spawn_npc_loc()
			var nav_target = NavigationServer3D.map_get_closest_point(get_world_3d().get_navigation_map(), position + vec_target)
			#var spawnCasted = spawnCast.instantiate()
			#map.add_child(spawnCasted)
			#spawnCasted.position = nav_target
			#spawnCasted.queue_free()
			## function for getting collision point get_collision_point()
			## raise raycast 3d from player, point downward (angled), if collides whith navmmesh: get intersect with navmesh, spawn @ intersectpoint
			## or instantiate raycast on target position, raise it and face straight down. check if navmesh exists. If true, spawn npc at intersection
			moved = 0
			move_dice = rng.randi_range(25, 60)
			var enemy_select = rng.randi_range(1, len(map.world_enemies))
			map.spawn_request = load(map.world_enemies[enemy_select - 1].resource_path)
			var spawned_npc = spawn_npc.instantiate()
			map.add_child(spawned_npc)
			var num = len(activeSpawns)
			spawned_npc.name = "NPC_spawn" + "%d" % num
			spawned_npc.position = nav_target
			activeSpawns.append(spawned_npc.name)

# Spawn NPC location based on distance and random angle
func _spawn_npc_loc() -> Vector3:
	rng = RandomNumberGenerator.new()
	var angle = rng.randf_range(0, TAU)
	var min_spawn_range = get_parent().min_spawn_range
	var max_spawn_range = get_parent().max_spawn_range
	var distance = rng.randi_range(min_spawn_range, max_spawn_range)
	return Vector3(distance * cos(angle), 0, distance * sin(angle))

# Handle NPC despawn based on name
func _despawn_npc(npc_name):
	var npc = map.get_node(npc_name)
	if npc:
		npc.queue_free()
		activeSpawns.erase(npc_name)

# Handle interaction logic
func handle_interactions():
	if Input.is_action_pressed("interact") and can_interact:
		can_interact = false
		in_scene = true
		var interactables = interactarea.get_overlapping_areas()
		if interactables.size() > 0:
			await interactables[0].interact()
		elif interactarea.has_overlapping_bodies():
			var interactables_bodies = interactarea.get_overlapping_bodies()
			await interactables_bodies[0].interact()
		can_interact = true
		in_scene = false

# Update animation based on movement
func update_animation():
	if not Input.is_action_pressed("up") and not Input.is_action_pressed("down") and not Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
		_animated_sprite.play("idle" + last_input)
	elif Input.is_action_pressed(last_input):
		_animated_sprite.play("move" + last_input)
		moved += 0.1
	else:
		if Input.is_action_pressed("up"):
			interactarea.rotation_degrees.y = 180
			_animated_sprite.play("moveup")
			last_input = "up"
			moved += 0.1
		if Input.is_action_pressed("down"):
			interactarea.rotation_degrees.y = 0
			_animated_sprite.play("movedown")
			last_input = "down"
			moved += 0.1
		if Input.is_action_pressed("right"):
			interactarea.rotation_degrees.y = 90
			_animated_sprite.play("moveright")
			last_input = "right"
			moved += 0.1
		if Input.is_action_pressed("left"):
			interactarea.rotation_degrees.y = 270
			_animated_sprite.play("moveleft")
			last_input = "left"
			moved += 0.1

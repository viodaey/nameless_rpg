extends CharacterBody3D

@onready var _animated_sprite = $AnimatedSprite3D
@export var speed = 15

var spawn_npc = load("res://Global/globalNPC3D.tscn")
var last_input = "right"
var moved : float = 0
var activeSpawns: Array
var move_dice : int
var disabled_spawn : bool = false
var rng = RandomNumberGenerator.new()
var can_interact : bool = true
var in_scene: bool = false
@onready var map = get_parent()
@onready var raycast = $RayCast3D
@onready var interactarea = $InteractArea

func get_input():
	var _input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = Vector3(_input_direction.x, 0, _input_direction.y) * speed

func _ready() -> void:
	move_dice = rng.randi_range(30, 100)
	position.y = 0.2

func _physics_process(_delta):
	if in_scene == true:
		return
	SimpleGrass.set_player_position(global_position)
	if Input.is_action_pressed("interact"):
		if can_interact:
			if interactarea.has_overlapping_areas():
				can_interact = false
				speed = 0
				var interactables = interactarea.get_overlapping_areas()
				await interactables[0].interact()
				can_interact = true
				speed = 15
			elif interactarea.has_overlapping_bodies():
				can_interact = false
				speed = 0
				var interactables = interactarea.get_overlapping_bodies()
				await interactables[0].interact()
				speed = 15
				can_interact = true
	if Input.is_anything_pressed() == false:
		_animated_sprite.play(("idle" + last_input))
	elif Input.is_action_pressed(last_input):
		_animated_sprite.play("move" + last_input)
		moved = moved + 0.1
	else:
		if Input.is_action_pressed("up"):
			interactarea.rotation_degrees.y = 180
			_animated_sprite.play("moveup")
			last_input = "up"
			moved = moved + 0.1
		if Input.is_action_pressed("down"):
			interactarea.rotation_degrees.y = 0
			_animated_sprite.play("movedown")
			last_input = "down"
			moved = moved + 0.1
		if Input.is_action_pressed("right"):
			interactarea.rotation_degrees.y = 90
			_animated_sprite.play("moveright")
			last_input = "right"
			moved = moved + 0.1
		if Input.is_action_pressed("left"):
			interactarea.rotation_degrees.y = 270
			_animated_sprite.play("moveleft")
			last_input = "left"
			moved = moved + 0.1
	get_input()
	move_and_slide()

## 	spawn NPC	
	if moved > move_dice and disabled_spawn == false:
		rng = RandomNumberGenerator.new()
		for i in rng.randi_range(1,2):
			var vec_target = await(_spawn_npc_loc())
			get_node("RayCast3D").position = self.position
			raycast.target_position = raycast.position + vec_target
			raycast.force_raycast_update()
			if not raycast.is_colliding():
				moved = 0
				move_dice = rng.randi_range(25, 60)
				var enemy_select = rng.randi_range(1,len(map.world_enemies))
				map.spawn_request = load(map.world_enemies[enemy_select - 1].resource_path)
				map.add_child(spawn_npc.instantiate().duplicate())
				var num = len(activeSpawns)
				var _spawned_npc = map.get_node("NPC_spawn")
				_spawned_npc.name = "NPC_spawn" + "%d" %num
				_spawned_npc.position = self.position + vec_target
				activeSpawns.append(_spawned_npc.name)

func _spawn_npc_loc():
	rng = RandomNumberGenerator.new()
	var angle = rng.randf_range(0, TAU)
	var min_spawn_range = get_parent().min_spawn_range
	var max_spawn_range = get_parent().max_spawn_range
	var distance = rng.randi_range(min_spawn_range, max_spawn_range)
	var vec_target = Vector3((distance)*cos(angle),0, (distance)*sin(angle))
	return vec_target

func _despawn_npc(npc):
	map.get_node(npc).queue_free()
	activeSpawns.erase(npc)

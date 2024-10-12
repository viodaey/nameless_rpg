extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D
@export var speed = 70

var spawn_npc = load("res://Global/globalNPC.tscn")
var last_input = "right"
var moved : float = 0
var activeSpawns: Array
var move_dice : int
var disabled_spawn : bool = false
var rng = RandomNumberGenerator.new()
@onready var map = get_parent()
@onready var raycast = $RayCast2D

# Called when the node enters the scene tree for the first time.
func get_input():
	var input_direction = Input.get_vector("left", "right", "up","down")
	velocity = input_direction * speed

func _ready() -> void:
	#pass # Replace with function body.
	move_dice = rng.randi_range(30, 100)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if Input.is_anything_pressed() == false:
		_animated_sprite.play(("idle " + last_input))
	elif Input.is_action_pressed(last_input):
		_animated_sprite.play("move " + last_input)
		moved = moved + 0.1
	else:
		if Input.is_action_pressed("up"):
			_animated_sprite.play("move up")
			last_input = "up"
			moved = moved + 0.1
		if Input.is_action_pressed("down"):
			_animated_sprite.play("move down")
			last_input = "down"
			moved = moved + 0.1
		if Input.is_action_pressed("right"):
			_animated_sprite.play("move right")
			last_input = "right"
			moved = moved + 0.1
		if Input.is_action_pressed("left"):
			_animated_sprite.play("move left")
			last_input = "left"
			moved = moved + 0.1
	get_input()
	move_and_slide()
	for i in get_slide_collision_count():
		if get_slide_collision(i).get_collider().get_parent().has_method("initiate_battle"):
			print("battle initiated from player")
			get_slide_collision(i).get_collider().get_praent().initiate_battle()


## 	spawn NPC	
	if moved > move_dice and disabled_spawn == false:
		var vec_target = await(_spawn_npc_loc())
		get_node("RayCast2D").position = self.position
		raycast.target_position = raycast.position + vec_target
		raycast.force_raycast_update()
		if not raycast.is_colliding():
			moved = 0
			move_dice = rng.randi_range(25, 75)
			var enemy_select = rng.randi_range(1,len(map.world_enemies))
			map.spawn_request = load(map.world_enemies[enemy_select - 1].resource_path)
			map.add_child(spawn_npc.instantiate().duplicate())
			var num = len(activeSpawns)
			var _spawned_npc = map.get_node("NPC_spawn")
			_spawned_npc.name = "NPC_spawn" + "%d" %num
			_spawned_npc.position = self.position + vec_target
			activeSpawns.append(_spawned_npc.name)

func _spawn_npc_loc():
	var rng = RandomNumberGenerator.new()
	var angle = rng.randi_range(0, TAU)
	var distance = rng.randi_range(350, 350)
	var vec_target = Vector2((distance)*cos(angle), (distance)*sin(angle))
	return vec_target

func _despawn_npc(npc):
	map.get_node(npc).queue_free()
	activeSpawns.erase(npc)


func _on_forest2exit_body_entered(body: Node2D) -> void:
	pass # Replace with function body.

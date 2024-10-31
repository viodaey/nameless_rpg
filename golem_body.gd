rextends CharacterBody2D

func generate_occluder_from_map(occlusion_map: Image, threshold: float = 0.5):
	var width = occlusion_map.get_width()
	var height = occlusion_map.get_height()
	var polygons = []

	for y in range(height):
		for x in range(width):
			var pixel_value = occlusion_map.get_pixel(x, y).r # Assuming grayscale map
			if pixel_value < threshold:
				# Determine the polygon vertices for this region
				# This is where you would write logic to define the occluder shape
				# You might group adjacent pixels to form larger polygons
				polygons. append(Vector2(x, y))

	# Create an OccluderPolygon2D from the polygons
	var occluder_polygon = OccluderPolygon2D.new()
	occluder_polygon.polygon = polygons

	# Add this to the LightOccluder2D node
	var light_occluder = LightOccluder2D.new()
	light_occluder.occluder = occluder_polygon
	add_child(light_occluder)

func _ready():
	var image : Image = load("res://textures/golem/golem1_o.png").get_image()
	generate_occluder_from_map(image)
#
#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0
#
#
#func _physics_process(delta: float) -> void:
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()

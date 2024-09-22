extends Control



@onready var confirm_c = $Popup
@onready var confirm_title = $Popup/MarginContainer/VBoxContainer/Title
@onready var confirm_description = $Popup/MarginContainer/VBoxContainer/Description
@onready var resume = $NinePatchRect/MarginContainer/VBoxContainer/Resume

var confirmCheck = ""
@onready var map_scene = get_tree().root.get_child(get_tree().root.get_child_count() - 1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = false

func _on_resume_pressed() -> void:
	if map_scene.scene_type == 1:
		map_scene.get_node("Player").get_node("Camera2D").enabled = true
		get_tree().paused = false
		self.visible = false
	
func _input(_event):
	if Input.is_action_pressed("ui_cancel"):
		if self.visible == false:
			self.position = get_viewport_rect().get_center() - (self.size / 2)
			resume.grab_focus() # Replace with function body.
			map_scene.get_node("Player").get_node("Camera2D").enabled = false
			get_tree().paused = true
			self.visible = true
		elif confirm_c.visible == true:
			_on_confirm_no_pressed()
		else:
			await(get_tree().create_timer(0.1).timeout)
			_on_resume_pressed()

func _on_monsters_pressed() -> void:
	var monManagerScene = load("res://Global/monManager.tscn").instantiate()
	get_parent().add_child(monManagerScene)
	self.visible = false

func _on_save_pressed() -> void:
	confirmCheck = "save"
	_confirm()
	
func _on_load_pressed() -> void:
	confirmCheck = "load"
	_confirm()
	
func _on_quit_pressed() -> void:
	confirmCheck = "quit"
	_confirm()


func _confirm():
	$Popup/MarginContainer/VBoxContainer/HBoxContainer/No.grab_focus()
	confirm_c.visible = true
	if confirmCheck == "save":
		confirm_title.text = "Save"
		confirm_description.text = "This will overwrite the current save.
Do you want to proceed?"
	if confirmCheck == "load":
		confirm_title.text = "Load"
		confirm_description.text = "Any unsaved progress will be lost.
Do you want to proceed?"
	if confirmCheck == "quit":
		confirm_title.text = "Quit"
		confirm_description.text = "You are about to quit the game.
Any unsaved progress will be lost.
Do you want to proceed?"


func _on_confirm_yes_pressed() -> void:
	if confirmCheck == "save":
		save()
		
	if confirmCheck == "load":
		await(load_game())
				
	if confirmCheck == "quit":
		confirm_description.text = "UNABLE TO QUIT YOU QUITTER!!!!!"
		await(get_tree().create_timer(3).timeout)
		confirm_description.text = "Okay bye"
		await(get_tree().create_timer(1).timeout)
		get_tree().quit()
	confirm_c.visible = false
	resume.grab_focus()
	
func _on_confirm_no_pressed() -> void:
	confirm_c.visible = false
	resume.grab_focus()
	
func save():
	ResourceSaver.save(inv.itemInventory, "res://Global/Save/playerInventory.tres")
	var save_file = FileAccess.open("res://Global/Save/savegame.save", FileAccess.WRITE)
	player.position = map_scene.get_node("Player").position
	player.current_scene = sceneManager.current_scene_path
	# Call save() from player(.gd)
	var playerData = player.call("save")
	# JSON provides a static method to serialized JSON string.
	var json_string = JSON.stringify(playerData)
	# Store the save dictionary as a new line in the save file.
	save_file.store_line(json_string)

func load_game():
	if ResourceLoader.exists("res://Global/Save/playerInventory.tres"):
		var load_inventory = ResourceLoader.load("res://Global/Save/playerInventory.tres")
		inv.itemInventory = load_inventory
		var save_file = FileAccess.open("res://Global/Save/savegame.save", FileAccess.READ)
		while save_file.get_position() < save_file.get_length():
			var json_string = save_file.get_line()
			
			# Creates the helper class to interact with JSON
			var json = JSON.new()

			# Check if there is any error while parsing the JSON string, skip in case of failure
			var parse_result = json.parse(json_string)
			if not parse_result == OK:
				print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
				continue

			# Get the data from the JSON object
			var node_data = json.get_data()

			for i in node_data.keys():
				if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
					continue
				player.set(i, node_data[i])
			player.position.x = node_data["pos_x"]
			player.position.y = node_data["pos_y"]
		if player.current_scene != sceneManager.current_scene_path:
			#await(get_tree().root.get_child(get_tree().root.get_child_count() - 2).call("sceneManager.goto_scene(%s)" % player.current_scene))
			await(sceneManager.goto_scene(player.current_scene))
			
		await(get_tree().create_timer(0.5).timeout)
		map_scene = get_tree().root.get_child(get_tree().root.get_child_count() - 1)
		map_scene.get_node("Player").position = player.position
		map_scene.get_node("Player").get_node("Camera2D").enabled = false
		confirm_description.text = "Save loaded"
		Input.is_action_pressed("ui_cancel")	
		await(get_tree().create_timer(2).timeout)


	else:
		confirm_description.text = "No save file found..."				
		await(get_tree().create_timer(2).timeout)	
		Input.is_action_pressed("ui_cancel")			

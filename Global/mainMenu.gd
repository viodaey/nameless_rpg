extends Control

var monManagerScene = load("res://Global/monManager.tscn").instantiate()

@onready var confirm_c = $Popup
@onready var confirm_title = $Popup/MarginContainer/VBoxContainer/Title
@onready var confirm_description = $Popup/MarginContainer/VBoxContainer/Description
@onready var resume = $NinePatchRect/MarginContainer/VBoxContainer/Resume

var confirmCheck = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.position = get_viewport_rect().get_center() - (self.size / 2)
	resume.grab_focus() # Replace with function body.

func _on_resume_pressed() -> void:
	if get_parent().scene_type == 1:
		get_parent().get_node("Player").get_node("Camera2D").enabled = true
		get_tree().paused = false
		self.queue_free()
	
func _input(_event):
	if Input.is_action_pressed("ui_cancel"):
		await(get_tree().create_timer(0.03).timeout)
		_on_resume_pressed()

func _on_monsters_pressed() -> void:
	get_parent().add_child(monManagerScene)
	self.queue_free()

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
		ResourceSaver.save(inv.itemInventory, "res://Global/Save/playerInventory.tres")
	if confirmCheck == "load":
			if ResourceLoader.exists("res://Global/Save/playerInventory.tres"):
				var load_inventory = ResourceLoader.load("res://Global/Save/playerInventory.tres")
				inv.itemInventory = load_inventory
				confirm_description.text = "Save loaded"
			else:
				confirm_description.text = "No save file found..."				
				await(get_tree().create_timer(2).timeout)				
				
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

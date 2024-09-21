extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.position = (get_viewport_rect().size / 2) - (self.size / 2)
	$NinePatchRect/MarginContainer/VBoxContainer/Resume.grab_focus() # Replace with function body.

func _on_resume_pressed() -> void:
	if get_parent().scene_type == 1:
		get_parent().get_node("Player").get_node("Camera2D").enabled = true
		get_tree().paused = false
		self.queue_free()

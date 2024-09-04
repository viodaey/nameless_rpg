extends Node

var current_scene = null
var last_scene : String = "res://Scenes/Overworld/overworld.tscn"
var current_scene_path : String = "res://Scenes/Overworld/overworld.tscn"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var root = get_tree().root
#	Both the actual scene and globals are children of root, but autoloaded nodes are always first. 
#	This means that the last child of root is always the loaded scene.
	current_scene = root.get_child(root.get_child_count() - 1)
	print(last_scene)

func goto_scene(path):
	call_deferred("_deferred_goto_scene", path)
	
func _deferred_goto_scene(path):
	last_scene = current_scene_path
	current_scene_path = path
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
	
	

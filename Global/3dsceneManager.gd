extends Node

@onready var last_scene : String = get_tree().current_scene.scene_file_path
@onready var current_scene_path : String = get_tree().current_scene.scene_file_path
var current_scene = null
var battle_bg: Texture = null
var mon_min_lvl: int
var mon_max_lvl: int
var static_clear: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func goto_scene(path):
	call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path):
	if current_scene.scene_type == 1:
		battle_bg = current_scene.battle_bg
	last_scene = current_scene_path
	current_scene_path = path
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
	MainMenu.map_scene = current_scene

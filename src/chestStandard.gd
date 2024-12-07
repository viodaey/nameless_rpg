extends StaticBody3D
@onready var map = get_parent()
@export var contents: item
@export var amount: int = 1
var looted: bool = false

func interact():
	if not looted:
		var dialog = preload("res://Global/dialog_scene.tscn")
		map.add_child(dialog.instantiate())
		dialog = map.get_node("Dialog")
		dialog.set_center_offset(0,0,0.70)
		dialog.set_diasize(0,"small")
		dialog.dia[0].scale = Vector2(1.3,1.3)
		dialog.set_color(0,"green")
		await dialog.set_text(0,"Got %s (x%d)!" %[contents._name, amount], 1.5, true)
		inv.add_item(contents, amount)
		dialog.queue_free()
		looted = true

extends StaticBody3D
@onready var map = get_parent().get_parent()
var dialog = preload("res://Global/dialog_scene.tscn")

func interact():
	map.add_child(dialog.instantiate())
	var dialog = map.get_node("Dialog")
	#dialog.dia[0].global_position = Vector2(global_position.x -5, global_position.z - 2)
	dialog.set_color(0,"black")
	await dialog.set_text(0,"Where do you think \n you're going?", 0, false, true)
	var choose = ["..Cave?","None of your business"] 
	var answer = await dialog.decide(choose)
	match answer:
		1:
			await dialog.set_text(0,"I don't think so buddy", 1, true)
		2:
			await dialog.set_text(0,"You better step away \n right now", 1, true)
	
	dialog.queue_free()
	
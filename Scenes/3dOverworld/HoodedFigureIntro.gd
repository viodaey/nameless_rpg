extends StaticBody3D
@onready var map = get_parent().get_parent()
var dialog = preload("res://Global/dialog_scene.tscn")

func interact():
	map.add_child(dialog.instantiate())
	var dialog = map.get_node("Dialog")
	#dialog.dia[0].global_position = Vector2(global_position.x -5, global_position.z - 2)
	dialog.set_color(0,"black")
	await dialog.set_text(0,"Hey, you there!\nover here, help me!", 1.5, true)
	await dialog.set_text(0,"Can't\nhold this\nout much\nlonger.", 1, true)

	#Start Battle


#After Battle
	await dialog.set_text(0,"Phew!...\nthat was a close call.", 1.5, true)
	await dialog.set_text(0,"I need to get back home\nand treat my wounds quickly.", 1, true)
	await dialog.set_text(0,"Come meet me at my house\nit's further up north", 1, true)
	dialog.queue_free()

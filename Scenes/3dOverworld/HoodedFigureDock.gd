extends StaticBody3D
@onready var map = get_parent().get_parent()
var dialog = preload("res://Global/dialog_scene.tscn")

func interact():
	map.add_child(dialog.instantiate())
	var dialog = map.get_node("Dialog")
	#dialog.dia[0].global_position = Vector2(global_position.x -5, global_position.z - 2)
	dialog.set_color(0,"black")
	await dialog.set_text(0,"Ah there you are,\nglad you could make it.", 1.5, true)
	await dialog.set_text(0,"Thank you for helping\nme out back there.", 1, true)
	await dialog.set_text(0,"if it wasn't for you,\nI would've been dogfood.", 1.5, true)
	await dialog.set_text(0,"There is something,\nstrange going on..", 1, true)
	await dialog.set_text(0,"We need to investigate\nfurther into this matter.", 1, true)
	await dialog.set_text(0,"I could use your help\nwill you assist me?.", 1, false,true)
	var choose = ["Most certainly!","Not right now.."] 
	var answer = await dialog.decide(choose)
	match answer:
		1:
			await dialog.set_text(0,"Wonderful,\nyou should go see\nthe forest southwest of here", 1, true)
			await dialog.set_text(0,"There have been some\ndisturbances lately", 1, true)
		2:
			await dialog.set_text(0,"Fine,\ncome back when you're ready.", 1, true)
	
	dialog.queue_free()
	
	

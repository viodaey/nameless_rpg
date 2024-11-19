extends StaticBody3D
@onready var map = get_parent().get_parent()
var dialog = preload("res://Global/dialog_scene.tscn")

func interact():
	map.add_child(dialog.instantiate())
	var dialog = map.get_node("Dialog")
	#dialog.dia[0].global_position = Vector2(global_position.x -5, global_position.z - 2)
	dialog.set_color(0,"black")
	await dialog.set_text(0,"You thought you \n could talk to me?", 1, true)
	await dialog.set_text(0,"I guess you can... \n Good for you", 1.5, true)
	await dialog.set_text(0,"You're looking for a quest?", 1, false,true)
	var choose = ["Yes please!","Not really"] 
	var answer = await dialog.decide(choose)
	match answer:
		1:
			await dialog.set_text(0,"Alright, well you could start \n in the forest southwest of here", 1, true)
			await dialog.set_text(0,"There have been some \n disturbances lately", 1, true)
		2:
			await dialog.set_text(0,"Are you sure?", 1, true)
	
	dialog.queue_free()
	

	

extends StaticBody3D
@onready var map = get_parent().get_parent()

func interact():
	var dialog = preload("res://Global/dialog_scene.tscn")
	map.add_child(dialog.instantiate())
	dialog = map.get_node("Dialog")
	dialog.set_color(0,"black")
	dialog.set_diasize(0,"regular")
	dialog.set_center_offset(3,0,0.70)
	dialog.set_diasize(3,"small")
	dialog.dia[3].scale = Vector2(1.3,1.3)
	dialog.set_color(3,"green")
	if player.scene_progression["overworld"] == 2:
		await dialog.set_text(0,"Ah there you are,\nglad you could make it.", 1.5, true)
		await dialog.set_text(0,"Thank you for helping\nme out back there.", 1, true)
		await dialog.set_text(0,"if it wasn't for you,\nI would've been dogfood.", 1.5, true)
		await dialog.set_text(0,".. come to think of it. I never asked your name.", 1.5,true)
		player._name = await dialog.request_textinput("Tell me your name")
		await dialog.set_text(0,"%s? Interesting....   Nice to meet you." % [player._name], 1.5, true)
		player.scene_progression["overworld"] = 3
	if player.scene_progression["overworld"] == 3:
		await dialog.set_text(0,"There is something,\nstrange going on..", 1, true)
		await dialog.set_text(0,"We need to investigate\nfurther into this matter.", 1, true)
		await dialog.set_text(0,"I could use your help\nwill you assist me?.", 1, false,true)
		var choose = ["Most certainly!","Not right now.."] 
		var answer = await dialog.decide(choose)
		match answer:
			1:
				await dialog.set_text(0,"Wonderful, you should go see the forest southwest of here.", 1, true)
				await dialog.set_text(0,"There have been some disturbances lately.", 1, true)
				await dialog.set_text(0,"Before you head out, let me tend to your wounds.", 1, true)
				player.full_heal()
				await dialog.set_text(3,"You are fully healed.")
				player.scene_progression["overworld"] = 4
			2:
				await dialog.set_text(0,"Fine, come back when you're ready.", 1, true)
	elif player.scene_progression["overworld"] == 4:
		await dialog.set_text(0,"You should check the forest southwest of here", 1, true)
		await dialog.set_text(0,"Do you want me to tend to your wounds?",1)
		var choose = ["Yes","Not right now"] 
		var answer = await dialog.decide(choose)
		match answer:
			1:
				await dialog.set_text(0,"Let me see.")
				player.full_heal()
				await dialog.set_text(3,"You are fully healed.")		
	dialog.queue_free()
	
	

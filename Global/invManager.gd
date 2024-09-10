extends Control

var itemInventory = load("res://inventory/playerInventory.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
		#y += 1

		
func add_item(_item, amount):
	for i in len(itemInventory.list):
		if _item._name == itemInventory.list[i]._item._name:
			itemInventory.list[i].amount += 1
			return
	var loadslot = invSlot.new()
	itemInventory.list.append(loadslot)
	itemInventory.list[len(itemInventory.list) - 1]._item = _item
	itemInventory.list[len(itemInventory.list) - 1].amount = amount
	
func sub_item(z):
	if itemInventory.list[z].amount > 1:
		itemInventory.list[z].amount -= 1
	else:
		itemInventory.list.pop_at(z)
	

	
#func _on_add_apple_pressed() -> void:
	#add_item(load("res://inventory/items/apple.tres"), 1)
	#_update()

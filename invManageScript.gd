extends Control

@export var itemInventory = load("res://inventory/playerInventory.tres")
@onready var select = $ItemPanel/Selector
@onready var itemList = $ItemPanel/ScrollCont/itemList
var x = 0 #valid item num
var z = 0 #selector position on valid item num
@onready var select_start = select.position.y

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in len(itemInventory.list):
		var label = Label.new()
		itemList.add_child(label)
		label.name = "Item%d" %x
		label.text = itemInventory.list[i]._item.name
		label.size_flags_horizontal = Control.SIZE_EXPAND
		label.focus_mode = Control.FOCUS_ALL
		label = Label.new()
		itemList.add_child(label)
		label.name = "Amount%d" %x
		label.text = "%d" %itemInventory.list[i].amount		
		x += 1
		#y += 1

func _update() -> void:
	#y = 0
	x = 0
	for i in itemList.get_children():
		itemList.remove_child(i)
	for i in len(itemInventory.list):
		#if itemInventory.list[i]._item:
		var label = Label.new()
		itemList.add_child(label)
		label.name = "Item%d" %x
		label.text = itemInventory.list[i]._item.name
		label.size_flags_horizontal = Control.SIZE_EXPAND
		label.focus_mode = Control.FOCUS_ALL
		label = Label.new()
		itemList.add_child(label)
		label.name = "Amount%d" %x
		label.text = "%d" %itemInventory.list[i].amount
		label.horizontal_alignment = 2	
		x += 1
		
func _input(event):
	if Input.is_action_pressed("ui_down"):
		if z < x - 1:
			select.position.y = select.position.y + 23
			z += 1
		else:
			select.position.y = select_start
			z = 0
	if Input.is_action_pressed("ui_up"):
		if z > 0:
			select.position.y = select.position.y - 23
			z -= 1
		elif x - 1 > z:
			select.position.y = select.position.y + (23 * (x - 1))
			z = x - 1
	if Input.is_action_pressed("ui_accept"):
		var item_selected = itemInventory.list[z]._item
		print(item_selected.name)
		
func add_item(item, amount):
	for i in len(itemInventory.list):
		if item.name == itemInventory.list[i]._item.name:
			itemInventory.list[i].amount += 1
			return
	var loadslot = invSlot.new()
	itemInventory.list.append(loadslot)
	itemInventory.list[len(itemInventory.list) - 1]._item = item
	itemInventory.list[len(itemInventory.list) - 1].amount = amount
	

	
func _on_add_apple_pressed() -> void:
	add_item(load("res://inventory/items/apple.tres"), 1)
	_update()

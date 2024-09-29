extends Control

#var itemInventory = load("res://inventory/playerInventory.tres")
@onready var select = $ItemPanel/MarginContainer/HBoxContainer/Control/Selector
@onready var itemList = $ItemPanel/MarginContainer/HBoxContainer/ScrollCont/itemList
var x = 0 #valid item num
var z = 0 #selector position on valid item num
@onready var select_start = select.position.y
var _mode : String = "Battle"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in len(inv.itemInventory.list):
		var label = Label.new()
		itemList.add_child(label)
		label.name = "Item%d" %x
		label.text = inv.itemInventory.list[i]._item._name
		label.size_flags_horizontal = Control.SIZE_EXPAND
		label.focus_mode = Control.FOCUS_ALL
		label = Label.new()
		itemList.add_child(label)
		label.name = "Amount%d" %x
		label.text = "%d" %inv.itemInventory.list[i].amount		
		x += 1
		#y += 1

func _update() -> void:
	#y = 0
	x = 0
	for i in itemList.get_children():
		itemList.remove_child(i)
	for i in len(inv.itemInventory.list):
		#if itemInventory.list[i]._item:
		var label = Label.new()
		itemList.add_child(label)
		label.name = "Item%d" %x
		label.text = inv.itemInventory.list[i]._item._name
		label.size_flags_horizontal = Control.SIZE_EXPAND
		label.focus_mode = Control.FOCUS_ALL
		label = Label.new()
		itemList.add_child(label)
		label.name = "Amount%d" %x
		label.text = "%d" %inv.itemInventory.list[i].amount
		label.horizontal_alignment = 2	
		x += 1
		
func _input(_event):
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
	if Input.is_action_just_released("ui_accept"):
		if len(inv.itemInventory.list) == 0:
			return
		var item_selected = inv.itemInventory.list[z]._item
		_update()
		get_parent().use_item(z)
		#inv.sub_item(z)

	if Input.is_action_pressed("ui_cancel"):
		if _mode == "battle":
			get_parent()._actionmenu.visible = true
			get_parent()._actionmenufoc.grab_focus()
		self.queue_free()


		
	
		
#func add_item(_item, amount):
	#for i in len(inv.itemInventory.list):
		#if _item.name == inv.itemInventory.list[i]._item.name:
			#inv.itemInventory.list[i].amount += 1
			#return
	#var loadslot = invSlot.new()
	#inv.itemInventory.list.append(loadslot)
	#inv.itemInventory.list[len(inv.itemInventory.list) - 1]._item = _item
	#inv.itemInventory.list[len(inv.itemInventory.list) - 1].amount = amount
	

	
#func _on_add_apple_pressed() -> void:
	#inv.add_item(load("res://inventory/items/apple.tres"), 1)
	#_update()

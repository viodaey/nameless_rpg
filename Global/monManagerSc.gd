extends Control

@onready var blockContainer = $monsterPanel/VBoxContainer/MarginContainer/HBoxContainer/GridContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in min(len(inv.itemInventory.monsterlist), 12):
		var currentMonster = inv.itemInventory.monsterlist[i]
		var currentContainer = blockContainer.get_child(i)
		currentContainer.get_child(0).texture = currentMonster._monster.texture
		currentContainer.get_child(1).text = currentMonster._monster._name
		currentContainer.get_child(1).disabled = false
	blockContainer.get_child(0).get_child(1).grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func swap_select(m):
	pass

func swap(m1 : Object, m2 : Object, a : Array) -> Array:
	var i = a.find(m1)
	a[a.find(m2)] = m1
	a[i] = m2
	return a

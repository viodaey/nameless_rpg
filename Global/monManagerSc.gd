extends Control

@onready var blockContainer = $monsterPanel/VBoxContainer/MarginContainer/HBoxContainer/GridContainer
@onready var displayMain = $monsterPanel/VBoxContainer/MarginContainer/HBoxContainer/Display/displayMain
@onready var displayStats = $monsterPanel/VBoxContainer/MarginContainer/HBoxContainer/Display/displayMain/displayStats
var mode : int = 0
var selected : int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for i in min(len(inv.itemInventory.monsterlist), 12):
		var currentMonster = inv.itemInventory.monsterlist[i]
		var currentContainer = blockContainer.get_child(i)
		currentContainer.get_child(0).texture = currentMonster._monster.texture
		currentContainer.get_child(1).text = currentMonster._monster._name
		currentContainer.get_child(1).disabled = false
	blockContainer.get_child(0).get_child(1).grab_focus()	
	get_viewport().gui_focus_changed.connect(_on_gui_focus_changed)
	_on_gui_focus_changed($monsterPanel/VBoxContainer/MarginContainer/HBoxContainer/GridContainer/Box1/Button)

func _on_gui_focus_changed(node: Node) -> void:
	var i = node.get_parent().get_index()
	if i <= (len(inv.itemInventory.monsterlist) -1):
		var selectedMonster = inv.itemInventory.monsterlist[i]
		displayMain.get_child(0).texture = selectedMonster._monster.texture
		displayMain.get_child(1).text = selectedMonster._monster._name
		displayMain.get_child(2).text = "Level %d %s" % [selectedMonster._monster.lvl, selectedMonster._monster._class._classname]
		displayStats.get_child(1).text = "%d / %d" % [selectedMonster.stats["hp"], selectedMonster._monster.max_health]
		displayStats.get_child(5).text = "%d" % selectedMonster._monster.damage
		selected = i

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

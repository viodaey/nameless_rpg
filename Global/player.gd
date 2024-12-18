extends Node

var ability_test = load("res://Global/Abilities/Multistrike_1.tres")
var ability_test_2 = load('res://Global/Abilities/Fireball_1.tres')

@warning_ignore("unused_private_class_variable")
var _name: String = "Skullhead"
var max_health: int = 80
var health: int = 100
var damage: int = 20
var critc: int = 8
var lvl: int = 1
var xp: int = 0
var max_xp: int = 20
var hp_grow: int = 0
var dmg_grow: int = 0
var magicdmg: int = 600
var mp: int = 10
var max_mp: int = 10
var mp_cost_fireball: int = 6
var last_exit: String = 'default'
var enemy_encounter: Array [String] = ["res://enemyResources/res_battle_spider.tres"]
#var enemy_stats = []
var position: Vector3
var atb: int = 100
var engagement: int = 0
## 0 = neutral, 1 = advantage, -1 = disadvantage
var current_scene
@warning_ignore("unused_private_class_variable")
var _abilities: Array[abilities] = [ability_test, ability_test_2]
var passive : abilities

## track scene progression. For new scenes add a string and number
var scene_progression : Dictionary [String, int] = {
	"overworld" : 0,
	"forest" : 0
	}

#var done: bool = false
func level_up():
	#var done_lvl_up: bool = false
	#while done_lvl_up == false:
	hp_grow = 0
	dmg_grow = 0
	while xp >= max_xp:
		hp_grow = hp_grow + round(max_health * 0.10)
		dmg_grow = dmg_grow + round(damage * 0.08)
		max_health = max_health + hp_grow
		#health = health + hp_grow
		damage = damage + dmg_grow
		lvl = lvl + 1
		xp = xp - max_xp
		max_xp = round(max_xp * 1.4)

func full_heal():
	health = max_health
	mp = max_mp
	
func save():
	var save_dict = {
		"filename" : "player.gd",
		"name" : _name,
		"pos_x" : position.x,
		"pos_z" : position.z,
		"max_health": max_health,
		"health" : health,
		"damage" : damage,
		"lvl" : lvl, 
		"xp" : xp,
		"max_xp" : max_xp, 
		"mp" : mp, 
		"max_mp" : max_mp,
		"magicdmg" : magicdmg,
		"current_scene" : current_scene,
		"scene_progression" : scene_progression.duplicate(true)
	}
	#for i in scene_progression:
		#save_dict[i] = scene_progression[i]
	return save_dict

extends Node

var max_health: int = 170
var health: int = 170
var damage: int = 30
var critc: int = 8
var lvl: int = 1
var xp: int = 0
var max_xp: int = 20
var hp_grow: int = 0
var dmg_grow: int = 0
var magicdmg: int = 40
var mp: int = 10
var max_mp: int = 10
var mp_cost_fireball: int = 6
var last_exit: String = 'default'
var enemy_encounter: String



func level_up():
	hp_grow = round(max_health * 0.15)
	dmg_grow = round(damage * 0.12)
	max_health = (max_health + hp_grow)
	damage = (damage + dmg_grow)
	lvl = lvl + 1
	xp = 0
	max_xp = round(max_xp * 1.4)
	
	

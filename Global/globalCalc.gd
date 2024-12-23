extends Node

var armorBaseValue: int = 150
var armorModifier: float = 0.666

func armorCalc(armor: int, damage: float = 0, returntype: int = 0):
	var mitigation = (armor*armorModifier)/(armorBaseValue+armor)
	var resultDamage = damage * mitigation
	match returntype:
		0:
			return mitigation
		1:
			return resultDamage

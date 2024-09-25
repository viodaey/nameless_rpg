extends Resource

class_name Enemy
const normy = preload("res://Global/Classes/Normy.tres") 
const basic_shape = preload("res://enemy_resources/enemy_collision/capsule_shape_15_50.tres")

@export var _name: String = "Enemy"
@export var texture: Texture = null
@export var evolution: Enemy
@export var evo_lvl: int = 9000
@export var health: float = 100
@export var base_health: float = 30
@export var damage: float = 20
@export var critc: int = 5
@export var xp: int = 10
@export var speed: int = 40
@export var music: String = "battle01"
@export var can_chill: bool = true
@export var lifesteal: int = 0
@export var animatedSprite: SpriteFrames = null
@export var affliction_type: String
@export var affliction_chance: int = 0
@export var map_scale: float = 1
@export var collision_shape: Shape2D = basic_shape
#@export var battle_scale: float = 1
@export var max_group_size: int = 3
@export var min_group_size: int = 1
@export var friends: Array [String]
@export var battle_scale_vec: Vector2 = Vector2(1,1)
@export var battle_y_sep: int = 0
@export var _class: _Class = normy
@export var lvl: int = 1
@export var atb: int = 110
@export var max_health: int
var hp_grow: int = 0
var dmg_grow: int = 0
var max_xp: int = 20
#@export var pivot_offset: Vector2 = size / 2

const allEnemies: Dictionary = {
	"Fire Wolf (Evo1)": "res://enemyResources/Firewolf_Evo_1.tres",
	"Fire Wolf (Evo2)": "res://enemyResources/Firewolf_Evo_2.tres",
	"Ice Wolf (Evo1)": "res://enemyResources/Icewolf_Evo_1.tres",
	"Ice Wolf (Evo2)": "res://enemyResources/Icewolf_Evo_2.tres",
	"Elecwolf (Evo1)": "res://enemyResources/Elecwolf_Evo_1.tres",
	"Earth Wolf (Evo1)": "res://enemyResources/Earthwolf_Evo_1.tres",
	"Golem": "res://enemyResources/golem.tres",
	"Fire Pixie": "res://enemyResources/Pixie_Fire.tres",
	"Shadow Wraith": "res://enemyResources/shadow_wraith.tres",
	"Baby Orc": "res://enemyResources/orc_baby.tres",
	"Teen Orc": "res://enemyResources/orc_teen.tres",
	"Orc": "res://enemyResources/orc_adult.tres",
	"Warbear (Evo1)": "res://enemyResources/Warbear_Evo_1.tres",
	}

func level_up():
	var hp_old = health
	var dmg_old = damage
	hp_grow = 0
	dmg_grow = 0
	while xp >= max_xp:
		lvl = lvl + 1
		xp = xp - max_xp
		max_xp = round(max_xp * 1.4)
	var calc_lvl = lvl - 1
	for i in calc_lvl:
		health = health * 1.08 * _class.hp_mult
		damage = damage * 1.08 * _class.dmg_mult
	hp_grow = health - hp_old
	dmg_grow = damage - dmg_old
	max_health = health


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

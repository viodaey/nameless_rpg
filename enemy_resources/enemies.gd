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
@export var damage: float = 12
@export var critc: int = 5
@export var xp: int = 10
@export var speed: int = 2
@export var music: String = "battle01"
@export var can_chill: bool = true
@export var lifesteal: int = 0
@export var animatedSprite: SpriteFrames = null
@export var affliction_type: String
@export var affliction_chance: int = 0
@export var map_scale: float = 1
@export var collision_shape: Shape2D = basic_shape
@export var can_wander: bool = true
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
@export var _abilties: Array[abilities]
@export var passive: abilities
@export var position_y_offset: float
var hp_grow: int = 0
var dmg_grow: int = 0
var max_xp: int = 20
#@export var pivot_offset: Vector2 = size / 2

const allEnemies: Dictionary = {
	"Golem": "res://enemy_resources/enemy_identityfiles/golem.tres",
	"Pixie Water": "res://enemy_resources/enemy_identityfiles/PixieWater.tres",
	"Fire Pixie": "res://enemy_resources/enemy_identityfiles/Pixie_Fire.tres",
	"Shadow Wraith": "res://enemy_resources/enemy_identityfiles/shadow_wraith.tres",
	"Baby Orc": "res://enemy_resources/enemy_identityfiles/orc_baby.tres",
	"Teen Orc": "res://enemy_resources/enemy_identityfiles/orc_teen.tres",
	"Orc": "res://enemy_resources/enemy_identityfiles/orc_adult.tres",
	"Warbear (Evo1)": "res://enemy_resources/enemy_identityfiles/Warbear_Evo_1.tres",
	"Birdman (Evo1)": "res://enemy_resources/enemy_identityfiles/birdman_chick.tres",
	"DeadEnt": "res://enemy_resources/enemy_identityfiles/DeadEnt.tres",
	"Ent": "res://enemy_resources/enemy_identityfiles/Ent.tres",
	"Spider": "res://enemy_resources/enemy_identityfiles/res_battle_spider.tres",
	"Roy the terrible": "res://enemy_resources/enemy_identityfiles/roy_the_terrible.tres",
	"Skelleton Mage (Evo1)": "res://enemy_resources/enemy_identityfiles/skelly_mage_1.tres",
	"Skeleton Warrior": "res://enemy_resources/enemy_identityfiles/skelly_warrior_1.tres",
	"Wolf Earth (Evo1)": "res://enemy_resources/enemy_identityfiles/WolfEarth_Evo_1.tres",
	"Wolf Earth (Evo2)": "res://enemy_resources/enemy_identityfiles/WolfEarth_Evo_2.tres",
	"Wolf Elec (Evo1)": "res://enemy_resources/enemy_identityfiles/WolfElec_Evo_1.tres",
	"Wolf Elec (Evo2)": "res://enemy_resources/enemy_identityfiles/WolfElec_Evo_2.tres",
	"Wolf Fire (Evo1)": "res://enemy_resources/enemy_identityfiles/WolfFire_Evo_1.tres",
	"Wolf Fire (Evo2)": "res://enemy_resources/enemy_identityfiles/WolfFire_Evo_2.tres",
	"Wolf Ice (Evo1)": "res://enemy_resources/enemy_identityfiles/WolfIce_Evo_1.tres",
	"Wolf Ice (Evo2)": "res://enemy_resources/enemy_identityfiles/WolfIce_Evo_2.tres",
	"Wolf Water (Evo1)": "res://enemy_resources/enemy_identityfiles/WolfWater_Evo_1.tres",
	"Wolf Water (Evo2)": "res://enemy_resources/enemy_identityfiles/WolfWater_Evo_2.tres",
	"Wolf Wind (Evo1)": "res://enemy_resources/enemy_identityfiles/WolfWind_Evo_1.tres",
	"Wolf Wind (Evo2)": "res://enemy_resources/enemy_identityfiles/WolfWind_Evo_2.tres"
	}

func level_up():
	var hp_old = health
	var dmg_old = damage
	health = base_health
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

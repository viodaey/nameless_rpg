extends Resource

class_name Enemy

@export var _name: String = "Enemy"
@export var texture: Texture = null
@export var health: float = 100
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
#@export var battle_scale: float = 1
@export var max_group_size: int = 3
@export var min_group_size: int = 1
@export var friends: Array [String]
@export var battle_scale_vec: Vector2 = Vector2(1,1)
@export var battle_y_sep: int = 0
@export var _class: _Class
@export var lvl: int = 1
@export var atb: int = 110
var max_health: int
var hp_grow: int = 0
var dmg_grow: int = 0
var max_xp: int = 20
#@export var pivot_offset: Vector2 = size / 2

const allEnemies: Dictionary = {
	"Fire Wolf": "res://enemyResources/Firewolf_Evo_2.tres",
	"Ice Wolf": "res://enemyResources/wolf_ice.tres",
	"Golem": "res://enemyResources/golem.tres",
	"Fire Pixie": "res://enemyResources/Pixie_Fire.tres",
	"Shadow Wraith": "res://enemyResources/shadow_wraith.tres",
	"Baby Orc": "res://enemyResources/orc_baby.tres",
	"Teen Orc": "res://enemyResources/orc_teen.tres",
	"Orc": "res://enemyResources/orc_adult.tres",
	"Earth Wolf": "res://enemyResources/Earthwolf_Evo_1.tres"
	}

func level_up():
	#var done_lvl_up: bool = false
	#while done_lvl_up == false:
	hp_grow = 0
	dmg_grow = 0
	while xp >= max_xp:
		hp_grow = hp_grow + round(max_health * 0.10)
		dmg_grow = dmg_grow + round(damage * 0.1)
		max_health = max_health + hp_grow
		#health = health + hp_grow
		damage = damage + dmg_grow
		lvl = lvl + 1
		xp = xp - max_xp
		max_xp = round(max_xp * 1.4)

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

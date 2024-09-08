extends Resource

class_name Enemy

@export var name: String = "Enemy"
@export var texture: Texture = null
@export var health: int = 100
@export var damage: int = 20
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
#@export var pivot_offset: Vector2 = size / 2

const allEnemies: Dictionary = {
	"Fire Wolf": "res://enemyResources/wolf_fire.tres",
	"Ice Wolf": "res://enemyResources/wolf_ice.tres",
	"Golem": "res://enemyResources/golem.tres",
	"Fire Pixie": "res://enemyResources/Pixie_Fire.tres",
	"Shadow Wraith": "res://enemyResources/shadow_wraith.tres",
	"Baby Orc": "res://enemyResources/orc_baby.tres",
	"Teen Orc": "res://enemyResources/orc_teen.tres",
	"Orc": "res://enemyResources/orc_adult.tres"
	}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

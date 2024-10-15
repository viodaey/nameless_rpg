extends Resource

class_name abilities

## enum target
#enemy 1
#enemy 2
#enemy 3
#enemy all
#player 1
#player all

## enum element
# dmg
# targets
# define main + additional? or just global?

## enum multipliers (attributes)
# attributes
# eg atp, mag, def, res, crt etc

@export var _name: String = "Ability"
@export var description: String = "This is an ability"
@export var target: String = "enemy"
@export var target_amount: int = 1
@export var eff_1 : String
@export var eff_1_ele : String
@export var eff_1_value : int
@export var eff_1_base: float
@export var eff_1_additive: String = "none"
@export var eff_1_additive_multiplier: float = 1
@export var eff_1_multiplier : String = "none"
@export var eff_1_multiplier_multiplier: float = 1
@export var eff_2 : String
@export var eff_2_ele : String
@export var eff_2_value : int
@export var eff_2_base: int
@export var eff_2_additive: String = "none"
@export var eff_2_additive_multiplier: float
@export var eff_2_multiplier : String = "none"
@export var eff_2_multiplier_multiplier: float
@export var animation: SpriteFrames
@export var animation_type: String
@export var icon : Texture
@export var mp: int = 0
@export var cooldown: int = 0

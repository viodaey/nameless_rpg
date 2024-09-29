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

@export var _name: String = "Ability"
@export var description: String = "This is an ability"
@export var target: String = "enemy"
@export var target_amount: int = 1
@export var eff_1 : String
@export var eff_1_ele : String
@export var eff_1_value : int
@export var eff_2 : String
@export var eff_2_ele : String
@export var eff_2_value : int
@export var animation: SpriteFrames
@export var animation_type: String
@export var icon : Texture
@export var mp: int = 0
@export var cooldown: int = 0

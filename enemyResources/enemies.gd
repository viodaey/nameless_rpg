extends Resource

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



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

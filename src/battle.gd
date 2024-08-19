extends Control

@export var enemy : Resource
var rng = RandomNumberGenerator.new()
var current_player_health = 0
var current_enemy_health = 0
var dealt_dmg = 0
var enemy_dmg = 0
var visible_characters = 0

@onready var _playerhp = $Panel_Menu/HBoxContainer/MarginContainer2/VBoxContainer/PlayerHP
@onready var _combat_log_box = $Panel_Menu/HBoxContainer/MarginContainer2/VBoxContainer/CombatLog/RichTextLabel
@onready var _playertexture = $MarginContainer
@onready var _enemyhp = $MarginMain/EnemyCont/EnemyHP
@onready var _enemyrect = $MarginMain/EnemyCont/MarginContainer/Enemy
@onready var _actionmenu = $Panel_Menu2

#var playerhpbox = '$Panel_Menu/HBoxContainer/MarginContainer2/VBoxContainer/PlayerHPlayerHP'
	
# Called when the node enters the scene tree for the first time.
func _ready():
	set_health_init(_playerhp, player.health, player.max_health)
	set_health_init(_enemyhp, enemy.health, enemy.health)
	_enemyrect.texture = enemy.texture
	current_player_health = player.health
	current_enemy_health = enemy.health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_health_init(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").text = "HP: %d/%d" % [health, max_health]

func set_health(progress_bar, health, max_health): 
	for i in max(0,dealt_dmg):
		progress_bar.value = progress_bar.value - 1
		progress_bar.max_value = max_health
		progress_bar.get_node("Label").text = "HP: %d/%d" % [progress_bar.value, max_health]
		await get_tree().create_timer(0.03).timeout
		
func enemy_died():
	var tween = get_tree().create_tween()
	await tween.tween_property($MarginMain/EnemyCont, "modulate:a", 0,  0.5)
	#$AnimationPlayer.play("enemy_dead")
	#await $AnimationPlayer.animation_finished
	await (combat_log("%s died" % (enemy.name)))
	player.xp = player.xp + enemy.xp
	if player.xp == player.max_xp:
		player.level_up()
		current_player_health = current_player_health + player.hp_grow
		set_health_init(_playerhp, current_player_health, player.max_health)
		await(combat_log("Level up!"))
		await(combat_log("Max HP increased by %d!" % [player.hp_grow]))
		await(combat_log("Attack Power increased by %d!" % [player.dmg_grow]))
		#combat_log("Level up! (2)![/p] Max HP increased to %d! Damage increased to %d!" % [player.max_health, player.damage])

func combat_log(text):
	visible_characters = 0
	_combat_log_box.visible_characters = visible_characters
	_combat_log_box.text = text
	for i in text: 
		visible_characters = (visible_characters + 1)
		_combat_log_box.visible_characters = visible_characters
		await get_tree().create_timer(0.03).timeout
	await get_tree().create_timer(1.4).timeout
	
func enemy_turn():
	var tween = get_tree().create_tween()
	var pos = _enemyrect.position
	if rng.randi_range(1, 100) <= 9:
		combat_log("%s is chillin'" % (enemy.name))
		$AnimationPlayer.play("enemy_chillin")
		await $AnimationPlayer.animation_finished
	else:
		dealt_dmg = round(rng.randf_range(0.8, 1.2) * enemy.damage)
		combat_log("%s attacks!" % (enemy.name))
		tween.tween_property(_enemyrect, "position", Vector2(pos[0] + 10, pos[1]), 0.4)
		#tween.set_parallel(true)
		tween.tween_property(_enemyrect, "position", Vector2(pos[0] - 20, pos[1]), 0.15)
		tween.tween_property(_enemyrect, "position", Vector2(pos[0], pos[1]), 0.3)
		for i in 6:
			tween.chain().tween_property(_playertexture, "modulate:a", 0,  0.1)
			tween.chain().tween_property(_playertexture, "modulate:a", 1,  0.1)
			#await get_tree().create_timer(0.4).timeout
		current_player_health = (current_player_health - dealt_dmg)
		set_health(_playerhp, current_player_health, player.max_health)
		await(combat_log("Got hit for %d damage" % [dealt_dmg]))
		
	

func _on_attack_pressed():

	_actionmenu.visible = false
	var tween = get_tree().create_tween()
	var pos = _playertexture.position
	#print(x)
	dealt_dmg = round(rng.randf_range(0.8, 1.2) * player.damage)
	combat_log("You attack %s!" % [enemy.name])
	#$AnimationPlayer.play("player_attack")
	#await $AnimationPlayer.animation_finished
	tween.tween_property(_playertexture, "position", Vector2(pos[0] - 10, pos[1]), 0.5)
	tween.tween_property(_playertexture, "position", Vector2(pos[0] + 20, pos[1]), 0.15)
	tween.tween_property(_playertexture, "position", Vector2(pos[0], pos[1]), 0.5).set_delay(0.5)
	await get_tree().create_timer(0.75).timeout
	$AnimationPlayer.play("enemy_damaged")
	#await $AnimationPlayer.animation_finished
	if player.critc >= rng.randi_range(1, 100):
		dealt_dmg = round(dealt_dmg * 1.5)
		await combat_log("CRITICAL HIT!")
	else:
		await get_tree().create_timer(0.75).timeout
	current_enemy_health = max(0, current_enemy_health - dealt_dmg)
	set_health(_enemyhp, current_enemy_health, enemy.health)
	await combat_log("You hit for %d damage" % [dealt_dmg])
	#await get_tree().create_timer(1).timeout
	#crit = false
	if current_enemy_health <= 0:
		enemy_died()
	else:
		await enemy_turn()
		_actionmenu.visible = true
	

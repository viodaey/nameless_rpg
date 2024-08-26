extends Control



@export var enemy : Resource #= player.enemy_encounter
var rng = RandomNumberGenerator.new()
var current_player_health = 0
var current_enemy_health = 0
var current_player_mp = 0
var dealt_dmg = 0
var enemy_dmg = 0
var visible_characters = 0
var try = 0


@onready var _playerhp = $Panel_Menu/HBoxContainer/MarginContainer2/VBoxContainer/PlayerHP
@onready var _playermp = $Panel_Menu/HBoxContainer/MarginContainer2/VBoxContainer/PlayerMP
#@onready var _combat_log = $Panel_Menu/HBoxContainer/MarginContainer2/VBoxContainer/CombatLog
@onready var _log_timer = $Panel_Menu/HBoxContainer/MarginContainer2/VBoxContainer/CombatLog/Timer
@onready var _combat_log_box = $Panel_Menu/HBoxContainer/MarginContainer2/VBoxContainer/CombatLog/RichTextLabel
@onready var _playertexture = $Player_1
@onready var _fireballAnimate = $Player_1/Fireball
@onready var _enemyhp = $MarginMain/EnemyCont/EnemyHP
@onready var _enemyrect = $MarginMain/EnemyCont/MarginContainer/Enemy
@onready var _actionmenu = $Panel_Menu2
@onready var _effectAnimate = $Player_1/onEnemyHit
#@onready var enemy: TextureRect = $MarginMain/EnemyCont/MarginContainer/Enemy

#@onready var enemy = player.enemy_encounter


#var playerhpbox = '$Panel_Menu/HBoxContainer/MarginContainer2/VBoxContainer/PlayerHPlayerHP'
	
# Called when the node enters the scene tree for the first time.
func _ready():
	set_health_init(_playerhp, player.health, player.max_health)
	set_health_init(_enemyhp, enemy.health, enemy.health)
	set_mp_init(_playermp, player.mp, player.max_mp)
	_enemyrect.texture = enemy.texture
	current_player_health = player.health
	current_player_mp = player.mp
	current_enemy_health = enemy.health
	if enemy.name != "ROY THE TERRIBLE":
		AudioPlayer.play_music_level("battle01")
	#else:
		

func _click(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_XBUTTON1):
		emit_signal("clicked")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_mp_init(progress_bar, mp, max_mp):
	progress_bar.value = mp 
	progress_bar.max_value = max_mp
	progress_bar.get_node("Label").text = "MP: %d/%d" % [mp, max_mp]

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

func set_mp(progress_bar, mp_cost, max_mp): 
	for i in max(0,mp_cost):
		current_player_mp = current_player_mp - mp_cost
		progress_bar.value = progress_bar.value - 1
		progress_bar.max_value = max_mp
		progress_bar.get_node("Label").text = "MP: %d/%d" % [progress_bar.value, max_mp]
		await get_tree().create_timer(0.03).timeout
		
func enemy_died():
	var tween = get_tree().create_tween()
	tween.tween_property($MarginMain/EnemyCont, "modulate:a", 0,  0.5)
	#$AnimationPlayer.play("enemy_dead")
	#await $AnimationPlayer.animation_finished
	await (combat_log("%s died" % (enemy.name)))
	player.xp = player.xp + enemy.xp
	if player.xp == player.max_xp:
		player.level_up()
		current_player_health = current_player_health + player.hp_grow
		set_health_init(_playerhp, current_player_health, player.max_health)
		await(combat_log("Level up!"))
		await get_tree().create_timer(0.7).timeout
		await(combat_log("Max HP increased by %d!" % [player.hp_grow]))
		await get_tree().create_timer(0.7).timeout
		await(combat_log("Attack Power increased by %d!" % [player.dmg_grow]))
		await get_tree().create_timer(0.7).timeout
		await _click
	get_tree().change_scene_to_file("res://Scenes/Overworld/overworld.tscn")
		#combat_log("Level up! (2)![/p] Max HP increased to %d! Damage increased to %d!" % [player.max_health, player.damage])

func combat_log(text):
	visible_characters = 0
	_combat_log_box.visible_characters = visible_characters
	_combat_log_box.text = text
	var log_timer = _log_timer
	for i in text: 
		visible_characters = (visible_characters + 1)
		_combat_log_box.visible_characters = visible_characters
		#log_timer.set("log", 0.000003)
		log_timer.start(0.03)
		await log_timer.timeout
	log_timer.start(0.4)
	await log_timer.timeout	
			
		#await get_tree().create_timer(0.03).timeout
	#await get_tree().create_timer(1.4).timeout
	
func enemy_turn():
	if rng.randi_range(1, 100) <= 9:
		combat_log("%s is chillin'" % (enemy.name))
		$AnimationPlayer.play("enemy_chillin")
		await $AnimationPlayer.animation_finished
	else:
		dealt_dmg = round(rng.randf_range(0.8, 1.2) * enemy.damage)
		await combat_log("%s attacks!" % (enemy.name))
		var tween = get_tree().create_tween()
		var pos = _enemyrect.position
		tween.tween_property(_enemyrect, "position", Vector2(pos[0] + 10, pos[1]), 0.4)
		#tween.set_parallel(true)
		tween.tween_property(_enemyrect, "position", Vector2(pos[0] - 20, pos[1]), 0.15)
		tween.tween_property(_enemyrect, "position", Vector2(pos[0], pos[1]), 0.3)
		await tween.step_finished 
		current_player_health = (current_player_health - dealt_dmg)
		set_health(_playerhp, current_player_health, player.max_health)
		tween = get_tree().create_tween()
		for i in 6:
			tween.chain().tween_property(_playertexture, "modulate:a", 0,  0.1)
			tween.chain().tween_property(_playertexture, "modulate:a", 1,  0.1)

		
		await tween.finished
		await combat_log("Got hit for %d damage" % [dealt_dmg])
		try = 0

		
	

func _on_attack_pressed():

	_actionmenu.visible = false
	var pos = _playertexture.position
	dealt_dmg = round(rng.randf_range(0.85, 1.15) * player.damage)
	await combat_log("You attack %s!" % [enemy.name])
	var tween = get_tree().create_tween()
	#$AnimationPlayer.play("player_attack")
	#await $AnimationPlayer.animation_finished
	tween.tween_property(_playertexture, "position", Vector2(pos[0] - 10, pos[1]), 0.5)
	tween.tween_property(_playertexture, "position", Vector2(pos[0] + 20, pos[1]), 0.15)
	tween.tween_property(_playertexture, "position", Vector2(pos[0], pos[1]), 0.5) #.set_delay(0.5)
	await get_tree().create_timer(0.75).timeout
	_effectAnimate.play('slash')
	await get_tree().create_timer(0.55).timeout
	_attack_phase_2()

func _on_magic_pressed():
	var mp_cost = player.mp_cost_fireball
	if current_player_mp < player.mp_cost_fireball and try < 2:
		await combat_log("Not enough mana")
		try = try + 1
	elif current_player_mp < player.mp_cost_fireball and try < 4:
		await combat_log("nOt eNoUgH mAnA...")
		try = try + 1
	elif current_player_mp < player.mp_cost_fireball and try >= 4:
		await combat_log("NOT ENOUGH MANA!")
		try = try + 1
	else:
		set_mp(_playermp, player.mp_cost_fireball, player.max_mp)
		player.mp = current_player_mp - player.mp_cost_fireball
		_actionmenu.visible = false
		var m_pos = _fireballAnimate.position
		dealt_dmg = player.magicdmg
		await combat_log("You use FIREBALL on %s!" % [enemy.name])
		set_mp
		#await get_tree().create_timer(0.3).timeout
		#$AnimationPlayer.play("player_attack")
		#await $AnimationPlayer.animation_finished
		var tween = get_tree().create_tween()
		tween.tween_property(_fireballAnimate, "modulate:a", 1,0.3)
		tween.tween_property(_fireballAnimate, "position", Vector2(m_pos[0] +350, m_pos[1]), 0.3)
		tween.tween_property(_fireballAnimate, "modulate:a", 0,0.05)	
		tween.tween_property(_fireballAnimate, "position", Vector2(m_pos[0], m_pos[1]), 0.1)
		#await get_tree().create_timer(5.70).timeout
		await tween.finished
		#tween.tween_property(_playertexture, "position", Vector2(pos[0] + 20, pos[1]), 0.15)
		#tween.tween_property(_playertexture, "position", Vector2(pos[0], pos[1]), 0.5).set_delay(0.5)
		#await get_tree().create_timer(0.75).timeout
		_attack_phase_2()	
	
func _attack_phase_2():
	$AnimationPlayer.play("enemy_damaged")
	#await $AnimationPlayer.animation_finished
	if player.critc >= rng.randi_range(1, 100):
		dealt_dmg = round(dealt_dmg * 1.5)
		await combat_log("CRITICAL HIT!")
		await get_tree().create_timer(0.5).timeout
	else:
		await get_tree().create_timer(0.75).timeout
	current_enemy_health = max(0, current_enemy_health - dealt_dmg)
	set_health(_enemyhp, current_enemy_health, enemy.health)
	await get_tree().create_timer(0.75).timeout
	await combat_log("You hit for %d damage" % [dealt_dmg])
	#await get_tree().create_timer(1).timeout
	#crit = false
	if current_enemy_health <= 0:
		enemy_died()
	else:
		await enemy_turn()
		_actionmenu.visible = true
	
	
#func _on_text_gui_input(event):
	#if (event is InputEventMouseButton && event.pressed && event.button_index == 1):
		#emit_signal("text_clicked")
#
#func await_click():
	#get_tree().create_timer(2.0).timeout.connect(func(): text_clicked.emit())
#
#(part of turn_logic function)
#if first_move.Move_name != "Sleep Talk" and second_move.Move_name != "Sleep Talk":
			#if exec_status(first_poke) != false:
				#if second_poke.stats.invincible == true:
					#hit_chance1 = 2
				#first_poke.stats.invincible = false
				#stab = stab1 if first_poke == active_poke else stab2
				#$Text.text = str(exec_move(first_move, first_poke, second_poke, hit_chance1, effect_chance1, stab))
				#print("First poke: ", first_poke.base_stats.poke_name)
				#await_click()
				#await text_clicked
			#if second_poke.stats.hp > 0:
				#if exec_status(second_poke) != false:
					#if first_poke.stats.invincible == true:
						#hit_chance2 = 2
					#second_poke.stats.invincible = false
					#stab = stab1 if second_poke == active_poke else stab2
					#$Text.text = str(exec_move(second_move, second_poke, first_poke, hit_chance2, effect_chance2, stab))
			#await_click()
			#await text_clicked 
			#emit_signal("turn_over")

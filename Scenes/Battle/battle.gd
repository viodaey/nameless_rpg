extends Control

@export var enemy : Resource 
@export var enemy2: Resource
@export var enemy3: Resource
@export var enemy4: Resource

var rng = RandomNumberGenerator.new()
var current_player_health: int = 0
var current_enemy_health: int = 0
var current_player_mp: int = 0
var dealt_dmg: int = 0
var enemy_dmg: int = 0
var visible_characters: int = 0
var try = 0
var player_count = 1
var e_groupsize: int = 1
var enemyDict: Dictionary = {1: enemyDict_1}
var enemyDict_1: Dictionary
var enemyDict_2: Dictionary
var enemyDict_3: Dictionary
var enemyDict_4: Dictionary
#var enemyToStat: Dictionary
var enemyStats1 : Dictionary
var enemyStats2 : Dictionary
var enemyStats3 : Dictionary
var enemyStats4 : Dictionary
var x : int = 1


@onready var _playerhp = $Panel_Menu/VBoxContainer/GridContainer/Player1Container/MarginContainer2/VBoxContainer/PlayerHP
@onready var _playermp = $Panel_Menu/VBoxContainer/GridContainer/Player1Container/MarginContainer2/VBoxContainer/PlayerMP
@onready var _log_timer = $CombatLogPanel/Timer
@onready var _combat_log_box = $CombatLogPanel/CombatLog
@onready var _playertexture = $Player_1
@onready var _fireballAnimate = $Player_1/Fireball
@onready var _enemycont1 = $EnemyContainer1
@onready var _enemycont2 = $EnemyContainer2
@onready var _enemycont3 = $EnemyContainer3
@onready var _enemycont4 = $EnemyContainer4
@onready var _enemyhp1 = $EnemyContainer1/EnemyHP
@onready var _enemyhp2 = $EnemyContainer2/EnemyHP
@onready var _enemyhp3 = $EnemyContainer3/EnemyHP
@onready var _enemyhp4 = $EnemyContainer4/EnemyHP
@onready var _enemyrect1 = $EnemyContainer1/AspectContainer/EnemyText
@onready var _enemyrect2 = $EnemyContainer2/AspectContainer/EnemyText
@onready var _enemyrect3 = $EnemyContainer3/AspectContainer/EnemyText
@onready var _enemyrect4 = $EnemyContainer4/AspectContainer/EnemyText
@onready var _actionmenu = $ActionMenu
@onready var _effectAnimate = $Player_1/hitAnimate
@onready var _enemy_resource = player.enemy_encounter
@onready var _player2container = $Panel_Menu/VBoxContainer/GridContainer/Player2Container
@onready var _player3container = $Panel_Menu/VBoxContainer/GridContainer/Player3Container
@onready var _player4container = $Panel_Menu/VBoxContainer/GridContainer/Player4Container
@onready var selected_enemy_ind = _enemycont1.get_node("Select")
@onready var active_enemies: Array = [_enemycont1]
@onready var fx = $FX
@onready var hp: int


func _ready():
	if player_count == 1:
		_player2container.visible = false
		_player3container.visible = false
		_player4container.visible = false
##	setup player
	set_health_init(_playerhp, player.health, player.max_health)
	set_mp_init(_playermp, player.mp, player.max_mp)
	current_player_health = player.health
	current_player_mp = player.mp
	
##	load enemy resource from encounter -- TURN OFF LOAD TO TEST RESOURCE
	enemy 	= load(player.enemy_encounter)
	AudioPlayer.play_music_level(enemy.music)
	enemyDict_1["res"] = enemy
	enemyDict_1["cont"] = _enemycont1
	enemyDict_1["live"] = enemyStats1
	enemyStats1["hp"] = enemyDict_1["res"].health		

##	setup enemy 1	
	set_health_init(enemyDict_1["cont"].get_node("EnemyHP"), enemyDict_1["res"].health, enemyDict_1["res"].health)
	_enemyrect1.texture = enemy.texture
	_enemycont1.get_node("Label").text = enemy.name
	_enemycont1.get_node("Select").modulate.a = 0
	if enemy.battle_scale_vec < Vector2(1,1):
		_enemycont1.size = _enemycont1.size * enemy.battle_scale_vec
		_enemycont1.position.x = _enemycont1.position.x + 50
	_enemycont1.add_theme_constant_override("separation", enemy.battle_y_sep)
	e_groupsize = rng.randi_range(enemy.min_group_size, enemy.max_group_size)
	#enemyToStat[_enemycont1] = enemyStats1
	#enemyStats1["res"] = enemy
	#enemyStats1["HP"] = enemy.health
	
#	first check if groupsize > 1
	if e_groupsize > 1:
		if len(enemy.friends) > 0:
			var bla = rng.randi_range(0, len(enemy.friends)) 
			if bla == 0:
				enemy2 = load(player.enemy_encounter)
			else:
				enemy2 = load(enemy.allEnemies[enemy.friends[bla-1]])
		else:
			enemy2 = load(player.enemy_encounter)
#	setup enemy 2
		enemyDict[2] = enemyDict_2
		enemyDict_2["cont"] = _enemycont2
		enemyDict_2["live"] = enemyStats2
		enemyDict_2["res"] = enemy2
		enemyStats2["hp"] = enemy2.health	
		set_health_init(_enemyhp2, enemyStats2["hp"], enemyStats2["hp"])
		_enemyrect2.texture = enemy2.texture
		_enemycont2.get_node("Label").text = enemy2.name
		_enemycont2.get_node("Select").modulate.a = 0
		if enemy2.battle_scale_vec < Vector2(1,1):
			_enemycont2.size = _enemycont2.size * enemy2.battle_scale_vec
			_enemycont2.position.x = _enemycont2.position.x + 50
		_enemycont2.add_theme_constant_override("separation", enemy2.battle_y_sep)
		#active_enemies.append(_enemycont2)

	
	else:
		_enemycont2.visible = false
	
	if e_groupsize > 2:
		if len(enemy.friends) > 0:
			var bla = rng.randi_range(0, len(enemy.friends)) 
			if bla == 0:
				enemy3 = load(player.enemy_encounter)
			else:
				enemy3 = load(enemy.allEnemies[enemy.friends[bla-1]])
		else:
			enemy3 = load(player.enemy_encounter)
		
#	setup enemy 3
		enemyDict[3] = enemyDict_3
		enemyDict_3["cont"] = _enemycont3
		enemyDict_3["live"] = enemyStats3
		enemyDict_3["res"] = enemy3
		enemyStats3["hp"] = enemy3.health	
		set_health_init(_enemyhp3, enemyStats3["hp"], enemyStats3["hp"])
		_enemyrect3.texture = enemy3.texture
		_enemycont3.get_node("Label").text = enemy3.name
		_enemycont3.get_node("Select").modulate.a = 0
		if enemy3.battle_scale_vec < Vector2(1,1):
			_enemycont3.size = _enemycont3.size * enemy3.battle_scale_vec
			_enemycont3.position.x = _enemycont3.position.x + 50
		_enemycont3.add_theme_constant_override("separation", enemy3.battle_y_sep)
	
	else:
		_enemycont3.visible = false

	if e_groupsize > 3:
		if len(enemy.friends) > 0:
			var bla = rng.randi_range(0, len(enemy.friends)) 
			if bla == 0:
				enemy4 = load(player.enemy_encounter)
			else:
				enemy4 = load(enemy.allEnemies[enemy.friends[bla-1]])
		else:
			enemy4 = load(player.enemy_encounter)
			
		
#	setup enemy 4
		enemyDict[4] = enemyDict_4
		enemyDict_4["cont"] = _enemycont4
		enemyDict_4["live"] = enemyStats4
		enemyDict_4["res"] = enemy4
		enemyStats4["hp"] = enemy4.health	
		set_health_init(_enemyhp4, enemyStats4["hp"], enemyStats4["hp"])
		_enemyrect4.texture = enemy4.texture
		_enemycont4.get_node("Label").text = enemy4.name
		_enemycont4.get_node("Select").modulate.a = 0
		if enemy4.battle_scale_vec < Vector2(1,1):
			_enemycont4.size = _enemycont4.size * enemy4.battle_scale_vec
			_enemycont4.position.x = _enemycont4.position.x + 50
		_enemycont4.add_theme_constant_override("separation", enemy4.battle_y_sep)
		

	else:
		_enemycont4.visible = false

	
func _click(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_XBUTTON1):
		emit_signal("clicked")

signal pressedSomething

func _input(event):
	if Input.is_anything_pressed():
		pressedSomething.emit()
		
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

###	select target
		#if Input.is_action_pressed("up"):
			#x = min(x + 1, len(active_enemies) - 1)
			#selected_enemy_ind.modulate.a = 0
			#_tween_selector().stop
			#selected_enemy_ind = active_enemies[x]
			#_tween_selector()
			#print("pressed up")
	#else:
		pass



func set_mp_init(progress_bar, mp, max_mp):
	progress_bar.value = mp 
	progress_bar.max_value = max_mp
	progress_bar.get_node("MPLabel").text = "MP: %d/%d" % [mp, max_mp]

func set_health_init(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health
	progress_bar.get_node("HPLabel").text = "HP: %d/%d" % [health, max_health]

func set_health(progress_bar, health, max_health):
	var stepsize : float = max(max_health / 100,1)
	var steps : int = ceil(min(dealt_dmg, health) / stepsize)
	var health_label_value: int = health
	for i in steps:
		progress_bar.value = progress_bar.value - stepsize
		health_label_value = health_label_value - stepsize
		progress_bar.get_node("HPLabel").text = "HP: %d/%d" % [max(0,health_label_value), max_health]
		if i == steps - 1:
			progress_bar.get_node("HPLabel").text = "HP: %d/%d" % [max(0,health - dealt_dmg), max_health]
		await get_tree().create_timer(0.03).timeout

func set_mp(progress_bar, mp_cost, max_mp): 
	for i in max(0,mp_cost):
		current_player_mp = current_player_mp - mp_cost
		progress_bar.value = progress_bar.value - 1
		progress_bar.max_value = max_mp
		progress_bar.get_node("MPLabel").text = "MP: %d/%d" % [progress_bar.value, max_mp]
		await get_tree().create_timer(0.10).timeout
		


func combat_log(text):
	visible_characters = 0
	_combat_log_box.visible_characters = visible_characters
	_combat_log_box.text = text
	var log_timer = _log_timer
	for i in text: 
		visible_characters = (visible_characters + 1)
		_combat_log_box.visible_characters = visible_characters
		log_timer.start(0.03)
		await log_timer.timeout
	log_timer.start(0.4)
	await log_timer.timeout	
			
	
func enemy_turn():
	if enemy.can_chill == true and rng.randi_range(1, 100) <= 9:
		combat_log("%s is chillin'" % (enemy.name))
		$AnimationPlayer.play("enemy_chillin")
		await $AnimationPlayer.animation_finished
	else:
		dealt_dmg = round(rng.randf_range(0.8, 1.2) * enemy.damage)
		await combat_log("%s attacks!" % [enemy.name])
		var tween = get_tree().create_tween()
		var pos = _enemyrect1.position
		tween.tween_property(_enemyrect1, "position", Vector2(pos[0] + 10, pos[1]), 0.4)
		tween.tween_property(_enemyrect1, "position", Vector2(pos[0] - 20, pos[1]), 0.15)
		tween.tween_property(_enemyrect1, "position", Vector2(pos[0], pos[1]), 0.3)
		await tween.step_finished 
		set_health(_playerhp, current_player_health, player.max_health)
		current_player_health = (current_player_health - dealt_dmg)
		player.health = current_player_health
		tween = get_tree().create_tween()
		for i in 6:
			tween.chain().tween_property(_playertexture, "modulate:a", 0,  0.1)
			tween.chain().tween_property(_playertexture, "modulate:a", 1,  0.1)
		
		await tween.finished
		await combat_log("Got hit for %d damage" % [dealt_dmg])
		if enemy.lifesteal > 0:
			set_health_init(_enemyhp1, (min(current_enemy_health + enemy.lifesteal, enemy.health)), enemy.health)
			await combat_log("%s regained %d health" % [enemy.name, enemy.lifesteal] )
		try = 0

		
var enemyCount : Array
var y : int = 0

func _on_attack_pressed():

	_actionmenu.visible = false
	enemyCount = enemyDict.keys()
	x = 0
	_await_selection()



func _await_selection():
	var _selector_tween: Tween
	selected_enemy_ind = enemyDict[enemyCount[x]]["cont"].get_node("Select")
	selected_enemy_ind.modulate.a = 1
	var max_x = len(enemyCount) - 1
	var pos = selected_enemy_ind.position
	var tween = get_tree().create_tween()
	_selector_tween = tween
	tween.tween_property(selected_enemy_ind, "position:y", 10, 0.5).as_relative().set_trans(tween.TRANS_SINE)
	tween.tween_property(selected_enemy_ind, "position:y", -10, 0.5).as_relative().set_trans(tween.TRANS_SINE)
	tween.set_loops()
	await(pressedSomething)
	_selector_tween.kill()
	selected_enemy_ind.position = pos
	if Input.is_action_pressed("up"):
		selected_enemy_ind.modulate.a = 0
		if x == max_x:
			x = 0
		else:
			x += 1
		selected_enemy_ind = enemyDict[enemyCount[x]]["cont"].get_node("Select")
		selected_enemy_ind.modulate.a = 1
		_await_selection()
	elif Input.is_action_pressed("down"):
		selected_enemy_ind.modulate.a = 0
		if x == 0:
			x = max_x
		else:
			x -= 1
		selected_enemy_ind = enemyDict[enemyCount[x]]["cont"].get_node("Select")
		selected_enemy_ind.modulate.a = 1
		_await_selection()
	elif Input.is_action_pressed("ui_accept"):
		selected_enemy_ind.modulate.a = 0
		print(x)
		y = enemyDict.keys()[enemyCount[x] - 1]
		print(y)
		_attack_phase_1(y)
	else:
		_await_selection()


func _attack_phase_1(y):
	var curEnemyCont = enemyDict[y]["cont"]
	var tween = get_tree().create_tween()
	#_actionmenu.visible = false
	var pos = _playertexture.position
	dealt_dmg = round(rng.randf_range(0.85, 1.15) * player.damage)
	await combat_log("You attack %s!" % [enemy.name])
	tween.tween_property(_playertexture, "position", Vector2(pos[0] - 10, pos[1]), 0.5)
	tween.tween_property(_playertexture, "position", Vector2(pos[0] + 20, pos[1]), 0.15)
	tween.tween_property(_playertexture, "position", Vector2(pos[0], pos[1]), 0.5) #.set_delay(0.5)
	await get_tree().create_timer(0.75).timeout
	fx.get_node("hitAnimate").position = curEnemyCont.position + (curEnemyCont.size / 2)
	fx.get_node("hitAnimate").play('slash')
	await get_tree().create_timer(0.55).timeout
	_attack_phase_2(y)

func _on_magic_pressed(y):
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
		set_mp(_playermp, mp_cost, player.max_mp)
		player.mp = current_player_mp
		_actionmenu.visible = false
		var m_pos = _fireballAnimate.position
		dealt_dmg = player.magicdmg
		await combat_log("You use FIREBALL on %s!" % [enemy.name])
		var tween = get_tree().create_tween()
		tween.tween_property(_fireballAnimate, "modulate:a", 1,0.3)
		tween.tween_property(_fireballAnimate, "position", Vector2(m_pos[0] +350, m_pos[1]), 0.3)
		tween.tween_property(_fireballAnimate, "modulate:a", 0,0.05)	
		tween.tween_property(_fireballAnimate, "position", Vector2(m_pos[0], m_pos[1]), 0.1)
		await tween.finished
		_attack_phase_2(y)	
	
func _attack_phase_2(y):
	var selected_enemy = enemyDict[y]["cont"]
	var curEnemyStats = enemyDict[y]["live"]
	#cur_enmy_stats["HP"] = selected_enemy.health
	
	#$AnimationPlayer.play("enemy_damaged")
	var tween = get_tree().create_tween()
	for i in 6:
		tween.chain().tween_property(selected_enemy, "modulate:a", 0,  0.1)
		tween.chain().tween_property(selected_enemy, "modulate:a", 1,  0.1)
	#await $AnimationPlayer.animation_finished
	if player.critc >= rng.randi_range(1, 100):
		dealt_dmg = round(dealt_dmg * 1.5)
		await combat_log("CRITICAL HIT!")
		await get_tree().create_timer(0.5).timeout
	else:
		await get_tree().create_timer(0.75).timeout
	await set_health(selected_enemy.get_node("EnemyHP"), curEnemyStats["hp"], enemyDict[y]["res"].health)
	curEnemyStats["hp"] = max(0, curEnemyStats["hp"] - dealt_dmg)
	#await get_tree().create_timer(0.75).timeout
	await combat_log("You hit for %d damage" % [dealt_dmg])
	#await get_tree().create_timer(1).timeout
	#crit = false
	enemyDict[y]["live"] = curEnemyStats
	if curEnemyStats["hp"] <= 0:
		await(enemy_died(y))
	if enemyDict.is_empty():
		sceneManager.goto_scene(sceneManager.last_scene)
	await enemy_turn()
	_actionmenu.visible = true


func enemy_died(y):
	var tween = get_tree().create_tween()
	var deaded_enemy = enemyDict[y]
	var dead_enemy_container = deaded_enemy["cont"]
	#var 
	tween.tween_property(dead_enemy_container, "modulate:a", 0,  0.5)
	await (combat_log("%s died" % (deaded_enemy["res"].name)))
	player.xp = player.xp + enemyDict[y]["res"].xp
	if player.xp >= player.max_xp:
		player.level_up()
		current_player_health = current_player_health + player.hp_grow
		set_health_init(_playerhp, current_player_health, player.max_health)
		await(combat_log("Level increased to %d" % [player.lvl]))
		await get_tree().create_timer(0.7).timeout
		await(combat_log("Max HP increased by %d!" % [player.hp_grow]))
		await get_tree().create_timer(0.7).timeout
		await(combat_log("Attack Power increased by %d!" % [player.dmg_grow]))
		await get_tree().create_timer(0.7).timeout
		player.hp_grow = 0
		player.dmg_grow = 0
	
	enemyDict.erase(y)




func _on_dance_pressed() -> void:
	var tween = get_tree().create_tween()
	for i in 10:
		tween.tween_property(_playertexture, "modulate:s", 1, 0.01)
		tween.tween_property(_playertexture, "modulate:h", 0.5, 0.01)
		tween.tween_property(_playertexture, "flip_h", true,  0.1)
		tween.tween_property(_playertexture, "modulate:h", 0.3, 0.01)
		tween.tween_property(_playertexture, "flip_h", false,  0.1)
		tween.tween_property(_playertexture, "modulate:h", 0.8, 0.01)
	tween.tween_property(_playertexture, "modulate:s", 0, 0.01)

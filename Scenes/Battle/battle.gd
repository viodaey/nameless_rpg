extends Control

const scene_type = 2
@onready var ability_ind_pos = $Abilities/AbilitiesSelection/MarginContainer/HBoxContainer/Control/Selector.position
#1 = map, 2 = battle, 3 = village?
@export var enemy : Resource 
var enemy2: Resource
var enemy3: Resource
var enemy4: Resource
var rng = RandomNumberGenerator.new()
var current_player_health: int = 0
var current_enemy_health: int = 0
var current_player_mp: int = 0
var dealt_dmg: int = 0
var enemy_dmg: int = 0
var visible_characters: int = 0
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
var playerDict: Dictionary = {1: playerDict_1}
var playerDict_1: Dictionary
var playerDict_2: Dictionary
var playerDict_3: Dictionary
var playerDict_4: Dictionary
var playerStats1 : Dictionary
var enemyList : Array
var targetCount : int
var targetList : Array
var x : int
var y : int = 0
var calc_lvl: int
var curPlayer = playerDict[1]

# attack = 0, item = 1, ability = 2
var next_phase: int = 0
var used_item: Resource
var used_item_slot: int = 0
var ax : int = 0
var ay : int = 1

@onready var _playerhp = $Panel_Menu/VBoxContainer/PlayerContainer1/PlayerHP
@onready var _playermp = $Panel_Menu/VBoxContainer/PlayerContainer1/PlayerMP
@onready var _log_timer = $CombatLogPanel/Timer
@onready var _combat_log_box = $CombatLogPanel/CombatLog
@onready var _projectile = $FX/projectile
@onready var _enemycont1 = $EnemyContainer1
@onready var _enemycont2 = $EnemyContainer2
@onready var _enemycont3 = $EnemyContainer3
@onready var _enemycont4 = $EnemyContainer4
@onready var _actionmenu = $ActionMenu
@onready var _actionmenufoc = $ActionMenu/MarginActions/HBoxContainer/Actions/Attack
@onready var _abilitiesnode = $Abilities
@onready var _abilitiesmenu = $Abilities/AbilitiesSelection/MarginContainer/HBoxContainer/AbilityList
#@onready var _player2statscont = $Panel_Menu/VBoxContainer/PlayerContainer2
@onready var _player3statscont = $Panel_Menu/VBoxContainer/PlayerContainer3
@onready var _player4statscont = $Panel_Menu/VBoxContainer/PlayerContainer4
@onready var selected_enemy_ind : TextureRect #= _enemycont1.get_node("Select")
@onready var active_enemies: Array = [_enemycont1]
@onready var fx = $FX
@onready var onhit1 = $FX/hitAnimate1
@onready var onhit2 = $FX/hitAnimate2
@onready var onhit3 = $FX/hitAnimate3
@onready var onhit4 = $FX/hitAnimate4

@onready var hp: int
@onready var min_lvl: int = sceneManager.mon_min_lvl
@onready var max_lvl: int = sceneManager.mon_max_lvl

func _ready():
##	setup player 1
	$Background.texture = sceneManager.battle_bg
	set_health_init(_playerhp, player.health, player.max_health)
	current_player_mp = player.mp
	set_mp_init(_playermp, player.mp, player.max_mp)
	playerDict_1["res"] = player
	playerDict_1["live"] = playerStats1
	playerDict_1["txt"] = $Player_1
	playerDict_1["cont"] = $Panel_Menu/VBoxContainer/PlayerContainer1
	playerDict_1["circle"] = $playerContainer1/selectCircle
	playerDict_1["ind"] = $playerContainer1/Select
	playerDict_1["ind"].modulate.a = 0
	playerDict_1["live"]["hp"] = player.health
	playerDict_1["live"]["mp"] = player.mp
	playerDict_1["live"]["dmg"] = player.damage
	playerDict_1["cont"].get_node("Name").text = ("%s lvl %d" %[playerDict_1["res"]._name, playerDict_1["res"].lvl])
	playerDict_1["atb"] = 0
	playerDict_1["max_atb"] = player.atb
	playerDict_1["dmg"] = player.damage	
	playerDict_1["cont"].get_node("PlayerATB").max_value = playerDict_1["max_atb"]
	
##	load player_monster 1
	if len(inv.itemInventory.monsterlist) > 0:
		playerDict[2] = playerDict_2
		playerDict_2["res"] = inv.itemInventory.monsterlist[0]._monster
		playerDict_2["live"] = inv.itemInventory.monsterlist[0].stats
		playerDict_2["txt"] = $soulContainer1/VBoxContainer/SoulText
		playerDict_2["cont"] = $Panel_Menu/VBoxContainer/PlayerContainer2
		playerDict_2["circle"] = $soulContainer1/VBoxContainer/SoulText/selectCircle
		playerDict_2["txtbox"] = $soulContainer1
		playerDict_2["ind"] = $soulContainer1/VBoxContainer/Select
		playerDict_2["ind"].modulate.a = 0
		playerDict_2["live"]["hp"] = inv.itemInventory.monsterlist[0].stats["hp"]
		playerDict_2["live"]["mp"] = inv.itemInventory.monsterlist[0].stats["mp"]
		playerDict_2["cont"].get_node("Name").text = ("%s lvl %d" %[playerDict_2["res"]._name, playerDict_2["res"].lvl])
		playerDict_2["txt"].sprite_frames =	playerDict_2["res"].animatedSprite
		playerDict_2["txt"].play("idle")
		if playerDict_2["res"].battle_scale_vec < Vector2(1,1):
			playerDict_2["txt"].scale = playerDict_2["res"].battle_scale_vec
		set_health_init(playerDict_2["cont"].get_node("PlayerHP"), playerDict_2["live"]["hp"], playerDict_2["res"].max_health)
		playerDict_2["atb"] = 0
		playerDict_2["max_atb"] = playerDict_2["res"].atb
		playerDict_2["dmg"] = playerDict_2["res"].damage
		playerDict_2["cont"].get_node("PlayerATB").max_value = playerDict_2["max_atb"]
		
	else:
		$Panel_Menu/VBoxContainer/PlayerContainer2.visible = false
		$soulContainer1.visible = false
	
	if len(inv.itemInventory.monsterlist) <= 100:
		_player3statscont.visible = false
		_player4statscont.visible = false

##	load enemy resource from encounter -- TURN OFF LOAD TO TEST EXPORT RESOURCE
	enemy = load(player.enemy_encounter)
	AudioPlayer.play_music_level(enemy.music)
	enemyDict_1["res"] = enemy
	enemyDict_1["cont"] = _enemycont1
	enemyDict_1["live"] = enemyStats1
	
##	roll for groupsize
	e_groupsize = rng.randi_range(enemy.min_group_size, enemy.max_group_size)
##	safety net starting player
	if player.lvl < 3:
		e_groupsize = 1
	if player.lvl < 5 and e_groupsize > 2:
		e_groupsize = 2
	if player.lvl < 10 and e_groupsize > 3:
		e_groupsize = 3
		
#### TESTING - SHOULD BE COMMENTED OUT
	#e_groupsize = 2
		
##	roll and allocate enemy 2
	if e_groupsize > 1:
		if len(enemy.friends) > 0:
			var bla = rng.randi_range(0, len(enemy.friends)) 
			if bla == 0:
				enemy2 = load(player.enemy_encounter)
			else:
				enemy2 = load(enemy.allEnemies[enemy.friends[bla-1]])
		else:
			enemy2 = load(player.enemy_encounter)
		enemyDict[2] = enemyDict_2
		enemyDict_2["cont"] = _enemycont2
		enemyDict_2["live"] = enemyStats2
		enemyDict_2["res"] = enemy2
	else:
		_enemycont2.visible = false
		
##	roll and allocate enemy 3
	if e_groupsize > 2:
		if len(enemy.friends) > 0:
			var bla = rng.randi_range(0, len(enemy.friends)) 
			if bla == 0:
				enemy3 = load(player.enemy_encounter)
			else:
				enemy3 = load(enemy.allEnemies[enemy.friends[bla-1]])
		else:
			enemy3 = load(player.enemy_encounter)
		enemyDict[3] = enemyDict_3
		enemyDict_3["cont"] = _enemycont3
		enemyDict_3["live"] = enemyStats3
		enemyDict_3["res"] = enemy3
	else:
		_enemycont3.visible = false
		
##	roll and allocate enemy 4
	if e_groupsize > 3:
		if len(enemy.friends) > 0:
			var bla = rng.randi_range(0, len(enemy.friends)) 
			if bla == 0:
				enemy4 = load(player.enemy_encounter)
			else:
				enemy4 = load(enemy.allEnemies[enemy.friends[bla-1]])
		else:
			enemy4 = load(player.enemy_encounter)

		enemyDict[4] = enemyDict_4
		enemyDict_4["cont"] = _enemycont4
		enemyDict_4["live"] = enemyStats4
		enemyDict_4["res"] = enemy4
	else:
		_enemycont4.visible = false

##	setup enemies
	for en in enemyDict:
		rng = RandomNumberGenerator.new()
		enemyDict[en]["live"]["hp"] = enemyDict[en]["res"].health
		enemyDict[en]["live"]["dmg"] = enemyDict[en]["res"].damage
		enemyDict[en]["live"]["xp"] = enemyDict[en]["res"].xp
		enemyDict[en]["live"]["lvl"] = rng.randi_range(min_lvl, min(max(player.lvl + 1, min_lvl), max_lvl))
		if enemyDict[en]["live"]["lvl"] > 1:
			calc_lvl = enemyDict[en]["live"]["lvl"] - 1
			for i in calc_lvl:
				enemyDict[en]["live"]["hp"] = enemyDict[en]["live"]["hp"] * enemyDict[en]["res"]._class.hp_mult * 1.08
				enemyDict[en]["live"]["dmg"] = enemyDict[en]["live"]["dmg"] * enemyDict[en]["res"]._class.dmg_mult * 1.08
				enemyDict[en]["live"]["xp"] = enemyDict[en]["live"]["xp"] * 1.4
		set_health_init(enemyDict[en]["cont"].get_node("EnemyHP"), enemyDict[en]["live"]["hp"], enemyDict[en]["live"]["hp"])
		enemyDict[en]["cont"].get_node("AspectContainer").get_node("EnemyText").sprite_frames = enemyDict[en]["res"].animatedSprite
		enemyDict[en]["cont"].get_node("AspectContainer").get_node("EnemyText").play("idle")
		enemyDict[en]["cont"].get_node("Label").text = "lvl: %d %s" % [enemyDict[en]["live"]["lvl"], enemyDict[en]["res"]._name]
		enemyDict[en]["cont"].get_node("Select").modulate.a = 0
		if enemyDict[en]["res"].battle_scale_vec < Vector2(1,1):
			enemyDict[en]["cont"].get_node("AspectContainer").get_node("EnemyText").scale = enemyDict[en]["res"].battle_scale_vec
			#enemyDict[en]["cont"].size = enemyDict[en]["cont"].size * enemyDict[en]["res"].battle_scale_vec
			#enemyDict[en]["cont"].position.x = enemyDict[en]["cont"].position.x + 50
		enemyDict[en]["cont"].add_theme_constant_override("separation", enemyDict[en]["res"].battle_y_sep)
		enemyDict[en]["atb"] = 0
		enemyDict[en]["max_atb"] = enemyDict[en]["res"].atb

##	check engagement
	if player.engagement == -1:
		for e in enemyDict:
			enemyDict[e]["atb"] = enemyDict[e]["max_atb"] - 1
		await combat_log("Surprise attack!")
	_turn_calc()

signal pressedSomething

func _input(_event) -> void:
	if Input.is_anything_pressed():
		pressedSomething.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
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
		@warning_ignore("narrowing_conversion")
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
		var z = 1
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or Input.is_action_pressed("ui_accept"):
			z = 4
		visible_characters = (visible_characters + 1)
		_combat_log_box.visible_characters = visible_characters
		log_timer.start(0.03 / z)
		await log_timer.timeout
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		log_timer.start(0.4)
		await log_timer.timeout		


func _turn_calc():
	curPlayer["circle"].visible = false
	while true:
		for i in 5:
			for p in playerDict:
				playerDict[p]["atb"] += 1
				playerDict[p]["cont"].get_node("PlayerATB").value = playerDict[p]["atb"]
				if playerDict[p]["atb"] == playerDict[p]["max_atb"]:
					playerDict[p]["atb"] = 0
					_player_turn(p)
					return
			for e in enemyDict:
				enemyDict[e]["atb"] += 1
				if enemyDict[e]["atb"] == enemyDict[e]["max_atb"]:
					enemyDict[e]["atb"] = 0
					enemy_turn(e)
					return
		await get_tree().create_timer(0.001).timeout
				
func _player_turn(p):
	curPlayer = playerDict[p]
	#curPlayer["cont"].get_node("PlayerATB")
	if curPlayer["live"].has("affl"):
		await combat_log("%s is %s" % [curPlayer["res"]._name, curPlayer["live"]["affl"]])
		if curPlayer["live"]["affl"] == "burning":
			dealt_dmg = 3
			set_health(
				curPlayer["cont"].get_node("PlayerHP"), 
				curPlayer["live"]["hp"], 
				curPlayer["res"].max_health)
			curPlayer["live"]["hp"] = (curPlayer["live"]["hp"] - dealt_dmg)
			curPlayer["res"].health = curPlayer["live"]["hp"]
			if rng.randi_range(0,100) > 40:
				curPlayer["live"].erase("affl")
				await combat_log("%s stopped burning" % [playerDict[y]["res"]._name])
	_actionmenu.visible = true
	_actionmenufoc.grab_focus()
	curPlayer["circle"].visible = true


func _on_attack_pressed():
	_actionmenu.visible = false
	targetCount = 1
	next_phase = 0
	x = 0
	_await_selection()

func _on_abilities_pressed() -> void:
	if len(curPlayer["res"]._abilities) > 0:
		_actionmenu.visible = false
		_abilitiesnode.visible = true
		x = 0
		ay = 1
		for i in len(curPlayer["res"]._abilities):
			_abilitiesmenu.get_node("Ability%s" %[i + 1]).visible = true
			_abilitiesmenu.get_node("Ability%s" %[i + 1]).get_node("Name").text =   curPlayer["res"]._abilities[i]._name
			_abilitiesmenu.get_node("Ability%s" %[i + 1]).get_node("MP").text =   ("%s" %curPlayer["res"]._abilities[i].mp)
		_await_ability_selection()

func _await_ability_selection():
	var ability_ind = $Abilities/AbilitiesSelection/MarginContainer/HBoxContainer/Control/Selector
	$Abilities/AbilitiesDescription/MarginContainer/HBoxContainer/Description.text = curPlayer["res"]._abilities[ay-1].description
	if curPlayer["res"]._abilities[ay-1].mp > 0:
		$Abilities/AbilitiesDescription/MarginContainer/HBoxContainer/VBoxContainer/MP.text = ("MP: %s" %curPlayer["res"]._abilities[ay-1].mp)
	else:
		$Abilities/AbilitiesDescription/MarginContainer/HBoxContainer/VBoxContainer/MP.text = ""
	if curPlayer["res"]._abilities[ay-1].cooldown > 0:
		$Abilities/AbilitiesDescription/MarginContainer/HBoxContainer/VBoxContainer/Cooldown.text = ("CD: %s" %curPlayer["res"]._abilities[ay-1].cooldown)
	ax = len(curPlayer["res"]._abilities)
	await(pressedSomething)
	if Input.is_action_pressed("ui_down"):
		if ax > ay:
			ability_ind.position.y = ability_ind.position.y + 27
			ay += 1
	if Input.is_action_pressed("ui_up"):
		if ay > 1:
			ability_ind.position.y = ability_ind.position.y - 27
			ay -= 1
	if Input.is_action_pressed("ui_accept"):
		if curPlayer["res"]._abilities[ay-1].target == "enemy":
			next_phase = 2
			targetCount = curPlayer["res"]._abilities[ay-1].target_amount
			_abilitiesnode.visible = false
			ability_ind.position = ability_ind_pos
			_await_selection()
			return
	if Input.is_action_pressed("ui_cancel"):
		ability_ind.position = ability_ind_pos
		ay = 1
		_abilitiesnode.visible = false
		_actionmenu.visible = true
		_actionmenufoc.grab_focus()
		return
	_await_ability_selection()
	
func _await_selection():
	enemyList = enemyDict.keys()
	var _selector_tween: Tween
	selected_enemy_ind = enemyDict[enemyList[x]]["cont"].get_node("Select")
	var max_x = len(enemyList) - 1
	var pos = selected_enemy_ind.position
	var tween = get_tree().create_tween()
	_selector_tween = tween
	tween.tween_property(selected_enemy_ind, "position:y", 10, 0.5).as_relative().set_trans(tween.TRANS_SINE)
	tween.tween_property(selected_enemy_ind, "position:y", -10, 0.5).as_relative().set_trans(tween.TRANS_SINE)
	tween.set_loops()
	for i in enemyDict:
		enemyDict[i]["cont"].get_node("Select").modulate.a = 0
	selected_enemy_ind.modulate.a = 1
	if targetCount > 1 and len(enemyList) > 1:
		enemyDict[enemyList[(x + 1) % len(enemyList)]]["cont"].get_node("Select").modulate.a = 0.5
		if targetCount > 2 and len(enemyList) > 2:
			enemyDict[enemyList[(x - 1) % len(enemyList)]]["cont"].get_node("Select").modulate.a = 0.5
		if targetCount == 4 and len(enemyList) == 4:
			enemyDict[enemyList[(x + 2) % len(enemyList)]]["cont"].get_node("Select").modulate.a = 0.5
	await(pressedSomething)
	_selector_tween.kill()
	selected_enemy_ind.position = pos
	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_right"):
		selected_enemy_ind.modulate.a = 0
		if x == max_x:
			x = 0
		else:
			x += 1
		selected_enemy_ind = enemyDict[enemyList[x]]["cont"].get_node("Select")
		#selected_enemy_ind.modulate.a = 1
		_await_selection()
	elif Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_left"):
		selected_enemy_ind.modulate.a = 0
		if x == 0:
			x = max_x
		else:
			x -= 1
		selected_enemy_ind = enemyDict[enemyList[x]]["cont"].get_node("Select")
		#selected_enemy_ind.modulate.a = 1
		_await_selection()
	elif Input.is_action_pressed("ui_accept"):
		for i in enemyDict:
			enemyDict[i]["cont"].get_node("Select").modulate.a = 0
		_selector_tween.kill()
		targetList = [enemyList[x]]
		y = enemyList[x]
		if targetCount > 1 and len(enemyList) > 1:
			targetList.append(enemyList[(x + 1) % len(enemyList)])
		if targetCount > 2 and len(enemyList) > 2:
			targetList.append(enemyList[(x - 1) % len(enemyList)])
		if targetCount == 4 and len(enemyList) == 4:
			targetList.append(enemyList[(x + 2) % len(enemyList)])
		if next_phase == 0:
			_attack_phase_1()
		elif next_phase == 1:
			use_item_2(enemyDict[y])
		elif next_phase == 2:
			use_ability()
	elif Input.is_action_pressed("ui_cancel"):
		for i in enemyDict:
			enemyDict[i]["cont"].get_node("Select").modulate.a = 0
		_selector_tween.kill()
		_actionmenu.visible = true
		_actionmenufoc.grab_focus()
	else:
		_await_selection()

		
func _player_selection():
	var playerCount = playerDict.keys()
	var _selector_tween: Tween
	var selected_ind = playerDict[playerCount[x]]["ind"]
	selected_ind.modulate.a = 1
	var max_x = len(playerCount) - 1
	var pos = selected_ind.position
	var tween = get_tree().create_tween()
	_selector_tween = tween
	tween.tween_property(selected_ind, "position:y", 10, 0.5).as_relative().set_trans(tween.TRANS_SINE)
	tween.tween_property(selected_ind, "position:y", -10, 0.5).as_relative().set_trans(tween.TRANS_SINE)
	tween.set_loops()
	await(pressedSomething)
	_selector_tween.kill()
	selected_ind.position = pos
	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_right"):
		selected_ind.modulate.a = 0
		if x == max_x:
			x = 0
		else:
			x += 1
		selected_ind = playerDict[playerCount[x]]["ind"]
		selected_ind.modulate.a = 1
		_player_selection()
	elif Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_left"):
		selected_ind.modulate.a = 0
		if x == 0:
			x = max_x
		else:
			x -= 1
		selected_ind = playerDict[playerCount[x]]["ind"]
		selected_ind.modulate.a = 1
		_player_selection()
	elif Input.is_action_pressed("ui_accept"):
		selected_ind.modulate.a = 0
		y = playerCount[x]
		_selector_tween.kill()
		if next_phase == 0:
			_attack_phase_1()
		elif next_phase == 1:
			use_item_2(playerDict[y])
	elif Input.is_action_pressed("ui_cancel"):
		selected_ind.modulate.a = 0
		_selector_tween.kill()
		_actionmenu.visible = true
		_actionmenufoc.grab_focus()
	else:
		_player_selection()
		
func _attack_phase_1():
	y = targetList[0]
	var curEnemyCont = enemyDict[y]["cont"]
	var pos = curPlayer["txt"].position
	dealt_dmg = round(rng.randf_range(0.85, 1.15) * curPlayer["dmg"])
	await combat_log("You attack %s!" % [enemyDict[y]["res"]._name])
	var tween = get_tree().create_tween()
	tween.tween_property(curPlayer["txt"], "position", Vector2(pos[0] -10, pos[1]), 0.5)
	tween.tween_property(curPlayer["txt"], "position", Vector2(pos[0] + 20, pos[1]),0.15)
	tween.tween_property(curPlayer["txt"], "position", Vector2(pos[0], pos[1]),0.5)
	await get_tree().create_timer(0.75).timeout
	onhit1.position = curEnemyCont.position + (curEnemyCont.size / 2)
	onhit1.play('slash')
	await get_tree().create_timer(0.55).timeout
	_attack_phase_2()
	
## 	get targets, iterate through targets
func _attack_phase_2():
	var crit: bool = false
	if curPlayer["res"].critc >= rng.randi_range(1, 100) and next_phase == 0:
		dealt_dmg = round(dealt_dmg * 1.5)
		crit = true
	for z in targetList:
		var selected_enemy = enemyDict[z]["cont"]
		var curEnemyStats = enemyDict[z]["live"]
		var tween = get_tree().create_tween()
		for i in 6:
			tween.chain().tween_property(selected_enemy, "modulate:a", 0,  0.1)
			tween.chain().tween_property(selected_enemy, "modulate:a", 1,  0.1)
	#if curPlayer["res"].critc >= rng.randi_range(1, 100):
		#dealt_dmg = round(dealt_dmg * 1.5)
		#await combat_log("CRITICAL HIT!")
		#await get_tree().create_timer(0.5).timeout
	#else:
		#await get_tree().create_timer(0.75).timeout
		set_health(selected_enemy.get_node("EnemyHP"), curEnemyStats["hp"], enemyDict[z]["res"].max_health)
		curEnemyStats["hp"] = max(0, curEnemyStats["hp"] - dealt_dmg)
		enemyDict[z]["live"] = curEnemyStats
	if crit == true:
		await combat_log("CRITICAL HIT!")
	await get_tree().create_timer(0.6).timeout
	await combat_log("%s hit for %d damage" % [curPlayer["res"]._name, dealt_dmg])
	await get_tree().create_timer(0.6).timeout
	for z in targetList:
		if enemyDict[z]["live"]["hp"] <= 0:
			y = z
			await(enemy_died())
	if enemyDict.is_empty():
		await(_drops())
		for p in playerDict:
			if p > 1:
				if playerDict[p]["res"].lvl >= playerDict[p]["res"].evo_lvl:
					await(evolve(p))
		sceneManager.goto_scene(sceneManager.last_scene)
	_turn_calc()

func _drops():
	var dropped: Array
	for i in e_groupsize:
		for d in len(inv.drops):
			if rng.randi_range(0, 100) <= inv.drops[d]:
				inv.add_item(inv.item_id[d], 1)
				dropped.append(inv.item_id[d]._name)
	for i in len(dropped):
		await combat_log("Obtained %s!" %dropped[i])

func enemy_died():
	var tween = get_tree().create_tween()
	tween.tween_property(enemyDict[y]["cont"], "modulate:a", 0,  0.5)
	await (combat_log("%s died" % (enemyDict[y]["res"]._name)))
	for p in playerDict:
		playerDict[p]["res"].xp = playerDict[p]["res"].xp + enemyDict[y]["live"]["xp"]
		if playerDict[p]["res"].xp >= playerDict[p]["res"].max_xp:
			playerDict[p]["res"].level_up()
			playerDict[p]["live"]["hp"] = playerDict[p]["live"]["hp"] + playerDict[p]["res"].hp_grow
			playerDict[p]["cont"].get_node("Name").text = ("%s lvl %d" %[playerDict[p]["res"]._name, playerDict[p]["res"].lvl])
			set_health_init(playerDict[p]["cont"].get_node("PlayerHP"), playerDict[p]["live"]["hp"], playerDict[p]["res"].max_health)
			await(combat_log("%s's level increased to %d" % [playerDict[p]["res"]._name, playerDict[p]["res"].lvl]))
			await get_tree().create_timer(0.7).timeout
			await(combat_log("Max HP increased by %d!" % [playerDict[p]["res"].hp_grow]))
			await get_tree().create_timer(0.7).timeout
			await(combat_log("Attack Power increased by %d!" % [playerDict[p]["res"].dmg_grow]))
			await get_tree().create_timer(0.7).timeout
		playerDict[p]["res"].health = playerDict[p]["live"]["hp"]
	enemyDict.erase(y)

func enemy_turn(e):
	if enemyDict[e]["res"].can_chill == true and rng.randi_range(1, 100) <= 9:
		combat_log("%s is chillin'" % (enemyDict[e]["res"]._name))
		var tween = get_tree().create_tween()
		tween.tween_property(enemyDict[e]["cont"].get_node("AspectContainer").get_node("EnemyText"), "flip_h", true, 1)
		tween.tween_property(enemyDict[e]["cont"].get_node("AspectContainer").get_node("EnemyText"), "flip_h", false, 1)
	else:
		x = rng.randi_range(1, len(playerDict))
		var players_array = playerDict.keys()
		y = players_array[x - 1]
		dealt_dmg = round(rng.randf_range(0.9, 1.1) * enemyDict[e]["live"]["dmg"])
		await combat_log("%s attacks %s!" % [enemyDict[e]["res"]._name, playerDict[y]["res"]._name])
		var tween = get_tree().create_tween()
		var pos = enemyDict[e]["cont"].position
		tween.tween_property(enemyDict[e]["cont"], "position", Vector2(pos[0] + 10, pos[1]), 0.4)
		tween.tween_property(enemyDict[e]["cont"], "position", Vector2(pos[0] - 20, pos[1]), 0.15)
		tween.tween_property(enemyDict[e]["cont"], "position", Vector2(pos[0], pos[1]), 0.3)
		await tween.step_finished 
		set_health(
			playerDict[y]["cont"].get_node("PlayerHP"), 
			playerDict[y]["live"]["hp"], 
			playerDict[y]["res"].max_health)
		playerDict[y]["live"]["hp"] = max(0,(playerDict[y]["live"]["hp"] - dealt_dmg))
		playerDict[y]["res"].health = playerDict[y]["live"]["hp"]
		tween = get_tree().create_tween()
		for i in 6:
			tween.chain().tween_property(playerDict[y]["txt"], "modulate:a", 0,  0.1)
			tween.chain().tween_property(playerDict[y]["txt"], "modulate:a", 1,  0.1)
		await tween.finished
		await combat_log("Got hit for %d damage" % [dealt_dmg])
		if enemyDict[e]["res"].lifesteal > 0:
			set_health_init(
				enemyDict[e]["cont"].get_node("EnemyHP"), 
				(min(enemyDict[e]["live"]["hp"] + enemyDict[e]["res"].lifesteal, enemyDict[e]["res"].health)), 
				enemyDict[e]["res"].health)
			await combat_log("%s regained %d health" % [enemyDict[e]["res"]._name, enemyDict[e]["res"].lifesteal] )
		if enemyDict[e]["res"].affliction_chance > 0:
			if rng.randi_range(0,100) <= enemyDict[e]["res"].affliction_chance:
				await combat_log("You are %s!" % [enemyDict[e]["res"].affliction_type])
		if playerDict[y]["live"]["hp"] == 0:
			await(_ally_died(y))
	_turn_calc()

func _on_item_pressed() -> void:
	targetCount = 1
	_actionmenu.visible = false
	var itemInvSc = preload("res://Global/inventory_manager.tscn").instantiate()
	add_child(itemInvSc)
	itemInvSc._mode = "battle"
	
func use_item(z) -> void:
	used_item = inv.itemInventory.list[z]._item
	used_item_slot = z
	if used_item.isTargetSelf == false:
		next_phase = 1
		x = 0
		_await_selection()
		get_node("InventScene").queue_free()
	if used_item.isTargetSelf == true:
		next_phase = 1
		x = 0
		_player_selection()
		get_node("InventScene").queue_free()
		
func use_item_2(target):
	inv.sub_item(used_item_slot)
	await(combat_log("You use %s on %s" % [used_item._name, target["res"]._name]))
	if used_item.effects.has("Capture"):
		onhit1.position = target["cont"].position + (target["cont"].size / 2)
		onhit1.z_index = -1
		onhit1.play('castDark2')
		var tween = get_tree().create_tween()
		tween.tween_property(enemyDict[y]["cont"].get_node("AspectContainer").get_node("EnemyText"), "modulate:v", 0, 0.2)
		tween.tween_property(enemyDict[y]["cont"].get_node("AspectContainer").get_node("EnemyText"), "modulate:v", 1, 0.03)
		tween.tween_property(enemyDict[y]["cont"].get_node("AspectContainer").get_node("EnemyText"), "modulate:v", 0, 0.03)
		tween.tween_property(enemyDict[y]["cont"].get_node("AspectContainer").get_node("EnemyText"), "modulate:v", 1, 0.03)
		tween.tween_property(enemyDict[y]["cont"].get_node("AspectContainer").get_node("EnemyText"), "modulate:a", 0, 1)
		if (used_item.effects["Capture"] * 10 - (enemyDict[y]["live"]["lvl"] * 5)) - (enemyDict[y]["live"]["hp"] / enemyDict[y]["res"].health)  >	rng.randi_range(1,100):
			await(combat_log("Capturing..."))
			await get_tree().create_timer(1).timeout
			await(combat_log("........................"))
			await get_tree().create_timer(0.5).timeout
			await(combat_log("............................................ Succes!"))
			var loadslot = monSlot.new()
			inv.itemInventory.monsterlist.append(loadslot)
			var capturedmonster = inv.itemInventory.monsterlist[len(inv.itemInventory.monsterlist) - 1]
			capturedmonster._monster = enemyDict[y]["res"].duplicate()
			capturedmonster._monster.max_health = enemyDict[y]["cont"].get_node("EnemyHP").max_value
			capturedmonster.stats["hp"] = enemyDict[y]["live"]["hp"]
			capturedmonster._monster.xp = 0
			capturedmonster._monster.damage = enemyDict[y]["live"]["dmg"]
			capturedmonster._monster.lvl = enemyDict[y]["live"]["lvl"]
			await(combat_log("Captured level %d %s!" % [capturedmonster._monster.lvl, capturedmonster._monster._name]))
			if capturedmonster._monster.lvl > 1:
				for i in (capturedmonster._monster.lvl - 1):
					capturedmonster._monster.max_xp = round(capturedmonster._monster.max_xp * 1.3)
			enemyDict[y]["cont"].visible = false
			enemyDict.erase(y)
			if enemyDict.is_empty():
				await(_drops())
				sceneManager.goto_scene(sceneManager.last_scene)
			_turn_calc()
		else:
			await(combat_log("Capturing..."))
			await get_tree().create_timer(1).timeout
			await(combat_log("........................"))
			await get_tree().create_timer(0.5).timeout
			await(combat_log("............................................ Failed..."))
			tween = get_tree().create_tween()
			tween.tween_property(enemyDict[y]["cont"].get_node("AspectContainer").get_node("EnemyText"), "modulate:a", 1, 0.2)
			_turn_calc()
		onhit1.z_index = 1
	if used_item.effects.has("Heal"):
		target["live"]["hp"] = min(target["live"]["hp"] + used_item.effects["Heal"], target["res"].max_health)
		set_health_init(
			target["cont"].get_node("PlayerHP"),
			target["live"]["hp"], 
			target["res"].max_health)
		action_menu()

func use_ability():
	var base_mult = 1
	var additive = 0
	var target = enemyDict[targetList[0]]
	var used_ability = curPlayer["res"]._abilities[ay - 1]
	await combat_log("%s casts %s on %s!" % [curPlayer["res"]._name, used_ability._name, target["res"]._name])
	set_mp(_playermp, used_ability.mp, player.max_mp)
	if used_ability.eff_1_multiplier != "none":
		base_mult = curPlayer["live"].get(used_ability.eff_1_multiplier)
		base_mult = base_mult * used_ability.eff_1_multiplier_multiplier
	if used_ability.eff_1_additive != "none":
		additive = curPlayer["live"].get(used_ability.eff_1_additive) * used_ability.eff_1_additive_multiplier
	if used_ability.target_amount == 4:
		if not used_ability.animation:
			for en in enemyDict:
				var hitnode = fx.get_node("hitAnimate%d" %en)
				hitnode.position = enemyDict[en]["cont"].position + (enemyDict[en]["cont"].size / 2)
				hitnode.play(used_ability.animation_type)
			
	if used_ability.target_amount == 1:
		if not used_ability.animation:
			pass
		if used_ability.animation_type == "projectile":
			_projectile.position = curPlayer["txt"].position + (curPlayer["txt"].size / 2) + Vector2(30,0)
			_projectile.sprite_frames = used_ability.animation
			var target_position = target["cont"].position + (target["cont"].size / 2)
			var tween = get_tree().create_tween()
			tween.tween_property(_projectile, "modulate:a", 1,0.3)
			tween.tween_property(_projectile, "position", target_position, 0.5)
			tween.tween_property(_projectile, "modulate:a", 0,0.05)	
			#tween.tween_property($FX/projectile, "position", Vector2(m_pos[0], m_pos[1]), 0.1)
			await tween.finished
	dealt_dmg = ((used_ability.eff_1_base * base_mult) + additive)
	_attack_phase_2()	
			
func _ally_died(z):
	await(combat_log("%s died" % playerDict[y]["res"]._name))
	#var tween = get_tree().create_tween()
	if z == 1:
		await(get_tree().create_timer(2).timeout)
		gameover()
		return
	
func gameover():
	sceneManager.goto_scene(sceneManager.last_scene)
	
func evolve(p):
	var lvl = playerDict[p]["res"].lvl
	await(combat_log("WHAT??????????!!!!!!"))
	var tween = get_tree().create_tween()
	tween.tween_property(playerDict[p]["txtbox"], "position", (playerDict[p]["txtbox"].get_parent().size / 2) - (playerDict[p]["txtbox"].size / 2), 1)
	tween.tween_property(playerDict[p]["txtbox"], "scale", playerDict[p]["txtbox"].scale * 1.5 , 1.1)
	await get_tree().create_timer(4).timeout
	await(combat_log("%s Evolved into %s!" % [playerDict[p]["res"]._name, playerDict[p]["res"].evolution._name]))
	inv.itemInventory.monsterlist[p - 2]._monster = inv.itemInventory.monsterlist[p - 2]._monster.evolution.duplicate()
	inv.itemInventory.monsterlist[p - 2]._monster.lvl = lvl
	
func action_menu():
	_actionmenu.visible = true
	_actionmenufoc.grab_focus()

func _on_escape_pressed() -> void:
	_actionmenu.visible = false
	await combat_log("Attempting to escape...")
	await get_tree().create_timer(0.8).timeout
	
	if rng.randi_range(1,100) > 20:
		await combat_log("Succesfully escaped!")
		await get_tree().create_timer(0.5).timeout
		sceneManager.goto_scene(sceneManager.last_scene)
	else: 
		await combat_log("Escape failed!")
		await get_tree().create_timer(0.5).timeout
		_turn_calc()


#func _on_magic_pressed():
	#_turn_calc()
	
	#var mp_cost = player.mp_cost_fireball
	#if current_player_mp < player.mp_cost_fireball and try < 2:
		#await combat_log("Not enough mana")
		#try = try + 1
	#elif current_player_mp < player.mp_cost_fireball and try < 4:
		#await combat_log("nOt eNoUgH mAnA...")
		#try = try + 1
	#elif current_player_mp < player.mp_cost_fireball and try >= 4:
		#await combat_log("NOT ENOUGH MANA!")
		#try = try + 1
	#else:
		#set_mp(_playermp, mp_cost, player.max_mp)
		#player.mp = current_player_mp
		#_actionmenu.visible = false
		#var m_pos = _fireballAnimate.position
		#dealt_dmg = player.magicdmg
		#await combat_log("You use FIREBALL on %s!" % [enemy._name])
		#var tween = get_tree().create_tween()
		#tween.tween_property(_fireballAnimate, "modulate:a", 1,0.3)
		#tween.tween_property(_fireballAnimate, "position", Vector2(m_pos[0] +350, m_pos[1]), 0.3)
		#tween.tween_property(_fireballAnimate, "modulate:a", 0,0.05)	
		#tween.tween_property(_fireballAnimate, "position", Vector2(m_pos[0], m_pos[1]), 0.1)
		#await tween.finished
		#_attack_phase_2()	

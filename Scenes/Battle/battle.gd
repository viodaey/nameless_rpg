extends Control

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
var playerDict: Dictionary = {1: playerDict_1}
var playerDict_1: Dictionary
var playerDict_2: Dictionary
var playerDict_3: Dictionary
var playerDict_4: Dictionary
var playerStats1 : Dictionary
var enemyCount : Array
var x : int
var y : int = 0
var calc_lvl: int

# attack = 0, item = 1
var next_phase: int = 0
var used_item: Resource


@onready var _playerhp = $Panel_Menu/VBoxContainer/PlayerContainer1/PlayerHP
@onready var _playermp = $Panel_Menu/VBoxContainer/PlayerContainer1/PlayerMP
@onready var _log_timer = $CombatLogPanel/Timer
@onready var _combat_log_box = $CombatLogPanel/CombatLog
@onready var _playertexture = $Player_1
@onready var _fireballAnimate = $FX/Fireball
@onready var _enemycont1 = $EnemyContainer1
@onready var _enemycont2 = $EnemyContainer2
@onready var _enemycont3 = $EnemyContainer3
@onready var _enemycont4 = $EnemyContainer4
@onready var _actionmenu = $ActionMenu
@onready var _actionmenufoc = $ActionMenu/MarginActions/HBoxContainer/Actions/Attack
#@onready var _player2statscont = $Panel_Menu/VBoxContainer/PlayerContainer2
@onready var _player3statscont = $Panel_Menu/VBoxContainer/PlayerContainer3
@onready var _player4statscont = $Panel_Menu/VBoxContainer/PlayerContainer4
@onready var selected_enemy_ind : TextureRect #= _enemycont1.get_node("Select")
@onready var active_enemies: Array = [_enemycont1]
@onready var fx = $FX
@onready var hp: int

func _ready():
	#if player_count == 1:
		#_player2statscont.visible = false

##	setup player 1
	set_health_init(_playerhp, player.health, player.max_health)
	current_player_mp = player.mp
	set_mp_init(_playermp, player.mp, player.max_mp)
	playerDict_1["res"] = player
	playerDict_1["live"] = playerStats1
	playerDict_1["txt"] = $Player_1
	playerDict_1["cont"] = $Panel_Menu/VBoxContainer/PlayerContainer1
	playerDict_1["live"]["hp"] = player.health
	playerDict_1["live"]["mp"] = player.mp
	playerDict_1["cont"].get_node("Name").text = playerDict_1["res"]._name
	
##	load player_monster 1
	if len(inv.itemInventory.monsterlist) > 0:
		playerDict[2] = playerDict_2
		playerDict_2["res"] = inv.itemInventory.monsterlist[0]._monster
		playerDict_2["live"] = inv.itemInventory.monsterlist[0].stats
		playerDict_2["txt"] = $soulContainer1/SoulText
		playerDict_2["cont"] = $Panel_Menu/VBoxContainer/PlayerContainer2
		playerDict_2["live"]["hp"] = inv.itemInventory.monsterlist[0].stats["hp"]
		playerDict_2["live"]["mp"] = inv.itemInventory.monsterlist[0].stats["mp"]
		playerDict_2["cont"].get_node("Name").text = playerDict_2["res"]._name
		playerDict_2["txt"].texture = 		playerDict_2["res"].texture
		if playerDict_2["res"].battle_scale_vec < Vector2(1,1):
			playerDict_2["cont"].size = playerDict_2["cont"].size * playerDict_2["res"].battle_scale_vec
		set_health_init(playerDict_2["cont"].get_node("PlayerHP"), playerDict_2["live"]["hp"], playerDict_2["res"].max_health)
		
		
	else:
		$Panel_Menu/VBoxContainer/PlayerContainer2.visible = false
		$soulContainer1.visible = false
	
	if len(inv.itemInventory.monsterlist) <= 1:
		_player3statscont.visible = false
		_player4statscont.visible = false
		
	
##	load enemy resource from encounter -- TURN OFF LOAD TO TEST EXPORT RESOURCE
	enemy 	= load(player.enemy_encounter)
	AudioPlayer.play_music_level(enemy.music)
	enemyDict_1["res"] = enemy
	enemyDict_1["cont"] = _enemycont1
	enemyDict_1["live"] = enemyStats1
	
##	roll for groupsize
	e_groupsize = rng.randi_range(enemy.min_group_size, enemy.max_group_size)
##	safety net starting player
	if player.lvl < 3 and e_groupsize > 2:
		e_groupsize = 2
	if player.lvl < 6 and e_groupsize > 3:
		e_groupsize = 3
		
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
		enemyDict[en]["live"]["hp"] = enemyDict[en]["res"].health
		enemyDict[en]["live"]["dmg"] = enemyDict[en]["res"].damage
		if enemyDict[en]["res"].lvl > 1:
			calc_lvl = enemyDict_1["res"].lvl - 1
			enemyDict[en]["live"]["hp"] = enemyDict[en]["live"]["hp"] * calc_lvl * enemyDict[en]["res"]._class.hp_mult * 1.08
			enemyDict[en]["live"]["dmg"] = enemyDict[en]["live"]["dmg"] * calc_lvl * enemyDict[en]["res"]._class.dmg_mult * 1.08
		set_health_init(enemyDict[en]["cont"].get_node("EnemyHP"), enemyDict[en]["live"]["hp"], enemyDict[en]["live"]["hp"])
		enemyDict[en]["cont"].get_node("AspectContainer").get_node("EnemyText").texture = enemyDict[en]["res"].texture
		enemyDict[en]["cont"].get_node("Label").text = "lvl: %d %s" % [enemyDict[en]["res"].lvl, enemyDict[en]["res"]._name]
		enemyDict[en]["cont"].get_node("Select").modulate.a = 0
		if enemyDict[en]["res"].battle_scale_vec < Vector2(1,1):
			enemyDict[en]["cont"].size = enemyDict[en]["cont"].size * enemyDict[en]["res"].battle_scale_vec
			enemyDict[en]["cont"].position.x = enemyDict[en]["cont"].position.x + 50
		enemyDict[en]["cont"].add_theme_constant_override("separation", enemyDict[en]["res"].battle_y_sep)
	
	_actionmenufoc.grab_focus()

signal pressedSomething

func _input(event):
	if Input.is_anything_pressed():
		pressedSomething.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
	
func enemy_turn():
	for e in enemyDict:
		if enemyDict[e]["res"].can_chill == true and rng.randi_range(1, 100) <= 9:
			combat_log("%s is chillin'" % (enemyDict[e]["res"]._name))
			$AnimationPlayer.play("enemy_chillin")
			await $AnimationPlayer.animation_finished
		else:
			x = rng.randi_range(1, len(playerDict))
			var players_array = playerDict.keys()
			y = players_array[x - 1]
			dealt_dmg = round(rng.randf_range(0.8, 1.2) * enemyDict[e]["res"].damage)
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
			playerDict[y]["live"]["hp"] = (playerDict[y]["live"]["hp"] - dealt_dmg)
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
	try = 0
	for players in playerDict:
		if playerDict[players]["live"].has("affl"):
			combat_log("%s is %s" % [playerDict[y]["res"]._name, playerDict[players]["live"]["affl"]])
			if playerDict[players]["live"]["affl"] == "burning":
				dealt_dmg = 3
				set_health(
					playerDict[players]["cont"].get_node("PlayerHP"), 
					playerDict[players]["live"]["hp"], 
					playerDict[players]["res"].max_health)
				playerDict[y]["live"]["hp"] = (playerDict[y]["live"]["hp"] - dealt_dmg)
				playerDict[y]["res"].health = playerDict[y]["live"]["hp"]
				if rng.randi_range(0,100) > 40:
					playerDict[players]["live"].erase("affl")
					combat_log("%s stopped burning" % [playerDict[y]["res"]._name])
					
	_actionmenu.visible = true
	_actionmenufoc.grab_focus()

#func_ player_turn
#moet gaan bepalen wie er aan de beurt is (eerst gewoon chronologisch?)
#moet daarop in ieder geval magic/ability menu gaan aanpassen
#indicator voor wiens turn
#moet doorgeven wie aanvalt 
#of monster autoattack??????????	

func _on_attack_pressed():
	_actionmenu.visible = false
	next_phase = 0
	x = 0
	_await_selection()

func _await_selection():
	enemyCount = enemyDict.keys()
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
	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_right"):
		selected_enemy_ind.modulate.a = 0
		if x == max_x:
			x = 0
		else:
			x += 1
		selected_enemy_ind = enemyDict[enemyCount[x]]["cont"].get_node("Select")
		selected_enemy_ind.modulate.a = 1
		_await_selection()
	elif Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_left"):
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
		y = enemyCount[x]
		_selector_tween.kill()
		if next_phase == 0:
			_attack_phase_1()
		elif next_phase == 1:
			use_item_2()
	elif Input.is_action_pressed("ui_cancel"):
		selected_enemy_ind.modulate.a = 0
		_selector_tween.kill()
		_actionmenu.visible = true
		_actionmenufoc.grab_focus()
	else:
		_await_selection()

func _attack_phase_1():
	var curEnemyCont = enemyDict[y]["cont"]
	var pos = _playertexture.position
	dealt_dmg = round(rng.randf_range(0.85, 1.15) * player.damage)
	await combat_log("You attack %s!" % [enemyDict[y]["res"]._name])
	var tween = get_tree().create_tween()
	tween.tween_property(_playertexture, "position", Vector2(pos[0] -10, pos[1]), 0.5)
	tween.tween_property(_playertexture, "position", Vector2(pos[0] + 20, pos[1]),0.15)
	tween.tween_property(_playertexture, "position", Vector2(pos[0], pos[1]),0.5)
	await get_tree().create_timer(0.75).timeout
	fx.get_node("hitAnimate").position = curEnemyCont.position + (curEnemyCont.size / 2)
	fx.get_node("hitAnimate").play('slash')
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
		set_mp(_playermp, mp_cost, player.max_mp)
		player.mp = current_player_mp
		_actionmenu.visible = false
		var m_pos = _fireballAnimate.position
		dealt_dmg = player.magicdmg
		await combat_log("You use FIREBALL on %s!" % [enemy._name])
		var tween = get_tree().create_tween()
		tween.tween_property(_fireballAnimate, "modulate:a", 1,0.3)
		tween.tween_property(_fireballAnimate, "position", Vector2(m_pos[0] +350, m_pos[1]), 0.3)
		tween.tween_property(_fireballAnimate, "modulate:a", 0,0.05)	
		tween.tween_property(_fireballAnimate, "position", Vector2(m_pos[0], m_pos[1]), 0.1)
		await tween.finished
		_attack_phase_2()	
	
func _attack_phase_2():
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
		await(enemy_died())
	if enemyDict.is_empty():
		sceneManager.goto_scene(sceneManager.last_scene)
	enemy_turn()


func enemy_died():
	var tween = get_tree().create_tween()
	tween.tween_property(enemyDict[y]["cont"], "modulate:a", 0,  0.5)
	await (combat_log("%s died" % (enemyDict[y]["res"]._name)))
	for p in playerDict:
		playerDict[p]["res"].xp = playerDict[p]["res"].xp + enemyDict[y]["res"].xp
		if playerDict[p]["res"].xp >= playerDict[p]["res"].max_xp:
			playerDict[p]["res"].level_up()
			playerDict[p]["live"]["hp"] = playerDict[p]["live"]["hp"] + playerDict[p]["res"].hp_grow
			set_health_init(playerDict[p]["cont"].get_node("PlayerHP"), playerDict[p]["live"]["hp"], playerDict[p]["res"].max_health)
			await(combat_log("Level increased to %d" % [playerDict[p]["res"].lvl]))
			await get_tree().create_timer(0.7).timeout
			await(combat_log("Max HP increased by %d!" % [playerDict[p]["res"].hp_grow]))
			await get_tree().create_timer(0.7).timeout
			await(combat_log("Attack Power increased by %d!" % [playerDict[p]["res"].dmg_grow]))
			await get_tree().create_timer(0.7).timeout
			playerDict[p]["res"].hp_grow = 0
			playerDict[p]["res"].dmg_grow = 0
		playerDict[p]["res"].health = playerDict[p]["live"]["hp"]
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


func _on_item_pressed() -> void:
	_actionmenu.visible = false
	var itemInvSc = preload("res://Global/inventory_manager.tscn").instantiate()
	add_child(itemInvSc)
	itemInvSc._mode = "battle"
	
func use_item(t) -> void:
	used_item = t
	if used_item.isTargetSelf == false:
		next_phase = 1
		pressedSomething.emit()
		await get_tree().create_timer(0.03).timeout
		x = 0
		_await_selection()
		get_node("InventScene").queue_free()
		
		
		
		
	
func use_item_2():
	await(combat_log("
	You use %s on %s" % [used_item._name, enemyDict[y]["res"]._name]))
	if used_item.effects["Capture"]:
		fx.get_node("hitAnimate").position = enemyDict[y]["cont"].position + (enemyDict[y]["cont"].size / 2)
		fx.get_node("hitAnimate").z_index = -1
		fx.get_node("hitAnimate").play('slash')
		if (used_item.effects["Capture"] * 10 - (enemyDict[y]["res"].lvl * 5)) - (enemyDict[y]["live"]["hp"] / enemyDict[y]["res"].health)  >	rng.randi_range(1,100):
			await(combat_log("capturing..."))
			await(combat_log("............................................ Succes!"))
			var loadslot = monSlot.new()
			inv.itemInventory.monsterlist.append(loadslot)
			var capturedmonster = inv.itemInventory.monsterlist[len(inv.itemInventory.monsterlist) - 1]
			capturedmonster._monster = enemyDict[y]["res"].duplicate()
			capturedmonster.stats["hp"] = enemyDict[y]["live"]["hp"]
			capturedmonster._monster.xp = 0
			#inv.itemInventory.monsterlist[len(inv.itemInventory.monsterlist) - 1].stats["mp"] = enemyDict[y]["live"]["mp"]
			print("Captured level %d %s!" % [capturedmonster._monster.lvl, capturedmonster._monster._name])
			if capturedmonster._monster.lvl > 1:
				for i in (capturedmonster._monster.lvl - 1):
					capturedmonster._monster.max_xp = round(capturedmonster._monster.max_xp * 1.3)
			enemyDict[y]["cont"].visible = false
			enemyDict[y]["res"].lvl = 1
			enemyDict.erase(y)
			if enemyDict.is_empty():
				sceneManager.goto_scene(sceneManager.last_scene)
			enemy_turn()
			
		else:
			await(combat_log("capturing..."))
			await(combat_log("............................................ Failed..."))
			enemy_turn()
		fx.get_node("hitAnimate").z_index = 1
			
			
		
	
	
		

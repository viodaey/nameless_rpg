extends Control
@onready var dia = [$dia_1, $dia_2, $dia_3, $dia_4]
@onready var dia_label = [$dia_1/MarginContainer/txt, $dia_1/MarginContainer/txt, $dia_3/MarginContainer/txt, $dia_4/MarginContainer/txt]
@onready var dia_decision = $dia_decision
@onready var decisionChoices = [
	$dia_decision/MarginContainer/VBoxContainer/Option1,
	$dia_decision/MarginContainer/VBoxContainer/Option2,
	$dia_decision/MarginContainer/VBoxContainer/Option3
]
@onready var color = {
	"pink": load("res://textures/UI/menu_ui_pink_100.png"),
	"blue": load("res://textures/UI/menu_ui_pixieblue_100.png"),
	"purple": load("res://textures/UI/menu_ui_purp_100.png"),
	"green": load("res://textures/UI/menu_ui_green_100.png"),
	"black": load("res://textures/UI/tt_texture.png") }
@onready var font = {
	"regular": load("res://Global/ui_regular.tres"),
	"bold": load("res://Global/ui_heading.tres")
}
var decision: int
signal madeDecision
signal anythingPressed

func set_color(diaNum, diaColor):
	dia[diaNum].texture = color[diaColor]
	
func set_text(diaNum, text, wait: int = 0, waitforpress: bool = false, retain: bool = false):
	dia[diaNum].visible = true
	var visible_characters = 0
	dia_label[diaNum].visible_characters = visible_characters
	dia_label[diaNum].text = text
	for i in text: 
		visible_characters = (visible_characters + 1)
		dia_label[diaNum].visible_characters = visible_characters
		await(get_tree().create_timer(0.05).timeout)
	await get_tree().create_timer(wait).timeout
	if waitforpress:
		await anythingPressed
	if not retain:
		dia[diaNum].visible = false

func set_font(diaNum, fontStr):
	dia_label[diaNum].label_settings = font[fontStr]
	
func decide(choices: Array):
	dia_decision.visible = true
	for i in len(choices):
		decisionChoices[i].visible = true
	for i in len(choices):
		decisionChoices[i].text = choices[i]
	#dia_decision.size = dia_decision.get_child(0).size * dia_decision.get_child(0).scale
	decisionChoices[0].grab_focus()
	await madeDecision
	for i in len(choices):
		decisionChoices[i].visible = true
	dia_decision.visible = false
	return decision


func _ready() -> void: ##TESTING
	for dianum in len(dia):
		dia[dianum].visible = false
	#var choose = ["Bla","Blabla"]
	#var answer 
	#answer = await decide(choose)
	#print("I CHOSE %d" %answer)
		
func _on_option_1_pressed() -> void:
	decision = 1
	madeDecision.emit()

func _on_option_2_pressed() -> void:
	decision = 2
	madeDecision.emit()

func _on_option_3_pressed() -> void:
	decision = 3
	madeDecision.emit()

func _input(event: InputEvent) -> void:
	anythingPressed.emit()

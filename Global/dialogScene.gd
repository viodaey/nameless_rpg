extends Control
@onready var dia = [$dia_1, $dia_2, $dia_3, $dia_4, $textInput]
@onready var dia_label = [$dia_1/MarginContainer/txt, $dia_1/MarginContainer/txt, $dia_3/MarginContainer/txt, $dia_4/MarginContainer/txt, $textInput/MarginContainer/VBoxContainer/label]
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
	"green": load("res://textures/UI/dialog_texture-green.png"),
	"black": load("res://textures/UI/tt_texture.png") }
@onready var font = {
	"regular": load("res://Global/ui_regular.tres"),
	"bold": load("res://Global/ui_heading.tres")
}
@onready var inputField = $textInput/MarginContainer/VBoxContainer/LineEdit
var sizes: Dictionary [String, Vector2] = {
	"small": Vector2(204,88),
	"regular": Vector2(352,112),
	"long": Vector2(352,224),
	"loot": Vector2(1500,99)
	}

var decision: int
var text_submitted: String

signal madeDecision
signal anythingPressed
signal text_submit_signal

func request_textinput(label, sampletext: String = "BARBIEGIRL"):
	dia[4].visible = true
	dia_label[4].text = label
	inputField.placeholder_text = sampletext
	$textInput/MarginContainer/VBoxContainer/LineEdit.grab_focus()
	await text_submit_signal
	dia[4].visible = false
	return text_submitted

func set_diasize(diaNum, pickSize: String, custom: Vector2 = Vector2(0,0)):
	var diaSize: Vector2
	if pickSize == "custom":
		diaSize = custom
	else:
		diaSize = sizes[pickSize]
	dia[diaNum].size = diaSize

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
		await(get_tree().create_timer(0.04).timeout)
	await get_tree().create_timer(wait).timeout
	if waitforpress:
		await anythingPressed
	if not retain:
		dia[diaNum].visible = false

func set_center_offset(diaNum, x: float = 0, y: float = 0):
	var viewport = get_viewport_rect()
	var center_view: Vector2 = (viewport.size / 2) - (dia[diaNum].size / 2)
	var offset_x = (center_view.x / 2) + ((center_view.x / 2) * x)
	var offset_y = (center_view.y / 2) + ((center_view.y / 2) * y)
	dia[diaNum].position = Vector2(offset_x, offset_y)

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
	#set_center_offset(0,0.75, 0.75) 
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

func _input(_event: InputEvent) -> void:
	anythingPressed.emit()


func _on_line_edit_text_submitted(new_text: String) -> void:
	text_submitted = new_text
	text_submit_signal.emit()

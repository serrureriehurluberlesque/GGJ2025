extends Control

signal finished

var prompt_text = ""
var duration_prompt = 5
var ingredients = {}

var personnage
var background
var background2
var frontground
var prompt
var composition
var verificator
var redo_or_next_btn


var animationplayer

func _ready() -> void:
	personnage = $Personnage
	background = $Background
	frontground = $Frontground
	background2 = $Background2
	prompt = $Prompt
	verificator = $Verificator
	composition = $Composition
	
	animationplayer = $AnimationPlayer
	
	redo_or_next_btn = $Verificator/RedoOrNext
	
	composition.connect("validate", init_verificator)
	#redo_btn.connect("pressed", redo)
	#next_btn.connect("pressed", next)

func reset_all():
	composition.hide()
	verificator.hide()
	prompt.hide()
	personnage.hide()
	verificator.hide()
	
	personnage.modulate = Color(1, 1, 1)
	background.modulate = Color(1, 1, 1)
	frontground.modulate = Color(1, 1, 1)
	background2.modulate = Color(1, 1, 1)
	redo_or_next_btn.modulate = Color(1, 1, 1)
	
	prompt_text = ""
	ingredients = {}
	
	#redo_btn.set_disabled(false)
	#next_btn.set_disabled(false)
	

func init_n_start(ingredients_list, i, p, dp, personnage_name, init_p):
	reset_all()
	ingredients = i
	prompt_text = p
	duration_prompt = dp
	composition.init_toppings(ingredients_list)
	if init_p:
		init_personnage(personnage_name)
	else:
		personnage.show()
		init_prompt()

func init_personnage(personnage_name):
	personnage.set_texture(load("res://assets/" + personnage_name + ".png"))
	personnage.show()
	animationplayer.play("personnage_in")

func init_prompt():
	%PromptText.text = prompt_text
	prompt.show()
	
	await get_tree().create_timer(duration_prompt).timeout
	
	init_composition()

func init_composition():
	composition.show()

func init_verificator(response):
	
	var r = {}
	r["tea"] = "hanamaru" if response["tea"] == ingredients[0] else "batsu"
	r["syrup"] = "hanamaru" if response["syrup"] == ingredients[1] else "batsu"
	r["bubble"] = "hanamaru" if response["bubble"] == ingredients[2] else "batsu"
	var hanamaru = r["tea"] == "hanamaru" and r["syrup"] == "hanamaru" and r["bubble"] == "hanamaru"
	
	personnage.modulate = Color(0.5, 0.5, 0.5)
	background.modulate = Color(0.5, 0.5, 0.5)
	frontground.modulate = Color(0.5, 0.5, 0.5)
	background2.modulate = Color(0.5, 0.5, 0.5)
	
	prompt.hide()
	composition.hide()
	
	for n in ["tea", "syrup", "bubble"]:
		verificator.get_node(n).set_texture(load("res://assets/" + r[n] + ".png"))
		verificator.get_node(n).modulate = Color(1, 1, 1, 0)
		verificator.get_node("Verre_" + n).set_texture(load("res://assets/toppings/" + response[n] + ".png"))
		
		verificator.get_node("Sound_" + n).set_stream(load("res://assets/sounds/ding_" + r[n] + ".wav"))
	
	if hanamaru:
		#redo_btn.set_disabled(true)
		redo_or_next_btn.connect("pressed", next)
		%ButtonText.text = "Suivant"
		$Jingle.stream = load("res://assets/sounds/Yay.wav")
	
	else:
		#next_btn.set_disabled(true)
		redo_or_next_btn.connect("pressed", redo)
		%ButtonText.text = "Ré-essayer"
		$Jingle.stream = load("res://assets/sounds/cringe.wav")
	
	redo_or_next_btn.modulate = Color(1, 1, 1, 0)
	
	verificator.show()
	animationplayer.play("validation")

func redo():
	finished.emit(false)
	redo_or_next_btn.pressed.disconnect(redo)

func next():
	finished.emit(true)
	redo_or_next_btn.pressed.disconnect(next)

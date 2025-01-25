extends Control

signal finished

var prompt_text = ""
var ingredients = {}

var personnage
var background
var frontground
var prompt
var composition
var verificator
var redo_btn
var next_btn

var animationplayer

func _ready() -> void:
	personnage = $Personnage
	background = $Background
	frontground = $Frontground
	prompt = $Prompt
	verificator = $Verificator
	composition = $Composition
	
	animationplayer = $AnimationPlayer
	
	redo_btn = $Verificator/Redo
	next_btn = $Verificator/Next
	
	redo_btn.connect("pressed", redo)
	next_btn.connect("pressed", next)

func reset_all():
	composition.hide()
	verificator.hide()
	prompt.hide()
	personnage.hide()
	verificator.hide()
	
	personnage.modulate = Color(1, 1, 1)
	background.modulate = Color(1, 1, 1)
	frontground.modulate = Color(1, 1, 1)
	redo_btn.modulate = Color(1, 1, 1)
	next_btn.modulate = Color(1, 1, 1)
	
	prompt_text = ""
	ingredients = {}
	
	redo_btn.set_disabled(false)
	next_btn.set_disabled(false)
	

func init_n_start(ingredients_list, i, p, personnage_name, init_p):
	reset_all()
	ingredients = i
	prompt_text = p
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
	prompt.get_node("RichTextLabel").text = prompt_text
	prompt.show()
	animationplayer.play("prompt_in")

func init_composition():
	composition.connect("validate", init_verificator)
	composition.show()

func init_verificator(response):
	
	var r = {}
	r["Tea"] = "hanamaru" if response["tea"] == ingredients[0] else "batsu"
	r["Syrup"] = "hanamaru" if response["syrup"] == ingredients[1] else "batsu"
	r["Bubble"] = "hanamaru" if response["bubble"] == ingredients[2] else "batsu"
	var hanamaru = r["Tea"] == "hanamaru" and r["Syrup"] == "hanamaru" and r["Bubble"] == "hanamaru"
	
	personnage.modulate = Color(0.5, 0.5, 0.5)
	background.modulate = Color(0.5, 0.5, 0.5)
	frontground.modulate = Color(0.5, 0.5, 0.5)
	
	prompt.hide()
	composition.hide()
	
	for n in ["Tea", "Syrup", "Bubble"]:
		verificator.get_node(n).set_texture(load("res://assets/" + r[n] + ".png"))
	
	if hanamaru:
		redo_btn.set_disabled(true)
		redo_btn.modulate = Color(0.5, 0.5, 0.5)
	else:
		next_btn.set_disabled(true)
		next_btn.modulate = Color(0.5, 0.5, 0.5)
	
	verificator.show()

func redo():
	finished.emit(false)

func next():
	finished.emit(true)

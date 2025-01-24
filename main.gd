extends Control

var prompt_text = ""
var ingredients = {}
var ingredients_list = {}

var personnage
var prompt
var composition
var verificator

var animationplayer

func _ready() -> void:
	# Faut load ingredients_list
	personnage = $AspectRatioContainer/Background/Personnage
	prompt = $AspectRatioContainer/Background/Prompt
	verificator = $AspectRatioContainer/Background/Verificator
	composition = $Composition
	
	animationplayer = $AnimationPlayer
	
	
	reset_all()

func reset_all():
	composition.hide()
	verificator.hide()
	prompt.hide()
	personnage.hide()
	
	prompt_text = ""
	ingredients = {}
	ingredients_list = {}
	
	init_personnage()
	
func compute_ingredient(p):
	return {"tee": "green", "sirup": "hibiscus", "bubbles": "water"}

func init_personnage():
	personnage.show()
	animationplayer.play("personnage_in")

func init_prompt():
	prompt_text = "Le jeu"
	ingredients = compute_ingredient(prompt_text)
	
	prompt.show()
	animationplayer.play("prompt_in")

func init_composition():
	print(composition)
	composition.connect("validate", init_verificator)
	composition.show()

func init_verificator(response):
	print(response)
	print(ingredients)
	prompt.hide()
	composition.hide()
	verificator.show()

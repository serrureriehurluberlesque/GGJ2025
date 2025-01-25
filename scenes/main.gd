extends Control

var prompt_text = ""
var ingredients = {}

var personnage
var prompt
var composition
var verificator

var animationplayer

func _ready() -> void:
	personnage = $Personnage
	prompt = $Prompt
	verificator = $Verificator
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
	

func init_n_start(ingredients_list, i, p, personnage_name):
	ingredients = i
	prompt_text = p
	composition.init_toppings(ingredients_list)
	init_personnage(personnage_name)

func init_personnage(personnage_name):
	personnage.set_texture(load("res://assets/" + personnage_name + ".png"))
	personnage.show()
	animationplayer.play("personnage_in")

func init_prompt():
	prompt.get_node("RichTextLabel").text = prompt_text
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

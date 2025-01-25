extends Node

signal validate

#static var STEPS: Array = ["tea", "syrup", "bubble"]
var step_id: int = 0

static var POSSIBLE_TEAS: Array = [
	{"key": "green", "title": "Green Tea", "descr": "Blabla green"},
	{"key": "black", "title": "Black Tea", "descr": "Blabla black"},
	{"key": "mate", "title": "Maté", "descr": "Blabla maté"},
]
static var POSSIBLE_SYRUPS: Array = [
	{"key": "hibiscus", "title": "Hibiscus", "descr": "Blabla"},
	{"key": "black", "title": "Black Tea", "descr": "Blabla black"},
	{"key": "mate", "title": "Maté", "descr": "Blabla maté"},
	{"key": "hibiscus", "title": "Hibiscus", "descr": "Blabla"},
	{"key": "black", "title": "Black Tea", "descr": "Blabla black"},
	{"key": "mate", "title": "Maté", "descr": "Blabla maté"},
]
static var POSSIBLE_BUBBLES: Array = [
	{"key": "tapioca", "title": "Hibiscus", "descr": "Blabla"},
	{"key": "pasteque", "title": "Black Tea", "descr": "Blabla black"},
	{"key": "cerise", "title": "Maté", "descr": "Blabla maté"},
	{"key": "fraise", "title": "Hibiscus", "descr": "Blabla"},
	{"key": "litchi", "title": "Black Tea", "descr": "Blabla black"},
	{"key": "ananas", "title": "Maté", "descr": "Blabla maté"},
	{"key": "fraise", "title": "Hibiscus", "descr": "Blabla"},
	{"key": "litchi", "title": "Black Tea", "descr": "Blabla black"},
	{"key": "ananas", "title": "Maté", "descr": "Blabla maté"},
]

@onready var title: Label = %SectionTitle

var all_toppings = []

var chosen_tea = ""
var chosen_syrup = ""
var chosen_bubble = ""

const scene_item = "res://scenes/composition/icon_item_container.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_toppings([POSSIBLE_TEAS, POSSIBLE_SYRUPS, POSSIBLE_BUBBLES])
	set_section_title()
	
func init_toppings(ingredients_list: Array) -> void:
	# Reset
	step_id = 0
	chosen_tea = ""
	chosen_syrup = ""
	chosen_bubble = ""
	$tea.visible = false
	$sirop.visible = false
	$bubbles.visible = false
	
	# Set toppings
	all_toppings = ingredients_list
	populate_list()
			
func populate_list() -> void:
	# Empty list and repopulate it
	for n in %List.get_children():
		%List.remove_child(n)
		n.queue_free()
		
	for tea in all_toppings[step_id]:
		var item = preload(scene_item).instantiate()
		item.item_title = tea["title"]
		item.item_descr = tea["descr"]
		item.key = tea["key"]
		item.connect("chosen", make_choice)
		%List.add_child(item)
		
	set_section_title()
	
func make_choice(key: String) -> void:
	print(key)
	
	if step_id == 0:
		chosen_tea = key
		$composition_player.play("add_tea")
	elif step_id == 1:
		chosen_syrup = key
		$composition_player.play("add_syrup")
	else:
		chosen_bubble = key
		$composition_player.play("add_bubbles")
	
	# Disable choices
	for n in %List.get_children():
		n.disabled = true

func prepare_next() -> void:	
	if chosen_tea and chosen_syrup and chosen_bubble:
		validate.emit({"tea": chosen_tea, "syrup": chosen_syrup, "bubble": chosen_bubble})
	else:
		step_id += 1
		
		populate_list()

func set_section_title() -> void:
	if step_id == 0:
		title.text = "Choose the tea"
	elif step_id == 1:
		title.text = "Choose the syrup"
	else:
		title.text = "Choose the toppings"

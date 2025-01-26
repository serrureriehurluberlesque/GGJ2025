extends Node

signal validate

#static var STEPS: Array = ["tea", "syrup", "bubble"]
var step_id: int = 0

static var POSSIBLE_TEAS: Array = [
	{"key": "green", "title": "Green Tea", "descr": "Blabla green"},
	{"key": "black", "title": "Black Tea", "descr": "Blabla black"},
	{"key": "mate", "title": "Maté", "descr": "Fruit du framboisier. Facilite le transit intestinal."},
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
	{"key": "litchi", "title": "Litchi", "descr": "Blabla black"},
	{"key": "ananas", "title": "Ananas", "descr": "Blabla maté"},
]

@onready var title: Label = %SectionTitle

var all_toppings = []

var chosen_tea = ""
var chosen_syrup = ""
var chosen_bubble = ""
var selected_key = ""

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
	$SectionRect.texture = load("res://assets/bouton_craft_1_tea.png")
	$DescrBubble/Submit.visible = false
	
	# Set toppings
	all_toppings = ingredients_list
	populate_list()
			
func populate_list() -> void:
	# Empty list and repopulate it
	for n in %List.get_children():
		%List.remove_child(n)
		n.queue_free()
		
	for elem in all_toppings[step_id]:
		var item = preload(scene_item).instantiate()
		item.item_title = elem["title"]
		item.item_descr = elem["descr"]
		item.key = elem["key"]
		item.item_icon = load("res://assets/icon/" + elem["key"] + ".png")
		item.connect("chosen", show_description)
		%List.add_child(item)
		
	set_section_title()
	
func show_description(description: String, key: String) -> void:
	$DescrBubble.visible = true
	%Description.text = description
	selected_key = key
	# Make choices look disabled
	for n in %List.get_children():
		if n.key != key:
			n.texture_normal = n.texture_disabled
		else:
			n.texture_normal = load("res://assets/bouton_craft_2.png")
			
	$DescrBubble/Submit.visible = true
	
func make_choice(key: String) -> void:
	$DescrBubble.visible = false
	
	if step_id == 0:
		chosen_tea = key
		$tea.texture = load("res://assets/toppings/" + key + ".png")
		$composition_player.play("add_tea")
	elif step_id == 1:
		chosen_syrup = key
		$sirop.texture = load("res://assets/toppings/" + key + ".png")
		$composition_player.play("add_syrup")
	else:
		chosen_bubble = key
		$bubbles.texture = load("res://assets/toppings/" + key + ".png")
		$RainningTapioca/GPUParticles2D.texture = load("res://assets/bubble/" + key + ".png")
		$composition_player.play("add_bubbles")
	
	# Disable choices
	for n in %List.get_children():
		if n.key != key:
			n.disabled = true
		else:
			n.texture_normal = n.texture_hover

func prepare_next() -> void:	
	if chosen_tea and chosen_syrup and chosen_bubble:
		validate.emit({"tea": chosen_tea, "syrup": chosen_syrup, "bubble": chosen_bubble})
	else:
		step_id += 1
		
		populate_list()

func set_section_title() -> void:
	if step_id == 0:
		title.text = "Thé"
	elif step_id == 1:
		title.text = "Sirop"
		$SectionRect.texture = load("res://assets/bouton_craft_1_sirup.png")
	else:
		title.text = "Boba"
		$SectionRect.texture = load("res://assets/bouton_craft_1_bubble.png")


func _on_submit_pressed() -> void:
	$DescrBubble/Submit/SubmitSound.play()
	if selected_key:
		make_choice(selected_key)
		

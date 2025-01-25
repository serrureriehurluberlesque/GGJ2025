extends Control

var main_scn
var tea
var toppings_list = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_toppings()
	
	main_scn = load("res://scenes/main.tscn")
	
	new_tapioc()

func load_toppings():
	var file = "res://assets/toppings.json"
	var json_as_text = FileAccess.get_file_as_string(file)
	var json_as_dict = JSON.parse_string(json_as_text)
	toppings_list = json_as_dict

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func new_tapioc():
	if tea:
		tea.free()
	
	var p = choose_prompt()
	var i = compute_ingredient(p)
	
	tea = main_scn.instantiate()
	add_child(tea)
	tea.init_n_start(toppings_list, compute_ingredient(p), p, "client_1")

func choose_prompt():
	return "

[center]Bla bla je veux un thé rose avec un peu de café et aussi une petite coupelle de drogue[/center]
"

func compute_ingredient(p):
	var i = []
	for ts in toppings_list:
		i.append(ts[0])
	return i

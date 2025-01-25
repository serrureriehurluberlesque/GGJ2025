extends Control

var main_scn
var tea
var toppings_list = {}

var prompts = []
var p 
var c
var i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_toppings()
	load_prompt()
	
	main_scn = load("res://scenes/main.tscn")
	
	tea = main_scn.instantiate()
	add_child(tea)
	tea.connect("finished", next)
	
	c = randi() % 3 + 1
	
	new_tapioc()

func load_toppings():
	var file = "res://assets/toppings.json"
	var json_as_text = FileAccess.get_file_as_string(file)
	var json_as_dict = JSON.parse_string(json_as_text)
	toppings_list = json_as_dict

func load_prompt():
	var file = "res://assets/prompt.json"
	var json_as_text = FileAccess.get_file_as_string(file)
	var json_as_dict = JSON.parse_string(json_as_text)
	prompts = json_as_dict
	for pr in prompts:
		for t in pr["toppings"]:
			var isok = false
			for tls in toppings_list:
				for tl in tls:
					isok = isok or t == tl["key"]
			if not isok:
				print("missing toppings for prompt")
				print(pr)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func new_tapioc():	
	p = choose_prompt()
	c = next_client()
	tea.init_n_start(toppings_list, p["toppings"], p["prompt_text"], "client_" + str(c))

func next_client():
	var tmp = (c + 1) % 3
	if tmp == 0:
		tmp = 3
	return tmp

func redo_tapioc():
	tea.init_n_start(toppings_list, p["toppings"], p["prompt_text"], "client_" + str(c))

func choose_prompt():
	return prompts.pop_front()

func next(hanamaru):
	if hanamaru:
		print("gg")
		new_tapioc()
	else:
		print("nab")
		redo_tapioc()

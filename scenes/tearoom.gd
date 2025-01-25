extends Control

var main_scn
var tea
var toppings_list = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_scn = load("res://scenes/main.tscn")
	# load toppings_list
	toppings_list = [[{"key": "green", "name": "Green Tea", "description": "It is a tea, sometimes it's green"}], [{"key": "green2", "name": "Green Tea2", "description": "It is a tea, sometimes it's green2"}], [{"key": "green3", "name": "Green Tea3", "description": "It is a tea, sometimes it's green3"}]]
	new_tapioc()


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

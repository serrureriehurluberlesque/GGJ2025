extends Control

var main_scn
var tea
var toppings_list = {}

var prompts = []
var p 
var c
var i
var difficulty_level = 1
var is_endless = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_toppings()
	load_prompt()
	
	main_scn = load("res://scenes/main.tscn")
	
	tea = main_scn.instantiate()
	add_child(tea)
	move_child(tea, 0)
	tea.connect("finished", next)
	$Control/Start.connect("pressed", start)
	$Control/SStart.connect("pressed", sstart)
	$Control/End.connect("pressed", end)
	$Control/End2.connect("pressed", endless)
	$Control/Black.connect("pressed", star)
	$Control/VideoStreamPlayer.connect("finished", star)
	
	c = randi() % 5
	
	

func load_toppings():
	var file = "res://assets/toppings.json"
	var json_as_text = FileAccess.get_file_as_string(file)
	var json_as_dict = JSON.parse_string(json_as_text)
	
	toppings_list = json_as_dict
	for ts in toppings_list:
		for t in ts:
			t["color"] = Color(t["color"])

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
	prompts.shuffle()
	prompts.shuffle()

func new_tapioc():	
	p = choose_prompt()
	c = next_client()
	if p:
		tea.init_n_start(toppings_list, p["toppings"], p["prompt_text"], p["duration_prompt"], "client_" + str(c), true)

func next_client():
	return (c + 1) % 5

func redo_tapioc():
	tea.init_n_start(toppings_list, p["toppings"], p["prompt_text"], p["duration_prompt"], "client_" + str(c), false)

func choose_prompt():
	var pr
	if is_endless:
		if prompts == []:
			endendless()
			return
		pr = prompts.pop_front()
		while pr["dificulty"] >= 1:
			if prompts == []:
				endendless()
				return
			pr = prompts.pop_front()
		return pr
	else:
		var j = 0
		var indice = -1
		for prompt in prompts:
			if prompt["dificulty"] == difficulty_level:
				indice = j
			j += 1
		
		if indice == -1:
			print("missing prompt of dificulty", difficulty_level)
			return prompts.pop_front()
		else:
			pr = prompts[indice]
			prompts.remove_at(indice)
			return pr

func next(hanamaru):
	if hanamaru:
		difficulty_level += 1
		if not is_endless and difficulty_level >= 4:
			gg()
		else:
			new_tapioc()
	else:
		redo_tapioc()

func gg():
	$Control/End.show()

func start():
	$Control/Start.hide()
	new_tapioc()

func star():
	$Control/VideoStreamPlayer.hide()
	$Control/Black.hide()
	$Control/Black.queue_free()
	$Control/VideoStreamPlayer.queue_free()

func sstart():
	$Control/SStart.hide()
	$Control/VideoStreamPlayer.play()
	$AudioStreamPlayer.play()

func end():
	$Control/End2.show()

func endless():
	$Control/End2.hide()
	$Control/End.hide()
	is_endless = true
	new_tapioc()

func endendless():
	$Control/End3.show()
	$Control/GPUParticles2D.emitting = true

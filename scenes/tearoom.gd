extends Control

var main_scn
var tea
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_scn = load("res://scenes/main.tscn")
	new_tapioc()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func new_tapioc():
	if tea:
		tea.free()
		
	tea = main_scn.instantiate()
	add_child(tea)
	tea.init_n_start({}, {}, "

[center]Bla bla je veux un thé rose avec un peu de café et aussi une petite coupelle de drogue[/center]
", "client_1")

	
func compute_ingredient(p):
	return {"tee": "green", "sirup": "hibiscus", "bubbles": "water"}

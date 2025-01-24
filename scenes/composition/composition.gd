extends Node

signal validate

static var CHOSEN_TEA: String = "green_tea"
static var CHOSEN_SIRUP: String = "peach"
static var CHOSEN_BUBBLES: String = "strawberry"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	validate.emit({"tea": CHOSEN_TEA, "sirup": CHOSEN_SIRUP, "bubbles": CHOSEN_BUBBLES})

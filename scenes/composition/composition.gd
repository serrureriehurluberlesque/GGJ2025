extends Node

signal validate

static var POSSIBLE_TEAS: Array = [
	{"type": "green", "title": "Green Tea", "descr": "Blabla green"},
	{"type": "black", "title": "Black Tea", "descr": "Blabla black"},
	{"type": "green", "title": "Maté", "descr": "Blabla maté"},
]
	
static var CHOSEN_SIRUP: String = "peach"
static var CHOSEN_BUBBLES: String = "strawberry"

const scene_item = "res://scenes/composition/icon_item_container.tscn"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for tea in POSSIBLE_TEAS:
		var item = preload(scene_item).instantiate()
		item.item_title = tea["title"]
		item.item_descr = tea["descr"]
		$TypeSelection/List.add_child(item)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#func _on_button_pressed() -> void:
	#validate.emit({"tea": CHOSEN_TEA, "sirup": CHOSEN_SIRUP, "bubbles": CHOSEN_BUBBLES})

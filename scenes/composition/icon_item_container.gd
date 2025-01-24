@tool
extends HBoxContainer

@onready var icon: TextureRect = %Icon
@onready var title: Label = %Title
@onready var description: Label = %Description

@export var item_icon: Texture:
	set(value):
		item_icon = value
		_update_labels()

@export var item_title: String = "Title":
	set(value):
		item_title = value
		_update_labels()
		
@export var item_descr: String = "Description":
	set(value):
		item_descr = value
		_update_labels()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_labels()

func _process(delta: float) -> void:
	_update_labels()
	
func _update_labels():
	if icon:
		icon.texture = item_icon
	if title:
		title.text = item_title
	if description:
		description.text = item_descr

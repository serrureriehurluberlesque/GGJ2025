extends TextureButton

signal chosen

@onready var icon: TextureRect = %Icon
@onready var title: Label = %Title
#@onready var description: Label = %Description
@export var key: String

@export var item_icon: Texture:
	set(value): 
		item_icon = value
		_update_labels()

@export var item_title: String = "Title":
	set(value):
		item_title = value
		_update_labels()
		
@export var item_descr: String = ""
#@export var item_descr: String = "Description":
	#set(value):
		#item_descr = value
		#_update_labels()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_labels()
	
func _update_labels():
	if icon:
		icon.texture = item_icon
	if title:
		title.text = item_title
	#if description:
		#description.text = item_descr
		#self.tooltip_text = item_descr

func _on_pressed() -> void:
	$ChoiceSound.play()
	chosen.emit(item_descr, key)


func _on_mouse_entered() -> void:
	%Icon.modulate = Color("fff1ee")
	$AnimationPlayer.play("icon_wiggle")


func _on_mouse_exited() -> void:
	%Icon.modulate = Color(1, 1, 1, 1)

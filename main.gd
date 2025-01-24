extends Control

var animationplayer

func _ready() -> void:
	animationplayer = $AnimationPlayer
	animationplayer.play("personnage_in")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

extends Obstacle


var animations := ['blue', 'green', 'orange']


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	$AnimatedSprite2D.play(animations.pick_random())

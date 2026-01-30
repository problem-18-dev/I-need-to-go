extends Obstacle


var animations := ['brown', 'pink', 'white']

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	$AnimatedSprite2D.play(animations.pick_random())

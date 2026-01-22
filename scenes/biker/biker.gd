extends Obstacle


enum Animations {BLUE, GREEN, RED}

@export var animation: Animations

var animations := ['blue', 'green', 'red']

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play(animations[animation])

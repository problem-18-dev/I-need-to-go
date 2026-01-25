class_name Obstacle
extends Area2D


@export var speed: float

var _ready_to_die := false
var _direction := Vector2.LEFT

@onready var _current_speed := speed


func _process(delta: float) -> void:
	position += _direction * _current_speed * delta


func flip() -> void:
	_direction = Vector2.RIGHT
	$AnimatedSprite2D.flip_h = true
	$VisibleOnScreenNotifier2D.position.x = -$VisibleOnScreenNotifier2D.position.x


func _on_body_entered(body: Node2D) -> void:
	body.die()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if _ready_to_die:
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if not _ready_to_die:
		_ready_to_die = true

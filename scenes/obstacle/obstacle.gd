class_name Obstacle
extends Area2D


const AUDIO_CHANCE := 0.25

@export_category("Entity")
@export var speed: float

@export_category("Audio")
@export var sound_to_play: AudioManager.SFX

var _can_die := false
var _direction := Vector2.LEFT


func _ready() -> void:
	var should_make_sound := randf() < AUDIO_CHANCE
	if should_make_sound and sound_to_play:
		AudioManager.play(sound_to_play)


func _process(delta: float) -> void:
	position += _direction * speed * delta


func flip() -> void:
	_direction = Vector2.RIGHT
	$AnimatedSprite2D.flip_h = true
	$VisibleOnScreenNotifier2D.position.x *= -1


func _on_body_entered(body: Node2D) -> void:
	body.die()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	_can_die = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if not _can_die:
		return
	
	queue_free()

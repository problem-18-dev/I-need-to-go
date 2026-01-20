extends CharacterBody2D


@export_category("Movement")
@export var move_speed := 120.0
@export var move_time := 0.5

var _direction := Vector2.ZERO


func _ready() -> void:
	$MovementTimer.wait_time = move_time


func _physics_process(_delta: float) -> void:
	_handle_movement()
	velocity = _direction * move_speed
	move_and_slide()


func die() -> void:
	print("OH NO, I DIED")


func _handle_movement() -> void:
	if not $MovementTimer.is_stopped():
		return

	if Input.is_action_just_pressed("move_up"):
		_direction = Vector2.UP
	elif Input.is_action_just_pressed("move_down"):
		_direction = Vector2.DOWN
	elif Input.is_action_just_pressed("move_left"):
		_direction = Vector2.LEFT
	elif Input.is_action_just_pressed("move_right"):
		_direction = Vector2.RIGHT

	if _direction != Vector2.ZERO:
		$MovementTimer.start()


func _on_movement_timer_timeout() -> void:
	_direction = Vector2.ZERO

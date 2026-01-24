extends CharacterBody2D


signal player_died

@export_category("Movement")
@export var move_speed := 120.0
@export var move_distance := 32.0

var _can_be_controlled := true

@onready var next_position := position


func _physics_process(delta: float) -> void:
	var direction := position.direction_to(next_position)

	# Snap target to next position if very close
	var distance_to_target := position.distance_to(next_position)
	if distance_to_target <= move_speed * delta:
		position = next_position
		$AnimatedSprite2D.play("idle")
		direction = Vector2.ZERO

	velocity = direction * move_speed
	move_and_slide()


func _unhandled_key_input(event: InputEvent) -> void:
	if not velocity.is_zero_approx() or not _can_be_controlled:
		return

	if event.is_action_pressed("move_up"):
		next_position.y -= move_distance
		$AnimatedSprite2D.play("walk_vertical")
	elif event.is_action_pressed("move_down"):
		next_position.y += move_distance
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("walk_vertical")
	elif event.is_action_pressed("move_left"):
		next_position.x -= move_distance
		$AnimatedSprite2D.play("walk_side")
		$AnimatedSprite2D.flip_h = true
	elif event.is_action_pressed("move_right"):
		next_position.x += move_distance
		$AnimatedSprite2D.play("walk_side")
		$AnimatedSprite2D.flip_h = false


func die() -> void:
	$AnimatedSprite2D.play("death")
	player_died.emit()


func move_back() -> void:
	if velocity.is_zero_approx():
		next_position.y += move_distance
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("walk_vertical")


func move_to(new_position: Vector2, cb = null) -> void:
	if velocity.is_zero_approx():
		next_position = new_position
		$AnimatedSprite2D.play("walk_vertical")
		if cb:
			cb.call()


func pee() -> void:
	_can_be_controlled = false
	$AnimatedSprite2D.play("pee")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("pee_loop")


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	die()

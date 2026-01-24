extends CharacterBody2D


@export_category("Movement")
@export var move_speed := 120.0
@export var move_distance := 32.0

@onready var next_position := position


func _physics_process(delta: float) -> void:
	var direction := position.direction_to(next_position)

	# Snap target to next position if very close
	var distance_to_target := position.distance_to(next_position)
	if distance_to_target <= move_speed * delta:
		position = next_position
		$AnimatedSprite2D.play("idle")
		direction = Vector2.ZERO

	if velocity.is_zero_approx() and (position.x < 0 or position.x > get_viewport_rect().size.x):
		die()

	velocity = direction * move_speed
	move_and_slide()


func _unhandled_key_input(event: InputEvent) -> void:
	if not velocity.is_zero_approx():
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
	print("OH NO, I DIED")


func move_back() -> void:
	if velocity.is_zero_approx():
		next_position.y += move_distance
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("walk_vertical")

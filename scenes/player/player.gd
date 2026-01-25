extends CharacterBody2D


signal died
signal got_to_urinal
signal moved

@export_category("Movement")
@export var move_speed := 120.0
@export var move_distance := 32.0

var _is_moving := false
var _reached_urinal := false

@onready var next_position := position


func _physics_process(delta: float) -> void:
	# If already in position, don't move
	if next_position == position:
		return

	# Snap target to next position if very close
	var distance_to_target := position.distance_to(next_position)
	if distance_to_target <= move_speed * delta:
		position = next_position
		$AnimatedSprite2D.play("idle")
		_is_moving = false

		if _reached_urinal:
			_pee()
		else:
			moved.emit()
		return

	_is_moving = true
	var direction := position.direction_to(next_position)
	velocity = direction * move_speed
	move_and_slide()


func _unhandled_key_input(event: InputEvent) -> void:
	if _is_moving:
		return

	if event.is_action_pressed("move_right"):
		_try_move(Vector2.RIGHT, "walk_side", false)
	elif event.is_action_pressed("move_left"):
		_try_move(Vector2.LEFT, "walk_side", true)
	elif event.is_action_pressed("move_up"):
		_try_move(Vector2.UP, "walk_vertical")
	elif event.is_action_pressed("move_down"):
		_try_move(Vector2.DOWN, "walk_vertical", true)


func start(start_position: Vector2) -> void:
	position = start_position


func die() -> void:
	_disable()
	$AnimationPlayer.play("death")
	died.emit()


func move_back() -> void:
	if not _is_moving:
		next_position.y += move_distance
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("walk_vertical")


func move_to_urinal(new_position: Vector2) -> void:
	_reached_urinal = true
	next_position = new_position
	$AnimatedSprite2D.play("walk_vertical")
	got_to_urinal.emit()


func _disable() -> void:
	set_physics_process(false)
	set_process_unhandled_key_input(false)
	$CollisionShape2D.set_deferred("disabled", true)


func _destroy() -> void:
	await $AnimatedSprite2D.animation_finished
	queue_free()


func _pee() -> void:
	_disable()
	$AnimatedSprite2D.play("pee")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("pee_loop")


func _try_move(direction: Vector2, animation: String, flip_h: bool = false) -> void:
	var raycast_name := ""
	if direction == Vector2.RIGHT:
		$RightRayCast2D.force_update_transform()
		raycast_name = "RightRayCast2D"
	elif direction == Vector2.LEFT:
		$LeftRayCast2D.force_update_transform()
		raycast_name = "LeftRayCast2D"
	elif direction == Vector2.UP:
		$TopRayCast2D.force_update_transform()
		raycast_name = "TopRayCast2D"
	elif direction == Vector2.DOWN:
		$BottomRayCast2D.force_update_transform()
		raycast_name = "BottomRayCast2D"

	if not get_node(raycast_name).is_colliding():
		next_position += direction * move_distance
		$AnimatedSprite2D.play(animation)
		$AnimatedSprite2D.flip_h = flip_h


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	die()

extends CharacterBody2D


signal died
signal got_to_urinal
signal moved

@export_category("Movement")
@export var move_speed := 120.0
@export var move_distance := 32.0

var _can_move := true
var _reached_urinal := false

@onready var animated_sprite := $AnimatedSprite2D
@onready var collision_shape := $CollisionShape2D
@onready var animation_player := $AnimationPlayer
@onready var next_position := position
@onready var raycasts := {
	Vector2.RIGHT: $RightRayCast2D,
	Vector2.LEFT: $LeftRayCast2D,
	Vector2.UP: $TopRayCast2D,
	Vector2.DOWN: $BottomRayCast2D
}


func _physics_process(delta: float) -> void:
	# If already in position, return
	if next_position.is_equal_approx(position):
		return

	# Snap target to next position if very close
	var distance_to_target := position.distance_to(next_position)
	if distance_to_target <= move_speed * delta:
		_arrive_at_target()
		return

	_move_to_target()
	move_and_slide()


func _unhandled_key_input(event: InputEvent) -> void:
	if not _can_move or _reached_urinal:
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
	animation_player.play("death")
	AudioManager.play(AudioManager.SFX.DEATH)
	died.emit()


func move_back() -> void:
	if not _can_move:
		return

	next_position.y += move_distance
	animated_sprite.flip_h = true
	animated_sprite.play("walk_vertical")


func move_to_urinal(new_position: Vector2) -> void:
	_reached_urinal = true
	next_position = new_position
	collision_shape.set_deferred("disabled", true)
	animated_sprite.play("walk_side")
	animated_sprite.flip_h = new_position.x < position.x
	got_to_urinal.emit()


func _arrive_at_target() -> void:
	position = next_position
	animated_sprite.play("idle")
	_can_move = true

	if _reached_urinal:
		_pee()
	else:
		moved.emit()


func _move_to_target() -> void:
	_can_move = false
	var direction := position.direction_to(next_position)
	velocity = direction * move_speed


func _disable() -> void:
	set_physics_process(false)
	set_process_input(false)
	collision_shape.set_deferred("disabled", true)
	_can_move = false


func _destroy() -> void:
	await animated_sprite.animation_finished
	queue_free()


func _pee() -> void:
	_disable()
	AudioManager.play(AudioManager.SFX.PEE)
	animated_sprite.play("pee")
	await animated_sprite.animation_finished
	animated_sprite.play("pee_loop")


func _try_move(direction: Vector2, animation: String, flip_h: bool = false) -> void:
	var raycast: RayCast2D = raycasts.get(direction)
	assert(raycast, "Invalid direction, raycast doesn't exist")
	
	raycast.force_update_transform()

	if not raycast.is_colliding():
		next_position += direction * move_distance
		animated_sprite.play(animation)
		animated_sprite.flip_h = flip_h
		AudioManager.play(AudioManager.SFX.MOVE)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	die()

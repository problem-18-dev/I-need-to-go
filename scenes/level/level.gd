extends Node


@export_category("Spawn")
@export var player_scene: PackedScene

@export_category("Level")
@export var next_level: Main.Scene
@export var start_time := 30.0
@export var urinals := 4

var _urinals_reached := 0
var _player: CharacterBody2D

@onready var _time_left := start_time


func _ready() -> void:
	$HUD.change_score(GameManager.score)
	_spawn_player()
	_reset_timer()


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		var paused := get_tree().paused
		if paused:
			$HUD.hide_message()
		else:
			$HUD.show_message("paused")
		get_tree().paused = not get_tree().paused


func _spawn_player() -> void:
	var player := player_scene.instantiate()
	player.start($PlayerSpawnPosition.position)
	player.died.connect(_on_player_died)
	player.got_to_urinal.connect(_on_player_got_to_urinal)
	player.moved.connect(_on_player_moved)
	_player = player
	$Game.call_deferred("add_child", player)


func _end_game() -> void:
	get_tree().call_group("obstacle_lane", "stop_spawning")
	await $HUD.show_message("game over", 5)
	GameManager.main_scene.load_scene(Main.Scene.END)


func _reset_timer() -> void:
	_time_left = start_time
	$HUD.change_timer(start_time, start_time)


func _win_level() -> void:
	$TimeLeft.stop()
	GameManager.score += floor(_time_left * 10.0)
	await $HUD.show_message("Nice!", 2)
	await $HUD.show_message("Score: " + str(GameManager.score), 3)
	GameManager.lives = GameManager.start_lives
	GameManager.main_scene.load_scene(next_level)


func _on_player_died() -> void:
	GameManager.lives -= 1
	$HUD.change_lives(GameManager.lives)
	if GameManager.lives <= 0 or GameManager.lives < urinals - _urinals_reached:
		GameManager.reset()
		await _end_game()
		return

	_reset_timer()
	_spawn_player()


func _on_player_got_to_urinal() -> void:
	_urinals_reached += 1
	GameManager.lives -= 1
	$HUD.change_lives(GameManager.lives)
	GameManager.score += 100
	$HUD.change_score(GameManager.score)

	if _urinals_reached >= urinals:
		_win_level()
		return

	_reset_timer()
	_spawn_player()


func _on_player_moved() -> void:
	GameManager.score += 10
	$HUD.change_score(GameManager.score)


func _on_time_left_timeout() -> void:
	_time_left -= 1
	$HUD.change_timer(_time_left)
	if _time_left < 0:
		_player.die()

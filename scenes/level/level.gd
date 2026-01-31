extends Node


const URINALS := 4

@export_category("Spawn")
@export var player_scene: PackedScene

@export_category("Level")
@export var next_level: Main.Scene
@export var life_time := 30.0

@export_category("Score")
@export var score_per_move := 10
@export var score_per_urinal := 100
@export var score_time_multiplier := 10

var _urinals_reached := 0
var _player: CharacterBody2D

@onready var _time_left := life_time


func _ready() -> void:
	$HUD.change_score(GameManager.score)
	_reset_timer()
	_spawn_player()


func _input(event: InputEvent) -> void:
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


func _reset_timer() -> void:
	_time_left = life_time
	$HUD.change_timer(life_time)
	

func _stop_timer() -> void:
	$TimeLeft.stop()


func _game_over() -> void:
	_stop_timer()
	get_tree().call_group("obstacle_lane", "stop_spawning")
	await $HUD.show_message("game over", 5)
	GameManager.main_scene.load_scene(Main.Scene.END)


func _win_level() -> void:
	_stop_timer()
	GameManager.score += floor(_time_left * score_time_multiplier)
	await $HUD.show_message("Nice!", 2)
	await $HUD.show_message("Score: " + str(GameManager.score), 3)
	GameManager.lives = GameManager.start_lives
	GameManager.main_scene.load_scene(next_level)
	

func _change_score(score: int) -> void:
	GameManager.score += score
	$HUD.change_score(GameManager.score)
	

func _change_lives(lives: int) -> void:
	GameManager.lives += lives
	$HUD.change_lives(GameManager.lives)


func _on_player_died() -> void:
	_change_lives(-1)
	
	var out_of_lives := GameManager.lives <= 0
	var not_enough_lives := GameManager.lives < URINALS - _urinals_reached
	if out_of_lives or not_enough_lives:
		await _game_over()
		return

	_reset_timer()
	_spawn_player()


func _on_player_got_to_urinal() -> void:
	_urinals_reached += 1
	_change_lives(-1)
	_change_score(score_per_urinal)
	

	if _urinals_reached >= URINALS:
		_win_level()
		return

	_reset_timer()
	_spawn_player()


func _on_player_moved() -> void:
	_change_score(score_per_move)


func _on_time_left_timeout() -> void:
	_time_left -= 1
	$HUD.change_timer(-1)
	
	if _time_left < 0:
		_player.die()

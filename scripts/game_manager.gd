extends Node


@export var start_lives := 9

var main_scene: Main
var lives := start_lives
var score := 0


func reset_all() -> void:
	lives = start_lives
	score = 0


func reset_lives() -> void:
	lives = start_lives
	

func reset_score() -> void:
	score = 0

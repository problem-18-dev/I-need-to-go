extends Node


@export var start_lives := 9

var main_scene: Main
var lives := start_lives
var score := 0


func reset() -> void:
	score = 0
	lives = start_lives

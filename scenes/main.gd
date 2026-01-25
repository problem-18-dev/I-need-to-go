class_name Main
extends Node

enum Scene {MAIN_MENU, INFO_MENU, LEVEL_ONE, LEVEL_TWO, LEVEL_THREE, END}

@export var first_scene := Scene.MAIN_MENU

var scenes := {
	Scene.MAIN_MENU: "res://hud/main_menu.tscn",
	Scene.INFO_MENU: "res://hud/info_menu.tscn",
	Scene.LEVEL_ONE: "res://levels/level_one.tscn",
}

var current_scene: Node


func _ready() -> void:
	GameManager.main_scene = self
	load_scene(first_scene)


func unload_scene() -> void:
	if current_scene:
		remove_child(current_scene)
		current_scene = null


func load_scene(scene: Scene) -> void:
	unload_scene()
	var new_scene: PackedScene = load(scenes[scene])
	current_scene = new_scene.instantiate()
	add_child(current_scene)

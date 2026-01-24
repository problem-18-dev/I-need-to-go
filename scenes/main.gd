class_name Main
extends Node

enum Scene {MAIN_MENU, LEVEL_ONE, LEVEL_TWO, LEVEL_THREE, END}

var scenes := {
	Scene.MAIN_MENU: "main_menu",
	Scene.LEVEL_ONE: "level_one",
}

var current_scene: Node


func _ready() -> void:
	GameManager.main_scene = self


func unload_scene() -> void:
	current_scene = null
	remove_child(current_scene)


func change_scene(scene: Scene) -> void:
	unload_scene()
	var new_scene: PackedScene = load(scenes[scene])
	current_scene = new_scene.instantiate()
	add_child(current_scene)

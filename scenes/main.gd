class_name Main
extends Node


signal scene_changed(scene: Scene)

enum Scene {SPLASH, MAIN_MENU, INFO_MENU, LEVEL_ONE, LEVEL_TWO, LEVEL_THREE, END}

@export_category("Scenes")
@export var first_scene := Scene.MAIN_MENU

@export_category("Music")
@export var db_in_game := -14.0

var scenes := {
	Scene.SPLASH: "res://hud/splash.tscn",
	Scene.MAIN_MENU: "res://hud/main_menu.tscn",
	Scene.LEVEL_ONE: "res://levels/level_one.tscn",
	Scene.LEVEL_TWO: "res://levels/level_two.tscn",
	Scene.LEVEL_THREE: "res://levels/level_three.tscn",
	Scene.END: "res://hud/end_menu.tscn",
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
	scene_changed.emit(scene)


func set_bus_db(bus: String, db: float) -> void:
	var bus_index := AudioServer.get_bus_index(bus)
	AudioServer.set_bus_volume_db(bus_index, db)


func _on_scene_changed(scene: Main.Scene) -> void:
	match scene:
		Main.Scene.MAIN_MENU, Main.Scene.END:
			$MusicPlayer.volume_db = 0
		Main.Scene.SPLASH:
			$MusicPlayer.stop()
		_:
			$MusicPlayer.volume_db = db_in_game
	
	if scene != Main.Scene.SPLASH and not $MusicPlayer.playing:
		$MusicPlayer.play()

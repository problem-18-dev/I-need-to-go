extends Node


func _on_timer_timeout() -> void:
	GameManager.main_scene.load_scene(Main.Scene.LEVEL_ONE)

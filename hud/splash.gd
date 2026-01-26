extends CanvasLayer


func _on_animated_sprite_2d_animation_finished() -> void:
	GameManager.main_scene.load_scene(Main.Scene.MAIN_MENU)

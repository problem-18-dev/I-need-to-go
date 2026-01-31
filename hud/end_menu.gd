extends Node


func _ready() -> void:
	$UI/ScoreLabel.text += str(GameManager.score)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") or event is InputEventScreenTouch:
		GameManager.main_scene.load_scene(Main.Scene.MAIN_MENU)

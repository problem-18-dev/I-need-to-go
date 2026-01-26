extends Node


func _ready() -> void:
	GameManager.main_scene.set_bus_db("Master", 0)
	$UI/ScoreLabel.text += str(GameManager.score)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") or event is InputEventScreenTouch:
		GameManager.main_scene.load_scene(Main.Scene.MAIN_MENU)

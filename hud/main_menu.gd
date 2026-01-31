extends Node


@export_category("UX")
@export var wait_time_on_info := 5.0


func _ready() -> void:
	GameManager.reset_all()
	if MobileManager.is_on_mobile():
		$UI/Intro/StartLabel.text = "Tap SCREEN to start"


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") or event is InputEventScreenTouch:
		_show_info()


func _show_info() -> void:
	$UI/Intro.hide()
	$UI/Info.show()
	await get_tree().create_timer(wait_time_on_info).timeout
	GameManager.main_scene.set_bus_db("Master", -3)
	GameManager.main_scene.load_scene(Main.Scene.LEVEL_ONE)

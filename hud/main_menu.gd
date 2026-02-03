extends Node


@export_category("UX")
@export var wait_time_on_info := 5.0


func _ready() -> void:
	GameManager.reset_all()
	if MobileManager.is_on_mobile():
		$UI/Intro/StartLabel.text = "Tap SCREEN to start"


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") or event is InputEventScreenTouch:
		if $UI/Info.visible:
			_go_to_level()
			return
		_show_info()


func _show_info() -> void:
	$UI/Intro.hide()
	$UI/Info.show()
	await get_tree().create_timer(wait_time_on_info).timeout


func _go_to_level() -> void:
	GameManager.main_scene.load_scene(Main.Scene.LEVEL_ONE)

extends Node


func _ready() -> void:
	if OS.has_feature("web_android") or OS.has_feature("web_ios"):
		$UI/PauseLabel.hide()
		$UI/StartLabel.text = "Press SCREEN to start"


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") or event is InputEventScreenTouch:
		_show_info()


func _show_info() -> void:
	$UI/StartLabel.hide()
	$UI/PauseLabel.hide()
	$UI/I.hide()
	$UI/TitleTexture.hide()
	$UI/InfoLabel.show()
	$InfoTimer.start()


func _on_info_timer_timeout() -> void:
	GameManager.main_scene.load_scene(Main.Scene.LEVEL_ONE)

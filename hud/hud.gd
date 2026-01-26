extends CanvasLayer


func _ready() -> void:
	if OS.has_feature("web_android") or OS.has_feature("web_ios"):
		$MobileButtonsTexture.show()
		$MobileButtons.show()


func change_lives(lives: int) -> void:
	for i in $Lives.get_child_count():
		var life: TextureRect = $Lives.get_child(i)
		life.visible = true if i < lives else false


func show_message(message: String, ttl = 0) -> void:
	$Message.text = message
	if ttl:
		await get_tree().create_timer(ttl).timeout
		hide_message()


func hide_message() -> void:
	$Message.text = ""


func change_score(score: int) -> void:
	$Score.text = str(score)


func change_timer(new_value: int, max_value = null) -> void:
	$TextureProgressBar.value = new_value

	if max_value:
		$AnimationPlayer.play("RESET")
		$TextureProgressBar.max_value = max_value

	if (new_value / $TextureProgressBar.max_value) < 0.3 and not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("danger")

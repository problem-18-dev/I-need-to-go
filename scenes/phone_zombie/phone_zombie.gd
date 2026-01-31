extends Obstacle


var _is_angry := false


func _physics_process(_delta: float) -> void:
	if $RayCast2D.is_colliding():
		var collider: CharacterBody2D = $RayCast2D.get_collider()
		collider.move_back()
		
		if not _is_angry:
			AudioManager.play(AudioManager.SFX.PHONE_ZOMBIE)
			_is_angry = true
			$AngerSprite2D.show()
			$AngerTimer.start()


func flip() -> void:
	super()
	$RayCast2D.rotate(PI)
	$AnimatedSprite2D.flip_h = false


func _on_anger_timer_timeout() -> void:
	_is_angry = false
	$AngerSprite2D.hide()

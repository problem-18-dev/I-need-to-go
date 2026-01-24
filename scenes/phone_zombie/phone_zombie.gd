extends Obstacle


func _physics_process(_delta: float) -> void:
	if $RayCast2D.is_colliding():
		var collider: CharacterBody2D = $RayCast2D.get_collider()
		collider.move_back()


func flip() -> void:
	super()
	$RayCast2D.rotate(PI)

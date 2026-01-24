extends Obstacle

var _anger_time := 1.5


func _ready() -> void:
	$AngerSprite2D.hide()


func _physics_process(_delta: float) -> void:
	if $RayCast2D.is_colliding():
		var collider: CharacterBody2D = $RayCast2D.get_collider()
		collider.move_back()
		$AngerSprite2D.show()
		await get_tree().create_timer(_anger_time).timeout
		$AngerSprite2D.hide()


func flip() -> void:
	super()
	$RayCast2D.rotate(PI)

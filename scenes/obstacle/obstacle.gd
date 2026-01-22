class_name Obstacle
extends Area2D


@export var speed := 150.0
@export var go_right := false


func _process(delta: float) -> void:
	var direction := Vector2.RIGHT if go_right else Vector2.LEFT
	position += direction * speed * delta
	$AnimatedSprite2D.flip_h = true if go_right else false


func _on_body_entered(body: Node2D) -> void:
	body.die()

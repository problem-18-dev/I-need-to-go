class_name Obstacle
extends Area2D


@export var speed := 150.0
@export var direction := Vector2.LEFT


func _process(delta: float) -> void:
	position += direction * speed * delta


func _on_body_entered(body: Node2D) -> void:
	body.die()

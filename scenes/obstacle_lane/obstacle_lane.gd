extends Node2D

@export_category("Spawning")
@export var obstacle_to_spawn: PackedScene
@export var spawn_frequency := 3.0
@export var speed := 120
@export var go_right := false

@export_category("Randomisiation")
@export var spawn_frequency_offset := 1.0
@export var speed_offset := 20.0



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SpawnTimer.wait_time = randf_range(spawn_frequency - spawn_frequency_offset, spawn_frequency)


func _on_timer_timeout() -> void:
	var obstacle: Obstacle = obstacle_to_spawn.instantiate()
	if go_right:
		obstacle.flip()
	obstacle.speed = randf_range(speed - speed_offset, speed + speed_offset)
	add_child(obstacle)

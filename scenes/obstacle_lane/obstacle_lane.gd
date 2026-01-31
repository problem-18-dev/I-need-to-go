extends Node2D


@export_category("Spawning")
@export var obstacle_to_spawn: PackedScene
@export var go_right := false
@export var sound_to_play: AudioManager.SFX
@export var speed := 120
@export var spawn_frequency := 3.0


func _ready() -> void:
	$SpawnTimer.wait_time = spawn_frequency


func stop_spawning() -> void:
	$SpawnTimer.stop()


func _on_timer_timeout() -> void:
	var obstacle: Obstacle = obstacle_to_spawn.instantiate()
	
	if go_right:
		obstacle.flip()
		
	obstacle.speed = speed
	obstacle.sound_to_play = sound_to_play
	add_child(obstacle)

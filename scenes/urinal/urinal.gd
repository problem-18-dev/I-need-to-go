extends Area2D

signal player_entered

@onready var marker_2d: Marker2D = $Marker2D
@onready var marker_2d_2: Marker2D = $Marker2D2
@onready var marker_2d_3: Marker2D = $Marker2D3


func _on_body_entered(body: Node2D) -> void:
	var marker: Marker2D = [marker_2d, marker_2d_2, marker_2d_3].pick_random()
	body.move_to(marker.global_position)
	player_entered.emit()

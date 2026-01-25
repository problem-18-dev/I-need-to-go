extends Area2D


@export_category("Sprites")
@export var closed_texture: Texture

@onready var marker: Marker2D = [$DownMarker2D, $UpMarker2D].pick_random()


func _on_body_entered(body: Node2D) -> void:
	body.move_to_urinal(marker.global_position)
	$Sprite2D.texture = closed_texture
	# Enable wall collision
	set_collision_layer_value(3, true)
	# Disable looking for player
	set_collision_mask_value(1, false)

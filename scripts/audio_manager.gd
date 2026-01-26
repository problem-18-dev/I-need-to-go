extends Node


enum SFX { MOVE, GROAN, PHONE_ZOMBIE, CAR, BIKER, DEATH, PEE }

var sfx: Dictionary[SFX, String] = {
	SFX.MOVE: "res://assets/sfx/move.ogg",
	SFX.PHONE_ZOMBIE: "res://assets/sfx/phone_zombie.ogg",
	SFX.CAR: "res://assets/sfx/car.ogg",
	SFX.BIKER: "res://assets/sfx/biker.ogg",
	SFX.DEATH: "res://assets/sfx/death.ogg",
	SFX.PEE: "res://assets/sfx/pee.ogg",
}


func play(sfx_name: SFX) -> void:
	var player := AudioStreamPlayer.new()
	player.bus = "SFX"
	player.stream = load(sfx[sfx_name])
	player.finished.connect(_on_player_finished.bind(player))
	player.autoplay = true
	add_child(player)


func _on_player_finished(player: AudioStreamPlayer) -> void:
	player.queue_free()

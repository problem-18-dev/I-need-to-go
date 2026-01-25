extends Node


enum SFX { MOVE, GROAN, PHONE_ZOMBIE, CAR, BIKER, DEATH, PEE }

var sfx: Dictionary[SFX, String] = {
	SFX.MOVE: "move",
	SFX.GROAN: "groan",
	SFX.PHONE_ZOMBIE: "phone_zombie",
	SFX.CAR: "car",
	SFX.BIKER: "biker",
	SFX.DEATH: "death",
	SFX.PEE: "pee"
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

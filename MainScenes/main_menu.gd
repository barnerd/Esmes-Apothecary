extends CanvasLayer

@export var background_music: AudioStream


func _ready() -> void:
	SoundManager.play_music(background_music)

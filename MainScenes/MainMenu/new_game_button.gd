extends Label

@export var ui_sound: AudioStream
@export var new_game_scene_path: String

func _on_new_game_button_pressed() -> void:
	SoundManager.play_ui_sound_with_pitch(ui_sound, randf_range(0.7, 1.1))
	SceneManager.load_scene(new_game_scene_path)

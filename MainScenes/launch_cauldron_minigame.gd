extends TextureButton

@export var cauldron_minigame_path: String


func _on_pressed() -> void:
	SceneManager.load_scene(cauldron_minigame_path)

extends TextureButton


func _on_pressed() -> void:
	if $"../..".is_game_running:
		$AnimationPlayer.play("pour_ingredients")
		$"../..".add_ingredients()

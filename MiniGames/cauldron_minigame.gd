extends Node2D

signal cauldron_minigame_started
signal cauldron_minigame_finished(score: float)

@onready var stir_slider = $Control/StirSlider
@onready var temp_slider = $Control/TempSlider
@onready var hourglass = $Control/PanelContainer/Hourglass
@onready var cauldron_liquid = $Control/CauldronLiquid
@onready var bubbler = $Control/CauldronLiquid/CPUParticles2D

var is_game_running: bool = false

var game_run_time: int = 30
var score: float
var elapsed_time: float


func _ready() -> void:
	hourglass.hourglass_timer_started.connect(on_hourglass_timer_started)
	hourglass.hourglass_timer_finished.connect(on_hourglass_timer_finished)
	
	# if story isn't loaded yet, wait for it
	if not StoryManager.is_story_loaded:
		await StoryManager.ink_player.loaded
	
	StoryManager.ink_player.choose_path("cauldron_mini_game")
	StoryManager.ink_player.continue_story()
	$Dialogue.visible = true
	
	$Dialogue.story_has_tags.connect(story_tags)
	$Dialogue.story_section_complete.connect(start_game)


func _process(delta: float) -> void:
	if is_game_running:
		elapsed_time += delta
		
		if elapsed_time < game_run_time / 2.0:
			score += temp_slider.value * delta
		else:
			score -= temp_slider.value * delta
		#score += stir_slider.value * delta


func start_game() -> void:
	cauldron_minigame_started.emit()
	
	score = 0.0
	elapsed_time = 0.0
	
	hourglass.flip_hourglass(game_run_time)


func end_game() -> void:
	print("Final Score: " + str(score))
	StoryManager.ink_player.set_variable("cauldron_mg_score", score / 22.0)
	StoryManager.ink_player.choose_path("cauldron_mini_game_finish")
	StoryManager.ink_player.continue_story()
	$Dialogue.visible = true


func story_tags(tags) -> void:
	print(tags)
	for tag in tags:
		match tag:
			"highlight_temperature_lever":
				$Control/TempArrow.visible = true
				$Control/Tray.release_focus()
			"highlight_ingredients":
				$Control/TempArrow.visible = false
				$Control/Tray.grab_focus()
			"unhighlight":
				$Control/TempArrow.visible = false
				$Control/Tray.release_focus()


func on_hourglass_timer_started() -> void:
	is_game_running = true


func on_hourglass_timer_finished() -> void:
	is_game_running = false
	
	end_game()


func add_ingredients() -> void:
	score += (1 - abs(elapsed_time - game_run_time / 2.0) / 15.0) * 1000


func update_shader(_speed: float, _height: float) -> void:
	cauldron_liquid.material.set_shader_parameter("speed", _speed)
	cauldron_liquid.material.set_shader_parameter("height", _height)


func _on_temp_slider_value_changed(value: float) -> void:
	update_shader(2.0 + value / 100.0 * 6.0, cauldron_liquid.material.get_shader_parameter("height"))
	
	# Changing the amount resets the particle emitter
	#bubbler.amount = roundi(20 * value / 100.0 + 1)
	
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property(bubbler, "initial_velocity_min", 100.0 * value / 100.0 + 10.0, 5.0)
	tween.tween_property(bubbler, "initial_velocity_max", 100.0 * value / 100.0 + 30.0, 5.0)


func _on_stir_slider_value_changed(value: float) -> void:
	update_shader(cauldron_liquid.material.get_shader_parameter("speed"), 0.015 + value / 100.0 * 0.02)

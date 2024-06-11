extends Node2D

signal cauldron_minigame_started
signal cauldron_minigame_finished(score: float)

@onready var stir_slider = $Control/StirSlider
@onready var temp_slider = $Control/TempSlider
@onready var hourglass = $Control/PanelContainer/Hourglass

var is_game_running: bool = false

var game_run_time: int = 30
var score: float
var elapsed_time: float


func _ready() -> void:
	hourglass.hourglass_timer_started.connect(on_hourglass_timer_started)
	hourglass.hourglass_timer_finished.connect(on_hourglass_timer_finished)
	
	# TODO: move this to player input
	start_game()


func _process(delta: float) -> void:
	if is_game_running:
		elapsed_time += delta
		
		score += stir_slider.value * delta
		score += temp_slider.value * delta


func start_game() -> void:
	cauldron_minigame_started.emit()
	
	score = 0.0
	elapsed_time = 0.0
	
	hourglass.flip_hourglass(game_run_time)


func on_hourglass_timer_started() -> void:
	is_game_running = true


func on_hourglass_timer_finished() -> void:
	is_game_running = false
	
	print("Final Score: " + str(score))

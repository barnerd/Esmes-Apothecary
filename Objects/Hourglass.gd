extends Node2D

signal hourglass_timer_started
signal hourglass_timer_finished

@onready var sand_drip = $Background/Drip
@onready var lower_sand = $Background/BottomMask/BottomSand # should go from 487 to 167
@onready var upper_sand = $Background/TopMask/TopSand # should go from -145 to 345


func flip_hourglass(drain_time: float) -> void:
	upper_sand.position.y = -229
	lower_sand.position.y = 513
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "rotation", 0, 1.0).from(-3.1415)
	
	await tween.finished

	drain_sand(drain_time)


func drain_sand(drain_time: float) -> void:
	hourglass_timer_started.emit()
	
	sand_drip.visible = true
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(upper_sand, "position:y", 345, drain_time).from(-145)
	tween.tween_property(lower_sand, "position:y", 167, drain_time).from(487)
	
	await tween.finished
	sand_drip.visible = false
	
	hourglass_timer_finished.emit()


func reset_hourglass() -> void:
	#upper_sand.position.y = -229
	#lower_sand.position.y = 513
	#self.rotation = -3.1415
	
	flip_hourglass(30)

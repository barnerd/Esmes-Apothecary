extends Sprite2D

@onready var left_scale: Sprite2D = $LeftScale
@onready var right_scale: Sprite2D = $RightScale

@export var max_rotation: float = 0.35
var current_rotation: float = 0.0


func _ready() -> void:
	current_rotation = -max_rotation / 4
	start_new_tween()


func _process(_delta: float) -> void:
	$LeftScale.rotation = -self.rotation
	$RightScale.rotation = -self.rotation


func start_new_tween() -> void:
	current_rotation *= -1.0
	var tween = get_tree().create_tween()
	tween.tween_property(self, "rotation", randf_range(current_rotation / 2.0, current_rotation), randf_range(1.3, 2.0))
	tween.tween_callback(start_new_tween)

extends Node2D
class_name WizardVisual

var controller_is_input: bool = true
var controller_points_direction: Vector2 = Vector2.ZERO

func _process(_delta: float) -> void:
	if not controller_is_input:
		look_at(get_global_mouse_position())
	elif controller_points_direction.length() > 0.2:
		look_at(global_position + (controller_points_direction * 100))
		print(controller_points_direction)
	return

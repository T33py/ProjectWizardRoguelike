extends Camera2D

@export var wizard: Wizard

func _process(_delta: float) -> void:
	if wizard != null:
		global_position = global_position.lerp(wizard.global_position, 0.25)
	return

extends Node
class_name WizardController

@export var wizard: Wizard

@export_category('Movement')
@export var accelleration: float = 0

var can_move: bool = true
var _move_direction: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	move(delta)
	return

func move(delta: float) -> void:
	if not can_move:
		return
	wizard.global_position += _move_direction * wizard.current_movespeed * delta
	return

func _input(_event: InputEvent) -> void:
	_move_direction = Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveBackward")
	return

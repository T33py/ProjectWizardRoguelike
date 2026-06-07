extends Node
class_name WizardController

@export var wizard: Wizard
var state: State

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

func goto_place_buildings_mode() -> void:
	state.current_wizard_activity = State.WizardActivities.PLACING_BUILDING
	return

func leave_place_buildings_mode() -> void:
	state.current_wizard_activity = State.WizardActivities.CASTING
	return

func _input(event: InputEvent) -> void:
	_move_direction = Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveBackward")
	if event.is_action_released("BuildingMenu"):
		goto_place_buildings_mode()
	elif event.is_action("Esc"):
		if state.current_wizard_activity == State.WizardActivities.PLACING_BUILDING:
			state.current_wizard_activity = State.WizardActivities.CASTING
	return

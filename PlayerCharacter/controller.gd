extends Node
class_name WizardController

@export var wizard: Wizard
var state: State

@export_category('Movement')
@export var accelleration: float = 0

var can_move: bool = true

var _controller_is_input: bool = false
var controller_is_input: bool:
	get: return _controller_is_input
	set(val):
		_controller_is_input = val
		wizard.visual.controller_is_input = val

var _move_direction: Vector2 = Vector2.ZERO
var _look_direction: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	move(delta)
	return

func move(delta: float) -> void:
	if not can_move:
		return
	wizard.global_position += _move_direction * wizard.stats.current_movespeed * delta
	return

func goto_place_buildings_mode() -> void:
	state.current_wizard_activity = State.WizardActivities.PLACING_BUILDING
	return

func leave_place_buildings_mode() -> void:
	state.current_wizard_activity = State.WizardActivities.CASTING
	return

func _input(event: InputEvent) -> void:
	_move_direction = Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveBackward")
	_look_direction = Input.get_vector("LookLeft", "LookRight", "LookUp", "LookDown")
	if _move_direction.length() > 0 or _look_direction.length() > 0:
		controller_is_input = true
		wizard.visual.controller_points_direction = _look_direction
	if event is InputEventMouseMotion:
		controller_is_input = false
	if event.is_action_released("BuildingMenu"):
		if state.current_player_activity == State.WizardActivities.PLACING_BUILDING:
			leave_place_buildings_mode()
		else:
			goto_place_buildings_mode()
	elif event.is_action("Esc"):
		if state.current_wizard_activity == State.WizardActivities.PLACING_BUILDING:
			state.current_wizard_activity = State.WizardActivities.CASTING
	return

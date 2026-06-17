extends Node
class_name PointerHandler

@export var state: State

var currently_pointed_at_hex: Hex

func _ready() -> void:
	state.wizard_changed_activity.connect(new_wizard_activity)
	return

func _input(event: InputEvent) -> void:
	if event.is_action_released("LeftClick"):
		handle_leftclick()
	return

func handle_leftclick() -> void:
	if state.current_wizard_activity == State.WizardActivities.PLACING_BUILDING:
		if currently_pointed_at_hex != null:
			if state.wizard.stats.current_mana >= 10:
				currently_pointed_at_hex.build_pylon()
				state.game_sounds.place_building_sound()
			else:
				state.game_sounds.cant_place_building_sound()
	return

func new_wizard_activity(activity: State.WizardActivities) -> void:
	if activity != State.WizardActivities.PLACING_BUILDING:
		stop_showing_build_placement_indication()
	return

func hex_recieved_pointer_focus(hex: Hex) -> void:
	if hex != currently_pointed_at_hex:
		hex_lost_pointer_focus(currently_pointed_at_hex)
		currently_pointed_at_hex = hex
	if currently_pointed_at_hex == null:
		return
	
	if state.current_wizard_activity == state.WizardActivities.PLACING_BUILDING:
		hex.show_pylon_build_placement_indication()
	return

func hex_lost_pointer_focus(hex: Hex) -> void:
	if hex == null:
		return
	if hex == currently_pointed_at_hex:
		currently_pointed_at_hex = null
	if state.current_wizard_activity == state.WizardActivities.PLACING_BUILDING:
		hex.hide_pylon_build_placement_indication()
	return

func stop_showing_build_placement_indication() -> void:
	if currently_pointed_at_hex == null:
		return
	currently_pointed_at_hex.hide_pylon_build_placement_indication()
	return

func register_hex(hex: Hex) -> void:
	if !hex.mouse_entered.is_connected(hex_recieved_pointer_focus):
		hex.mouse_entered.connect(hex_recieved_pointer_focus)
		hex.mouse_exited.connect(hex_lost_pointer_focus)
	return

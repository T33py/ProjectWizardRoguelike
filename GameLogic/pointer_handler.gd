extends Node
class_name PointerHandler

@export var state: State

var currently_pointed_at_hex: Hex

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
	if state.current_wizard_activity == state.WizardActivities.PLACING_BUILDING:
		hex.hide_pylon_build_placement_indication()
	return


func register_hex(hex: Hex) -> void:
	if !hex.mouse_entered.is_connected(hex_recieved_pointer_focus):
		hex.mouse_entered.connect(hex_recieved_pointer_focus)
		hex.mouse_exited.connect(hex_lost_pointer_focus)
	return

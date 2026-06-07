extends Node
class_name PointerHandler

var currently_pointed_at_hex: Hex

func hex_recieved_pointer_focus(hex: Hex) -> void:
	if hex != currently_pointed_at_hex:
		hex_lost_pointer_focus(currently_pointed_at_hex)
		currently_pointed_at_hex = hex
		currently_pointed_at_hex.show_neighbour_numbers()
	return

func hex_lost_pointer_focus(hex: Hex) -> void:
	if hex == null:
		return
	if hex == currently_pointed_at_hex:
		currently_pointed_at_hex.hide_neighbour_numbers()
	return


func register_hex(hex: Hex) -> void:
	if !hex.mouse_entered.is_connected(hex_recieved_pointer_focus):
		hex.mouse_entered.connect(hex_recieved_pointer_focus)
		hex.mouse_exited.connect(hex_lost_pointer_focus)
	return

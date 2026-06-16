extends Node
class_name MapWizardTracker

signal current_wizard_location(hex: Hex)

@export var show_wizard_location: bool = false

var wizard: Wizard

var _wizard_location: Hex = null
var wizard_location: Hex:
	get: return _wizard_location
	set(val):
		if _wizard_location != null:
			_wizard_location.find_child('WizardHere').visible = false
		if val != null and show_wizard_location:
			val.find_child('WizardHere').visible = true
		if _wizard_location != val:
			_wizard_location = val
			current_wizard_location.emit(_wizard_location)

var wizard_touches_hexes: Array[Hex] = []

var frame_counter: int = 0
var check_pos_frames: int = 30

func _process(_delta: float) -> void:
	frame_counter += 1
	if frame_counter > check_pos_frames:
		update_wizard_correct_location()
		frame_counter = 0
	return

func wizard_entered_hex(hex: Hex) -> void:
	wizard_touches_hexes.append(hex)
	update_wizard_correct_location()
	return

func wizard_left_hex(hex: Hex) -> void:
	wizard_touches_hexes.erase(hex)
	if wizard_location == hex:
		wizard_location = null
	update_wizard_correct_location()
	return

func update_wizard_correct_location() -> void:
	var closest_hex: Hex = wizard_location
	if wizard_location == null and len(wizard_touches_hexes) > 0:
		wizard_location = wizard_touches_hexes[0]
	if closest_hex == null:
		return
	for hex in wizard_touches_hexes:
		if hex.global_position.distance_to(wizard.global_position) < closest_hex.global_position.distance_to(wizard.global_position):
			if wizard_location != hex:
				wizard_location = hex
	return

func on_hex_created(hex: Hex) -> void:
	hex.wizard_entered.connect(wizard_entered_hex)
	hex.wizard_exited.connect(wizard_left_hex)
	return

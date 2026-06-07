extends Control

@onready var hex_map: HexMap = $HexMap
@onready var pointer_handler: PointerHandler = $PointerHandler

func _ready() -> void:
	hex_map.new_hex_created.connect(pointer_handler.register_hex)
	for hex in hex_map.all_hexes:
		pointer_handler.register_hex(hex)
	return

@tool
extends Node2D
class_name Hex

signal mouse_entered(me: Hex)
signal mouse_exited(me: Hex)

var hex_map: HexMap

var _coordinates: Vector2i = Vector2i.ZERO
var coordinates: Vector2i :
	get: return _coordinates
	set(val):
		_coordinates = val
var neighbouring_coordinates: Array[Vector2i] = []

@onready var hitbox: Area2D = $Hitbox

func _ready() -> void:
	hitbox.mouse_entered.connect(_mouse_entered)
	hitbox.mouse_exited.connect(_mouse_exited)
	return

func get_neighbours() -> Array[Hex]:
	return hex_map.get_hexes(neighbouring_coordinates)

func show_neighbour_numbers():
	return

func hide_neighbour_numbers():
	return

func _mouse_entered() -> void:
	mouse_entered.emit(self)
	return

func _mouse_exited() -> void:
	mouse_exited.emit(self)
	return

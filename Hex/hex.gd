@tool
extends Node2D
class_name Hex

signal mouse_entered(me: Hex)
signal mouse_exited(me: Hex)

@export var enemy_spawner_prefab: PackedScene
@export var pylon_prefab: PackedScene

var hex_map: HexMap

var _coordinates: Vector2i = Vector2i.ZERO
var coordinates: Vector2i :
	get: return _coordinates
	set(val):
		_coordinates = val
var neighbouring_coordinates: Array[Vector2i] = []

var allows_building: bool = true
var building:Node2D

@onready var hitbox: Area2D = $Hitbox
@onready var border_shower: HexBorderShower = $HexBorderShower

func _ready() -> void:
	hitbox.mouse_entered.connect(_mouse_entered)
	hitbox.mouse_exited.connect(_mouse_exited)
	return

func get_neighbours() -> Array[Hex]:
	return hex_map.get_hexes(neighbouring_coordinates)

func show_pylon_build_placement_indication():
	if building != null:
		return
	var pylon: Pylon = pylon_prefab.instantiate()
	pylon.being_placed = true
	add_child(pylon)
	pylon.global_position = global_position
	building = pylon
	border_shower.striped_border()
	return

func hide_pylon_build_placement_indication():
	if building != null:
		if building is Pylon:
			building.get_rid_of_this()
		building = null
		border_shower.clean()
	return

func _mouse_entered() -> void:
	mouse_entered.emit(self)
	return

func _mouse_exited() -> void:
	mouse_exited.emit(self)
	return

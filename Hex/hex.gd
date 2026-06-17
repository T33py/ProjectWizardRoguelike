@tool
extends Node2D
class_name Hex

signal mouse_entered(me: Hex)
signal mouse_exited(me: Hex)
signal wizard_entered(me: Hex)
signal wizard_exited(me: Hex)

enum Biome { PLACEHOLDER, GRASS, WATER, DESERT }

@export var enemy_spawner_prefab: PackedScene
@export var pylon_prefab: PackedScene

## The index at which each biomes tiles starts
@export var biome_indexes: Array[int] = [0, 2, 6, 7]

var hex_map: HexMap

var _coordinates: Vector2i = Vector2i.ZERO
var coordinates: Vector2i :
	get: return _coordinates
	set(val):
		_coordinates = val
var neighbouring_coordinates: Array[Vector2i] = []
var reachable_neighbours: int = 0
var walkable: bool = true
var land_reachable: bool = true

var _biome: Biome = Biome.PLACEHOLDER
var biome: Biome:
	get: return _biome
	set(val):
		_biome = val
		if visual != null:
			_choose_a_sprite()
var sprite_idx: int = 0

var allows_building: bool = true
var building:Node2D

@onready var visual: Sprite2D = $Sprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var border_shower: HexBorderShower = $HexBorderShower

func _ready() -> void:
	hitbox.mouse_entered.connect(_mouse_entered)
	hitbox.mouse_exited.connect(_mouse_exited)
	hitbox.area_entered.connect(_area_entered)
	hitbox.area_exited.connect(_area_exited)
	_choose_a_sprite()
	return

func get_neighbours() -> Array[Hex]:
	return hex_map.get_hexes(neighbouring_coordinates)

func build_pylon() -> void:
	if building is Pylon:
		building.place()
	return

func show_pylon_build_placement_indication() -> void:
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
			if building.being_placed:
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

func _area_entered(other: Area2D) -> void:
	if other.get_parent() is Wizard:
		wizard_entered.emit(self)
	return

func _area_exited(other: Area2D) -> void:
	if other.get_parent() is Wizard:
		wizard_exited.emit(self)
	return

func _choose_a_sprite() -> void:
	var ssrange: int = 0
	if len(biome_indexes) >= biome+1:
		ssrange = biome_indexes[biome+1]-1 - biome_indexes[biome]
	else:
		ssrange = visual.hframes-1 - biome_indexes[biome]
	sprite_idx = randi_range(biome_indexes[biome], biome_indexes[biome]+ssrange)
	visual.frame = sprite_idx
	return

func _to_string() -> String:
	return 'Hex' + str(coordinates)

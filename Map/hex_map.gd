@tool
extends Node2D
class_name HexMap

signal new_hex_created(hex: Hex)

@export var state: State

@export var hex_template: PackedScene
var _dx: float = 0
@export var dx: float:
	get: return _dx
	set(val):
		_dx = val
		_hex_spacing_changed()
var _dy: float = 0
@export var dy: float:
	get: return _dy
	set(val):
		_dy = val
		_hex_spacing_changed()
@export var grid_origin: Vector2 = Vector2(350, 350)
var _grid_size: Vector2i = Vector2i(0, 0)
@export var grid_size: Vector2i :
	get: return _grid_size
	set(val): 
		_grid_size = val

var _screensized_grid_size: Vector2i = Vector2i.ZERO
@export var screensized_grid_size: Vector2i:
	get: return _screensized_grid_size
	set(val):
		_screensized_grid_size = val
		make_screensized_grid()

var _starting_hexes: int = 100
@export var starting_hexes: int:
	get: return _starting_hexes
	set(val):
		_starting_hexes = val
		spiral_grid_out()

var all_hexes: Array[Hex] = []

# grid starts out 1x1 (0, 0)
var grid: Array[Array] = [ [ null ] ]
# tracks the offset for the hexes with negative coordinates
var grid_x_offset: int = 0
var grid_y_offset: int = 0

var grid_x_min: int = 0
var grid_x_max: int = 0
var grid_y_min: int = 0
var grid_y_max: int = 0

@onready var wizard_tracker: MapWizardTracker = $WizardTracker

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wizard_tracker.wizard = state.wizard
	new_hex_created.connect(wizard_tracker.on_hex_created)
	redo_grid()
	for c in get_children():
		if c is Hex:
			all_hexes.append(c)
			new_hex_created.emit(c)
	pass

func setup_grid():
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			setup_hex(x, y)
	pass

## setup a new hex at the provided coordinate in the grid
func setup_hex(x: int, y: int) -> Hex:
	#print('setup (' + str(x) + ', ' + str(y) + ')')
	var hex: Hex = get_hex(x, y)
	if hex == null:
		hex = hex_template.instantiate() as Hex
		hex.coordinates = Vector2i(x, y)
		hex.neighbouring_coordinates = make_neighbouring_coordinates(hex.coordinates)
		hex.hex_map = self
		all_hexes.append(hex)
		add_child(hex)
	hex.position = grid_origin + Vector2(2 * (x * dx) + (dx * (abs(y)%2)), y * dy)
	hex.biome = hex.Biome.GRASS
	#print('all hexes: ' + str(all_hexes))
	add_hex_to_grid(hex)
	new_hex_created.emit(hex)
	return hex

func add_hex_to_grid(hex: Hex):
	#print('add ' + str(hex))
	var x = hex.coordinates.x
	var y = hex.coordinates.y
	var grid_changed = false
	if x > grid_x_max:
		grid_x_max = x
		grid_changed = true
	elif x < grid_x_min:
		grid_x_min = x
		grid_changed = true
		
	if y > grid_y_max:
		grid_y_max = y
		grid_changed = true
	elif y < grid_y_min:
		grid_y_min = y
		grid_changed = true
		
	if grid_changed:
		redo_grid()
	
	grid[x + grid_x_offset][y + grid_y_offset] = hex
	pass

func redo_grid():
	var length = len(grid) + 16
	var height = len(grid[0]) + 16
	var new_grid: Array[Array] = []
	var new_x_offset = length/2
	var new_y_offset = height/2
	var new_grid_x_min = -new_x_offset
	var new_grid_x_max = length - new_x_offset - 1
	var new_grid_y_min = -new_y_offset
	var new_grid_y_max = height - new_y_offset - 1
	new_grid.resize(length)
	for x in range(length):
		new_grid[x] = []
		new_grid[x].resize(height)
	for hex in all_hexes:
		var x = hex.coordinates.x
		var y = hex.coordinates.y
		#print('placing ' + str(hex) + ' at: (' + str(x + new_x_offset) + ', ' + str(y + new_y_offset) + ')')
		new_grid[x + new_x_offset][y + new_y_offset] = hex
	grid_x_offset = new_x_offset
	grid_y_offset = new_y_offset
	grid_x_max = new_grid_x_max
	grid_x_min = new_grid_x_min
	grid_y_max = new_grid_y_max
	grid_y_min = new_grid_y_min
	grid = new_grid
	pass

func get_hex(x: int, y: int) -> Hex:
	x += grid_x_offset
	if x < len(grid) and x >= 0:
		y += grid_y_offset
		if y < len(grid[x]) and y >= 0:
			if is_instance_valid(grid[x][y]):
				if grid[x][y].is_queued_for_deletion():
					return null
				return grid[x][y]
	return null

func get_hexes(coordinates: Array[Vector2i]) -> Array[Hex]:
	var hexes: Array[Hex] = []
	for c in coordinates:
		var h = get_hex(c.x, c.y)
		if h != null:
			hexes.append(h)
	return hexes

func spiral_grid_out() -> void:
	if starting_hexes == 0:
		return
	if len(all_hexes) == 0:
		setup_hex(0, 0)
	
	var chi: int = 0
	
	if len(all_hexes) == 0:
		setup_hex(0, 0)
	var current_hex: Hex = all_hexes[chi]
	
	while len(all_hexes) < starting_hexes:
		for coord in current_hex.neighbouring_coordinates:
			if get_hex(coord.x, coord.y) == null and len(all_hexes) < starting_hexes:
				setup_hex(coord.x, coord.y)
		chi += 1
		current_hex = all_hexes[chi]
	return

func make_screensized_grid() -> void:
	for hex in all_hexes:
		hex.queue_free()
	all_hexes.resize(0)
	for x in range(screensized_grid_size.x):
		for y in range(screensized_grid_size.y):
			setup_hex(x, y)
	return

func print_grid():
	print('grid is ' + str(len(grid)) + ' x ' + str(len(grid[0])))
	var ls = []
	for row in range(len(grid[0])):
		ls.append('')
		for col in range(len(grid)):
			if grid[col][row] == null:
				ls[row] += '. '
			else:
				ls[row] += 'h '
	for l in ls:
		print(l)
	pass

func _hex_spacing_changed():
	for hex in all_hexes:
		var x: int = hex.coordinates.x
		var y: int = hex.coordinates.y
		hex.position = grid_origin + Vector2(2 * (x * dx) + (dx * (abs(y)%2)), y * dy)
		
	return

func make_neighbouring_coordinates(val: Vector2i) -> Array[Vector2i]: 
	var c1: Array[Vector2i] = [
							Vector2i(val.x, val.y+2), 
			Vector2i(val.x-1, val.y+1),          Vector2i(val.x, val.y+1),                         
			Vector2i(val.x-1, val.y-1),          Vector2i(val.x, val.y-1), 
							Vector2i(val.x, val.y-2),
		]
	var c2: Array[Vector2i] = [
							Vector2i(val.x, val.y+2), 
			Vector2i(val.x, val.y+1),          Vector2i(val.x+1, val.y+1),                         
			Vector2i(val.x, val.y-1),          Vector2i(val.x+1, val.y-1), 
							Vector2i(val.x, val.y-2),
		]
	if val.y%2 == 0:
		return c1
	else:
		return c2

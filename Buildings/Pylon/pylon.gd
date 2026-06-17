extends Node2D
class_name Pylon

var being_placed: bool = true
@onready var base: BuildingBase = $BuildingBase

func _ready() -> void:
	if being_placed:
		base.modulate = base.build_indicator_modulation
	return

func place() -> void:
	base.modulate = Color.WHITE
	being_placed = false
	return


func get_rid_of_this() -> void:
	queue_free()
	return

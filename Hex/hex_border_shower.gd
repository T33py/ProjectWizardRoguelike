extends Node2D
class_name HexBorderShower

enum BorderSprites {
	FULL,
	F1, F2, F3, F4, F5, F6,
	STRIPED,
	S1, S2, S3, S4, S5, S6
}


@export var border_prefab: PackedScene

var currently_shown_borders: Array[Sprite2D] = []

func clean() -> void:
	if len(currently_shown_borders) > 0:
		for b in currently_shown_borders:
			b.queue_free()
		currently_shown_borders = []
	return

func create_border(b: BorderSprites) -> Sprite2D:
	var sprite: Sprite2D = border_prefab.instantiate()
	sprite.frame = b
	add_child(sprite)
	sprite.global_position = global_position
	sprite.z_index = 1
	currently_shown_borders.append(sprite)
	return sprite

func full_border() -> void:
	clean()
	create_border(BorderSprites.FULL)
	return

func striped_border() -> void:
	clean()
	create_border(BorderSprites.STRIPED)
	return

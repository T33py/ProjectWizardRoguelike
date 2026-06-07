@tool
extends Node2D
class_name BuildingBase

@export var orb_bob_amplitude: float = 5
@export var orb_bob_speed: float = 25
@export var build_indicator_modulation: Color = Color.WHITE

var orb_bob_dir: int = 1

@onready var foundation: Sprite2D = $Foundation
@onready var orb: Sprite2D = $Orb
@onready var orb_bob_center: Node2D = $OrbBobCenter

func _process(delta: float) -> void:
	orb.position += Vector2(0, orb_bob_dir * orb_bob_speed * delta)
	if orb.position.y > orb_bob_center.position.y + orb_bob_amplitude:
		orb_bob_dir = -1
	elif orb.position.y < orb_bob_center.position.y - orb_bob_amplitude:
		orb_bob_dir = 1
	return

extends Node2D
class_name Wizard

@export var state: State

@onready var controller: WizardController = $Controller
@onready var stats: WizardStats = $Stats
@onready var hitbox: Area2D = $Hitbox

func _ready() -> void:
	controller.state = state
	return
